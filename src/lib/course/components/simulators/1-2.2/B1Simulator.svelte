<script lang="ts">
	/**
	 * 1-2.2 B1：質量單位加「重」= 重量單位
	 * 教學核心：這是老師用10年教學總結出的最有效記憶規律
	 * 設計：4個單位對同時「長出」「重」字的動畫，有節奏感
	 * 互動：第一次點擊→四行同時逐字顯示「重」字；第二次點擊→收尾+結論
	 */
	import type { CourseState } from '$lib/course/courseState.svelte';

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

	let step = $state(0); // 0=初始 1=動畫進行 2=高亮完成 3=結論
	let animRow = $state(-1); // 當前正在動畫的行（-1=未開始）

	const PAIRS = [
		{ mass: 'mg', weight: 'mgw', suffix: 'w' },
		{ mass: 'g', weight: 'gw', suffix: 'w' },
		{ mass: 'kg', weight: 'kgw', suffix: 'w' },
		{ mass: 't', weight: 'tw', suffix: 'w' }
	];

	async function handleClick() {
		if (step >= 3 || courseState.isUnlocked(courseState.currentStage.id)) return;

		if (step === 0) {
			step = 1;
			// 逐行動畫：每行間隔300ms
			for (let i = 0; i < PAIRS.length; i++) {
				animRow = i;
				await sleep(300);
			}
			await sleep(400);
			step = 2;
		} else if (step === 2) {
			step = 3;
			await sleep(500);
			onCorrect();
		}
	}

	// 計算「重」字的透明度：animRow >= 行索引 時才顯示
	function getWOpacity(rowIdx: number): number {
		if (step >= 2) return 1;
		if (animRow >= rowIdx) return 1;
		return 0;
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if step === 0}點擊觀察規律
		{:else if step === 1}觀察：右欄比左欄多了什麼？
		{:else if step === 2}發現了！再點確認
		{:else}規律：質量單位加「重」= 重量單位
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 360 240"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[380px] cursor-pointer"
		onclick={handleClick}
		role="img"
		aria-label="質量單位與重量單位對照"
	>
		<!-- 背景 -->
		<rect width="360" height="240" rx="8" fill="#fafafa" />

		<!-- 標題列 -->
		<rect x="20" y="12" width="130" height="28" rx="5" fill="#dbeafe" />
		<text x="85" y="30" text-anchor="middle" font-size="13" font-weight="bold" fill="#1d4ed8"
			>質量單位</text
		>

		<rect x="210" y="12" width="130" height="28" rx="5" fill="#fce7f3" />
		<text x="275" y="30" text-anchor="middle" font-size="13" font-weight="bold" fill="#be185d"
			>重量單位</text
		>

		<!-- 中間加號區（step>=1顯示） -->
		{#if step >= 1}
			<rect
				x="158"
				y="12"
				width="44"
				height="28"
				rx="5"
				fill="#fef3c7"
				stroke="#fbbf24"
				stroke-width="1.5"
			/>
			<text x="180" y="30" text-anchor="middle" font-size="13" font-weight="bold" fill="#d97706"
				>+「重」</text
			>
		{/if}

		<!-- ── 四行對照 ── -->
		{#each PAIRS as pair, i (pair.left ?? i)}
			{@const y = 68 + i * 42}

			<!-- 質量欄 -->
			<rect
				x="30"
				y={y - 16}
				width="110"
				height="32"
				rx="5"
				fill={step >= 2 ? '#dbeafe' : '#f1f5f9'}
				stroke={step >= 2 ? '#93c5fd' : '#e2e8f0'}
				stroke-width={step >= 2 ? 2 : 1}
			/>
			<text x="85" y={y + 5} text-anchor="middle" font-size="20" font-weight="bold" fill="#1d4ed8"
				>{pair.mass}</text
			>

			<!-- 等號 -->
			<text
				x="180"
				y={y + 5}
				text-anchor="middle"
				font-size="16"
				fill="#64748b"
				opacity={step >= 1 ? 1 : 0}>→</text
			>

			<!-- 重量欄：質量部分＋「重」後綴 -->
			<rect
				x="220"
				y={y - 16}
				width="120"
				height="32"
				rx="5"
				fill={step >= 2 ? '#fce7f3' : '#f1f5f9'}
				stroke={step >= 2 ? '#f9a8d4' : '#e2e8f0'}
				stroke-width={step >= 2 ? 2 : 1}
			/>
			<text x="255" y={y + 5} text-anchor="middle" font-size="20" font-weight="bold" fill="#1d4ed8"
				>{pair.mass}</text
			>
			<!-- 「重」字（動畫出現） -->
			<text
				x={255 + pair.mass.length * 11 + 5}
				y={y + 5}
				font-size="20"
				font-weight="bold"
				fill={step >= 2 ? '#be185d' : '#f97316'}
				opacity={getWOpacity(i)}>重</text
			>
		{/each}

		<!-- 結論 -->
		{#if step >= 3}
			<rect
				x="20"
				y="208"
				width="320"
				height="26"
				rx="6"
				fill="#fdf4ff"
				stroke="#d946ef"
				stroke-width="1.5"
			/>
			<text x="180" y="225" text-anchor="middle" font-size="12" font-weight="bold" fill="#86198f">
				質量單位加「重」= 重量單位
			</text>
		{/if}
	</svg>
</div>
