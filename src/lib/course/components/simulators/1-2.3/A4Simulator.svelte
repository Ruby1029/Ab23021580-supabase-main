<script lang="ts">
	/**
	 * 1-2.3 A4：讀數 - 砝碼加總，揭曉是哪種飲料罐
	 * 右盤已有 50g+20g+5g，學生點擊「加總」看結果
	 * 教學核心：物體質量 = 右盤所有砝碼的總和
	 */
	import type { CourseState } from '$lib/course/courseState.svelte';
	import TopPanBalance from './_shared/TopPanBalance.svelte';
	import RealisticWeight from './_shared/RealisticWeight.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	const WEIGHTS = [
		{ g: 50, color: '#60a5fa', stroke: '#2563eb' },
		{ g: 20, color: '#86efac', stroke: '#16a34a' },
		{ g: 5, color: '#fca5a5', stroke: '#dc2626' }
	];
	const TOTAL = 75; // 50+20+5

	let step = $state(0); // 0=初始 1=加總動畫 2=揭曉
	let highlightIdx = $state(-1);
	let runningSum = $state(0);

	async function handleClick() {
		if (step > 0 || courseState.isUnlocked(courseState.currentStage.id)) return;
		step = 1;
		// 逐一高亮砝碼並累加
		for (let i = 0; i < WEIGHTS.length; i++) {
			highlightIdx = i;
			await sleep(600);
			runningSum += WEIGHTS[i].g;
			await sleep(400);
		}
		highlightIdx = -1;
		await sleep(500);
		step = 2;
		await sleep(800);
		onCorrect();
	}

	const DRINK_NAME = '標準易開罐（355ml）';
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if step === 0}右盤有三個砝碼，點擊加總讀數
		{:else if step === 1}加總中：{runningSum}g
		{:else}物體質量 = {TOTAL}g → {DRINK_NAME}！
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 370 260"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[390px] {step === 0 ? 'cursor-pointer' : ''}"
		onclick={handleClick}
		role="img"
		aria-label="砝碼加總讀數"
	>
		<rect width="370" height="260" rx="8" fill="#f8fafc" />

		<!-- 天平（已平衡，左=飲料罐，右=砝碼） -->
		<TopPanBalance cx={185} cy={120} tiltAngle={0} />

		<text x="130" y="70" text-anchor="middle" font-size="11" font-weight="bold" fill="#1e293b"
			>飲料罐</text
		>
		<text x="240" y="70" text-anchor="middle" font-size="11" font-weight="bold" fill="#1e293b"
			>{step >= 1 ? `${runningSum}g` : '?'}</text
		>

		<!-- 左盤飲料罐 (大致放在左盤上方) -->
		<rect
			x="85"
			y="45"
			width="20"
			height="28"
			rx="4"
			fill="#94a3b8"
			stroke="#64748b"
			stroke-width="1.5"
		/>
		<rect x="88" y="41" width="14" height="6" rx="2" fill="#64748b" />

		<!-- 右盤砝碼列表 -->
		<g transform="translate(0, 10)">
			{#each WEIGHTS as w, i (`${w.g}-${i}`)}
				{@const highlighted = highlightIdx === i}
				<RealisticWeight
					mass={w.g}
					x={225 + i * 44 + 19}
					y={120}
					material="brass"
					selected={highlighted}
				/>
			{/each}
		</g>

		<!-- 加總符號 -->
		{#if step >= 1}
			<text x="227" y="162" font-size="11" fill="#64748b">50 + 20 + 5 =</text>
			<text
				x="318"
				y="162"
				font-size="14"
				font-weight="bold"
				fill={step >= 2 ? '#16a34a' : '#f97316'}>{runningSum}g</text
			>
		{/if}

		<!-- 揭曉飲料罐 -->
		{#if step >= 2}
			<rect
				x="20"
				y="178"
				width="330"
				height="68"
				rx="8"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="2"
			/>
			<text x="185" y="200" text-anchor="middle" font-size="13" font-weight="bold" fill="#16a34a"
				>物體質量 = {TOTAL}g</text
			>
			<text x="185" y="220" text-anchor="middle" font-size="11" fill="#064e3b">
				≈ {DRINK_NAME}
			</text>
			<text x="185" y="238" text-anchor="middle" font-size="10" fill="#047857">
				砝碼總和 = 物體質量
			</text>
		{:else if step === 0}
			<text x="185" y="200" text-anchor="middle" font-size="11" fill="#94a3b8"> 點擊開始加總 </text>
		{/if}
	</svg>
</div>
