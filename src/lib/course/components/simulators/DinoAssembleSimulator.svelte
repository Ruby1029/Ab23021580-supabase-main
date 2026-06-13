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

	let started = $state(false);
	let count = $state(0);
	let done = $state(false);

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	async function handleClick() {
		if (started || done || courseState.isUnlocked(courseState.currentStage.id)) return;
		started = true;

		// 每 80ms 加一塊積木，共 30 塊
		for (let i = 1; i <= 30; i++) {
			count = i;
			await sleep(80);
		}

		done = true;
		await sleep(600);
		onCorrect();
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !started}點擊開始組裝
		{:else if done}小恐龍 = 1 個物體，30 個物質
		{:else}組裝中… {count} / 30 塊
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 340 260"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[360px] cursor-pointer"
		role="img"
		aria-label="樂高積木組裝小恐龍"
		onclick={handleClick}
	>
		<!-- 恐龍 -->
		<LegoDino x={180} y={120} builtCount={count} />

		<!-- 散落的積木（未組裝時顯示） -->
		{#if !started}
			{#each Array(6) as brickMarker, i (`${brickMarker}-${i}`)}
				<rect
					x={30 + i * 50}
					y={220 + (i % 2) * 12}
					width="14"
					height="8"
					rx="2"
					fill={i % 2 === 0 ? '#22c55e' : '#16a34a'}
					stroke="#166534"
					stroke-width="0.8"
					opacity="0.5"
				/>
			{/each}
			<text x="170" y="250" text-anchor="middle" font-size="11" fill="#94a3b8">點擊開始組裝</text>
		{/if}

		<!-- 計數器 -->
		{#if started && !done}
			<text x="310" y="25" text-anchor="end" font-size="15" font-weight="black" fill="#22c55e">
				{count}<tspan font-size="9" fill="#64748b"> / 30</tspan>
			</text>
		{/if}

		<!-- 標籤 -->
		{#if done}
			<rect
				x="50"
				y="222"
				width="240"
				height="30"
				rx="7"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="170" y="242" text-anchor="middle" font-size="12" font-weight="bold" fill="#16a34a">
				30 個物質 組成 1 個物體
			</text>
		{/if}
	</svg>
</div>
