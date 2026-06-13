<script lang="ts">
	let { onCorrect } = $props();
</script>

<div
	class="flex h-full min-h-[300px] w-full flex-col items-center justify-center rounded-xl border bg-slate-50"
>
	<button
		class="group flex flex-col items-center justify-center gap-4 transition-transform hover:scale-110 active:scale-95"
		onclick={onCorrect}
	>
		<div
			class="flex h-24 w-24 items-center justify-center rounded-full bg-blue-500 text-white shadow-lg transition-all group-hover:bg-blue-600 group-hover:shadow-blue-500/50"
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="48"
				height="48"
				viewBox="0 0 24 24"
				fill="currentColor"
				stroke="currentColor"
				stroke-width="2"
				stroke-linecap="round"
				stroke-linejoin="round"
				class="ml-2"><polygon points="6 3 20 12 6 21 6 3" /></svg
			>
		</div>
		<span class="text-xl font-bold tracking-wider text-slate-700">點擊開始單元</span>
	</button>
</div>
