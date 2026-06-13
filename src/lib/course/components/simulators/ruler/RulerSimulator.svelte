<script lang="ts">
	import type { CourseState } from '../../../courseState.svelte';
	import RulerBase from './RulerBase.svelte';
	import RulerInteraction from './RulerInteraction.svelte';
	import { authFetch } from '$lib/supabase/auth';

	let {
		courseState,
		contentUrl,
		completeOnServer = true,
		currentDistance = $bindable(0),
		accumulatedPulls = $bindable(0),
		isActionCorrect = $bindable(false),
		resetTrigger = 0,
		onCorrect
	}: {
		courseState: CourseState;
		contentUrl: string;
		completeOnServer?: boolean;
		currentDistance: number;
		accumulatedPulls: number;
		isActionCorrect: boolean;
		resetTrigger?: number;
		onCorrect: (options?: { skipProgressSync?: boolean }) => void;
	} = $props();

	let currentStage = $derived(courseState.currentStage);
	let config = $derived(currentStage.simulator?.config);

	const pxPerMm = 4;
	const svgWidth = 900;
	const svgHeight = 320;
	const offsetX = 50;

	let isDragging = $state(false);
	let isSubmitting = $state(false);
	let currentMm = $state(0);
	let startMm = $state(0);
	let pullHistory = $state<{ startMm: number; currentMm: number }[]>([]);

	let sliderX = $derived(offsetX + currentMm * pxPerMm);
	let startDragX = $derived(offsetX + startMm * pxPerMm);

	$effect(() => {
		currentDistance = Math.abs(currentMm - startMm) / 10;
	});

	$effect(() => {
		if (currentStage) reset(true);
	});

	// 監控外部重置訊號
	$effect(() => {
		if (resetTrigger > 0) reset(true);
	});

	function reset(isFullReset = false) {
		const id = currentStage.simulator?.id;
		if (isFullReset) {
			pullHistory = [];
			accumulatedPulls = 0;
		}
		if (id === 'RULER_STATIC' || id === 'RULER_DRAG_ACCUMULATE') {
			startMm = 0;
			currentMm = 0;
		} else {
			startMm = 50;
			currentMm = 50;
		}
		currentDistance = 0;
		isActionCorrect = false;
	}

	function handleInput(clientX: number, target: SVGElement) {
		const svgRect = target.getBoundingClientRect();
		const x = ((clientX - svgRect.left) * svgWidth) / svgRect.width;
		let xMm = Math.round((x - offsetX) / pxPerMm);
		xMm = Math.max(0, Math.min(200, xMm));
		if (!isDragging) startMm = xMm;
		currentMm = xMm;
	}

	function completeCurrentPull() {
		isDragging = false;
		pullHistory.push({ startMm, currentMm });
		accumulatedPulls++;
		if (accumulatedPulls >= (config?.pulls ?? 5)) {
			void submitAction({
				type: 'ruler_accumulate',
				distance: currentDistance,
				pulls: accumulatedPulls
			});
		} else {
			reset(false);
		}
	}

	function onPointerDown(e: MouseEvent | TouchEvent) {
		if (currentStage.simulator?.id === 'RULER_STATIC' || courseState.isUnlocked(currentStage.id))
			return;
		if (e.type === 'touchstart') e.preventDefault();
		isDragging = true;
		const clientX = 'touches' in e ? e.touches[0].clientX : (e as MouseEvent).clientX;
		handleInput(clientX, e.currentTarget as SVGElement);
	}

	function onPointerMove(e: MouseEvent | TouchEvent) {
		if (!isDragging || currentStage.simulator?.id === 'RULER_STATIC') return;
		if (e.type === 'touchmove') e.preventDefault();
		const clientX = 'touches' in e ? e.touches[0].clientX : (e as MouseEvent).clientX;
		handleInput(clientX, e.currentTarget as SVGElement);
	}

	function onPointerEnd() {
		if (!isDragging) return;
		isDragging = false;

		if (
			currentStage.simulator?.id === 'RULER_DRAG' ||
			currentStage.simulator?.id === 'RULER_DRAG_PRECISION'
		) {
			void submitAction({
				type: 'ruler_drag',
				distance: currentDistance
			});
		} else if (currentStage.simulator?.id === 'RULER_DRAG_ACCUMULATE') {
			completeCurrentPull();
		}
	}

	function handleStaticClick() {
		if (currentStage.simulator?.id === 'RULER_STATIC') {
			void submitAction({
				type: 'static_click'
			});
		}
	}

	async function submitAction(action: {
		type: string;
		value?: number;
		distance?: number;
		pulls?: number;
	}) {
		if (isSubmitting || courseState.isUnlocked(currentStage.id)) return;
		isSubmitting = true;

		try {
			const response = await authFetch('/api/simulator/action', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					contentUrl,
					stageId: currentStage.id,
					legacyLessonId: currentStage.id,
					simulatorId: currentStage.simulator?.id,
					completeLesson: completeOnServer,
					action
				})
			});

			if (!response.ok) return;
			const result = await response.json();
			if (result.correct) {
				isActionCorrect = true;
				onCorrect({ skipProgressSync: completeOnServer });
			}
		} finally {
			isSubmitting = false;
		}
	}
</script>

<div class="relative flex flex-col overflow-hidden">
	<div class="pointer-events-none absolute top-4 right-4 z-10 flex flex-col gap-2">
		{#if currentStage.simulator?.id.includes('DRAG')}
			<div class="flex items-center gap-3 rounded-lg bg-blue-600 px-4 py-2 text-white shadow-lg">
				<span class="text-xs font-bold opacity-80">目前距離</span>
				<span class="font-mono text-xl font-black"
					>{currentDistance.toFixed(1)} <small class="text-xs">cm</small></span
				>
			</div>
			{#if currentStage.simulator?.id.includes('ACCUMULATE')}
				<div
					class="flex items-center gap-3 rounded-lg bg-emerald-600 px-4 py-2 text-white shadow-lg"
				>
					<span class="text-xs font-bold opacity-80">累積進度</span>
					<span class="font-mono text-xl font-black">{accumulatedPulls} / {config?.pulls ?? 0}</span
					>
				</div>
			{/if}
		{/if}
	</div>

	<!-- svelte-ignore a11y_no_noninteractive_element_interactions, a11y_no_noninteractive_tabindex -->
	<svg
		width="100%"
		viewBox="0 0 {svgWidth} {svgHeight}"
		preserveAspectRatio="xMidYMid meet"
		onmousedown={onPointerDown}
		onmousemove={onPointerMove}
		onmouseup={onPointerEnd}
		onmouseleave={onPointerEnd}
		ontouchstart={onPointerDown}
		ontouchmove={onPointerMove}
		ontouchend={onPointerEnd}
		class="cursor-pointer select-none"
		class:pointer-events-none={courseState.isUnlocked(currentStage.id) &&
			currentStage.simulator?.id !== 'RULER_STATIC'}
		role="application"
		tabindex="0"
		aria-label="互動式尺規"
	>
		<RulerBase {startMm} {currentMm} />
		<RulerInteraction
			type={currentStage.simulator?.config.type}
			config={currentStage.simulator?.config}
			{sliderX}
			{startDragX}
			{pullHistory}
			activePullIndex={accumulatedPulls}
			onStaticClick={handleStaticClick}
		/>
	</svg>

	<!-- 按鈕已從此處移除，將搬移至上一層組件 -->
</div>

<style>
	.pointer-events-none {
		pointer-events: none;
	}
</style>
