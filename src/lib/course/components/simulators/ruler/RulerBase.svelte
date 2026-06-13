<script lang="ts">
	let {
		pxPerMm = 4,
		startMm = 50,
		currentMm = 50,
		tickIntervalMm = 1,
		majorTickIntervalMm = 10,
		unitLabel = 'cm'
	}: {
		pxPerMm?: number;
		startMm?: number;
		currentMm?: number;
		tickIntervalMm?: number;
		majorTickIntervalMm?: number;
		unitLabel?: string;
	} = $props();

	let minMm = $derived(Math.min(startMm, currentMm));
	let maxMm = $derived(Math.max(startMm, currentMm));
	let ticks = $derived.by(() => {
		const interval = Math.max(0.1, tickIntervalMm);
		const majorInterval = Math.max(interval, majorTickIntervalMm);
		const count = Math.floor(200 / interval);

		return Array.from({ length: count + 1 }, (_, i) => {
			const mm = Number((i * interval).toFixed(4));
			const majorRatio = mm / majorInterval;
			const halfRatio = mm / (majorInterval / 2);

			return {
				mm,
				isMajor: Math.abs(majorRatio - Math.round(majorRatio)) < 0.001,
				isHalf: Math.abs(halfRatio - Math.round(halfRatio)) < 0.001
			};
		});
	});

	function tickLabel(mm: number) {
		if (unitLabel === 'inch') return Number((mm / 25.4).toFixed(1)).toString();
		return Number((mm / 10).toFixed(1)).toString();
	}
</script>

<g class="ruler-base">
	<rect
		x="50"
		y="40"
		width="800"
		height="80"
		fill="var(--bg-main)"
		stroke="#333"
		stroke-width="2"
		rx="4"
	/>

	{#each ticks as tick (`${tick.x}-${tick.label ?? ''}-${tick.isMajor}`)}
		{@const x = 50 + tick.mm * pxPerMm}
		{@const isPassed = tick.mm >= minMm && tick.mm <= maxMm && minMm !== maxMm}

		<line
			x1={x}
			y1="40"
			x2={x}
			y2={tick.isMajor ? 75 : tick.isHalf ? 65 : 55}
			stroke={isPassed ? '#3b82f6' : '#333'}
			stroke-width={tick.isMajor ? (isPassed ? 3 : 2) : 1}
			class="transition-colors duration-200"
		/>

		{#if tick.isMajor}
			<text
				{x}
				y="95"
				text-anchor="middle"
				font-size="14"
				font-weight={isPassed ? '900' : 'bold'}
				fill={isPassed ? '#3b82f6' : '#333'}
				class="transition-all duration-200"
			>
				{tickLabel(tick.mm)}
			</text>
		{/if}
	{/each}

	<!-- 將 cm 字樣放在 19cm 和 20cm 之間的中點 (19.5cm) -->
	<text
		x={50 + 195 * pxPerMm}
		y="65"
		text-anchor="middle"
		font-size="14"
		font-weight="900"
		fill="#333">{unitLabel}</text
	>
</g>
