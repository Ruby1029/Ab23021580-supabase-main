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
		<!-- A1 Recap -->
		<div
			class="flex items-center justify-between rounded-lg border border-slate-200 bg-white p-4 shadow-sm"
		>
			<div class="flex items-center gap-4">
				<div
					class="flex h-12 w-12 items-center justify-center rounded-full bg-blue-100 text-xl font-bold text-blue-600"
				>
					A1
				</div>
				<div class="font-bold text-slate-600">
					體積(V) 固定，質量(M) <span class="text-rose-500">增加</span>
				</div>
			</div>
			<div class="text-lg font-black text-indigo-600">→ 緊密程度變大</div>
		</div>

		<!-- A2 Recap -->
		<div
			class="flex items-center justify-between rounded-lg border border-slate-200 bg-white p-4 shadow-sm"
		>
			<div class="flex items-center gap-4">
				<div
					class="flex h-12 w-12 items-center justify-center rounded-full bg-blue-100 text-xl font-bold text-blue-600"
				>
					A2
				</div>
				<div class="font-bold text-slate-600">
					質量(M) 固定，體積(V) <span class="text-blue-500">縮小</span>
				</div>
			</div>
			<div class="text-lg font-black text-indigo-600">→ 緊密程度變大</div>
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
				<div class="text-lg font-bold text-indigo-800">
					共同規律：讓 <span class="text-rose-600">M 變大</span>，或讓
					<span class="text-blue-600">V 變小</span>，都會讓緊密度上升！
				</div>
				<div class="mt-2 font-bold text-slate-600">數學上，哪種運算符合這個特性？</div>
			</div>
		{/if}
	</div>
</div>
