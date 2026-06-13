<script lang="ts">
	let { onCorrect } = $props();
	let isDone = $state(false);

	function handleComplete() {
		isDone = true;
		onCorrect();
	}
</script>

<div
	class="mx-auto flex min-h-[300px] w-full max-w-[600px] flex-col items-center justify-center rounded-xl border bg-slate-50 p-8 shadow-inner"
>
	<div class="flex w-full flex-col gap-6">
		<!-- B1 Recap -->
		<div
			class="flex items-center justify-between rounded-lg border border-slate-200 bg-white p-4 shadow-sm"
		>
			<div class="flex items-center gap-4">
				<div
					class="flex h-12 w-12 items-center justify-center rounded-full bg-blue-100 text-xl font-bold text-blue-600"
				>
					B1
				</div>
				<div class="font-bold text-slate-600">
					固定V時，糖水的 <span class="text-rose-500">M 更高</span>
				</div>
			</div>
			<div class="text-lg font-black text-amber-600">→ 糖水斜率更大</div>
		</div>

		<!-- B2 Recap -->
		<div
			class="flex items-center justify-between rounded-lg border border-slate-200 bg-white p-4 shadow-sm"
		>
			<div class="flex items-center gap-4">
				<div
					class="flex h-12 w-12 items-center justify-center rounded-full bg-blue-100 text-xl font-bold text-blue-600"
				>
					B2
				</div>
				<div class="font-bold text-slate-600">
					固定M時，糖水的 <span class="text-blue-500">V 更小</span>
				</div>
			</div>
			<div class="text-lg font-black text-amber-600">→ 糖水斜率更大</div>
		</div>

		<div class="my-2 h-px w-full bg-slate-300"></div>

		{#if !isDone}
			<button
				class="w-full rounded-xl bg-indigo-500 py-4 text-lg font-bold text-white shadow-md transition-all hover:bg-indigo-600 active:scale-95"
				onclick={handleComplete}
			>
				找出共同規律
			</button>
		{:else}
			<div class="animate-pulse rounded-xl border border-indigo-200 bg-indigo-50 p-4 text-center">
				<div class="mb-2 text-lg font-bold text-indigo-800">
					共同規律：在 M-V 圖上，代表密度較大的物質，其斜線都會比較<span
						class="font-black text-rose-600">陡峭</span
					>！
				</div>
				<div class="font-bold text-slate-600">斜率大小 = 密度大小</div>
			</div>
		{/if}
	</div>
</div>
