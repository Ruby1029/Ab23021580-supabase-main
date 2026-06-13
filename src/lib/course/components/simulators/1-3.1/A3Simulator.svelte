<script lang="ts">
	import { Spring } from 'svelte/motion';

	let { onCorrect } = $props();

	// Graph parameters
	const W = 500;
	const H = 400;
	const padding = 50;
	const graphW = W - padding * 2;
	const graphH = H - padding * 2;
	const maxX = 600;
	const maxY = 600;

	function mapX(val: number) {
		return padding + (val / maxX) * graphW;
	}
	function mapY(val: number) {
		return H - padding - (val / maxY) * graphH;
	}

	let step = $state(0);
	const progressX = new Spring(0, { stiffness: 0.1, damping: 0.6 });
	const progressY = new Spring(0, { stiffness: 0.1, damping: 0.6 });

	function nextStep() {
		if (step >= 5) return;
		step++;
		progressX.set(step);
		setTimeout(() => progressY.set(step), 400);

		if (step === 5) {
			setTimeout(() => {
				onCorrect();
			}, 1000);
		}
	}
</script>

<div class="flex w-full flex-col items-center justify-center p-4">
	<div class="mb-4 rounded-full bg-white px-4 py-2 text-lg font-bold text-slate-700 shadow-sm">
		點擊按鈕，觀察斜率的變化規律
	</div>

	<!-- SVG 鎖定在 aspect-video 容器內 -->
	<div class="relative aspect-video w-full max-w-[600px]">
		<svg
			viewBox="0 0 {W} {H}"
			class="absolute inset-0 h-full w-full rounded-xl border bg-white shadow-md"
		>
			<!-- Grid -->
			{#each [100, 200, 300, 400, 500, 600] as val (val)}
				<line
					x1={padding}
					y1={mapY(val)}
					x2={W - padding}
					y2={mapY(val)}
					stroke="#e2e8f0"
					stroke-width="1"
					stroke-dasharray="4"
				/>
				<line
					x1={mapX(val)}
					y1={H - padding}
					x2={mapX(val)}
					y2={padding}
					stroke="#e2e8f0"
					stroke-width="1"
					stroke-dasharray="4"
				/>
				<text x={padding - 10} y={mapY(val) + 4} text-anchor="end" font-size="12" fill="#64748b"
					>{val}</text
				>
				<text x={mapX(val)} y={H - padding + 20} text-anchor="middle" font-size="12" fill="#64748b"
					>{val}</text
				>
			{/each}

			<!-- Axes -->
			<line
				x1={padding}
				y1={H - padding}
				x2={W - padding + 20}
				y2={H - padding}
				stroke="#334155"
				stroke-width="2"
				marker-end="url(#arrow)"
			/>
			<line
				x1={padding}
				y1={H - padding}
				x2={padding}
				y2={padding - 20}
				stroke="#334155"
				stroke-width="2"
				marker-end="url(#arrow)"
			/>
			<text
				x={W - padding + 10}
				y={H - padding + 35}
				font-size="14"
				font-weight="bold"
				fill="#334155">體積 V (ml)</text
			>
			<text x={padding - 20} y={padding - 30} font-size="14" font-weight="bold" fill="#334155"
				>質量 M (g)</text
			>

			<defs>
				<marker
					id="arrow"
					viewBox="0 0 10 10"
					refX="5"
					refY="5"
					markerWidth="6"
					markerHeight="6"
					orient="auto-start-reverse"
				>
					<path d="M 0 0 L 10 5 L 0 10 z" fill="#334155" />
				</marker>
				<marker
					id="arrow-red"
					viewBox="0 0 10 10"
					refX="5"
					refY="5"
					markerWidth="5"
					markerHeight="5"
					orient="auto-start-reverse"
				>
					<path d="M 0 0 L 10 5 L 0 10 z" fill="#ef4444" />
				</marker>
			</defs>

			<!-- Main Line (faded) -->
			<line
				x1={mapX(0)}
				y1={mapY(0)}
				x2={mapX(600)}
				y2={mapY(600)}
				stroke="#3b82f6"
				stroke-width="4"
				opacity="0.2"
			/>

			<!-- Steps Visualization -->
			{#if step > 0}
				{@const currX = Math.min(step, progressX.current)}
				{@const currY = Math.min(step, progressY.current)}

				<!-- X Arrow (Right) -->
				<line
					x1={mapX((step - 1) * 100)}
					y1={mapY((step - 1) * 100)}
					x2={mapX((step - 1) * 100 + (currX - (step - 1)) * 100)}
					y2={mapY((step - 1) * 100)}
					stroke="#ef4444"
					stroke-width="3"
					marker-end="url(#arrow-red)"
				/>

				<!-- Y Arrow (Up) -->
				<line
					x1={mapX(step * 100)}
					y1={mapY((step - 1) * 100)}
					x2={mapX(step * 100)}
					y2={mapY((step - 1) * 100 + (currY - (step - 1)) * 100)}
					stroke="#10b981"
					stroke-width="3"
					marker-end="url(#arrow)"
				/>

				<!-- Slope text label -->
				{#if currY === step}
					<text
						x={mapX(step * 100 - 50)}
						y={mapY(step * 100) - 10}
						font-size="12"
						font-weight="bold"
						fill="#334155"
						text-anchor="middle"
					>
						+100g / +100ml
					</text>
				{/if}

				<!-- History steps -->
				{#each Array(step - 1) as stepMarker, i (`${stepMarker}-${i}`)}
					<line
						x1={mapX(i * 100)}
						y1={mapY(i * 100)}
						x2={mapX((i + 1) * 100)}
						y2={mapY(i * 100)}
						stroke="#ef4444"
						stroke-width="3"
						marker-end="url(#arrow-red)"
					/>
					<line
						x1={mapX((i + 1) * 100)}
						y1={mapY(i * 100)}
						x2={mapX((i + 1) * 100)}
						y2={mapY((i + 1) * 100)}
						stroke="#10b981"
						stroke-width="3"
						marker-end="url(#arrow)"
					/>
				{/each}
			{/if}
		</svg>
	</div>
	<!-- end aspect-video wrapper -->

	<button
		class="rounded-lg bg-blue-500 px-6 py-3 font-bold text-white shadow-md transition-all hover:bg-blue-600 active:scale-95 disabled:cursor-not-allowed disabled:opacity-50"
		onclick={nextStep}
		disabled={step >= 5}
	>
		{step >= 5 ? '觀察完畢' : '前進一格 ( +100ml )'}
	</button>
</div>
