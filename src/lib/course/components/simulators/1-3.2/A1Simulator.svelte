<script lang="ts">
	let { onCorrect } = $props();

	let step = $state(0);
	let isDone = $state(false);

	const stepData = [
		{ name: '空瓶', mass: 50, color: 'transparent', desc: '只有空氣' },
		{ name: '放入乒乓球', mass: 100, color: '#fcd34d', desc: '球與球之間縫隙很大' },
		{ name: '加入石塊', mass: 300, color: '#94a3b8', desc: '石塊填補了球的縫隙' },
		{ name: '倒入細沙', mass: 600, color: '#d97706', desc: '細沙填滿了更小的縫隙' },
		{ name: '倒入水', mass: 850, color: '#3b82f6', desc: '水滲透了所有的孔隙' }
	];

	$effect(() => {
		if (step === 4 && !isDone) {
			isDone = true;
			setTimeout(onCorrect, 1000);
		}
	});

	let currentMass = $derived(stepData[step].mass);
	let currentDesc = $derived(stepData[step].desc);

	// SVG params
	const cx = 200;
	const cy = 250;
	const bottleW = 100;
	const bottleH = 150;
</script>

<div
	class="mx-auto flex w-full max-w-[600px] flex-col overflow-hidden rounded-xl border bg-slate-50 shadow-inner"
>
	<div class="pt-4 pb-1 text-center text-base font-bold text-slate-700">觀察：不斷填補縫隙</div>

	<!-- SVG in aspect-video wrapper (Simulator UI Layout Skill) -->
	<div class="relative aspect-video w-full bg-slate-100">
		<svg viewBox="0 0 400 300" class="absolute inset-0 h-full w-full select-none">
			<defs>
				<!-- 5-stop Metallic Gradients (Skeuomorphic SVG Design Skill) -->
				<linearGradient id="metal-base" x1="0%" y1="0%" x2="0%" y2="100%">
					<stop offset="0%" stop-color="#f8fafc" />
					<stop offset="25%" stop-color="#cbd5e1" />
					<stop offset="50%" stop-color="#94a3b8" />
					<stop offset="75%" stop-color="#cbd5e1" />
					<stop offset="100%" stop-color="#64748b" />
				</linearGradient>
				<linearGradient id="metal-pan" x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stop-color="#94a3b8" />
					<stop offset="20%" stop-color="#f1f5f9" />
					<stop offset="50%" stop-color="#cbd5e1" />
					<stop offset="80%" stop-color="#f1f5f9" />
					<stop offset="100%" stop-color="#64748b" />
				</linearGradient>

				<!-- Glass -->
				<linearGradient id="glass-bottle" x1="0%" y1="0%" x2="100%" y2="0%">
					<stop offset="0%" stop-color="rgba(255,255,255,0.7)" />
					<stop offset="15%" stop-color="rgba(255,255,255,0.2)" />
					<stop offset="85%" stop-color="rgba(255,255,255,0.2)" />
					<stop offset="100%" stop-color="rgba(255,255,255,0.6)" />
				</linearGradient>

				<filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
					<feDropShadow dx="0" dy="8" stdDeviation="4" flood-opacity="0.25" />
				</filter>
				<filter id="drop-shadow-light">
					<feDropShadow dx="0" dy="2" stdDeviation="2" flood-opacity="0.2" />
				</filter>
			</defs>

			<!-- Electronic Scale -->
			<g transform="translate(0, 30)">
				<ellipse {cx} {cy} rx="100" ry="20" fill="rgba(0,0,0,0.15)" filter="url(#shadow)" />
				<!-- Base -->
				<path
					d="M {cx - 90} {cy - 20} L {cx + 90} {cy - 20} Q {cx + 100} {cy - 20} {cx +
						100} {cy} L {cx + 100} {cy + 5} Q {cx + 100} {cy + 15} {cx + 90} {cy + 15} L {cx -
						90} {cy + 15} Q {cx - 100} {cy + 15} {cx - 100} {cy + 5} L {cx - 100} {cy} Q {cx -
						100} {cy - 20} {cx - 90} {cy - 20} Z"
					fill="url(#metal-base)"
					stroke="#475569"
					stroke-width="1.5"
				/>

				<!-- Pan -->
				<ellipse
					{cx}
					cy={cy - 25}
					rx="70"
					ry="14"
					fill="url(#metal-pan)"
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
					{currentMass} g
				</text>
			</g>

			<!-- Bottle -->
			<g transform="translate(0, {cy - 25})">
				<!-- Contents based on step -->
				{#if step >= 4}
					<!-- Water -->
					<path
						d="M {cx - bottleW / 2} 0 L {cx - bottleW / 2} {-bottleH} Q {cx} {-bottleH - 10} {cx +
							bottleW / 2} {-bottleH} L {cx + bottleW / 2} 0 Z"
						fill="rgba(59,130,246,0.6)"
					/>
				{/if}
				{#if step >= 3}
					<!-- Sand -->
					<path
						d="M {cx - bottleW / 2} 0 L {cx - bottleW / 2} {-bottleH + 20} Q {cx} {-bottleH +
							10} {cx + bottleW / 2} {-bottleH + 30} L {cx + bottleW / 2} 0 Z"
						fill="rgba(217,119,6,0.8)"
					/>
				{/if}
				{#if step >= 2}
					<!-- Stones -->
					<circle cx={cx - 20} cy={-20} r="15" fill="#64748b" filter="url(#drop-shadow-light)" />
					<circle cx={cx + 25} cy={-30} r="18" fill="#475569" filter="url(#drop-shadow-light)" />
					<circle cx={cx - 10} cy={-50} r="12" fill="#94a3b8" filter="url(#drop-shadow-light)" />
					<circle cx={cx + 15} cy={-70} r="16" fill="#64748b" filter="url(#drop-shadow-light)" />
					<circle cx={cx - 30} cy={-80} r="14" fill="#475569" filter="url(#drop-shadow-light)" />
					<circle cx={cx + 20} cy={-110} r="15" fill="#94a3b8" filter="url(#drop-shadow-light)" />
					<circle cx={cx - 15} cy={-120} r="17" fill="#64748b" filter="url(#drop-shadow-light)" />
				{/if}
				{#if step >= 1}
					<!-- Ping pong balls -->
					<circle
						cx={cx - 25}
						cy={-30}
						r="20"
						fill="url(#metal-pan)"
						stroke="#fcd34d"
						stroke-width="2"
					/>
					<circle
						cx={cx + 20}
						cy={-40}
						r="20"
						fill="url(#metal-pan)"
						stroke="#fcd34d"
						stroke-width="2"
					/>
					<circle
						cx={cx - 10}
						cy={-75}
						r="20"
						fill="url(#metal-pan)"
						stroke="#fcd34d"
						stroke-width="2"
					/>
					<circle
						cx={cx + 25}
						cy={-85}
						r="20"
						fill="url(#metal-pan)"
						stroke="#fcd34d"
						stroke-width="2"
					/>
					<circle
						cx={cx - 20}
						cy={-115}
						r="20"
						fill="url(#metal-pan)"
						stroke="#fcd34d"
						stroke-width="2"
					/>
					<circle
						cx={cx + 15}
						cy={-130}
						r="20"
						fill="url(#metal-pan)"
						stroke="#fcd34d"
						stroke-width="2"
					/>
				{/if}

				<!-- Bottle Glass Outline -->
				<!-- Bottom ellipse -->
				<ellipse
					{cx}
					cy="0"
					rx={bottleW / 2}
					ry="8"
					fill="none"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="3"
				/>
				<!-- Body -->
				<path
					d="M {cx - bottleW / 2} 0 L {cx - bottleW / 2} {-bottleH} A {bottleW / 2} 8 0 0 1 {cx +
						bottleW / 2} {-bottleH} L {cx + bottleW / 2} 0"
					fill="url(#glass-bottle)"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="3"
				/>
				<!-- Top opening -->
				<ellipse
					{cx}
					cy={-bottleH}
					rx={bottleW / 2}
					ry="8"
					fill="rgba(255,255,255,0.2)"
					stroke="rgba(255,255,255,0.9)"
					stroke-width="3"
				/>

				<!-- Fixed Volume Label -->
				<text
					x={cx - bottleW / 2 - 15}
					y={-bottleH / 2}
					text-anchor="end"
					font-size="14"
					font-weight="bold"
					fill="#334155"
				>
					體積 V = 500 ml (固定)
				</text>
				<line
					x1={cx - bottleW / 2 - 10}
					y1={-bottleH}
					x2={cx - bottleW / 2}
					y2={-bottleH}
					stroke="#334155"
					stroke-width="2"
				/>
				<line
					x1={cx - bottleW / 2 - 10}
					y1="0"
					x2={cx - bottleW / 2}
					y2="0"
					stroke="#334155"
					stroke-width="2"
				/>
				<line
					x1={cx - bottleW / 2 - 10}
					y1={-bottleH}
					x2={cx - bottleW / 2 - 10}
					y2="0"
					stroke="#334155"
					stroke-width="2"
				/>
			</g>
		</svg>
	</div>

	<!-- Controls (Normal Flex Flow) -->
	<div class="flex w-full shrink-0 flex-col gap-4 border-t border-slate-200 bg-white px-6 py-4">
		<div class="flex flex-col gap-1 text-center">
			<span class="text-sm font-bold text-slate-500">當前狀態：{stepData[step].name}</span>
			<span class="text-sm font-bold text-blue-600">{currentDesc}</span>
		</div>

		<div class="flex justify-between gap-2">
			<button
				class="flex-1 rounded-lg border-2 py-2 font-bold transition-all {step === 0
					? 'border-slate-400 bg-slate-100 text-slate-700'
					: 'border-slate-200 bg-white text-slate-400 hover:bg-slate-50'}"
				onclick={() => (step = 0)}>空瓶</button
			>
			<button
				class="flex-1 rounded-lg border-2 py-2 font-bold transition-all {step === 1
					? 'border-amber-400 bg-amber-100 text-amber-700'
					: 'border-slate-200 bg-white text-slate-400 hover:bg-slate-50'}"
				onclick={() => (step = 1)}>加球</button
			>
			<button
				class="flex-1 rounded-lg border-2 py-2 font-bold transition-all {step === 2
					? 'border-slate-500 bg-slate-200 text-slate-700'
					: 'border-slate-200 bg-white text-slate-400 hover:bg-slate-50'}"
				onclick={() => (step = 2)}>加石塊</button
			>
			<button
				class="flex-1 rounded-lg border-2 py-2 font-bold transition-all {step === 3
					? 'border-orange-500 bg-orange-100 text-orange-700'
					: 'border-slate-200 bg-white text-slate-400 hover:bg-slate-50'}"
				onclick={() => (step = 3)}>加沙</button
			>
			<button
				class="flex-1 rounded-lg border-2 py-2 font-bold transition-all {step === 4
					? 'border-blue-500 bg-blue-100 text-blue-700'
					: 'border-slate-200 bg-white text-slate-400 hover:bg-slate-50'}"
				onclick={() => (step = 4)}>加水</button
			>
		</div>

		<div class="mt-2 flex items-center justify-around rounded-lg border bg-slate-50 p-2">
			<div class="text-center">
				<div class="text-xs text-slate-500">體積 (V)</div>
				<div class="text-lg font-black text-slate-700">固定不變</div>
			</div>
			<div class="text-2xl font-black text-slate-300">→</div>
			<div class="text-center">
				<div class="text-xs text-slate-500">質量 (M)</div>
				<div class="text-lg font-black text-rose-600">不斷增加</div>
			</div>
			<div class="text-2xl font-black text-slate-300">→</div>
			<div class="text-center">
				<div class="text-xs text-slate-500">密度 (緊密程度)</div>
				<div class="text-lg font-black text-indigo-600">越來越大</div>
			</div>
		</div>
	</div>
</div>
