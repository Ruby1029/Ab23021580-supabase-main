<script lang="ts">
	/**
	 * 1-2.2 A2：1L的水，放上電子秤 → 1kg = 10³g
	 * 教學核心：1kg的定義=1000g，透過天平讓學生「看見」等量關係
	 * 設計：天平左側1L水瓶，右側1000個1g砝碼（動態堆疊），平衡時結論顯示
	 */
	import type { CourseState } from '$lib/course/courseState.svelte';
	import DigitalScale from '../_global/lab/DigitalScale.svelte';

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

	let step = $state(0); // 0=初始 1=秤上水瓶 2=顯示讀數 3=完成
	let weightCount = $state(0); // 動態累加的砝碼數（最多顯示20個代表1000）

	async function handleClick() {
		if (step >= 3 || courseState.isUnlocked(courseState.currentStage.id)) return;
		if (step === 0) {
			step = 1;
			await sleep(800);
			step = 2;
			// 動態累加砝碼視覺（每50ms加1個，共20格）
			for (let i = 1; i <= 20; i++) {
				weightCount = i;
				await sleep(60);
			}
			await sleep(600);
			step = 3;
			await sleep(400);
			onCorrect();
		}
	}

	// 1000個砝碼以20格代表（每格=50g），排成4列5行
	const WEIGHT_COLS = 5;
	const WEIGHT_ROWS = 4;
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if step === 0}點擊觀察
		{:else if step === 1}將 1L 水瓶放上電子秤…
		{:else if step === 2}另一邊：累計 1000 個 1g 砝碼
		{:else}1kg = 1000g = 10³g
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 380 270"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[400px] cursor-pointer"
		onclick={handleClick}
		role="img"
		aria-label="1kg=1000g天平"
	>
		<!-- ── 左半：1L水瓶 + 電子秤 ── -->
		<rect x="0" y="0" width="180" height="270" rx="8" fill="#f0f9ff" />
		<text x="90" y="22" text-anchor="middle" font-size="12" font-weight="bold" fill="#0369a1"
			>1L 水瓶</text
		>

		<!-- 水瓶（立體感） -->
		{#if step >= 1}
			<!-- 瓶身 -->
			<rect
				x="55"
				y="65"
				width="70"
				height="110"
				rx="8"
				fill="#bae6fd"
				fill-opacity="0.7"
				stroke="#38bdf8"
				stroke-width="2"
			/>
			<!-- 水的高光 -->
			<rect x="60" y="70" width="12" height="80" rx="6" fill="white" fill-opacity="0.35" />
			<!-- 瓶蓋 -->
			<rect
				x="72"
				y="52"
				width="36"
				height="16"
				rx="6"
				fill="#0284c7"
				stroke="#0369a1"
				stroke-width="1.5"
			/>
			<!-- 1L 標示 -->
			<text x="90" y="128" text-anchor="middle" font-size="18" font-weight="bold" fill="#0369a1"
				>1L</text
			>
			<text x="90" y="148" text-anchor="middle" font-size="10" fill="#38bdf8">礦泉水</text>
		{/if}

		<!-- 電子秤 -->
		<DigitalScale x={90} y={226} reading={step >= 2 ? '1 kg' : step >= 1 ? '...' : '---'} />

		<!-- ── 分界線 ── -->
		<line
			x1="190"
			y1="10"
			x2="190"
			y2="260"
			stroke="#94a3b8"
			stroke-width="1.5"
			stroke-dasharray="5 4"
		/>

		<!-- = 符號 -->
		{#if step >= 2}
			<text x="190" y="140" text-anchor="middle" font-size="22" font-weight="bold" fill="#16a34a"
				>=</text
			>
		{/if}

		<!-- ── 右半：砝碼堆 ── -->
		<rect x="200" y="0" width="180" height="270" rx="8" fill="#fefce8" />
		<text x="290" y="22" text-anchor="middle" font-size="12" font-weight="bold" fill="#92400e">
			{#if step >= 2}
				{Math.min(weightCount, 20)} × 50g = {Math.min(weightCount, 20) * 50}g
			{:else}
				1g × 1000 個
			{/if}
		</text>

		<!-- 砝碼格（4列5行，每格代表50g） -->
		{#each Array(WEIGHT_ROWS) as rowValue, row (`row-${row}-${rowValue}`)}
			{#each Array(WEIGHT_COLS) as colValue, col (`col-${row}-${col}-${colValue}`)}
				{@const idx = row * WEIGHT_COLS + col}
				{@const filled = step >= 2 && idx < weightCount}
				<rect
					x={215 + col * 28}
					y={50 + row * 38}
					width="24"
					height="30"
					rx="4"
					fill={filled ? '#fbbf24' : '#f3f4f6'}
					stroke={filled ? '#d97706' : '#e5e7eb'}
					stroke-width={filled ? 1.5 : 1}
				/>
				{#if filled}
					<text
						x={215 + col * 28 + 12}
						y={50 + row * 38 + 19}
						text-anchor="middle"
						font-size="8"
						font-weight="bold"
						fill="#92400e"
					>
						50g
					</text>
				{/if}
			{/each}
		{/each}

		<!-- 完成結論 -->
		{#if step >= 3}
			<rect
				x="10"
				y="238"
				width="360"
				height="26"
				rx="6"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="190" y="255" text-anchor="middle" font-size="12" font-weight="bold" fill="#16a34a">
				1L 水 = 1kg = 1000g = 10³g
			</text>
		{/if}
	</svg>
</div>
