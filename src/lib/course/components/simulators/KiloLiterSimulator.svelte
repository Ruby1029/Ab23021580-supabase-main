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

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	async function handleClick() {
		if (started || done || courseState.isUnlocked(courseState.currentStage.id)) return;
		started = true;

		const t0 = performance.now(),
			dur = 2800;
		await new Promise<void>((resolve) => {
			function tick(now: number) {
				const t = Math.min((now - t0) / dur, 1);
				count = Math.round(t * 1000);
				if (t < 1) requestAnimationFrame(tick);
				else resolve();
			}
			requestAnimationFrame(tick);
		});

		done = true;
		await sleep(700);
		onCorrect();
	}

	// 10×10 格子，每格代表一支水瓶（可見層），標注 ×10 層 = 1000
	const COLS = 10,
		ROWS = 10;
	const GRID_X = 15,
		GRID_Y = 40;
	const CELL_W = 32,
		CELL_H = 20;
	const GAP = 2;

	// 目前要亮起的格數（0~100，映射自 count 0~1000）
	const litCells = $derived(Math.min(Math.ceil(count / 10), 100));
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !started}點擊觀察：1m³ 有多少瓶 1L 水？
		{:else if done}✓ 1 m³ = 1 kL = 1000 L
		{:else}{count} / 1000 瓶{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 370 310"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[390px] cursor-pointer"
		role="img"
		aria-label="1立方公尺等於1000個1L水瓶"
		onclick={handleClick}
	>
		<!-- 標題 -->
		<text x="185" y="22" text-anchor="middle" font-size="12" fill="#475569" font-weight="bold">
			1 m³ = ? 瓶 × 1L
		</text>

		<!-- 10×10 格子（俯視代表 100 瓶 × 10 層） -->
		{#each Array(ROWS) as rowMarker, row (`${rowMarker}-${row}`)}
			{#each Array(COLS) as colMarker, col (`${row}-${colMarker}-${col}`)}
				{@const idx = row * COLS + col}
				{@const cx = GRID_X + col * (CELL_W + GAP)}
				{@const cy = GRID_Y + row * (CELL_H + GAP)}
				{@const isLit = idx < litCells}
				<rect
					x={cx}
					y={cy}
					width={CELL_W}
					height={CELL_H}
					rx="3"
					fill={isLit ? '#3b82f6' : '#f1f5f9'}
					fill-opacity={isLit ? 0.7 : 1}
					stroke={isLit ? '#2563eb' : '#cbd5e1'}
					stroke-width="1"
				/>
				{#if isLit}
					<text
						x={cx + CELL_W / 2}
						y={cy + CELL_H / 2 + 3.5}
						text-anchor="middle"
						font-size="7"
						fill="white"
						font-weight="bold">1L</text
					>
				{/if}
			{/each}
		{/each}

		<!-- 格子說明 -->
		<text
			x="185"
			y={GRID_Y + ROWS * (CELL_H + GAP) + 16}
			text-anchor="middle"
			font-size="10"
			fill="#64748b"
		>
			每格 = 1 瓶（1L），10×10 = 100 瓶 × 10 層
		</text>

		<!-- 示意水瓶（右下角，展示「每格代表的東西」） -->
		<WaterBottle
			x={305}
			y={GRID_Y + ROWS * (CELL_H + GAP) - 95}
			scale={0.55}
			fillRatio={started ? 1 : 0.3}
			label="1L"
		/>

		<!-- 層數標示 -->
		<text
			x="185"
			y={GRID_Y + ROWS * (CELL_H + GAP) + 32}
			text-anchor="middle"
			font-size="11"
			fill="#3b82f6"
			font-weight="bold"
		>
			100 瓶 × 10 層 = 1000 瓶
		</text>

		<!-- 計數器 -->
		{#if started && !done}
			<text x="340" y="22" text-anchor="end" font-size="14" font-weight="black" fill="#3b82f6">
				{count}<tspan font-size="9" fill="#64748b"> / 1000</tspan>
			</text>
		{/if}

		<!-- 未開始提示 -->
		{#if !started}
			<text
				x="185"
				y={GRID_Y + (ROWS * (CELL_H + GAP)) / 2}
				text-anchor="middle"
				font-size="13"
				fill="#94a3b8">點擊開始</text
			>
		{/if}

		<!-- 完成標示 -->
		{#if done}
			<rect
				x="25"
				y="272"
				width="320"
				height="34"
				rx="8"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="185" y="294" text-anchor="middle" font-size="13" font-weight="bold" fill="#16a34a">
				1 m³ = 1 kL = 1000 L ✓
			</text>
		{/if}
	</svg>
</div>
