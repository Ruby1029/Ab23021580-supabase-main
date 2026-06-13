<script lang="ts">
	import type { CourseState } from '$lib/course/courseState.svelte';
	import WaterBottle from './1-1.3/_shared/WaterBottle.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	let started = $state(false);
	let count = $state(0);
	let done = $state(false);
	let streaming = $state(false);

	// 兩瓶位置
	const BX1 = 52,
		BX2 = 230,
		BY = 108;
	const BOTTLES = [BX1, BX2];

	const fillRatio = $derived(count / 2000);

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	async function handleClick() {
		if (started || done || courseState.isUnlocked(courseState.currentStage.id)) return;
		started = true;
		streaming = true;

		const t0 = performance.now(),
			dur = 2400;
		await new Promise<void>((resolve) => {
			function tick(now: number) {
				const t = Math.min((now - t0) / dur, 1);
				count = Math.round(t * 2000);
				if (t < 1) requestAnimationFrame(tick);
				else resolve();
			}
			requestAnimationFrame(tick);
		});

		streaming = false;
		done = true;
		await sleep(700);
		onCorrect();
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !started}按藍色按鈕出水，觀察 2L 飲水量
		{:else if done}✓ 2L = 2 dm³ = 2000 ml = 2000 cm³
		{:else}{count} / 2000 cm³{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 380 305"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[400px]"
		role="img"
		aria-label="飲水機出水示意圖"
	>
		<!-- ══ 飲水機出水組件 ══ -->
		<rect
			x="110"
			y="12"
			width="140"
			height="46"
			rx="8"
			fill="#e2e8f0"
			stroke="#94a3b8"
			stroke-width="2"
		/>
		<rect x="118" y="20" width="100" height="6" rx="2" fill="#cbd5e1" />
		<!-- 熱水按鈕（裝飾） -->
		<circle cx="145" cy="42" r="11" fill="#fca5a5" stroke="#ef4444" stroke-width="2" />
		<text x="145" y="47" text-anchor="middle" font-size="9" fill="#dc2626" font-weight="bold"
			>熱</text
		>
		<!-- 冷水按鈕（可點擊） -->
		<circle
			cx="220"
			cy="42"
			r="11"
			fill={started ? '#93c5fd' : '#3b82f6'}
			stroke="#1d4ed8"
			stroke-width="2"
			class="cursor-pointer transition-colors duration-200"
			onclick={handleClick}
			role="button"
			tabindex="0"
			aria-label="點擊出水"
		/>
		<text x="220" y="47" text-anchor="middle" font-size="9" fill="white" font-weight="bold">冷</text
		>
		<!-- 出水口 -->
		<rect x="150" y="58" width="36" height="8" rx="2" fill="#94a3b8" />
		<polygon points="154,66 182,66 178,78 158,78" fill="#64748b" />
		<line x1="160" y1="78" x2="176" y2="78" stroke="#94a3b8" stroke-width="1.5" />

		<!-- 水流 -->
		{#if streaming}
			<rect
				x="165"
				y="78"
				width="6"
				height={BY - 78 + 15}
				rx="3"
				fill="#3b82f6"
				fill-opacity="0.7"
			/>
			<line
				x1="168"
				y1={BY + 10}
				x2={BX1 + 26}
				y2={BY + 10}
				stroke="#3b82f6"
				stroke-width="4"
				stroke-opacity="0.5"
				stroke-linecap="round"
			/>
		{/if}

		<!-- ══ 兩個水瓶（共用元件） ══ -->
		{#each BOTTLES as bx, i (`${bx}-${i}`)}
			<WaterBottle x={bx} y={BY} {fillRatio} label="5×10×20 cm" sublabel="第 {i + 1} 瓶 = 1L" />
		{/each}

		<!-- 加號 -->
		<text x="195" y="175" text-anchor="middle" font-size="28" font-weight="black" fill="#94a3b8"
			>+</text
		>

		<!-- 未開始提示 -->
		{#if !started}
			<text x="195" y="220" text-anchor="middle" font-size="11" fill="#cbd5e1">← 按藍色按鈕</text>
		{/if}

		<!-- 計數器 -->
		{#if started && !done}
			<text x="195" y="10" text-anchor="middle" font-size="14" font-weight="black" fill="#3b82f6">
				{count}<tspan font-size="9" fill="#64748b"> / 2000 cm³</tspan>
			</text>
		{/if}

		<!-- 完成標示 -->
		{#if done}
			<rect
				x="30"
				y="280"
				width="318"
				height="36"
				rx="8"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="189" y="303" text-anchor="middle" font-size="13" font-weight="bold" fill="#16a34a">
				每天 2L = 2 dm³ = 2000 ml = 2000 cm³ ✓
			</text>
		{/if}
	</svg>
</div>
