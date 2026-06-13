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
	<div class="mb-6 text-xl font-bold text-slate-700">數學移項：如何單獨求出 M？</div>

	<div class="flex w-full max-w-md flex-col gap-4">
		<!-- Step 1: Base Equation -->
		<div class="flex justify-center rounded-xl border-2 border-indigo-100 bg-white p-6 shadow-md">
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
			<!-- Step 2: Multiply both sides -->
			<div class="animate-fade-in flex justify-center font-bold text-slate-400">
				↓ 等號兩邊同乘 V ↓
			</div>

			<div
				class="animate-fade-in flex justify-center rounded-xl border border-slate-200 bg-white p-6 shadow-sm"
			>
				<div class="flex items-center gap-4 text-2xl font-black text-slate-800">
					<span>D <span class="text-blue-500">× V</span></span>
					<span class="text-slate-400">=</span>
					<div class="flex flex-col items-center">
						<span class="border-b-2 border-slate-800 px-2 text-rose-500">M</span>
						<span class="mt-1 px-2 text-blue-500">V</span>
					</div>
					<span class="text-blue-500">× V</span>
				</div>
			</div>
		{/if}

		{#if step >= 2}
			<!-- Step 3: Cancel out -->
			<div class="animate-fade-in flex justify-center font-bold text-slate-400">
				↓ 右邊的 V 被消掉了 ↓
			</div>

			<div
				class="animate-fade-in relative flex justify-center overflow-hidden rounded-xl border border-slate-200 bg-white p-4 shadow-sm"
			>
				<div class="relative z-10 flex items-center gap-4 text-2xl font-black text-slate-800">
					<span>D × V</span>
					<span class="text-slate-400">=</span>
					<span class="text-rose-500">M</span>
				</div>
			</div>
		{/if}

		{#if step >= 3}
			<div class="animate-fade-in flex justify-center font-bold text-slate-400">
				↓ 左右交換，寫成好記的口訣 ↓
			</div>
		{/if}

		{#if step >= 4}
			<!-- Result -->
			<div
				class="animate-fade-in flex flex-col items-center justify-center gap-2 rounded-xl bg-indigo-500 p-6 text-white shadow-lg"
			>
				<span class="text-4xl font-black tracking-widest"
					><span class="text-rose-200">M</span> = <span class="text-blue-200">V</span> × D</span
				>
				<span class="mt-2 font-bold text-indigo-100">（超好記口訣：MoVie = ViDeo）</span>
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
