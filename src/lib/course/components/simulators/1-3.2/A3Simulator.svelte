<script lang="ts">
	let { onCorrect } = $props();

	let sugarCount = $state(0);
	let isDone = $state(false);

	$effect(() => {
		if (sugarCount >= 5 && !isDone) {
			isDone = true;
			setTimeout(onCorrect, 1000);
		}
	});

	let mass = $derived(100 + sugarCount * 10);
	let sweetness = $derived(sugarCount * 20); // 0 to 100%

	// SVG params
	const cx = 200;
	const cy = 180;
	const cupW = 120;
	const cupH = 140;
</script>

<div
	class="mx-auto flex w-full max-w-[600px] flex-col overflow-hidden rounded-xl border bg-slate-50 shadow-inner"
>
	<div class="pt-4 pb-1 text-center text-base font-bold text-slate-700">比喻：加糖水變甜</div>

	<!-- SVG in aspect-video wrapper -->
	<div class="relative aspect-video w-full bg-slate-100">
		<svg viewBox="0 0 400 300" class="absolute inset-0 h-full w-full select-none">
			<defs>
				<!-- Glass -->
				<linearGradient id="glass-cup" x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stop-color="rgba(255,255,255,0.8)" />
					<stop offset="20%" stop-color="rgba(255,255,255,0.3)" />
					<stop offset="80%" stop-color="rgba(255,255,255,0.3)" />
					<stop offset="100%" stop-color="rgba(255,255,255,0.7)" />
				</linearGradient>

				<filter id="shadow3" x="-20%" y="-20%" width="140%" height="140%">
					<feDropShadow dx="0" dy="8" stdDeviation="4" flood-opacity="0.15" />
				</filter>
				<filter id="sugar-shadow">
					<feDropShadow dx="1" dy="2" stdDeviation="1" flood-opacity="0.3" />
				</filter>
			</defs>

			<!-- Table Base -->
			<ellipse {cx} cy={cy + 10} rx="110" ry="15" fill="rgba(0,0,0,0.1)" filter="url(#shadow3)" />
			<line x1="50" y1={cy + 10} x2="350" y2={cy + 10} stroke="#cbd5e1" stroke-width="2" />

			<!-- Water inside cup -->
			<g transform="translate(0, {cy})">
				<!-- Sweetness color changes from light blue to dark yellow/brown -->
				<!-- Calculate color dynamically: R: 59->217, G: 130->119, B: 246->6 -->
				<!-- A simpler way is just overlaying a yellow tint with opacity based on sweetness -->

				<!-- Base water -->
				<path
					d="M {cx - cupW / 2 + 5} {-5} L {cx - cupW / 2 + 5} {-cupH + 30} Q {cx} {-cupH + 20} {cx +
						cupW / 2 -
						5} {-cupH + 30} L {cx + cupW / 2 - 5} {-5} Z"
					fill="rgba(59,130,246,0.3)"
				/>

				<!-- Sugar tint -->
				<path
					d="M {cx - cupW / 2 + 5} {-5} L {cx - cupW / 2 + 5} {-cupH + 30} Q {cx} {-cupH + 20} {cx +
						cupW / 2 -
						5} {-cupH + 30} L {cx + cupW / 2 - 5} {-5} Z"
					fill="rgba(217,119,6, {sweetness / 150})"
				/>

				<!-- Sugar cubes at bottom -->
				{#each Array(sugarCount) as sugarMarker, i (`${sugarMarker}-${i}`)}
					<rect
						x={cx - 30 + ((i * 15) % 40) - Math.floor(i / 3) * 10}
						y={-15 - Math.floor(i / 3) * 12}
						width="12"
						height="12"
						rx="2"
						fill="white"
						filter="url(#sugar-shadow)"
						opacity="0.8"
						transform="rotate({((i * 15) % 30) - 15}, {cx}, 0)"
					/>
				{/each}

				<!-- Cup Glass -->
				<path
					d="M {cx - cupW / 2} 0 L {cx - cupW / 2} {-cupH} A {cupW / 2} 8 0 0 1 {cx +
						cupW / 2} {-cupH} L {cx + cupW / 2} 0"
					fill="url(#glass-cup)"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="4"
				/>
				<!-- Bottom curve -->
				<path
					d="M {cx - cupW / 2} 0 Q {cx} 15 {cx + cupW / 2} 0"
					fill="none"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="4"
				/>
				<!-- Top opening -->
				<ellipse
					{cx}
					cy={-cupH}
					rx={cupW / 2}
					ry="8"
					fill="rgba(255,255,255,0.1)"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="4"
				/>
			</g>

			<!-- Labels -->
			<text x="50" y="50" font-size="14" font-weight="bold" fill="#64748b"
				>體積(V): 100 ml (固定杯子)</text
			>
			<text x="50" y="75" font-size="14" font-weight="bold" fill="#0f172a">質量(M): {mass} g</text>

			<!-- Sweetness Meter -->
			<text x="350" y="50" font-size="12" font-weight="bold" fill="#b45309" text-anchor="end"
				>甜度計</text
			>
			<rect
				x="340"
				y="60"
				width="10"
				height="100"
				rx="5"
				fill="#f1f5f9"
				stroke="#cbd5e1"
				stroke-width="2"
			/>
			<rect
				x="342"
				y={158 - sweetness * 0.96}
				width="6"
				height={sweetness * 0.96}
				rx="3"
				fill="#d97706"
				class="transition-all duration-300"
			/>
		</svg>
	</div>

	<!-- Controls (Normal Flex Flow) -->
	<div
		class="flex w-full shrink-0 flex-col items-center gap-4 border-t border-slate-200 bg-white px-6 py-4"
	>
		<button
			class="flex items-center gap-2 rounded-full bg-amber-500 px-8 py-3 font-bold text-white shadow-md transition-all hover:bg-amber-600 active:scale-95"
			onclick={() => sugarCount++}
			disabled={sugarCount >= 5}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="20"
				height="20"
				viewBox="0 0 24 24"
				fill="none"
				stroke="currentColor"
				stroke-width="2"
				stroke-linecap="round"
				stroke-linejoin="round"><path d="M5 12h14" /><path d="M12 5v14" /></svg
			>
			加入一顆方糖
		</button>

		<div class="text-sm font-bold text-slate-500">
			{#if sugarCount === 0}
				目前是一杯純水
			{:else if sugarCount < 5}
				加入了 {sugarCount} 顆方糖，質量增加，越來越甜！
			{:else}
				很甜了！固定體積下，質量越大，濃度（密度）越大！
			{/if}
		</div>
	</div>
</div>
