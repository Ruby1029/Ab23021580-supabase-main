import { error, json, type RequestHandler } from '@sveltejs/kit';
import { prisma } from '$lib/server/prisma';
import { requireSupabaseUser } from '$lib/server/supabaseAuth';
import { validateLessonOrQuizId, validateContentUrl, validateStatus } from '$lib/server/validation';

function clampProgress(value: unknown) {
	const number = typeof value === 'number' && Number.isFinite(value) ? value : 0;
	return Math.max(0, Math.min(100, Math.round(number)));
}

export const GET: RequestHandler = async ({ request }) => {
	const user = await requireSupabaseUser(request);

	const progress = await prisma.userProgress.findMany({
		where: { userId: user.id },
		orderBy: { updatedAt: 'desc' },
		include: {
			lesson: {
				include: {
					chapter: {
						include: {
							course: true
						}
					}
				}
			}
		}
	});

	return json({ progress });
};

export const POST: RequestHandler = async ({ request }) => {
	const user = await requireSupabaseUser(request);
	const body = await request.json().catch(() => ({}));

	const lessonId = body.lessonId ? validateLessonOrQuizId(body.lessonId, 'lessonId') : '';
	const contentUrl = body.contentUrl ? validateContentUrl(body.contentUrl, 'contentUrl') : '';
	const legacyLessonId = body.legacyLessonId
		? validateLessonOrQuizId(body.legacyLessonId, 'legacyLessonId')
		: '';
	const status = body.status ? validateStatus(body.status) : 'in_progress';
	const progressPercentage =
		status === 'completed' ? 100 : clampProgress(body.progressPercentage ?? body.progress);

	if (!lessonId && !contentUrl) {
		throw error(400, 'lessonId 或 contentUrl 是必填欄位');
	}

	const lesson = lessonId
		? await prisma.lesson.findUnique({ where: { id: lessonId } })
		: legacyLessonId
			? await prisma.lesson.findFirst({
					where: {
						contentUrl,
						legacyLessonId
					},
					orderBy: { createdAt: 'asc' }
				})
			: await prisma.lesson.findFirst({
					where: { contentUrl },
					orderBy: { createdAt: 'asc' }
				});

	if (!lesson) {
		throw error(404, '找不到課程單元');
	}

	const now = new Date();
	const existing = await prisma.userProgress.findUnique({
		where: {
			userId_lessonId: {
				userId: user.id,
				lessonId: lesson.id
			}
		}
	});
	const nextProgressPercentage = Math.max(existing?.progressPercentage ?? 0, progressPercentage);
	const nextStatus =
		nextProgressPercentage >= 100
			? 'completed'
			: nextProgressPercentage > 0
				? 'in_progress'
				: status;

	const progress = existing
		? await prisma.userProgress.update({
				where: { id: existing.id },
				data: {
					status: nextStatus,
					progressPercentage: nextProgressPercentage,
					lastAccessedAt: now,
					completedAt:
						nextStatus === 'completed' ? (existing.completedAt ?? now) : existing.completedAt
				}
			})
		: await prisma.userProgress.create({
				data: {
					userId: user.id,
					lessonId: lesson.id,
					status: nextStatus,
					progressPercentage: nextProgressPercentage,
					startedAt: nextStatus === 'not_started' ? null : now,
					completedAt: nextStatus === 'completed' ? now : null,
					lastAccessedAt: now
				}
			});

	return json({ progress });
};
