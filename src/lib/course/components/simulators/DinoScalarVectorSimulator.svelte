<script lang="ts">
	import type { CourseState } from '$lib/course/courseState.svelte';
	import LegoDino from './1-2.1/_shared/LegoDino.svelte';
	import DigitalScale from './_global/lab/DigitalScale.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	let started = $state(false);
	let done = $state(false);

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	async function handleClick() {
		if (started || done || courseState.isUnlocked(courseState.currentStage.id)) return;
		started = true;
		await sleep(2500);
		done = true;
		await sleep(600);
		onCorrect();
	}

	// 左右半場座標
	const MID = 185;
	const SPACE_CX = 92,
		EARTH_CX = 278;
	const SCALE_Y = 210,
		DINO_Y = 130;

	// 星星座標
	const STARS = Array.from({ length: 20 }, (_, i) => ({
		x: (i * 47 + 13) % MID,
		y: (i * 59 + 7) % 280,
		r: 0.8 + (i % 3) * 0.5
	}));
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !started}點擊觀察
		{:else if done}質量（純量） vs 重量（向量）
		{:else}觀察兩者的差異…
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 370 280"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[390px] cursor-pointer"
		role="img"
		aria-label="質量與重量比較"
		onclick={handleClick}
	>
		<!-- ══ 左半場：太空（質量） ══ -->
		<rect x="0" y="0" width={MID} height="280" rx="8" fill="#0f172a" />
		<!-- 太空背景 -->
		{#each STARS as star (`${star.x}-${star.y}`)}
			<circle cx={star.x} cy={star.y} r={star.r} fill="white" opacity="0.8" />
		{/each}
		<!-- 左側標題 -->
		<text x={SPACE_CX} y="268" text-anchor="middle" font-size="14" font-weight="bold" fill="#94a3b8"
			>🌌 太空</text
		>

		<!-- 恐龍 (漂浮) -->
		<LegoDino x={SPACE_CX} y={DINO_Y} scale={0.7} builtCount={30} floating={true} />

		<!-- ══ 分界線 ══ -->
		<line
			x1={MID}
			y1="0"
			x2={MID}
			y2="280"
			stroke="#64748b"
			stroke-width="2"
			stroke-dasharray="6 4"
		/>

		<!-- ══ 右半場：地球 (重量) ══ -->
		<rect x={MID} y="0" width={370 - MID} height="280" rx="8" fill="#eff6ff" />
		<!-- 地面 -->
		<rect x={MID} y="230" width={370 - MID} height="50" rx="0" fill="#86efac" fill-opacity="0.3" />
		<!-- 右側標題 -->
		<text x={EARTH_CX} y="268" text-anchor="middle" font-size="14" font-weight="bold" fill="#3b82f6"
			>🌍 地球</text
		>

		<!-- 恐龍 + 電子秤 -->
		<LegoDino x={EARTH_CX} y={DINO_Y} scale={0.7} builtCount={30} />
		<DigitalScale x={EARTH_CX} y={SCALE_Y} reading={started ? '300 gw' : '---'} />

		<!-- 比較標示與箭頭 -->
		{#if started}
			<!-- 左側：純量 (無方向) -->
			<text
				x={SPACE_CX}
				y="40"
				text-anchor="middle"
				font-size="12"
				font-weight="bold"
				fill="#f8fafc">純量：300 克</text
			>

			<!-- 右側：向量 (向下) -->
			<text
				x={EARTH_CX}
				y="40"
				text-anchor="middle"
				font-size="12"
				font-weight="bold"
				fill="#1e40af">向量：向下 300 克重</text
			>

			<!-- 向下的箭頭 (代表重力方向) -->
			<g transform="translate({EARTH_CX}, 55)">
				<line x1="0" y1="0" x2="0" y2="25" stroke="#ef4444" stroke-width="3" />
				<polygon points="-4,20 4,20 0,28" fill="#ef4444" />
			</g>
		{/if}
	</svg>
</div>
