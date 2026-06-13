<script lang="ts">
	import type { Component } from 'svelte';
	import { fade } from 'svelte/transition';
	import type { CourseState } from '../courseState.svelte';
	import RulerSimulator from './simulators/ruler/RulerSimulator.svelte';
	import QuizSimulator from './simulators/quiz/QuizSimulator.svelte';
	import QuizInput from './simulators/quiz/QuizInput.svelte';
	import MathRenderer from './Math.svelte';

	import PixelButton from './PixelButton.svelte';

	type SimulatorModule = {
		default: Component<Record<string, unknown>>;
	};

	const SIMULATORS: Record<string, () => Promise<SimulatorModule>> = {
		MULTI_RULER_CLICK: () => import('./simulators/MultiRulerSimulator.svelte'),
		PENCIL_RULER: () => import('./simulators/PencilRulerSimulator.svelte'),
		MATCH_DIAGRAM: () => import('./simulators/MatchDiagramSimulator.svelte'),
		AVERAGE_SIMULATOR: () => import('./simulators/AverageSimulator.svelte'),
		CROW_STONE_SIMULATOR: () => import('./simulators/CrowStoneSimulator.svelte'),
		WATER_DROP_SIMULATOR: () => import('./simulators/WaterDropSimulator.svelte'),
		LITER_BOX_SIMULATOR: () => import('./simulators/LiterBoxSimulator.svelte'),
		KILO_LITER_SIMULATOR: () => import('./simulators/KiloLiterSimulator.svelte'),
		GRAD_CYLINDER_SIMULATOR: () => import('./simulators/GradCylinderSimulator.svelte'),
		EYE_LEVEL_SIMULATOR: () => import('./simulators/EyeLevelSimulator.svelte'),
		DINO_ASSEMBLE_SIMULATOR: () => import('./simulators/DinoAssembleSimulator.svelte'),
		DINO_MASS_SIMULATOR: () => import('./simulators/DinoMassSimulator.svelte'),
		DINO_WEIGHT_SIMULATOR: () => import('./simulators/DinoWeightSimulator.svelte'),
		DINO_SCALAR_VECTOR_SIMULATOR: () => import('./simulators/DinoScalarVectorSimulator.svelte'),
		LESSON_122_A1: () => import('./simulators/1-2.2/A1Simulator.svelte'),
		LESSON_122_A2: () => import('./simulators/1-2.2/A2Simulator.svelte'),
		LESSON_122_A3: () => import('./simulators/1-2.2/A3Simulator.svelte'),
		LESSON_122_A4: () => import('./simulators/1-2.2/A4Simulator.svelte'),
		LESSON_122_B1: () => import('./simulators/1-2.2/B1Simulator.svelte'),
		LESSON_123_A: () => import('./simulators/1-2.3/ASimulator.svelte'),
		LESSON_123_A1: () => import('./simulators/1-2.3/A1Simulator.svelte'),
		LESSON_123_A2: () => import('./simulators/1-2.3/A2Simulator.svelte'),
		LESSON_123_A3: () => import('./simulators/1-2.3/A3Simulator.svelte'),
		LESSON_123_A4: () => import('./simulators/1-2.3/A4Simulator.svelte'),
		LESSON_123_A2A3A4: () => import('./simulators/1-2.3/A2A3A4Simulator.svelte'),
		LESSON_131_A: () => import('./simulators/1-3.1/ASimulator.svelte'),
		LESSON_131_A1: () => import('./simulators/1-3.1/A1Simulator.svelte'),
		LESSON_131_A2: () => import('./simulators/1-3.1/A2Simulator.svelte'),
		LESSON_131_A3: () => import('./simulators/1-3.1/A3Simulator.svelte'),
		LESSON_132_A: () => import('./simulators/1-3.2/ASimulator.svelte'),
		LESSON_132_A1: () => import('./simulators/1-3.2/A1Simulator.svelte'),
		LESSON_132_A2: () => import('./simulators/1-3.2/A2Simulator.svelte'),
		LESSON_132_A2XA1: () => import('./simulators/1-3.2/A2XA1Simulator.svelte'),
		LESSON_132_A3: () => import('./simulators/1-3.2/A3Simulator.svelte'),
		LESSON_132_B: () => import('./simulators/1-3.2/BSimulator.svelte'),
		LESSON_132_B1: () => import('./simulators/1-3.2/B1Simulator.svelte'),
		LESSON_132_B2: () => import('./simulators/1-3.2/B2Simulator.svelte'),
		LESSON_133_A: () => import('./simulators/1-3.3/ASimulator.svelte'),
		LESSON_133_A1: () => import('./simulators/1-3.3/A1Simulator.svelte'),
		LESSON_133_A2: () => import('./simulators/1-3.3/A2Simulator.svelte'),
		LESSON_133_B: () => import('./simulators/1-3.3/BSimulator.svelte'),
		LESSON_133_B1: () => import('./simulators/1-3.3/B1Simulator.svelte'),
		LESSON_133_B2: () => import('./simulators/1-3.3/B2Simulator.svelte'),
		LESSON_133_B2XB1: () => import('./simulators/1-3.3/B2XB1Simulator.svelte')
	};

	const STATIC_SIMULATOR_IDS = new Set(['STATIC_IMAGE', 'IMAGE_CROW_WATER', 'IMAGE_MASS_WEIGHT']);

	let {
		courseState,
		contentUrl,
		currentDistance = $bindable(0),
		accumulatedPulls = $bindable(0),
		onCorrect
	}: {
		courseState: CourseState;
		contentUrl: string;
		currentDistance: number;
		accumulatedPulls: number;
		onCorrect: (options?: { skipProgressSync?: boolean }) => void;
	} = $props();

	let currentStage = $derived(courseState.currentStage);
	let isActionCorrect = $state(false);
	let isQuizCorrect = $state(false);
	let showQuizDelayed = $state(false);
	let resetTrigger = $state(0);
	let ActiveSimulator = $state<Component<Record<string, unknown>> | null>(null);
	let hasInlineQuiz = $derived.by(() => {
		if (currentStage.quiz) return true;
		return /^1\s*(.+?)\s*=/.test(currentStage.contentText ?? '');
	});

	$effect(() => {
		const simId = currentStage?.simulator?.id;
		ActiveSimulator = null;

		if (simId && SIMULATORS[simId]) {
			SIMULATORS[simId]().then((module) => {
				if (courseState.currentStage?.simulator?.id === simId) {
					ActiveSimulator = module.default;
				}
			});

			const nextId = courseState.lessons[courseState.currentStageIndex + 1]?.simulator?.id;
			if (nextId && SIMULATORS[nextId]) void SIMULATORS[nextId]();
		}
	});

	$effect(() => {
		if (currentStage.id) {
			isActionCorrect = false;
			isQuizCorrect = false;
			showQuizDelayed = false;

			if (
				currentStage.simContent ||
				!currentStage.simulator ||
				STATIC_SIMULATOR_IDS.has(currentStage.simulator.id)
			) {
				isActionCorrect = true;
			}
		}
	});

	$effect(() => {
		if (isActionCorrect) {
			const timer = setTimeout(() => {
				showQuizDelayed = true;
			}, 600);
			return () => clearTimeout(timer);
		} else {
			showQuizDelayed = false;
		}
	});

	$effect(() => {
		if (
			isActionCorrect &&
			(isQuizCorrect || (!hasInlineQuiz && showQuizDelayed)) &&
			!courseState.isUnlocked(currentStage.id)
		) {
			onCorrect();
		}
	});
</script>

<section
	class="simulator-area relative flex flex-grow flex-col overflow-hidden transition-all duration-300 {styles.container}"
>
	{#key currentStage.id}
		<div
			class="flex flex-grow flex-col p-4"
			in:fade={{ duration: 500, delay: 500 }}
			out:fade={{ duration: 500 }}
		>
			<!-- 推導文字區 -->
			{#if currentStage.simContent}
				<div class="flex flex-grow items-center justify-center p-6">
					<div class="inline-block p-10 {styles.board}">
						<MathRenderer formula={currentStage.simContent} />
					</div>
				</div>
			{/if}

			{#if currentStage.simulator}
				{#if currentStage.simulator.id.startsWith('RULER')}
					<RulerSimulator
						{courseState}
						{contentUrl}
						completeOnServer={!hasInlineQuiz}
						bind:currentDistance
						bind:accumulatedPulls
						bind:isActionCorrect
						{resetTrigger}
						onCorrect={(options) => {
							isActionCorrect = true;
							if (options?.skipProgressSync && !hasInlineQuiz) onCorrect(options);
						}}
					/>
				{:else if currentStage.simulator.id === 'QUIZ_UNIT'}
					{#if !currentStage.simContent}
						<QuizSimulator {courseState} {onCorrect} />
					{/if}
				{:else if ActiveSimulator}
					<svelte:component
						this={ActiveSimulator}
						{courseState}
						onCorrect={() => (isActionCorrect = true)}
					/>
				{/if}
			{/if}

			{#if showQuizDelayed && !courseState.isUnlocked(currentStage.id) && hasInlineQuiz}
				<div class="absolute bottom-8 left-1/2 z-30 w-auto -translate-x-1/2">
					<QuizInput
						quizConfig={currentStage.quiz}
						quizLayout={currentStage.quizLayout}
						contentText={currentStage.contentText}
						bind:isQuizCorrect
					/>
				</div>
			{/if}
		</div>
	{/key}

	<!-- 底部工具欄區：按鈕上移至此層 -->
	<div
		class="pointer-events-none absolute right-[34px] bottom-[30px] left-4 z-50 flex items-center justify-between"
	>
		<!-- 左側：功能按鈕 -->
		<div class="pointer-events-auto">
			{#if currentStage.simulator?.id.startsWith('RULER') && currentStage.simulator?.id !== 'RULER_STATIC'}
				<PixelButton size="sm" color="default" onclick={() => resetTrigger++}>清除重作</PixelButton>
			{/if}
		</div>

		<!-- 右側：開發者工具 -->
		<div class="pointer-events-auto flex items-center gap-[18px]">
			<PixelButton
				size="xs"
				color="default"
				onclick={() => courseState.next()}
				title="開發者專用：跳到下一關"
			>
				SKIP STAGE >>
			</PixelButton>
		</div>
	</div>
</section>

<style>
	.simulator-area {
		display: grid;
		grid-template-columns: 1fr;
		grid-template-rows: 1fr;
	}
	.simulator-area > :global(div) {
		grid-column: 1;
		grid-row: 1;
	}
</style>
