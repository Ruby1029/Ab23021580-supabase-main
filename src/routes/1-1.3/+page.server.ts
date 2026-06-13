import { getPublicCourseDataByChapterKey } from '$lib/server/courseData';

export const load = async () => {
	return {
		courseData: await getPublicCourseDataByChapterKey('1-1.3')
	};
};
