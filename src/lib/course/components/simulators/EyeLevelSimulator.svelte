<script lang="ts">
	import type { CourseState } from '$lib/course/courseState.svelte';
	import GraduatedCylinder from './_global/lab/GraduatedCylinder.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	let selected = $state<string | null>(null);
	let done = $state(false);

	// 量筒參數
	const CYL_X = 220,
		CYL_Y = 260,
		CYL_H = 210;
	const WATER = 0.6;
	const WATER_Y = CYL_Y - 14 - WATER * (CYL_H - 14); // 水面 Y 座標

	// 三個眼睛位置
	const EYES = [
		{ id: 'high', label: '過高', y: WATER_Y - 50, correct: false },
		{ id: 'level', label: '平視', y: WATER_Y, correct: true },
		{ id: 'low', label: '過低', y: WATER_Y + 50, correct: false }
	];

	function sleep(ms: number) {
		return new Promise<void>((r) => setTimeout(r, ms));
	}

	async function handleSelect(eye: (typeof EYES)[0]) {
		if (done || courseState.isUnlocked(courseState.currentStage.id)) return;
		selected = eye.id;

		if (eye.correct) {
			done = true;
			await sleep(800);
			onCorrect();
		}
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !selected}點選正確的觀測角度來讀取量筒
		{:else if done}✓ 平視法：眼睛與液面同高
		{:else}再試一次！
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 340 300"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[360px]"
		role="img"
		aria-label="平視法讀取量筒"
	>
		<!-- 量筒 -->
		<GraduatedCylinder x={CYL_X} y={CYL_Y} height={CYL_H} waterLevel={WATER} />

		<!-- 三個眼睛選項 -->
		{#each EYES as eye (eye.label)}
			{@const isSelected = selected === eye.id}
			{@const eyeX = 60}

			<!-- 連線（點擊後才顯示） -->
			{#if isSelected}
				<line
					x1={eyeX + 30}
					y1={eye.y}
					x2={CYL_X - 22}
					y2={WATER_Y}
					stroke={eye.correct ? '#22c55e' : '#ef4444'}
					stroke-width="1.5"
					stroke-dasharray={eye.correct ? 'none' : '5 3'}
				/>
				<!-- 正確/錯誤標記 -->
				<text
					x={(eyeX + 30 + CYL_X - 22) / 2}
					y={(eye.y + WATER_Y) / 2 - 6}
					text-anchor="middle"
					font-size="16"
					font-weight="bold"
					fill={eye.correct ? '#22c55e' : '#ef4444'}
				>
					{eye.correct ? '✓' : '✗'}
				</text>
			{/if}

			<!-- 眼睛圖示（可點擊） -->
			<g
				class="cursor-pointer"
				onclick={() => handleSelect(eye)}
				role="button"
				tabindex="0"
				aria-label={eye.label}
			>
				<!-- 眼睛外框 -->
				<ellipse
					cx={eyeX}
					cy={eye.y}
					rx="26"
					ry="16"
					fill={isSelected ? (eye.correct ? '#dcfce7' : '#fef2f2') : '#f1f5f9'}
					stroke={isSelected ? (eye.correct ? '#22c55e' : '#ef4444') : '#64748b'}
					stroke-width="2"
				/>
				<!-- 瞳孔 -->
				<circle cx={eyeX + 6} cy={eye.y} r="7" fill="#1e293b" />
				<circle cx={eyeX + 8} cy={eye.y - 2} r="2.5" fill="white" />

				<!-- 標籤 -->
				<text
					x={eyeX - 35}
					y={eye.y + 4}
					text-anchor="end"
					font-size="11"
					fill={isSelected ? (eye.correct ? '#16a34a' : '#dc2626') : '#475569'}
					font-weight="bold"
				>
					{eye.label}
				</text>
			</g>
		{/each}

		<!-- 底部說明 -->
		{#if done}
			<rect
				x="30"
				y="272"
				width="280"
				height="28"
				rx="6"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="170" y="291" text-anchor="middle" font-size="12" font-weight="bold" fill="#16a34a">
				平視法 = 眼睛與液面同高 ✓
			</text>
		{/if}
	</svg>
</div>
