<script lang="ts">
	import type { CourseState } from '$lib/course/courseState.svelte';
	import RulerBase from './ruler/RulerBase.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	let config = $derived(courseState.currentStage.simulator?.config);
	let units: string[] = $derived(config?.units ?? []);
	let pencilMm: number = $derived(config?.pencilMm ?? 117);
	let correctAnswer: string = $derived(config?.answer ?? '');

	// 從 config 讀取刻度設定，預設為 10mm (1cm)
	let tickIntervalMm = $derived(config?.tickIntervalMm ?? 10);
	let majorTickIntervalMm = $derived(config?.majorTickIntervalMm ?? 10);

	// RulerBase 的固定參數
	const pxPerMm = 4;
	const offsetX = 50; // RulerBase 的起點 x
	const svgWidth = 900;
	const svgHeight = 250;

	// 鉛筆在 SVG 座標中的位置
	let pencilEndX = $derived(offsetX + pencilMm * pxPerMm);
	const pencilY = 140; // 放在尺的下方
	const pencilH = 24;

	let userAnswer = $state('');
	let submitted = $state(false);
	let isCorrect = $derived(userAnswer.trim() === correctAnswer);

	$effect(() => {
		if (isCorrect && submitted && !courseState.isUnlocked(courseState.currentStage.id)) {
			onCorrect();
		}
	});
</script>

<div
	class="flex flex-col gap-4 overflow-hidden rounded-xl border border-gray-100 bg-white p-4 shadow-sm"
>
	<!-- 直尺 + 橫向鉛筆 SVG -->
	<svg
		width="100%"
		viewBox="0 0 {svgWidth} {svgHeight}"
		preserveAspectRatio="xMidYMid meet"
		class="select-none"
		role="img"
		aria-label="直尺與鉛筆示意圖"
	>
		<!-- 渲染直尺：傳入自定義刻度 -->
		<RulerBase startMm={0} currentMm={0} {tickIntervalMm} {majorTickIntervalMm} />

		<!-- 橫向鉛筆設計 -->
		<g transform="translate({offsetX}, {pencilY})">
			<!-- 筆身 (黃色) -->
			<rect
				x="0"
				y="0"
				width={pencilMm * pxPerMm - 30}
				height={pencilH}
				fill="#f1c40f"
				stroke="#d4ac0d"
				stroke-width="1.5"
			/>
			<!-- 筆頭木質部 (淺褐色三角形) -->
			<path
				d="M {pencilMm * pxPerMm - 30} 0 L {pencilMm * pxPerMm} {pencilH / 2} L {pencilMm *
					pxPerMm -
					30} {pencilH} Z"
				fill="#ebccad"
			/>
			<!-- 筆芯 (黑色筆尖) -->
			<path
				d="M {pencilMm * pxPerMm - 10} {pencilH / 2 - 4} L {pencilMm * pxPerMm} {pencilH /
					2} L {pencilMm * pxPerMm - 10} {pencilH / 2 + 4} Z"
				fill="#2d3436"
			/>
			<!-- 筆後端橡皮擦 (粉紅色) -->
			<rect x="-10" y="0" width="10" height={pencilH} fill="#ff7675" rx="2" />
			<!-- 筆身裝飾線 -->
			<line
				x1="10"
				y1={pencilH * 0.3}
				x2={pencilMm * pxPerMm - 40}
				y2={pencilH * 0.3}
				stroke="rgba(0,0,0,0.1)"
				stroke-width="1"
			/>
			<line
				x1="10"
				y1={pencilH * 0.7}
				x2={pencilMm * pxPerMm - 40}
				y2={pencilH * 0.7}
				stroke="rgba(0,0,0,0.1)"
				stroke-width="1"
			/>
		</g>

		<!-- 輔助垂直虛線：從筆尖連到尺 -->
		<line
			x1={pencilEndX}
			y1={pencilY + pencilH / 2}
			x2={pencilEndX}
			y2="120"
			stroke="#3b82f6"
			stroke-width="2"
			stroke-dasharray="4 2"
		/>

		<!-- 三種單位浮標 (放在筆的下方或側面) -->
		{#each units as unit, i (`${unit.label}-${i}`)}
			<g transform="translate({pencilEndX + 20}, {pencilY - 110 + i * 35})">
				<rect
					x="0"
					y="0"
					width="90"
					height="26"
					rx="6"
					fill="#f8fafc"
					stroke="#cbd5e1"
					stroke-width="1"
				/>
				<text x="45" y="18" text-anchor="middle" font-size="13" font-weight="900" fill="#64748b"
					>{unit}</text
				>
			</g>
		{/each}
	</svg>

	<!-- 填寫區 -->
	<div class="mt-2 flex items-center justify-center gap-3 text-lg font-black">
		<span class="text-gray-600">{config?.question}</span>
		<input
			type="text"
			bind:value={userAnswer}
			placeholder="???"
			class="w-24 rounded-lg border-2 px-2 py-1 text-center text-xl font-black transition-all
				{submitted && isCorrect
				? 'border-emerald-400 bg-emerald-50 text-emerald-700'
				: submitted && !isCorrect
					? 'border-red-400 bg-red-50 text-red-700'
					: 'border-gray-300 outline-none focus:border-blue-400'}"
			onkeydown={(e) => {
				if (e.key === 'Enter') submitted = true;
			}}
		/>
		<button
			class="rounded-lg bg-blue-600 px-4 py-1.5 font-bold text-white transition-all hover:bg-blue-700"
			onclick={() => (submitted = true)}
		>
			確認
		</button>
	</div>

	{#if submitted && !isCorrect}
		<p class="text-center text-sm font-bold text-red-500">再觀察一下直尺和鉛筆的位置 🔍</p>
	{:else if submitted && isCorrect}
		<p class="text-center text-sm font-bold text-emerald-600">✓ 正確！</p>
	{/if}
</div>
