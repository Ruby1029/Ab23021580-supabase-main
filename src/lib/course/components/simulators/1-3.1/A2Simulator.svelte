<script lang="ts">
	import { Spring } from 'svelte/motion';

	let { onCorrect } = $props();

	// Graph parameters
	const W = 500;
	const H = 400;
	const padding = 50;
	const graphW = W - padding * 2;
	const graphH = H - padding * 2;

	// Scale
	const maxX = 600;
	const maxY = 600;

	let points = $state<{ x: number; y: number }[]>([]);
	let isDone = $state(false);

	const targetPoints = [
		{ x: 100, y: 100 },
		{ x: 600, y: 600 }
	];

	function mapX(val: number) {
		return padding + (val / maxX) * graphW;
	}

	function mapY(val: number) {
		return H - padding - (val / maxY) * graphH;
	}

	function unmapX(px: number) {
		return ((px - padding) / graphW) * maxX;
	}

	function unmapY(py: number) {
		return ((H - padding - py) / graphH) * maxY;
	}

	function handleGraphClick(e: MouseEvent) {
		if (isDone) return;

		const rect = (e.currentTarget as SVGSVGElement).getBoundingClientRect();
		// Adjust for viewBox scaling
		const scaleX = W / rect.width;
		const scaleY = H / rect.height;

		const px = (e.clientX - rect.left) * scaleX;
		const py = (e.clientY - rect.top) * scaleY;

		let valX = Math.round(unmapX(px) / 100) * 100;
		let valY = Math.round(unmapY(py) / 100) * 100;

		// Constrain
		valX = Math.max(0, Math.min(maxX, valX));
		valY = Math.max(0, Math.min(maxY, valY));

		// Check if point already exists
		if (!points.some((p) => p.x === valX && p.y === valY)) {
			points = [...points, { x: valX, y: valY }];
		}

		checkWin();
	}

	function checkWin() {
		// Check if targetPoints are all in points
		const hasAll = targetPoints.every((tp) => points.some((p) => p.x === tp.x && p.y === tp.y));

		// Ensure only 2 points or the targets are matched
		if (hasAll) {
			isDone = true;
			onCorrect();
		} else if (points.length >= 3) {
			// Reset if too many wrong points
			setTimeout(() => {
				points = [];
			}, 500);
		}
	}

	// Line animation
	const lineProgress = new Spring(0, { stiffness: 0.1, damping: 0.5 });
	$effect(() => {
		if (isDone) lineProgress.set(1);
	});
</script>

<div class="flex w-full flex-col items-center justify-center p-4">
	<div class="mb-4 rounded-full bg-white px-4 py-2 text-lg font-bold text-slate-700 shadow-sm">
		請在座標圖上點出 100ml 與 600ml 水的質量
	</div>

	<!-- SVG 鎖定在 aspect-video 容器內 -->
	<div class="relative aspect-video w-full max-w-[600px]">
		<svg
			viewBox="0 0 {W} {H}"
			class="absolute inset-0 h-full w-full cursor-crosshair rounded-xl border bg-white shadow-md"
			onclick={handleGraphClick}
			role="presentation"
		>
			<!-- Grid lines -->
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

			<!-- Labels -->
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
			<text x={padding - 10} y={H - padding + 20} font-size="12" fill="#64748b">0</text>

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
			</defs>

			<!-- Drawn Line -->
			{#if isDone}
				{@const p1 = { x: padding, y: H - padding }}
				{@const p2 = { x: mapX(600), y: mapY(600) }}
				<line
					x1={p1.x}
					y1={p1.y}
					x2={p1.x + (p2.x - p1.x) * lineProgress.current}
					y2={p1.y + (p2.y - p1.y) * lineProgress.current}
					stroke="#3b82f6"
					stroke-width="4"
					stroke-linecap="round"
				/>
				<text
					x={mapX(300) - 20}
					y={mapY(300) - 20}
					fill="#2563eb"
					font-weight="bold"
					font-size="16"
					transform="rotate(-38, {mapX(300)}, {mapY(300)})"
				>
					M ∝ V (通過原點的斜直線)
				</text>
			{/if}

			<!-- User Points -->
			{#each points as p (`${p.x}-${p.y}`)}
				<!-- Check if it is a target point -->
				{@const isTarget = targetPoints.some((tp) => tp.x === p.x && tp.y === p.y)}
				<circle
					cx={mapX(p.x)}
					cy={mapY(p.y)}
					r="6"
					fill={isTarget ? '#ef4444' : '#94a3b8'}
					class="transition-all duration-300"
				/>
				{#if isTarget}
					<text
						x={mapX(p.x) + 10}
						y={mapY(p.y) - 10}
						fill="#ef4444"
						font-weight="bold"
						font-size="12">({p.x}, {p.y})</text
					>
				{/if}
			{/each}

			<!-- Hover effect hint for correct zones (only before done) -->
			{#if !isDone}
				{#each targetPoints as tp (`${tp.x}-${tp.y}`)}
					{#if !points.some((p) => p.x === tp.x && p.y === tp.y)}
						<circle
							cx={mapX(tp.x)}
							cy={mapY(tp.y)}
							r="15"
							fill="rgba(239, 68, 68, 0.1)"
							class="pointer-events-none animate-pulse"
						/>
					{/if}
				{/each}
			{/if}
		</svg>
	</div>
	<!-- end aspect-video wrapper -->
</div>
