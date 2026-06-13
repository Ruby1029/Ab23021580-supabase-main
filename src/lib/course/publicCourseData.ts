import type { CourseData, Lesson, SimulatorConfig } from './types';

const sensitiveRulerKeys = new Set(['target', 'correct_zone', 'correctZone']);

function publicSimulatorConfig(config: SimulatorConfig) {
	const next: SimulatorConfig = { ...config };

	if (typeof config.id === 'string' && config.id.startsWith('RULER')) {
		for (const key of sensitiveRulerKeys) {
			delete next[key];
		}
	}

	return next;
}

function publicLesson(lesson: Lesson): Lesson {
	return {
		...lesson,
		simulator: lesson.simulator
			? {
					...lesson.simulator,
					config: publicSimulatorConfig(lesson.simulator.config)
				}
			: undefined
	};
}

export function publicCourseData(courseData: CourseData): CourseData {
	return {
		...courseData,
		lessons: courseData.lessons.map(publicLesson)
	};
}
