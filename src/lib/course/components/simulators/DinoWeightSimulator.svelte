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
	const EARTH_CX = 92,
		MOON_CX = 278;
	const SCALE_Y = 210,
		DINO_Y = 130;
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !started}點擊觀察
		{:else if done}重量 = 質量受星球引力影響的結果
		{:else}觀察讀數差異…
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 370 280"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[390px] cursor-pointer"
		role="img"
		aria-label="地球與月球重量比較"
		onclick={handleClick}
	>
		<!-- ══ 左半場：地球 ══ -->
		<rect x="0" y="0" width={MID} height="280" rx="8" fill="#eff6ff" />
		<!-- 地球背景 -->
		<circle cx={EARTH_CX} cy="260" r="60" fill="#3b82f6" opacity="0.15" />
		<circle cx={EARTH_CX - 10} cy="252" r="18" fill="#22c55e" opacity="0.12" />
		<!-- 地面 -->
		<rect x="0" y="230" width={MID} height="50" rx="0" fill="#86efac" fill-opacity="0.3" />
		<text x={EARTH_CX} y="268" text-anchor="middle" font-size="14" font-weight="bold" fill="#3b82f6"
			>🌍 地球</text
		>

		<!-- 恐龍 + 電子秤 -->
		<LegoDino x={EARTH_CX} y={DINO_Y} scale={0.7} builtCount={30} />
		<DigitalScale x={EARTH_CX} y={SCALE_Y} reading={started ? '0.6 kg' : '---'} />

		<!-- ══ 分界線 ══ -->
		<line
			x1={MID}
			y1="0"
			x2={MID}
			y2="280"
			stroke="#94a3b8"
			stroke-width="2"
			stroke-dasharray="6 4"
		/>

		<!-- ══ 右半場：月球 ══ -->
		<rect x={MID} y="0" width={370 - MID} height="280" rx="8" fill="#f1f5f9" />
		<!-- 月球背景 -->
		<circle cx={MOON_CX} cy="260" r="55" fill="#94a3b8" opacity="0.12" />
		<!-- 月面 -->
		<rect x={MID} y="230" width={370 - MID} height="50" rx="0" fill="#cbd5e1" fill-opacity="0.3" />
		<!-- 隕石坑 -->
		<circle cx={MOON_CX - 20} cy="242" r="6" fill="#94a3b8" fill-opacity="0.15" />
		<circle cx={MOON_CX + 25} cy="248" r="8" fill="#94a3b8" fill-opacity="0.12" />
		<text x={MOON_CX} y="268" text-anchor="middle" font-size="14" font-weight="bold" fill="#64748b"
			>🌙 月球</text
		>

		<!-- 恐龍 + 電子秤 -->
		<LegoDino x={MOON_CX} y={DINO_Y} scale={0.7} builtCount={30} />
		<DigitalScale x={MOON_CX} y={SCALE_Y} reading={started ? '0.1 kg' : '---'} />

		<!-- 比較標示 -->
		{#if started && !done}
			<text
				x={EARTH_CX}
				y="20"
				text-anchor="middle"
				font-size="13"
				font-weight="bold"
				fill="#3b82f6">0.6 kg</text
			>
			<text x={MID} y="20" text-anchor="middle" font-size="13" fill="#94a3b8">≠</text>
			<text x={MOON_CX} y="20" text-anchor="middle" font-size="13" font-weight="bold" fill="#64748b"
				>0.1 kg</text
			>
		{/if}

		<!-- 完成標示 -->
		{#if done}
			<rect
				x="35"
				y="4"
				width="300"
				height="30"
				rx="7"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="185" y="24" text-anchor="middle" font-size="12" font-weight="bold" fill="#16a34a">
				重量 = 質量受星球引力影響的結果
			</text>
		{/if}
	</svg>
</div>
