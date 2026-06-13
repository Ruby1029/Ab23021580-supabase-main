import { error, json, type RequestHandler } from '@sveltejs/kit';
import { prisma } from '$lib/server/prisma';
import { requireSupabaseUser } from '$lib/server/supabaseAuth';
import { validateLessonOrQuizId, validateContentUrl } from '$lib/server/validation';

type SimulatorConfig = {
	id?: string;
	type?: string;
	target?: number;
	range?: [number, number];
	pulls?: number;
	correct_zone?: [number, number];
};

type SimulatorAction = {
	type?: string;
	value?: number;
	distance?: number;
	pulls?: number;
};

const fallbackRulerConfigs = new Map<string, SimulatorConfig>([
	['/1-1:A1', { id: 'RULER_STATIC', type: 'STATIC' }],
	['/1-1:A2', { id: 'RULER_DRAG', type: 'DRAG', target: 10 }],
	['/1-1:A3', { id: 'RULER_DRAG_ACCUMULATE', type: 'DRAG_ACCUMULATE', target: 20, pulls: 5 }],
	['/1-1:A4', { id: 'RULER_DRAG_PRECISION', type: 'PRECISION', target: 1 }],
	['/1-1.2:B3', { id: 'RULER_STATIC', type: 'STATIC' }]
]);

function asRecord(value: unknown) {
	return value && typeof value === 'object' && !Array.isArray(value)
		? (value as Record<string, unknown>)
		: {};
}

function asNumber(value: unknown) {
	return typeof value === 'number' && Number.isFinite(value) ? value : null;
}

function normalizeZone(value: unknown): [number, number] | null {
	if (!Array.isArray(value) || value.length < 2) return null;
	const min = asNumber(value[0]);
	const max = asNumber(value[1]);
	if (min === null || max === null) return null;
	return [Math.min(min, max), Math.max(min, max)];
}

function normalizeConfig(value: unknown): SimulatorConfig {
	const raw = asRecord(value);
	const config = asRecord(raw.config ?? raw);
	const zone = normalizeZone(config.correct_zone);
	const range = normalizeZone(config.range);

	return {
		id: typeof config.id === 'string' ? config.id : undefined,
		type: typeof config.type === 'string' ? config.type : undefined,
		target: asNumber(config.target) ?? undefined,
		range: range ?? undefined,
		pulls: asNumber(config.pulls) ?? undefined,
		correct_zone: zone ?? undefined
	};
}

function getFallbackConfig(contentUrl: string, legacyLessonId: string) {
	return fallbackRulerConfigs.get(`${contentUrl}:${legacyLessonId}`);
}

async function resolveLesson(lessonId: string, contentUrl: string, legacyLessonId: string) {
	if (lessonId) {
		return prisma.lesson.findUnique({ where: { id: lessonId } });
	}

	if (!contentUrl || !legacyLessonId) return null;

	return prisma.lesson.findFirst({
		where: {
			contentUrl,
			legacyLessonId
		},
		orderBy: { createdAt: 'asc' }
	});
}

function evaluateRulerAction(config: SimulatorConfig, action: SimulatorAction) {
	const simulatorId = config.id ?? '';
	const simulatorType = config.type ?? '';

	if (simulatorId === 'RULER_STATIC' || simulatorType === 'STATIC') {
		return action.type === 'static_click' || action.type === 'ruler_click';
	}

	if (action.type === 'ruler_click') {
		const value = asNumber(action.value);
		if (value === null) return false;

		const zone = config.correct_zone;
		if (zone) return value >= zone[0] && value <= zone[1];

		const target = asNumber(config.target);
		return target !== null && Math.abs(value - target) <= 0.051;
	}

	if (simulatorId === 'RULER_DRAG' || simulatorId === 'RULER_DRAG_PRECISION') {
		const distance = asNumber(action.distance);
		const target = asNumber(config.target);
		if (distance === null || target === null) return false;
		return Math.abs(distance - target) <= 0.051;
	}

	if (simulatorId === 'RULER_DRAG_ACCUMULATE') {
		const pulls = asNumber(action.pulls);
		const distance = asNumber(action.distance);
		const expectedPulls = config.pulls ?? 1;
		const target = config.target ?? 0;
		return (
			pulls !== null && pulls >= expectedPulls && distance !== null && distance + 0.051 >= target
		);
	}

	return false;
}

async function markLessonCompleted(userId: string, lessonId: string) {
	const now = new Date();
	const existing = await prisma.userProgress.findUnique({
		where: {
			userId_lessonId: {
				userId,
				lessonId
			}
		}
	});

	if (existing) {
		return prisma.userProgress.update({
			where: { id: existing.id },
			data: {
				status: 'completed',
				progressPercentage: 100,
				lastAccessedAt: now,
				completedAt: existing.completedAt ?? now
			}
		});
	}

	return prisma.userProgress.create({
		data: {
			userId,
			lessonId,
			status: 'completed',
			progressPercentage: 100,
			startedAt: now,
			completedAt: now,
			lastAccessedAt: now
		}
	});
}

export const POST: RequestHandler = async ({ request }) => {
	const user = await requireSupabaseUser(request);
	const body = await request.json().catch(() => ({}));

	const lessonId = body.lessonId ? validateLessonOrQuizId(body.lessonId, 'lessonId') : '';
	const contentUrl = body.contentUrl ? validateContentUrl(body.contentUrl, 'contentUrl') : '';

	const rawLegacyLessonId =
		typeof body.legacyLessonId === 'string'
			? body.legacyLessonId
			: typeof body.stageId === 'string'
				? body.stageId
				: '';
	const legacyLessonId = rawLegacyLessonId
		? validateLessonOrQuizId(rawLegacyLessonId, 'legacyLessonId')
		: '';

	const action = asRecord(body.action) as SimulatorAction;
	const completeLesson = body.completeLesson !== false;

	const lesson = await resolveLesson(lessonId, contentUrl, legacyLessonId);
	if (!lesson) {
		throw error(404, '找不到課程單元');
	}

	const dbConfig = normalizeConfig(lesson.simulatorConfig);
	const fallbackConfig = getFallbackConfig(contentUrl, legacyLessonId);
	const config = dbConfig.id ? dbConfig : fallbackConfig;

	if (!config?.id?.startsWith('RULER')) {
		throw error(400, '目前只支援直尺模擬器後端判斷');
	}

	const correct = evaluateRulerAction(config, action);
	const progress = correct && completeLesson ? await markLessonCompleted(user.id, lesson.id) : null;

	return json({
		correct,
		nextStageUnlocked: correct,
		progress,
		message: correct ? '答對了' : '再試一次'
	});
};
