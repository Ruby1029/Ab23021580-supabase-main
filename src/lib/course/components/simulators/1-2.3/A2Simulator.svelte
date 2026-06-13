<script lang="ts">
	/**
	 * 1-2.3 A2：歸零操作
	 * 點擊螺絲旋轉，指針擺動幅度漸小直到置中
	 * 教學核心：校準螺絲的作用與操作方向（朝較高的盤旋入/旋出）
	 */
	import type { CourseState } from '$lib/course/courseState.svelte';
	import TopPanBalance from './_shared/TopPanBalance.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	// 初始偏移：左盤較高 → 右側較重（正角度）
	const INIT_OFFSET = 14; // 初始傾斜度
	let zeroOffset = $state(INIT_OFFSET);
	let turns = $state(0); // 已轉動次數
	let animating = $state(false);
	let done = $state(false);

	const MAX_TURNS = 5;

	async function turnScrew() {
		if (animating || done || courseState.isUnlocked(courseState.currentStage.id)) return;
		animating = true;
		turns++;

		// 每次轉動：擺動後減少偏移
		const newOffset = INIT_OFFSET * (1 - turns / MAX_TURNS);
		// 擺動動畫：先過沖再回穩
		const swing = newOffset * 0.3;
		zeroOffset = newOffset - swing;
		await sleep(150);
		zeroOffset = newOffset + swing * 0.5;
		await sleep(150);
		zeroOffset = newOffset;
		await sleep(200);

		if (turns >= MAX_TURNS) {
			zeroOffset = 0;
			done = true;
			await sleep(700);
			onCorrect();
		}
		animating = false;
	}

	// 哪側較高的文字提示
	const sideHint = $derived(
		zeroOffset > 2
			? '右盤較高 → 朝右盤方向旋入螺絲'
			: zeroOffset < -2
				? '左盤較高 → 朝左盤方向旋入螺絲'
				: '指針置中 ✓ 歸零完成'
	);
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if !done}點擊校準螺絲，使指針歸零（{turns}/{MAX_TURNS}）{:else}歸零完成：指針靜止在正中央{/if}
	</p>

	<svg width="100%" viewBox="0 0 370 250" preserveAspectRatio="xMidYMid meet" class="max-w-[390px]">
		<rect width="370" height="250" rx="8" fill="#f8fafc" />

		<!-- 天平（初始向右傾斜） -->
		<TopPanBalance
			cx={185}
			cy={145}
			tiltAngle={0}
			{zeroOffset}
			highlightPart={!done ? 'screw' : null}
		/>

		<!-- 螺絲點擊熱區 (右側校準螺絲) -->
		{#if !done}
			<circle
				cx={313}
				cy={145}
				r="15"
				fill="transparent"
				stroke="#f97316"
				stroke-width="2"
				stroke-dasharray="4 3"
				style="cursor:pointer"
				onclick={turnScrew}
			/>
			<text x="313" y="170" text-anchor="middle" font-size="9" fill="#f97316"> 點擊旋轉 </text>
		{/if}

		<!-- 狀態提示 -->
		<rect
			x="20"
			y="222"
			width="330"
			height="22"
			rx="5"
			fill={done ? '#dcfce7' : '#fef3c7'}
			stroke={done ? '#4ade80' : '#fbbf24'}
			stroke-width="1.5"
		/>
		<text
			x="185"
			y="237"
			text-anchor="middle"
			font-size="10"
			font-weight="bold"
			fill={done ? '#16a34a' : '#92400e'}
		>
			{sideHint}
		</text>
	</svg>
</div>
