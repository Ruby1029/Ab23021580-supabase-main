<script lang="ts">
	/**
	 * 1-2.3 A2A3A4：操作 SOP 對照
	 * 左：有歸零流程；右：跳過歸零，結果誤差
	 * 教學核心：歸零的必要性，含秤量紙的正確用法
	 */
	import type { CourseState } from '$lib/course/courseState.svelte';
	import TopPanBalance from './_shared/TopPanBalance.svelte';

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

	let step = $state(0); // 0=初始 1=執行中 2=結果對比
	let leftDone = $state(false);
	let rightDone = $state(false);

	// 左側（正確）：偏移0，秤出75g
	// 右側（錯誤）：有3g初始偏移，秤出結果誤差
	const CORRECT_MASS = 75;
	const WRONG_MASS = 72; // 因為天平未歸零，少算了3g

	async function handleClick() {
		if (step >= 2 || courseState.isUnlocked(courseState.currentStage.id)) return;
		step = 1;
		await sleep(1000);
		leftDone = true;
		await sleep(500);
		rightDone = true;
		await sleep(800);
		step = 2;
		await sleep(600);
		onCorrect();
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if step === 0}點擊對比：有歸零 vs 跳過歸零
		{:else if step === 1}執行中…
		{:else}跳過歸零 → 結果誤差 {CORRECT_MASS - WRONG_MASS}g！
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 370 255"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[390px] {step === 0 ? 'cursor-pointer' : ''}"
		onclick={handleClick}
		role="img"
		aria-label="歸零對比"
	>
		<rect width="370" height="255" rx="8" fill="#fafafa" />

		<!-- ── 左半：正確（有歸零） ── -->
		<rect x="0" y="0" width="180" height="255" rx="8" fill="#f0fdf4" />
		<text x="90" y="18" text-anchor="middle" font-size="11" font-weight="bold" fill="#16a34a">
			✓ 有歸零
		</text>
		<TopPanBalance cx={90} cy={130} tiltAngle={leftDone ? 0 : 0} zeroOffset={0} />
		{#if leftDone}
			<rect
				x="15"
				y="195"
				width="150"
				height="22"
				rx="5"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="90" y="210" text-anchor="middle" font-size="11" font-weight="bold" fill="#16a34a">
				正確：{CORRECT_MASS}g
			</text>
		{/if}

		<!-- 分界線 -->
		<line
			x1="185"
			y1="5"
			x2="185"
			y2="250"
			stroke="#e2e8f0"
			stroke-width="2"
			stroke-dasharray="5 4"
		/>

		<!-- ── 右半：錯誤（跳過歸零） ── -->
		<rect x="190" y="0" width="180" height="255" rx="8" fill="#fff5f5" />
		<text x="280" y="18" text-anchor="middle" font-size="11" font-weight="bold" fill="#ef4444">
			✗ 跳過歸零
		</text>
		<!-- 天平有初始偏移 -->
		<TopPanBalance cx={280} cy={130} tiltAngle={rightDone ? 0 : 0} zeroOffset={rightDone ? 0 : 4} />
		{#if rightDone}
			<rect
				x="205"
				y="195"
				width="150"
				height="22"
				rx="5"
				fill="#fee2e2"
				stroke="#fca5a5"
				stroke-width="1.5"
			/>
			<text x="280" y="210" text-anchor="middle" font-size="11" font-weight="bold" fill="#ef4444">
				誤差：{WRONG_MASS}g（少{CORRECT_MASS - WRONG_MASS}g）
			</text>
		{/if}

		<!-- SOP 說明 -->
		{#if step >= 2}
			<rect
				x="10"
				y="225"
				width="350"
				height="24"
				rx="5"
				fill="#fffbeb"
				stroke="#fbbf24"
				stroke-width="1.5"
			/>
			<text x="185" y="240" text-anchor="middle" font-size="10" font-weight="bold" fill="#92400e">
				SOP：① 歸零 → ② 秤量 → ③ 讀數（砝碼總和）
			</text>
		{/if}
	</svg>
</div>
