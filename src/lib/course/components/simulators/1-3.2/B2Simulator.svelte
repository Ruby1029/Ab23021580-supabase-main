<script lang="ts">
	let { onCorrect } = $props();
	let step = $state(0);

	function next() {
		step++;
		if (step >= 4) {
			onCorrect();
		}
	}
</script>

<div
	class="mx-auto flex min-h-[400px] w-full max-w-[600px] flex-col items-center justify-center rounded-xl border bg-slate-50 p-8 shadow-inner"
>
	<div class="mb-6 text-xl font-bold text-slate-700">水的大單位換算：1000 kg/m³ = ? g/cm³</div>

	<div class="flex w-full max-w-md flex-col gap-4">
		<!-- Step 1: Base Units -->
		<div class="flex justify-around rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
			<div class="text-lg font-bold text-rose-600">1 kg = 1000 g</div>
			<div class="text-lg font-bold text-blue-600">1 m³ = 10⁶ cm³</div>
		</div>

		{#if step >= 1}
			<!-- Step 2: Plug in -->
			<div
				class="animate-fade-in flex flex-col items-center gap-2 rounded-xl border border-slate-200 bg-white p-4 shadow-sm"
			>
				<div class="text-sm font-bold text-slate-500">先換算 1 kg/m³</div>
				<div class="flex items-center gap-4 text-xl font-black text-slate-800">
					<span
						>1 <span class="text-rose-600">kg</span> / <span class="text-blue-600">m³</span></span
					>
					<span class="text-slate-400">=</span>
					<div class="flex flex-col items-center">
						<span class="border-b-2 border-slate-800 px-2 text-rose-600">1000 g</span>
						<span class="mt-1 px-2 text-blue-600">1,000,000 cm³</span>
					</div>
				</div>
			</div>
		{/if}

		{#if step >= 2}
			<!-- Step 3: Simplify -->
			<div
				class="animate-fade-in flex flex-col items-center rounded-xl border border-slate-200 bg-white p-4 shadow-sm"
			>
				<div class="mb-2 text-sm font-bold text-slate-500">約分消掉 3 個 0</div>
				<div class="flex items-center gap-4 text-xl font-black text-slate-800">
					<span>1 kg/m³</span>
					<span class="text-slate-400">=</span>
					<div class="flex flex-col items-center">
						<span class="border-b-2 border-slate-800 px-2 text-rose-600">1 g</span>
						<span class="mt-1 px-2 text-blue-600">1000 cm³</span>
					</div>
				</div>
			</div>
		{/if}

		{#if step >= 3}
			<!-- Step 4: Multiply by 1000 -->
			<div class="animate-fade-in flex justify-center font-bold text-slate-400">
				↓ 等式兩邊同乘 1000 ↓
			</div>
		{/if}

		{#if step >= 4}
			<!-- Result -->
			<div
				class="animate-fade-in flex items-center justify-center rounded-xl bg-indigo-500 p-6 text-white shadow-lg"
			>
				<span class="text-3xl font-black">1000 kg/m³ = 1 g/cm³</span>
			</div>
		{/if}
	</div>

	<div class="mt-8">
		{#if step < 4}
			<button
				class="rounded-lg bg-indigo-500 px-8 py-3 font-bold text-white shadow-md transition-all hover:bg-indigo-600 active:scale-95"
				onclick={next}
			>
				下一步
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
