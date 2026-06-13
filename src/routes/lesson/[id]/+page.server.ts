import { getPublicCourseDataByChapterKey } from '$lib/server/courseData';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params }) => {
	return {
		courseData: await getPublicCourseDataByChapterKey(params.id),
		lessonKey: params.id
	};
};
