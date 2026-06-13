<script lang="ts">
	/**
	 * 1-2.3 A3：秤量操作 - 由大到小放砝碼
	 * 點擊砝碼依序放入右盤，指針逐漸置中
	 * 教學核心：從重到輕放置，指針接近後換小砝碼微調
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

	// 物體質量 = 75g（模擬）
	const OBJECT_MASS = 75;

	// 可用砝碼（由大到小）
	const WEIGHTS = [
		{ g: 100, color: '#fbbf24', stroke: '#d97706' },
		{ g: 50, color: '#60a5fa', stroke: '#2563eb' },
		{ g: 20, color: '#86efac', stroke: '#16a34a' },
		{ g: 10, color: '#c4b5fd', stroke: '#7c3aed' },
		{ g: 5, color: '#fca5a5', stroke: '#dc2626' }
	];

	let rightTotal = $state(0);
	let placedWeights = $state<number[]>([]); // 已放入的砝碼 index
	let removedWeights = $state<Set<number>>(new Set()); // 已移除（因超重）
	let done = $state(false);
	let message = $state('');

	// 天平傾斜角度（左=物體，右=砝碼）
	const tiltAngle = $derived.by(() => {
		const diff = rightTotal - OBJECT_MASS;
		return Math.max(-18, Math.min(18, diff * 0.25));
	});

	async function placeWeight(idx: number) {
		if (done || removedWeights.has(idx) || placedWeights.includes(idx)) return;
		if (courseState.isUnlocked(courseState.currentStage.id)) return;

		const wg = WEIGHTS[idx].g;
		const newTotal = rightTotal + wg;

		if (newTotal > OBJECT_MASS + 10) {
			// 超重：提示拿掉
			message = `${wg}g 太重了，取出後換小一點的`;
			removedWeights = new Set([...removedWeights, idx]);
			return;
		}

		placedWeights = [...placedWeights, idx];
		rightTotal = newTotal;
		message = `右盤：${rightTotal}g`;

		if (Math.abs(rightTotal - OBJECT_MASS) <= 5) {
			done = true;
			message = `指針置中！物體質量 = ${rightTotal}g`;
			await sleep(800);
			onCorrect();
		}
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if !done}左盤已放物體，點擊砝碼（由大到小）放入右盤{:else}秤量完成！{/if}
	</p>

	<svg width="100%" viewBox="0 0 370 260" preserveAspectRatio="xMidYMid meet" class="max-w-[390px]">
		<rect width="370" height="260" rx="8" fill="#f8fafc" />

		<!-- 天平 -->
		<TopPanBalance cx={185} cy={120} {tiltAngle} />

		{#if rightTotal > 0}
			<text x="240" y="70" text-anchor="middle" font-size="11" font-weight="bold" fill="#1e293b"
				>{rightTotal}g</text
			>
		{/if}
		<text x="130" y="70" text-anchor="middle" font-size="11" font-weight="bold" fill="#1e293b"
			>物體</text
		>

		<!-- 左盤放置圓柱體物體 (模擬) -->
		<!-- 左盤在 TopPanBalance 的位置大約是 pivotX - 90, pivotY - 30 -->
		<!-- pivotX = 185, pivotY = cy - 40 = 80. 所以 leftPanCenter.y 約為 50 -->
		<!-- 根據傾斜度會有變化，這裡簡單固定在托盤相對位置，稍後可以用絕對定位或動態計算，此處先示意 -->

		<!-- 砝碼區 -->
		<text x="185" y="178" text-anchor="middle" font-size="10" fill="#64748b"
			>真實砝碼組（點擊放入托盤）</text
		>

		<g transform="translate(0, 30)">
			{#each WEIGHTS as w, i (`${w.g}-${i}`)}
				{@const used = placedWeights.includes(i)}
				{@const removed = removedWeights.has(i)}
				{@const cx = 55 + i * 66}
				<g onclick={() => placeWeight(i)}>
					<RealisticWeight
						mass={w.g}
						x={cx}
						y={198}
						material="brass"
						interactive={true}
						disabled={used || removed}
					/>
					{#if removed}
						<text x={cx} y="210" text-anchor="middle" font-size="8" fill="#ef4444">×已取出</text>
					{:else if used}
						<text x={cx} y="210" text-anchor="middle" font-size="8" fill="#16a34a">✓已放入</text>
					{/if}
				</g>
			{/each}
		</g>

		<!-- 狀態訊息 -->
		<rect
			x="20"
			y="238"
			width="330"
			height="18"
			rx="4"
			fill={done ? '#dcfce7' : '#fef3c7'}
			stroke={done ? '#4ade80' : '#fbbf24'}
			stroke-width="1.5"
		/>
		<text
			x="185"
			y="250"
			text-anchor="middle"
			font-size="10"
			font-weight="bold"
			fill={done ? '#16a34a' : '#92400e'}
		>
			{message || '由大到小加砝碼，直到指針置中'}
		</text>
	</svg>
</div>
