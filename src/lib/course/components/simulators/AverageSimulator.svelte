<script lang="ts">
	import type { CourseState } from '$lib/course/courseState.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	let config = $derived(courseState.currentStage.simulator?.config);
	let baseRecords: number[] = $derived(config?.records ?? []);
	let includeOutlier: boolean = $derived(config?.includeOutlier ?? false);
	let outlierValue: number = $derived(config?.outlierValue ?? 15.0);

	// 全部記錄（含異常值）
	let allRecords = $derived(includeOutlier ? [...baseRecords, outlierValue] : [...baseRecords]);

	// 學生點選的記錄（選中=納入計算）
	let selected = $derived.by(() => allRecords.map(() => true));

	let selectedRecords = $derived(allRecords.filter((_, i) => selected[i]));
	let average = $derived(
		selectedRecords.length > 0
			? selectedRecords.reduce((a, b) => a + b, 0) / selectedRecords.length
			: 0
	);

	// B2：正確答案是移除異常值後得到合理平均
	let correctAvg = $derived(baseRecords.reduce((a, b) => a + b, 0) / baseRecords.length);
	let isDone = $derived(
		includeOutlier
			? Math.abs(average - correctAvg) < 0.05 && selectedRecords.length === baseRecords.length
			: selectedRecords.length === allRecords.length
	);

	$effect(() => {
		if (isDone && !courseState.isUnlocked(courseState.currentStage.id)) {
			onCorrect();
		}
	});
</script>

<div class="flex w-full flex-col items-center gap-6 p-6">
	<p class="text-sm font-semibold text-gray-500">
		{includeOutlier ? '找出並取消勾選錯誤的測量記錄' : '點擊每筆記錄，觀察平均值的變化'}
	</p>

	<!-- 測量記錄表格 -->
	<div
		class="w-full max-w-lg overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm"
	>
		<table class="w-full text-center">
			<thead>
				<tr class="bg-gray-100 text-sm font-bold text-gray-600">
					<th class="px-4 py-3">測量者</th>
					<th class="px-4 py-3">測量結果 (cm)</th>
					<th class="px-4 py-3">納入計算</th>
				</tr>
			</thead>
			<tbody>
				{#each allRecords as record, i (`${record}-${i}`)}
					{@const isOutlier = includeOutlier && record === outlierValue}
					{@const isDeselected = !selected[i]}
					<tr
						class="border-t border-gray-100 transition-colors {isDeselected
							? 'bg-red-50'
							: isOutlier
								? 'bg-amber-50'
								: 'hover:bg-blue-50'}"
					>
						<td class="px-4 py-3 font-bold text-gray-700">第 {i + 1} 人</td>
						<td
							class="px-4 py-3 font-mono text-lg font-black
							{isOutlier ? 'text-amber-600' : 'text-gray-800'}
							{isDeselected ? 'text-gray-400 line-through' : ''}"
						>
							{record.toFixed(1)}
						</td>
						<td class="px-4 py-3">
							<button
								class="h-7 w-7 rounded-md border-2 text-sm font-black transition-all
									{selected[i] ? 'border-blue-500 bg-blue-500 text-white' : 'border-gray-300 bg-white text-gray-300'}"
								onclick={() => {
									selected[i] = !selected[i];
								}}
							>
								{selected[i] ? '✓' : '✗'}
							</button>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>

	<!-- 計算公式 -->
	<div class="w-full max-w-lg rounded-2xl border border-blue-200 bg-blue-50 p-5">
		<p class="mb-2 text-xs font-bold tracking-widest text-blue-500 uppercase">平均值計算過程</p>
		<p class="font-mono text-sm leading-relaxed break-all text-blue-800">
			({selectedRecords.map((r) => r.toFixed(1)).join(' + ')}) ÷ {selectedRecords.length}
		</p>
		<div class="mt-3 flex items-center gap-3">
			<span class="font-bold text-gray-500">= </span>
			<span class="text-3xl font-black {isDone ? 'text-emerald-600' : 'text-blue-700'}">
				{average.toFixed(2)} cm
			</span>
			{#if isDone}
				<span class="text-sm font-bold text-emerald-500">✓ 正確！</span>
			{/if}
		</div>
	</div>

	{#if includeOutlier && !isDone}
		<p class="text-sm font-bold text-amber-600">
			⚠ 平均值偏差過大，請取消勾選與其他人差異很大的數值
		</p>
	{/if}
</div>
