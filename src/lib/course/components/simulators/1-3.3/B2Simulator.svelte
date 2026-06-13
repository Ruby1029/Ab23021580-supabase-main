<script lang="ts">
	let { onCorrect } = $props();

	let showLine = $state(false);

	function trigger() {
		showLine = true;
		setTimeout(onCorrect, 1000);
	}

	// SVG Map
	const W = 500;
	const H = 400;
	const padding = 50;

	function mapX(v: number) {
		return padding + (v / 100) * (W - 2 * padding);
	}
	function mapY(m: number) {
		return H - padding - (m / 150) * (H - 2 * padding);
	}

	// Data
	// Water: M = 1 * V  => V = M / 1.0
	// Sugar water: M = 1.5 * V => V = M / 1.5
	const fixedM = 90;
	const vWater = fixedM / 1.0; // 90
	const vSugar = fixedM / 1.5; // 60
</script>

<div
	class="mx-auto flex w-full max-w-[600px] flex-col overflow-hidden rounded-xl border bg-slate-50 shadow-inner"
>
	<div class="pt-4 pb-1 text-center text-base font-bold text-slate-700">
		看圖說故事：固定質量 (M)
	</div>

	<!-- SVG in aspect-video wrapper -->
	<div class="relative aspect-video w-full bg-slate-100">
		<svg viewBox="0 0 {W} {H}" class="absolute inset-0 h-full w-full border-b bg-white">
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
					<path d="M 0 0 L 10 5 L 0 10 z" fill="#475569" />
				</marker>
			</defs>

			<!-- Axes -->
			<line
				x1={padding}
				y1={H - padding}
				x2={W - padding + 20}
				y2={H - padding}
				stroke="#475569"
				stroke-width="2"
				marker-end="url(#arrow)"
			/>
			<line
				x1={padding}
				y1={H - padding}
				x2={padding}
				y2={padding - 20}
				stroke="#475569"
				stroke-width="2"
				marker-end="url(#arrow)"
			/>

			<text
				x={W - padding + 10}
				y={H - padding + 20}
				text-anchor="middle"
				font-weight="bold"
				fill="#475569">體積 V (cm³)</text
			>
			<text x={padding - 15} y={padding - 20} text-anchor="end" font-weight="bold" fill="#475569"
				>質量 M (g)</text
			>

			<!-- Lines -->
			<!-- Water line -->
			<line
				x1={mapX(0)}
				y1={mapY(0)}
				x2={mapX(90)}
				y2={mapY(90)}
				stroke="#3b82f6"
				stroke-width="3"
			/>
			<text x={mapX(90) + 10} y={mapY(90) + 5} font-weight="bold" fill="#3b82f6">純水</text>

			<!-- Sugar water line -->
			<line
				x1={mapX(0)}
				y1={mapY(0)}
				x2={mapX(90)}
				y2={mapY(135)}
				stroke="#d97706"
				stroke-width="3"
			/>
			<text x={mapX(90) + 10} y={mapY(135) + 5} font-weight="bold" fill="#d97706">糖水</text>

			<!-- Animation Part -->
			{#if showLine}
				<!-- Horizontal line at fixed M -->
				<line
					x1={padding}
					y1={mapY(fixedM)}
					x2={mapX(vWater)}
					y2={mapY(fixedM)}
					stroke="#ef4444"
					stroke-width="2"
					stroke-dasharray="6"
					class="animate-draw-h"
				/>

				<!-- Vertical lines down to V axis -->
				<line
					x1={mapX(vSugar)}
					y1={mapY(fixedM)}
					x2={mapX(vSugar)}
					y2={H - padding}
					stroke="#d97706"
					stroke-width="2"
					stroke-dasharray="4"
					class="animate-draw-v1 delay-500"
					style="opacity: 0; animation-fill-mode: forwards;"
				/>
				<line
					x1={mapX(vWater)}
					y1={mapY(fixedM)}
					x2={mapX(vWater)}
					y2={H - padding}
					stroke="#3b82f6"
					stroke-width="2"
					stroke-dasharray="4"
					class="animate-draw-v2 delay-1000"
					style="opacity: 0; animation-fill-mode: forwards;"
				/>

				<!-- Points -->
				<circle
					cx={mapX(vSugar)}
					cy={mapY(fixedM)}
					r="5"
					fill="#d97706"
					class="animate-fade-in delay-500"
					style="opacity: 0; animation-fill-mode: forwards;"
				/>
				<circle
					cx={mapX(vWater)}
					cy={mapY(fixedM)}
					r="5"
					fill="#3b82f6"
					class="animate-fade-in delay-1000"
					style="opacity: 0; animation-fill-mode: forwards;"
				/>

				<!-- M label -->
				<text
					x={padding - 10}
					y={mapY(fixedM) + 4}
					text-anchor="end"
					font-weight="bold"
					fill="#ef4444"
					class="animate-fade-in">相同質量</text
				>

				<!-- V labels -->
				<text
					x={mapX(vSugar)}
					y={H - padding + 20}
					text-anchor="middle"
					font-weight="bold"
					fill="#d97706"
					class="animate-fade-in delay-500"
					style="opacity: 0; animation-fill-mode: forwards;">較小</text
				>
				<text
					x={mapX(vWater)}
					y={H - padding + 20}
					text-anchor="middle"
					font-weight="bold"
					fill="#3b82f6"
					class="animate-fade-in delay-1000"
					style="opacity: 0; animation-fill-mode: forwards;">較大</text
				>
			{/if}
		</svg>
	</div>

	<!-- Controls -->
	<div class="flex w-full shrink-0 flex-col items-center gap-4 bg-white px-6 py-4">
		{#if !showLine}
			<button
				class="rounded-lg bg-rose-500 px-8 py-3 font-bold text-white shadow-md transition-all hover:bg-rose-600 active:scale-95"
				onclick={trigger}
			>
				畫一條水平線 (固定 M)
			</button>
		{:else}
			<div
				class="animate-fade-in rounded-lg border border-rose-200 bg-rose-50 px-6 py-3 text-lg font-bold text-slate-700 delay-1000"
				style="opacity: 0; animation-fill-mode: forwards;"
			>
				質量一樣時，<span class="text-amber-600">糖水的體積更小</span>，代表糖水比較緊密！
			</div>
		{/if}
	</div>
</div>

<style>
	.animate-draw-h {
		animation: drawH 0.5s ease-out forwards;
	}
	@keyframes drawH {
		from {
			stroke-dashoffset: 400;
			stroke-dasharray: 400;
		}
		to {
			stroke-dashoffset: 0;
			stroke-dasharray: 400;
		}
	}

	.animate-draw-v1 {
		animation: drawV 0.5s ease-out forwards;
	}
	.animate-draw-v2 {
		animation: drawV 0.5s ease-out forwards;
	}
	@keyframes drawV {
		from {
			stroke-dashoffset: 400;
			stroke-dasharray: 400;
			opacity: 1;
		}
		to {
			stroke-dashoffset: 0;
			stroke-dasharray: 400;
			opacity: 1;
		}
	}

	.animate-fade-in {
		animation: fadeIn 0.5s ease-out forwards;
	}
	@keyframes fadeIn {
		from {
			opacity: 0;
		}
		to {
			opacity: 1;
		}
	}

	.delay-500 {
		animation-delay: 0.5s;
	}
	.delay-1000 {
		animation-delay: 1s;
	}
</style>
