<script lang="ts">
	/**
	 * 1-2.3 A1：天平部位辨識
	 * 點擊四個部位依序高亮 + 彈出標籤
	 * 教學核心：指針、校準螺絲、左盤、右盤的位置與功能
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

	type Part = 'needle' | 'screw' | 'leftPan' | 'rightPan';
	const PARTS: Part[] = ['needle', 'screw', 'leftPan', 'rightPan'];
	const PART_NAMES: Record<Part, string> = {
		needle: '指針',
		screw: '校準螺絲',
		leftPan: '左盤',
		rightPan: '右盤'
	};

	let foundParts = $state<Set<Part>>(new Set());
	let currentHighlight = $state<Part | null>(null);
	let done = $state(false);

	// 點擊區域（對應 TopPanBalance 元件內的座標，viewBox 0 0 370 250）
	// cx=185, cy=145, pivotY=145, leftBeam=75, rightBeam=295
	const CLICK_ZONES: Array<{ part: Part; x: number; y: number; w: number; h: number }> = [
		{ part: 'needle', x: 165, y: 55, w: 40, h: 90 }, // 指針區域 (朝上)
		{ part: 'screw', x: 45, y: 130, w: 30, h: 30 }, // 左螺絲區域
		{ part: 'screw', x: 295, y: 130, w: 30, h: 30 }, // 右螺絲區域
		{ part: 'leftPan', x: 35, y: 100, w: 80, h: 50 }, // 左盤區域
		{ part: 'rightPan', x: 255, y: 100, w: 80, h: 50 } // 右盤區域
	];

	async function clickZone(part: Part) {
		if (done || courseState.isUnlocked(courseState.currentStage.id)) return;
		currentHighlight = part;
		foundParts = new Set([...foundParts, part]);
		if (PARTS.every((p) => foundParts.has(p))) {
			done = true;
			await sleep(800);
			onCorrect();
		}
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if !done}
			點擊天平各部位（已找到 {foundParts.size}/4）
		{:else}
			指針、校準螺絲、左盤、右盤：天平四大部位
		{/if}
	</p>

	<svg width="100%" viewBox="0 0 370 250" preserveAspectRatio="xMidYMid meet" class="max-w-[390px]">
		<rect width="370" height="250" rx="8" fill="#f8fafc" />

		<!-- 天平共用元件 -->
		<TopPanBalance
			cx={185}
			cy={145}
			tiltAngle={0}
			highlightPart={currentHighlight}
			showLabels={done}
		/>

		<!-- 透明點擊層（疊在 Balance 上方） -->
		{#each CLICK_ZONES as zone (zone.part)}
			<rect
				x={zone.x}
				y={zone.y}
				width={zone.w}
				height={zone.h}
				fill="transparent"
				stroke={foundParts.has(zone.part) ? '#4ade80' : 'transparent'}
				stroke-width="2"
				rx="4"
				style="cursor:pointer"
				onclick={() => clickZone(zone.part)}
			/>
			<!-- 已找到的打勾標示 -->
			{#if foundParts.has(zone.part)}
				<circle cx={zone.x + zone.w - 8} cy={zone.y + 8} r="8" fill="#4ade80" />
				<text
					x={zone.x + zone.w - 8}
					y={zone.y + 12}
					text-anchor="middle"
					font-size="10"
					fill="white">✓</text
				>
			{/if}
		{/each}

		<!-- 下方部位清單 -->
		<rect
			x="10"
			y="222"
			width="350"
			height="22"
			rx="5"
			fill={done ? '#dcfce7' : '#f1f5f9'}
			stroke={done ? '#4ade80' : '#e2e8f0'}
			stroke-width="1.5"
		/>
		<text x="185" y="237" text-anchor="middle" font-size="10" fill={done ? '#16a34a' : '#64748b'}>
			{#if done}
				四個部位全部找到！
			{:else}
				{PARTS.filter((p) => foundParts.has(p))
					.map((p) => PART_NAMES[p])
					.join('、') || '點擊天平上的各部位'}
			{/if}
		</text>
	</svg>
</div>
