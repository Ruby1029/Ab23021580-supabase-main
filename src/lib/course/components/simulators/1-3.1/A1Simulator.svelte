<script lang="ts">
	let { onCorrect } = $props();

	let volume = $state(0);
	const MAX_VOLUME = 600;

	$effect(() => {
		if (volume > 400) {
			onCorrect();
		}
	});

	// SVG parameters
	const cx = 200;
	const cy = 250;

	let waterH = $derived((volume / MAX_VOLUME) * 120);
	const beakerBottomY = cy - 2;
</script>

<div
	class="mx-auto flex w-full max-w-[600px] flex-col overflow-hidden rounded-xl border bg-slate-50 shadow-inner"
>
	<!-- SVG 鎖定在 aspect-video 比例容器內，防止高度爆炸 -->
	<div class="relative aspect-video w-full bg-slate-100">
		<svg viewBox="0 0 400 300" class="absolute inset-0 h-full w-full select-none">
			<defs>
				<!-- Scale Base Gradient -->
				<linearGradient id="scale-base" x1="0%" y1="0%" x2="0%" y2="100%">
					<stop offset="0%" stop-color="#e2e8f0" />
					<stop offset="100%" stop-color="#94a3b8" />
				</linearGradient>
				<!-- Scale Pan Gradient -->
				<linearGradient id="scale-pan" x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stop-color="#cbd5e1" />
					<stop offset="50%" stop-color="#f8fafc" />
					<stop offset="100%" stop-color="#94a3b8" />
				</linearGradient>
				<!-- Glass Gradient -->
				<linearGradient id="glass" x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stop-color="rgba(255,255,255,0.6)" />
					<stop offset="20%" stop-color="rgba(255,255,255,0.1)" />
					<stop offset="80%" stop-color="rgba(255,255,255,0.1)" />
					<stop offset="100%" stop-color="rgba(255,255,255,0.5)" />
				</linearGradient>
				<!-- Water Gradient -->
				<linearGradient id="water" x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stop-color="rgba(59,130,246,0.8)" />
					<stop offset="50%" stop-color="rgba(96,165,250,0.8)" />
					<stop offset="100%" stop-color="rgba(37,99,235,0.8)" />
				</linearGradient>
				<filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
					<feDropShadow dx="0" dy="8" stdDeviation="4" flood-opacity="0.2" />
				</filter>
			</defs>

			<!-- Electronic Scale -->
			<g transform="translate(0, 30)">
				<!-- Base shadow -->
				<ellipse {cx} {cy} rx="90" ry="15" fill="rgba(0,0,0,0.15)" filter="url(#shadow)" />
				<!-- Base -->
				<path
					d="M {cx - 80} {cy - 20} L {cx + 80} {cy - 20} Q {cx + 90} {cy - 20} {cx +
						90} {cy} L {cx + 90} {cy + 5} Q {cx + 90} {cy + 15} {cx + 80} {cy + 15} L {cx -
						80} {cy + 15} Q {cx - 90} {cy + 15} {cx - 90} {cy + 5} L {cx - 90} {cy} Q {cx -
						90} {cy - 20} {cx - 80} {cy - 20} Z"
					fill="url(#scale-base)"
					stroke="#64748b"
					stroke-width="1.5"
				/>

				<!-- Pan -->
				<ellipse
					{cx}
					cy={cy - 25}
					rx="60"
					ry="12"
					fill="url(#scale-pan)"
					stroke="#94a3b8"
					stroke-width="2"
				/>
				<path
					d="M {cx - 60} {cy - 25} L {cx - 55} {cy - 20} L {cx + 55} {cy - 20} L {cx + 60} {cy -
						25} Z"
					fill="#94a3b8"
				/>

				<!-- LCD Display -->
				<rect
					x={cx - 30}
					y={cy - 10}
					width="60"
					height="20"
					rx="2"
					fill="#0f172a"
					stroke="#334155"
					stroke-width="2"
				/>
				<rect x={cx - 28} y={cy - 8} width="56" height="16" rx="1" fill="#86efac" />
				<text
					x={cx + 25}
					y={cy + 4}
					text-anchor="end"
					font-family="monospace"
					font-weight="bold"
					font-size="14"
					fill="#064e3b"
				>
					{volume.toFixed(1)} g
				</text>
			</g>

			<!-- Beaker -->
			<g>
				<!-- Water Body -->
				{#if volume > 0}
					<path
						d="M {cx - 40} {beakerBottomY - waterH} L {cx - 40} {beakerBottomY} Q {cx -
							40} {beakerBottomY + 5} {cx} {beakerBottomY + 5} Q {cx + 40} {beakerBottomY + 5} {cx +
							40} {beakerBottomY} L {cx + 40} {beakerBottomY - waterH} Z"
						fill="url(#water)"
					/>
					<!-- Water Top Ellipse -->
					<ellipse {cx} cy={beakerBottomY - waterH} rx="40" ry="6" fill="rgba(96,165,250,0.9)" />
				{/if}

				<!-- Beaker Glass Back -->
				<ellipse
					{cx}
					cy={beakerBottomY - 140}
					rx="45"
					ry="8"
					fill="none"
					stroke="rgba(255,255,255,0.8)"
					stroke-width="2"
				/>

				<!-- Beaker Body -->
				<path
					d="M {cx - 45} {beakerBottomY - 140} L {cx - 45} {beakerBottomY} Q {cx -
						45} {beakerBottomY + 10} {cx} {beakerBottomY + 10} Q {cx + 45} {beakerBottomY +
						10} {cx + 45} {beakerBottomY} L {cx + 45} {beakerBottomY - 140}"
					fill="url(#glass)"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="2"
				/>

				<!-- Beaker Glass Front Ellipse -->
				<path
					d="M {cx - 45} {beakerBottomY - 140} Q {cx} {beakerBottomY - 130} {cx +
						45} {beakerBottomY - 140}"
					fill="none"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="2"
				/>

				<!-- Markings -->
				{#each [100, 200, 300, 400, 500, 600] as mark (mark)}
					{@const markY = beakerBottomY - (mark / MAX_VOLUME) * 120}
					<line x1={cx - 45} y1={markY} x2={cx - 35} y2={markY} stroke="white" stroke-width="1.5" />
					<text
						x={cx - 20}
						y={markY + 3}
						text-anchor="start"
						font-size="8"
						fill="white"
						font-weight="bold">{mark}</text
					>
				{/each}
			</g>

			<!-- Water Stream (when adding) -->
			<!-- omitted for simplicity, controlled by slider -->
		</svg>
	</div>
	<!-- end aspect-video wrapper -->

	<!-- Controls（正常流，不重疊 SVG）-->
	<div class="flex w-full shrink-0 flex-col gap-2 border-t border-slate-200 bg-white px-8 py-4">
		<div class="flex justify-between text-sm font-bold text-slate-600">
			<span>空杯 (0 ml)</span>
			<span>裝滿 (600 ml)</span>
		</div>
		<input
			type="range"
			min="0"
			max="600"
			step="10"
			bind:value={volume}
			class="h-2 w-full cursor-pointer appearance-none rounded-lg bg-slate-200 accent-blue-500"
		/>
		<div class="text-center text-sm text-slate-500">
			目前水量：<span class="font-black text-blue-600">{volume} ml</span>，質量約
			<span class="font-black text-emerald-600">{volume} g</span>
		</div>
	</div>
</div>
