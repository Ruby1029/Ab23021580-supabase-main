<script lang="ts">
	/**
	 * 1-2.2 A3：以10³尺度繼續往上推 → 1t = 10³kg
	 * 教學核心：讓學生感受10³的累積尺度感
	 * 設計：三段式10³階梯（1g→1kg→1t），配合實體物件對應
	 * 交互：點擊逐步展開每個階層
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

	let step = $state(0); // 0=初始 1=顯示g 2=顯示kg 3=顯示t 4=完成

	const LEVELS = [
		{ label: '1g', example: '一顆迴紋針', color: '#6ee7b7', bg: '#d1fae5', y: 195 },
		{ label: '1kg', example: '一瓶礦泉水', color: '#60a5fa', bg: '#dbeafe', y: 145 },
		{ label: '1t', example: '一台轎車', color: '#a78bfa', bg: '#ede9fe', y: 80 }
	];

	async function handleClick() {
		if (step >= 4 || courseState.isUnlocked(courseState.currentStage.id)) return;
		if (step < 3) {
			step++;
		} else if (step === 3) {
			step = 4;
			await sleep(500);
			onCorrect();
		}
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if step === 0}點擊逐步展開
		{:else if step === 1}從1公克開始…
		{:else if step === 2}×1000 → 1公斤
		{:else if step === 3}再×1000 → 1公噸，再點確認
		{:else}1g →×10³→ 1kg →×10³→ 1t
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 360 260"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[380px] cursor-pointer"
		onclick={handleClick}
		role="img"
		aria-label="10³尺度階梯"
	>
		<!-- 背景 -->
		<rect width="360" height="260" rx="8" fill="#fafafa" />

		<!-- 階梯台階（從右下到左上） -->
		{#each LEVELS as lv, i (lv.label ?? i)}
			{#if step > i}
				<!-- 台階 -->
				<rect
					x={60 + i * 30}
					y={lv.y}
					width={240 - i * 60}
					height={260 - lv.y}
					rx={i === 0 ? '0 0 6 6' : '0'}
					fill={lv.bg}
					stroke={lv.color}
					stroke-width="2"
				/>

				<!-- 單位標示 -->
				<text
					x={180}
					y={lv.y + 22}
					text-anchor="middle"
					font-size="16"
					font-weight="bold"
					fill={lv.color}>{lv.label}</text
				>

				<!-- 實體例子 -->
				<text x={180} y={lv.y + 40} text-anchor="middle" font-size="10" fill="#64748b"
					>{lv.example}</text
				>

				<!-- ×10³ 箭頭（不是最底層才顯示） -->
				{#if i < 2 && step > i + 1}
					<!-- 向上箭頭 -->
					<line
						x1="75"
						y1={lv.y - 5}
						x2="75"
						y2={LEVELS[i + 1].y + 60}
						stroke={LEVELS[i + 1].color}
						stroke-width="2.5"
						stroke-dasharray="none"
						marker-end="url(#upArr)"
					/>
					<rect
						x="20"
						y={(lv.y + LEVELS[i + 1].y) / 2 - 10}
						width="48"
						height="20"
						rx="4"
						fill={LEVELS[i + 1].bg}
						stroke={LEVELS[i + 1].color}
						stroke-width="1.5"
					/>
					<text
						x="44"
						y={(lv.y + LEVELS[i + 1].y) / 2 + 4}
						text-anchor="middle"
						font-size="11"
						font-weight="bold"
						fill={LEVELS[i + 1].color}
					>
						×10³
					</text>
				{/if}
			{/if}
		{/each}

		<defs>
			<marker
				id="upArr"
				viewBox="0 0 10 10"
				refX="5"
				refY="0"
				markerWidth="6"
				markerHeight="6"
				orient="auto"
			>
				<path d="M0,10 L5,0 L10,10 z" fill="#a78bfa" />
			</marker>
		</defs>

		<!-- 未展開提示 -->
		{#if step === 0}
			<text x="180" y="140" text-anchor="middle" font-size="13" fill="#94a3b8">
				點擊查看單位階梯
			</text>
		{/if}

		<!-- 完成結論 -->
		{#if step >= 4}
			<rect
				x="15"
				y="228"
				width="330"
				height="26"
				rx="6"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="180" y="245" text-anchor="middle" font-size="12" font-weight="bold" fill="#16a34a">
				每升一階 ×10³：1t = 10³kg = 10⁶g
			</text>
		{/if}
	</svg>
</div>
