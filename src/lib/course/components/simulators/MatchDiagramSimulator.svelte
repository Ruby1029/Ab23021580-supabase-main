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
	let zones: string[] = $derived(config?.zones ?? []);
	let tags: string[] = $derived(config?.tags ?? []);
	let answers: Record<string, string> = $derived(config?.answers ?? {});

	// 每個 zone 目前放了哪個 tag
	let zoneContents = $state<Record<string, string | null>>({});
	// 還未放置的 tags
	let freeTags = $state<string[]>([]);

	$effect(() => {
		zoneContents = Object.fromEntries(zones.map((z) => [z, null]));
		freeTags = [...tags];
	});

	let allCorrect = $derived(zones.every((z) => zoneContents[z] === answers[z]));

	$effect(() => {
		if (allCorrect && !courseState.isUnlocked(courseState.currentStage.id)) {
			onCorrect();
		}
	});

	// ── 拖曳邏輯 ──────────────────────────────────────────────────────────────
	let draggingTag = $state<string | null>(null);

	function onDragStart(tag: string) {
		draggingTag = tag;
	}

	function onDropZone(zone: string) {
		if (!draggingTag) return;

		// 如果 zone 已有內容，把舊的放回 freeTags
		const existing = zoneContents[zone];
		if (existing) freeTags = [...freeTags, existing];

		// 把拖來的從 freeTags 移除（若來自 freeTags）
		freeTags = freeTags.filter((t) => t !== draggingTag);

		// 如果來自另一個 zone，清空那個 zone（搜尋並清除）
		for (const z of zones) {
			if (zoneContents[z] === draggingTag && z !== zone) {
				zoneContents[z] = null;
			}
		}

		zoneContents[zone] = draggingTag;
		draggingTag = null;
	}

	function onDropFree() {
		if (!draggingTag) return;
		// 把 tag 從 zone 收回 freeTags
		for (const z of zones) {
			if (zoneContents[z] === draggingTag) {
				zoneContents[z] = null;
			}
		}
		if (!freeTags.includes(draggingTag)) {
			freeTags = [...freeTags, draggingTag];
		}
		draggingTag = null;
	}
</script>

<div class="flex w-full flex-col items-center gap-8 p-6 select-none">
	<!-- 測量結果示例 -->
	<div class="text-center">
		<p class="mb-2 text-sm text-gray-500">測量結果範例</p>
		<div
			class="flex items-center justify-center gap-0 rounded-2xl border-2 border-gray-200 bg-white px-8 py-4 text-4xl font-black shadow-sm"
		>
			<span class="text-blue-700">11.</span>
			<span class="text-orange-500">7</span>
			<span class="ml-1 text-emerald-600">cm</span>
		</div>
		<p class="mt-2 text-xs text-gray-400">（倒敘法：從單位開始判斷）</p>
	</div>

	<!-- 配對區 -->
	<div class="flex flex-wrap justify-center gap-4">
		{#each zones as zone (zone.id)}
			{@const content = zoneContents[zone]}
			{@const correct = content !== null && content === answers[zone]}
			<!-- svelte-ignore a11y_no_static_element_interactions -->
			<div
				class="flex flex-col items-center gap-2"
				ondragover={(e) => e.preventDefault()}
				ondrop={() => onDropZone(zone)}
			>
				<!-- Zone 放置槽 -->
				<div
					class="flex h-14 w-28 items-center justify-center rounded-xl border-2 border-dashed text-2xl font-black transition-all
					{correct
						? 'border-emerald-400 bg-emerald-50'
						: content
							? 'border-blue-400 bg-blue-50'
							: 'border-gray-300 bg-gray-50 hover:border-blue-300'}"
				>
					{#if content}
						<!-- svelte-ignore a11y_no_static_element_interactions -->
						<span
							class="cursor-grab text-2xl font-black {correct
								? 'text-emerald-600'
								: 'text-blue-700'}"
							draggable="true"
							ondragstart={() => onDragStart(content)}
						>
							{content}
						</span>
					{:else}
						<span class="text-sm text-gray-300">拖曳至此</span>
					{/if}
				</div>
				<!-- Zone 標籤 -->
				<span class="max-w-[7rem] text-center text-xs font-bold text-gray-600">{zone}</span>
			</div>
		{/each}
	</div>

	<!-- 可拖曳標籤池 -->
	<!-- svelte-ignore a11y_no_static_element_interactions -->
	<div
		class="flex min-h-[56px] w-full max-w-sm flex-wrap justify-center gap-3 rounded-xl border border-gray-200 bg-gray-50 p-3"
		ondragover={(e) => e.preventDefault()}
		ondrop={onDropFree}
	>
		{#if freeTags.length === 0}
			<span class="self-center text-sm text-gray-300">所有標籤已放置</span>
		{:else}
			{#each freeTags as tag (tag.id)}
				<!-- svelte-ignore a11y_no_static_element_interactions -->
				<span
					class="cursor-grab rounded-lg border-2 border-blue-300 bg-white px-4 py-2 text-xl font-black text-blue-700 shadow-sm transition-all hover:border-blue-500 hover:shadow-md"
					draggable="true"
					ondragstart={() => onDragStart(tag)}
				>
					{tag}
				</span>
			{/each}
		{/if}
	</div>

	{#if allCorrect}
		<p class="text-base font-black text-emerald-600">✓ 正確！測量結果 = 準確值 + 估計值 + 單位</p>
	{/if}
</div>
