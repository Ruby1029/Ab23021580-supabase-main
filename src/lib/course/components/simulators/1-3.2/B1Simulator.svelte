<script lang="ts">
	let { onCorrect } = $props();
	let step = $state(0);

	function next() {
		step++;
		if (step >= 2) {
			onCorrect();
		}
	}
</script>

<div
	class="mx-auto flex min-h-[300px] w-full max-w-[600px] flex-col items-center justify-center rounded-xl border bg-slate-50 p-8 shadow-inner"
>
	<div class="mb-8 text-xl font-bold text-slate-700">密度的單位是怎麼來的？</div>

	<div class="flex w-full max-w-sm flex-col gap-6">
		<!-- Formula -->
		<div
			class="flex items-center justify-center rounded-xl border-2 border-indigo-100 bg-white p-6 shadow-md"
		>
			<div class="flex items-center gap-4 text-3xl font-black text-slate-800">
				<span>D</span>
				<span class="text-slate-400">=</span>
				<div class="flex flex-col items-center">
					<span class="border-b-2 border-slate-800 px-2 text-rose-500">M</span>
					<span class="mt-1 px-2 text-blue-500">V</span>
				</div>
			</div>
		</div>

		{#if step >= 1}
			<div class="animate-fade-in flex justify-center text-slate-400">↓ 代入單位 ↓</div>

			<!-- Units -->
			<div
				class="animate-fade-in flex items-center justify-center rounded-xl border-2 border-emerald-100 bg-white p-6 shadow-md"
			>
				<div class="flex items-center gap-4 text-2xl font-black text-slate-800">
					<span>單位</span>
					<span class="text-slate-400">=</span>
					<div class="flex flex-col items-center">
						<span class="border-b-2 border-slate-800 px-2 text-rose-600">g</span>
						<span class="mt-1 px-2 text-blue-600">cm³</span>
					</div>
				</div>
			</div>
		{/if}

		{#if step >= 2}
			<div class="animate-fade-in flex justify-center text-slate-400">↓ 寫成單行 ↓</div>

			<!-- Result -->
			<div
				class="animate-fade-in flex items-center justify-center rounded-xl bg-emerald-500 p-4 text-white shadow-lg"
			>
				<span class="text-3xl font-black">g/cm³</span>
			</div>
		{/if}
	</div>

	<div class="mt-8">
		{#if step < 2}
			<button
				class="rounded-lg bg-indigo-500 px-8 py-3 font-bold text-white shadow-md transition-all hover:bg-indigo-600 active:scale-95"
				onclick={next}
			>
				{step === 0 ? '代入單位' : '推導結果'}
			</button>
		{/if}
	</div>
</div>

<style>
	.animate-fade-in {
		animation: fadeIn 0.5s ease-out forwards;
	}
	@keyframes fadeIn {
		from {
			opacity: 0;
			transform: translateY(-10px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}
</style>
