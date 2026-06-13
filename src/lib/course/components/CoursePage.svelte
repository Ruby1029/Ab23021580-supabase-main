<script lang="ts">
	import { onMount } from 'svelte';
	import type { CourseData } from '$lib/course/types';
	import { CourseState } from '$lib/course/courseState.svelte';
	import QuestionArea from '$lib/course/components/QuestionArea.svelte';
	import SimulatorDispatcher from '$lib/course/components/SimulatorDispatcher.svelte';
	import LearningSidebar from '$lib/course/components/LearningSidebar.svelte';
	import { endLearningSession, startLearningSession } from '$lib/course/learningTimer';
	import { syncCourseProgress } from '$lib/course/progressSync';
	import { publicCourseData } from '$lib/course/publicCourseData';

	let {
		courseData,
		contentUrl
	}: {
		courseData: CourseData;
		contentUrl: string;
	} = $props();

	const courseState = new CourseState(publicCourseData(courseData).lessons);

	let currentDistance = $state(0);
	let accumulatedPulls = $state(0);
	let isCorrect = $state(false);
	let showFeedback = $state(false);
	let learningSessionId: string | null = null;

	onMount(() => {
		startLearningSession(contentUrl).then((sessionId) => {
			learningSessionId = sessionId;
		});

		return () => {
			void endLearningSession(learningSessionId);
		};
	});

	function handleCorrect(options: { skipProgressSync?: boolean } = {}) {
		const currentStage = courseState.currentStage;
		isCorrect = true;
		showFeedback = true;
		courseState.unlock(currentStage.id);
		if (!options.skipProgressSync) {
			void syncCourseProgress(contentUrl, 100, currentStage.id);
		}

		courseState.next();
	}

	function handleBack() {
		if (courseState.currentStageIndex === 0) {
			window.location.href = '/main';
		} else {
			courseState.prev();
		}
	}

	$effect(() => {
		const index = courseState.currentStageIndex;
		if (index >= 0) {
			currentDistance = 0;
			accumulatedPulls = 0;
			isCorrect = false;
			showFeedback = false;
		}
	});
</script>

<div class="relative flex min-h-screen flex-col bg-gray-50">
	<button
		onclick={handleBack}
		class="absolute top-8 left-8 z-50 cursor-pointer p-2 text-gray-500 transition-colors hover:text-[#4A3000]"
		aria-label="返回"
	>
		<svg
			xmlns="http://www.w3.org/2000/svg"
			width="32"
			height="32"
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			stroke-width="2.5"
			stroke-linecap="round"
			stroke-linejoin="round"
		>
			<line x1="19" y1="12" x2="5" y2="12"></line>
			<polyline points="12 19 5 12 12 5"></polyline>
		</svg>
	</button>

	<main class="flex w-full flex-grow flex-col items-center justify-center p-8">
		<div class="flex w-full max-w-[1000px] flex-col gap-6">
			<QuestionArea {courseState} {isCorrect} {showFeedback} />

			<SimulatorDispatcher
				{courseState}
				{contentUrl}
				bind:currentDistance
				bind:accumulatedPulls
				onCorrect={handleCorrect}
			/>
		</div>
	</main>

	<LearningSidebar {courseState} />
</div>
