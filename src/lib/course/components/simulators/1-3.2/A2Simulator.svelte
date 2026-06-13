<script lang="ts">
	let { onCorrect } = $props();

	let force = $state(0);
	let isDone = $state(false);

	const forceLevels = [
		{ name: '平放的衛生紙', volume: 100, mass: 2, r: 60, scaleY: 0.2 },
		{ name: '輕輕揉成團', volume: 80, mass: 2, r: 45, scaleY: 0.8 },
		{ name: '用力捏緊', volume: 40, mass: 2, r: 30, scaleY: 0.9 },
		{ name: '死命壓實', volume: 20, mass: 2, r: 20, scaleY: 1.0 }
	];

	$effect(() => {
		if (force === 3 && !isDone) {
			isDone = true;
			setTimeout(onCorrect, 1000);
		}
	});

	let currentLvl = $derived(forceLevels[force]);

	// SVG params
	const cx = 200;
	const cy = 250;
</script>

<div
	class="mx-auto flex w-full max-w-[600px] flex-col overflow-hidden rounded-xl border bg-slate-50 shadow-inner"
>
	<div class="pt-4 pb-1 text-center text-base font-bold text-slate-700">觀察：壓縮體積</div>

	<!-- SVG in aspect-video wrapper -->
	<div class="relative aspect-video w-full bg-slate-100">
		<svg viewBox="0 0 400 300" class="absolute inset-0 h-full w-full select-none">
			<defs>
				<!-- 5-stop Metallic Gradients -->
				<linearGradient id="metal-base2" x1="0%" y1="0%" x2="0%" y2="100%">
					<stop offset="0%" stop-color="#f8fafc" />
					<stop offset="25%" stop-color="#cbd5e1" />
					<stop offset="50%" stop-color="#94a3b8" />
					<stop offset="75%" stop-color="#cbd5e1" />
					<stop offset="100%" stop-color="#64748b" />
				</linearGradient>
				<linearGradient id="metal-pan2" x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stop-color="#94a3b8" />
					<stop offset="20%" stop-color="#f1f5f9" />
					<stop offset="50%" stop-color="#cbd5e1" />
					<stop offset="80%" stop-color="#f1f5f9" />
					<stop offset="100%" stop-color="#64748b" />
				</linearGradient>
				<filter id="shadow2" x="-20%" y="-20%" width="140%" height="140%">
					<feDropShadow dx="0" dy="8" stdDeviation="4" flood-opacity="0.25" />
				</filter>

				<!-- Tissue Paper Texture -->
				<radialGradient id="tissue-grad">
					<stop offset="0%" stop-color="#ffffff" />
					<stop offset="70%" stop-color="#f1f5f9" />
					<stop offset="100%" stop-color="#cbd5e1" />
				</radialGradient>
				<filter id="tissue-shadow">
					<feDropShadow dx="0" dy="4" stdDeviation="3" flood-opacity="0.3" />
				</filter>
			</defs>

			<!-- Electronic Scale -->
			<g transform="translate(0, 30)">
				<ellipse {cx} {cy} rx="100" ry="20" fill="rgba(0,0,0,0.15)" filter="url(#shadow2)" />
				<!-- Base -->
				<path
					d="M {cx - 90} {cy - 20} L {cx + 90} {cy - 20} Q {cx + 100} {cy - 20} {cx +
						100} {cy} L {cx + 100} {cy + 5} Q {cx + 100} {cy + 15} {cx + 90} {cy + 15} L {cx -
						90} {cy + 15} Q {cx - 100} {cy + 15} {cx - 100} {cy + 5} L {cx - 100} {cy} Q {cx -
						100} {cy - 20} {cx - 90} {cy - 20} Z"
					fill="url(#metal-base2)"
					stroke="#475569"
					stroke-width="1.5"
				/>

				<!-- Pan -->
				<ellipse
					{cx}
					cy={cy - 25}
					rx="70"
					ry="14"
					fill="url(#metal-pan2)"
					stroke="#64748b"
					stroke-width="2"
				/>
				<path
					d="M {cx - 70} {cy - 25} L {cx - 65} {cy - 20} L {cx + 65} {cy - 20} L {cx + 70} {cy -
						25} Z"
					fill="#94a3b8"
				/>

				<!-- LCD Display -->
				<rect
					x={cx - 35}
					y={cy - 10}
					width="70"
					height="22"
					rx="3"
					fill="#0f172a"
					stroke="#334155"
					stroke-width="2"
				/>
				<rect x={cx - 32} y={cy - 7} width="64" height="16" rx="1" fill="#86efac" />
				<text
					x={cx + 28}
					y={cy + 5}
					text-anchor="end"
					font-family="monospace"
					font-weight="bold"
					font-size="14"
					fill="#064e3b"
				>
					{currentLvl.mass.toFixed(1)} g
				</text>
			</g>

			<!-- Tissue Paper -->
			<!-- Center the tissue on the pan -->
			<g transform="translate({cx}, {cy - 5})">
				<!-- Apply size and shape transformations with CSS transitions for smooth animation -->
				<g
					style="transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1); transform: scale(1, {currentLvl.scaleY})"
				>
					{#if force === 0}
						<!-- Flat paper -->
						<rect
							x="-80"
							y="-10"
							width="160"
							height="10"
							rx="2"
							fill="url(#tissue-grad)"
							filter="url(#tissue-shadow)"
							stroke="#cbd5e1"
							stroke-width="1"
						/>
					{:else}
						<!-- Crumpled ball, simulated using layered circles to look wrinkly -->
						<circle
							cx="0"
							cy={-currentLvl.r + 5}
							r={currentLvl.r}
							fill="url(#tissue-grad)"
							filter="url(#tissue-shadow)"
							stroke="#cbd5e1"
							stroke-width="1.5"
						/>
						<path
							d="M {-currentLvl.r * 0.5} {-currentLvl.r} Q 0 {-currentLvl.r * 1.5} {currentLvl.r *
								0.6} {-currentLvl.r * 0.8}"
							fill="none"
							stroke="#94a3b8"
							stroke-width="2"
							stroke-linecap="round"
						/>
						<path
							d="M {-currentLvl.r * 0.7} {-currentLvl.r * 0.5} Q {-currentLvl.r *
								0.2} 0 {currentLvl.r * 0.4} {-currentLvl.r * 0.3}"
							fill="none"
							stroke="#cbd5e1"
							stroke-width="2"
							stroke-linecap="round"
						/>
					{/if}
				</g>
			</g>

			<!-- Hand animation for pressing (optional hint) -->
			{#if force > 0 && force < 3}
				<path
					d="M {cx} 50 L {cx - 20} 80 L {cx - 10} 80 L {cx - 10} 120 L {cx + 10} 120 L {cx +
						10} 80 L {cx + 20} 80 Z"
					fill="#ef4444"
					class="animate-bounce"
					opacity="0.6"
				/>
			{/if}
		</svg>
	</div>

	<!-- Controls (Normal Flex Flow) -->
	<div class="flex w-full shrink-0 flex-col gap-4 border-t border-slate-200 bg-white px-6 py-4">
		<div class="flex flex-col gap-1 text-center">
			<span class="text-sm font-bold text-slate-500">當前狀態：{currentLvl.name}</span>
		</div>

		<input
			type="range"
			min="0"
			max="3"
			step="1"
			bind:value={force}
			class="h-2 w-full cursor-pointer appearance-none rounded-lg bg-slate-200 accent-blue-500"
		/>

		<div class="mt-2 flex items-center justify-around rounded-lg border bg-slate-50 p-2">
			<div class="w-24 text-center">
				<div class="text-xs text-slate-500">質量 (M)</div>
				<div class="text-lg font-black text-slate-700">固定不變</div>
			</div>
			<div class="text-2xl font-black text-slate-300">→</div>
			<div class="w-24 text-center">
				<div class="text-xs text-slate-500">體積 (V)</div>
				<div class="text-lg font-black text-blue-600">不斷縮小</div>
			</div>
			<div class="text-2xl font-black text-slate-300">→</div>
			<div class="w-28 text-center">
				<div class="text-xs text-slate-500">密度 (緊密程度)</div>
				<div class="text-lg font-black text-indigo-600">越來越大</div>
			</div>
		</div>
	</div>
</div>
