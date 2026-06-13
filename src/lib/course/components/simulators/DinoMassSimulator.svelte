<script lang="ts">
	import type { CourseState } from '$lib/course/courseState.svelte';
	import LegoDino from './1-2.1/_shared/LegoDino.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	let scene = $state<'space' | 'water' | null>(null);
	let done = $state(false);

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	async function handleClick() {
		if (done || courseState.isUnlocked(courseState.currentStage.id)) return;

		if (!scene) {
			scene = 'space';
			await sleep(2000);
			scene = 'water';
			await sleep(2000);
			done = true;
			await sleep(500);
			onCorrect();
		}
	}

	// 星星座標（隨機但固定）
	const STARS = Array.from({ length: 30 }, (_, i) => ({
		x: (i * 73 + 17) % 340,
		y: (i * 47 + 11) % 220,
		r: 0.8 + (i % 3) * 0.5
	}));
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !scene}點擊觀察
		{:else if scene === 'space'}太空中 — 質量 = 30 塊積木
		{:else if scene === 'water'}水中 — 質量 = 30 塊積木
		{/if}
		{#if done}
			<br />質量 = 物質的總量，不隨地點改變
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 340 240"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[360px] cursor-pointer"
		role="img"
		aria-label="質量不隨環境改變"
		onclick={handleClick}
	>
		<!-- 背景 -->
		{#if scene === 'space'}
			<!-- 太空 -->
			<rect width="340" height="240" rx="8" fill="#0f172a" />
			{#each STARS as star (`${star.x}-${star.y}`)}
				<circle cx={star.x} cy={star.y} r={star.r} fill="white" opacity="0.8" />
			{/each}
			<!-- 地球（遠景） -->
			<circle cx="300" cy="210" r="35" fill="#3b82f6" opacity="0.4" />
			<circle cx="295" cy="205" r="12" fill="#22c55e" opacity="0.3" />
		{:else if scene === 'water'}
			<!-- 水中 -->
			<rect width="340" height="240" rx="8" fill="#0ea5e9" fill-opacity="0.3" />
			<rect y="20" width="340" height="220" rx="0" fill="#0284c7" fill-opacity="0.2" />
			<!-- 氣泡 -->
			{#each [60, 120, 200, 270, 310] as bx, i (`${bx}-${i}`)}
				<circle cx={bx} cy={180 + i * 8} r={3 + (i % 3)} fill="white" fill-opacity="0.4" />
				<circle cx={bx + 15} cy={140 + i * 12} r={2 + (i % 2)} fill="white" fill-opacity="0.3" />
			{/each}
		{:else}
			<rect width="340" height="240" rx="8" fill="#f8fafc" stroke="#e2e8f0" stroke-width="2" />
		{/if}

		<!-- 小恐龍 -->
		<LegoDino x={170} y={110} builtCount={30} floating={scene !== null} />

		<!-- 質量標籤（始終顯示 30 塊） -->
		{#if scene}
			<rect
				x="100"
				y="200"
				width="140"
				height="28"
				rx="6"
				fill="white"
				fill-opacity="0.9"
				stroke="#94a3b8"
				stroke-width="1"
			/>
			<text x="170" y="219" text-anchor="middle" font-size="12" font-weight="bold" fill="#475569">
				質量 = 30 塊積木
			</text>
		{/if}

		<!-- 未開始提示 -->
		{#if !scene}
			<text x="170" y="220" text-anchor="middle" font-size="12" fill="#94a3b8">點擊觀察</text>
		{/if}

		<!-- 完成標示 -->
		{#if done}
			<rect
				x="50"
				y="200"
				width="240"
				height="30"
				rx="7"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="170" y="220" text-anchor="middle" font-size="12" font-weight="bold" fill="#16a34a">
				質量 = 物質的總量，不隨地點改變
			</text>
		{/if}
	</svg>
</div>
