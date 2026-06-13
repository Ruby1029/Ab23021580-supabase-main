<script lang="ts">
	let { onCorrect } = $props();

	let selectedCategory = $state('solid');
	let selectedItem = $state(0);
	let isDone = $state(false);

	const categories = [
		{ id: 'solid', name: '固體' },
		{ id: 'liquid', name: '液體' },
		{ id: 'gas', name: '氣體' }
	];

	const materials = {
		solid: [
			{ name: '金', d: 19.3, icon: '🌟', color: 'bg-yellow-200' },
			{ name: '鐵', d: 7.8, icon: '🔩', color: 'bg-slate-300' },
			{ name: '鋁', d: 2.7, icon: '🥫', color: 'bg-slate-200' },
			{ name: '冰', d: 0.92, icon: '🧊', color: 'bg-cyan-100' }
		],
		liquid: [
			{ name: '水銀', d: 13.6, icon: '🌡️', color: 'bg-slate-300' },
			{ name: '海水', d: 1.03, icon: '🌊', color: 'bg-blue-200' },
			{ name: '水', d: 1.0, icon: '💧', color: 'bg-blue-100' },
			{ name: '沙拉油', d: 0.9, icon: '🛢️', color: 'bg-amber-100' }
		],
		gas: [
			{ name: '氧氣', d: 0.0014, icon: '☁️', color: 'bg-sky-50' },
			{ name: '空氣', d: 0.0012, icon: '💨', color: 'bg-slate-50' },
			{ name: '氫氣', d: 0.00009, icon: '🎈', color: 'bg-rose-50' }
		]
	};

	let currentList = $derived(materials[selectedCategory as keyof typeof materials]);
	let currentItem = $derived(currentList[selectedItem]);

	let seenCategories = $state(new Set(['solid']));

	function selectCategory(id: string) {
		selectedCategory = id;
		selectedItem = 0;
		seenCategories.add(id);

		if (seenCategories.size === 3 && !isDone) {
			isDone = true;
			setTimeout(onCorrect, 1000);
		}
	}
</script>

<div
	class="mx-auto flex w-full max-w-[600px] flex-col overflow-hidden rounded-xl border bg-slate-50 shadow-inner"
>
	<div class="border-b bg-white pt-4 pb-1 text-center text-base font-bold text-slate-700">
		各種物質的密度 (常溫常壓)
	</div>

	<div class="flex h-[300px]">
		<!-- Categories -->
		<div class="flex w-1/4 flex-col border-r bg-slate-100">
			{#each categories as cat (cat.id)}
				<button
					class="flex-1 border-b text-lg font-bold transition-all {selectedCategory === cat.id
						? 'bg-indigo-500 text-white shadow-inner'
						: 'text-slate-600 hover:bg-slate-200'}"
					onclick={() => selectCategory(cat.id)}
				>
					{cat.name}
				</button>
			{/each}
		</div>

		<!-- Items List -->
		<div class="w-1/3 overflow-y-auto border-r bg-white">
			{#each currentList as item, index (`${item.name}-${index}`)}
				<button
					class="flex w-full items-center justify-between border-b px-4 py-4 text-left transition-all {selectedItem ===
					index
						? item.color + ' border-l-4 border-l-indigo-500'
						: 'border-l-4 border-l-transparent hover:bg-slate-50'}"
					onclick={() => (selectedItem = index)}
				>
					<div class="flex items-center gap-3">
						<span class="text-2xl">{item.icon}</span>
						<span class="font-bold text-slate-700">{item.name}</span>
					</div>
					{#if selectedItem === index}
						<svg
							xmlns="http://www.w3.org/2000/svg"
							width="16"
							height="16"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							class="text-indigo-600"><path d="m9 18 6-6-6-6" /></svg
						>
					{/if}
				</button>
			{/each}
		</div>

		<!-- Detail View -->
		<div
			class="relative flex flex-1 flex-col items-center justify-center bg-slate-50 p-6 text-center"
		>
			<div class="animate-bounce-short mb-4 text-6xl">{currentItem.icon}</div>
			<div class="mb-2 text-2xl font-black text-slate-800">{currentItem.name}</div>

			<div class="mt-2 rounded-xl border bg-white px-6 py-4 shadow-md">
				<div class="mb-1 text-sm font-bold text-slate-400">密度 D</div>
				<div class="font-mono text-3xl font-black text-indigo-600">
					{currentItem.d}
				</div>
				<div class="mt-1 text-sm font-bold text-slate-500">g/cm³</div>
			</div>

			{#if currentItem.name === '金'}
				<div
					class="absolute right-0 bottom-4 left-0 mx-4 rounded bg-amber-100 py-1 text-xs font-bold text-amber-600"
				>
					超重！
				</div>
			{/if}
			{#if currentItem.name === '氫氣'}
				<div
					class="absolute right-0 bottom-4 left-0 mx-4 rounded bg-rose-100 py-1 text-xs font-bold text-rose-500"
				>
					超輕！氣球能飛
				</div>
			{/if}
		</div>
	</div>

	<!-- Hint -->
	<div class="border-t border-indigo-100 bg-indigo-50 p-3 text-center">
		<span class="text-sm font-bold text-indigo-800">
			觀察：同種狀態下，不同物質密度不同。金和氫氣差了數十萬倍！
		</span>
	</div>
</div>

<style>
	.animate-bounce-short {
		animation: bounceShort 0.5s ease-out;
	}
	@keyframes bounceShort {
		0%,
		100% {
			transform: translateY(0);
		}
		50% {
			transform: translateY(-10px);
		}
	}
</style>
