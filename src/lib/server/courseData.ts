import { error } from '@sveltejs/kit';
import type { CourseData, Lesson, LessonType, SimulatorConfig } from '$lib/course/types';
import { publicCourseData } from '$lib/course/publicCourseData';
import { prisma } from './prisma';

const lessonTypes = new Set<LessonType>(['體感', '邏輯', '實驗', '敘述', '觀念']);

function normalizeLessonType(value: string | null | undefined): LessonType {
	if (!value) return '觀念';
	if (lessonTypes.has(value as LessonType)) return value as LessonType;
	if (value.includes('體感')) return '體感';
	if (value.includes('邏輯')) return '邏輯';
	if (value.includes('實驗')) return '實驗';
	if (value.includes('敘述')) return '敘述';
	return '觀念';
}

function asConfig(value: unknown): SimulatorConfig | null {
	if (!value || typeof value !== 'object' || Array.isArray(value)) return null;
	const config = value as SimulatorConfig;
	if (typeof config.id !== 'string') return null;
	return config;
}

function toLesson(row: {
	id: string;
	title: string;
	simulatorConfig: unknown;
	legacyLessonId: string | null;
	fullId: string | null;
	lessonType: string | null;
	simContent: string | null;
	contentText: string | null;
}): Lesson {
	const config = asConfig(row.simulatorConfig);
	const quiz = config && 'quiz' in config ? config.quiz : undefined;
	const quizLayout = config && config.quizLayout === 'table' ? 'table' : undefined;

	return {
		id: row.legacyLessonId ?? row.id,
		fullId: row.fullId ?? undefined,
		type: normalizeLessonType(row.lessonType),
		question: row.title,
		simulator: config
			? {
					id: config.id,
					config
				}
			: undefined,
		simContent: row.simContent ?? undefined,
		quiz: quiz as Lesson['quiz'],
		quizLayout,
		contentText: row.contentText ?? ''
	};
}

export async function getPublicCourseDataByChapterKey(chapterKey: string): Promise<CourseData> {
	const chapter = await prisma.chapter.findUnique({
		where: { chapterKey },
		select: {
			title: true,
			section: true,
			chapterKey: true,
			lessons: {
				where: { isActive: true },
				orderBy: { orderIndex: 'asc' },
				select: {
					id: true,
					title: true,
					simulatorConfig: true,
					legacyLessonId: true,
					fullId: true,
					lessonType: true,
					simContent: true,
					contentText: true
				}
			}
		}
	});

	if (!chapter) {
		throw error(404, '找不到課程資料');
	}

	return publicCourseData({
		chapter: chapter.chapterKey ?? chapterKey,
		section: chapter.section ?? '',
		title: chapter.title.replace(new RegExp(`^${chapterKey}\\s*`), ''),
		lessons: chapter.lessons.map(toLesson)
	});
}
