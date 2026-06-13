<script lang="ts">
	/**
	 * 1-2.2 A4：比公克還小的是什麼？→ 1mg = 10⁻³g
	 * 教學核心：mg 的尺度感極小，需要精密天平，且是10⁻³而非單純「小一點」
	 * 設計：左半-放大鏡對準一粒鹽的立方晶格，右半-精密天平顯示0.001g
	 * 互動：點擊啟動放大鏡對焦動畫，再顯示精密天平讀數
	 */
	import type { CourseState } from '$lib/course/courseState.svelte';
	import DigitalScale from '../_global/lab/DigitalScale.svelte';

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

	let step = $state(0); // 0=初始 1=放大鏡對焦 2=顯示晶格+讀數 3=完成

	async function handleClick() {
		if (step >= 3 || courseState.isUnlocked(courseState.currentStage.id)) return;
		if (step === 0) {
			step = 1;
			await sleep(900);
			step = 2;
			await sleep(1500);
			step = 3;
			await sleep(400);
			onCorrect();
		}
	}

	// 鹽的NaCl晶格格點（5×5）
	const LATTICE = Array.from({ length: 25 }, (_, i) => ({
		cx: 220 + (i % 5) * 22,
		cy: 70 + Math.floor(i / 5) * 22,
		isNa: (Math.floor(i / 5) + (i % 5)) % 2 === 0
	}));
	void LATTICE;
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if step === 0}點擊用放大鏡觀察一粒鹽
		{:else if step === 1}對焦中…
		{:else if step === 2}NaCl 晶格：一粒鹽 ≈ 1mg
		{:else}1mg = 10⁻³g = 0.001g
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 380 265"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[400px] cursor-pointer"
		onclick={handleClick}
		role="img"
		aria-label="1mg一粒鹽放大"
	>
		<!-- ── 左半：放大鏡 ── -->
		<rect x="0" y="0" width="195" height="265" rx="8" fill="#f8fafc" />

		<!-- 放大鏡外框 -->
		<circle
			cx="90"
			cy="120"
			r="68"
			fill="white"
			fill-opacity="0.9"
			stroke="#94a3b8"
			stroke-width="3"
		/>
		<circle cx="90" cy="120" r="65" fill={step >= 1 ? '#f0f9ff' : '#f8fafc'} stroke="none" />
		<!-- 手柄 -->
		<line
			x1="140"
			y1="170"
			x2="170"
			y2="200"
			stroke="#94a3b8"
			stroke-width="8"
			stroke-linecap="round"
		/>

		<!-- 未放大時：只有小白點（代表看不清的鹽粒） -->
		{#if step === 0}
			<circle cx="90" cy="120" r="3" fill="#94a3b8" opacity="0.6" />
			<text x="90" y="200" text-anchor="middle" font-size="10" fill="#cbd5e1"> 點擊放大觀察 </text>
		{/if}

		<!-- step>=2：鏡頭內顯示NaCl晶格（簡化3×3） -->
		{#if step >= 2}
			<!-- NaCl 晶格（鏡內3×3） -->
			{#each [0, 1, 2] as row (row)}
				{#each [0, 1, 2] as col (`${row}-${col}`)}
					{@const isNa = (row + col) % 2 === 0}
					<circle
						cx={58 + col * 32}
						cy={92 + row * 32}
						r="12"
						fill={isNa ? '#93c5fd' : '#fca5a5'}
						stroke={isNa ? '#1d4ed8' : '#b91c1c'}
						stroke-width="1.5"
					/>
					<text
						x={58 + col * 32}
						y={92 + row * 32 + 4}
						text-anchor="middle"
						font-size="8"
						font-weight="bold"
						fill={isNa ? '#1d4ed8' : '#b91c1c'}
					>
						{isNa ? 'Na⁺' : 'Cl⁻'}
					</text>
				{/each}
			{/each}
			<!-- 晶格說明 -->
			<text x="90" y="205" text-anchor="middle" font-size="9" fill="#475569">
				氯化鈉晶格（放大示意）
			</text>
		{/if}

		<!-- ── 分界線 ── -->
		<line
			x1="200"
			y1="10"
			x2="200"
			y2="255"
			stroke="#94a3b8"
			stroke-width="1.5"
			stroke-dasharray="5 4"
		/>

		<!-- ── 右半：精密天平 ── -->
		<rect x="205" y="0" width="175" height="265" rx="8" fill="#fefce8" />
		<text x="292" y="22" text-anchor="middle" font-size="12" font-weight="bold" fill="#92400e">
			精密電子天平
		</text>

		<!-- 精密天平（比一般電子秤更精細的外觀） -->
		<!-- 防風罩 -->
		{#if step >= 2}
			<rect
				x="222"
				y="40"
				width="140"
				height="120"
				rx="6"
				fill="#f1f5f9"
				fill-opacity="0.5"
				stroke="#cbd5e1"
				stroke-width="1.5"
				stroke-dasharray="4 3"
			/>
			<text x="292" y="58" text-anchor="middle" font-size="9" fill="#94a3b8"> 防風罩 </text>
		{/if}

		<!-- 秤盤上的鹽粒 -->
		{#if step >= 2}
			<circle cx="292" cy="130" r="4" fill="#e2e8f0" stroke="#94a3b8" stroke-width="1" />
			<text x="292" y="108" text-anchor="middle" font-size="9" fill="#64748b"> 一粒鹽 </text>
		{/if}

		<!-- 電子秤本體（使用共用元件） -->
		<DigitalScale x={292} y={210} reading={step >= 2 ? '0.001 g' : '---'} scale={1.1} />

		<!-- 指數換算 -->
		{#if step >= 2}
			<text x="292" y="242" text-anchor="middle" font-size="10" font-weight="bold" fill="#0369a1">
				= 10⁻³ g = 1 mg
			</text>
		{/if}

		<!-- 完成結論 -->
		{#if step >= 3}
			<rect
				x="10"
				y="242"
				width="360"
				height="19"
				rx="5"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="190" y="255" text-anchor="middle" font-size="11" font-weight="bold" fill="#16a34a">
				1mg = 10⁻³g：比公克小1000倍
			</text>
		{/if}
	</svg>
</div>
