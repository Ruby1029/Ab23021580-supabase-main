<script lang="ts">
	/**
	 * 1-2.2 A1：4°C的水，1ml = 1公克
	 * 教學核心：公克的定義來自水的物理性質（4°C時密度=1g/ml）
	 * 設計：左半-溫度計顯示4°C，右半-1ml水+電子秤，箭頭連結「因果」
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

	let step = $state(0); // 0=初始 1=溫度計亮起 2=水上秤+讀數 3=完成

	async function handleClick() {
		if (step >= 3 || courseState.isUnlocked(courseState.currentStage.id)) return;
		if (step === 0) {
			step = 1;
			await sleep(1200);
			step = 2;
			await sleep(1500);
			step = 3;
			await sleep(500);
			onCorrect();
		}
	}

	// 溫度計刻度動畫（step>=1時逐漸升到4°C位置）
	const THERM_BOTTOM = 185;
	const THERM_TOP = 60;
	const TEMP_4C_Y = THERM_BOTTOM - (4 / 40) * (THERM_BOTTOM - THERM_TOP); // 線性映射 0~40°C
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if step === 0}點擊觀察
		{:else if step === 1}水溫：4°C
		{:else if step === 2}1ml 的水，放上電子秤…
		{:else}4°C 的水：密度＝1g/ml，定義了「公克」
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 370 260"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[390px] cursor-pointer"
		onclick={handleClick}
		role="img"
		aria-label="4°C水定義公克"
	>
		<!-- ── 左半：溫度計 ── -->
		<rect x="0" y="0" width="175" height="260" rx="8" fill="#f0f9ff" />
		<text x="87" y="22" text-anchor="middle" font-size="12" font-weight="bold" fill="#0369a1"
			>水溫</text
		>

		<!-- 溫度計外框 -->
		<rect
			x="80"
			y="55"
			width="14"
			height="130"
			rx="7"
			fill="white"
			stroke="#94a3b8"
			stroke-width="2"
		/>
		<!-- 球泡 -->
		<circle cx="87" cy="192" r="12" fill="white" stroke="#94a3b8" stroke-width="2" />

		<!-- 液柱（step>=1時從底部升到4°C位置）-->
		{#if step >= 1}
			<rect
				x="83.5"
				y={TEMP_4C_Y}
				width="7"
				height={THERM_BOTTOM - TEMP_4C_Y}
				rx="3.5"
				fill="#3b82f6"
			/>
			<circle cx="87" cy="192" r="10" fill="#3b82f6" />
		{:else}
			<circle cx="87" cy="192" r="10" fill="#94a3b8" />
		{/if}

		<!-- 刻度線 -->
		{#each [0, 10, 20, 30, 40] as t (t)}
			{@const ty = THERM_BOTTOM - (t / 40) * (THERM_BOTTOM - THERM_TOP)}
			<line x1="94" y1={ty} x2="100" y2={ty} stroke="#cbd5e1" stroke-width="1.5" />
			<text x="103" y={ty + 4} font-size="9" fill="#94a3b8">{t}</text>
		{/each}

		<!-- 4°C 刻度高亮 -->
		<line
			x1="80"
			y1={TEMP_4C_Y}
			x2="94"
			y2={TEMP_4C_Y}
			stroke={step >= 1 ? '#ef4444' : '#e2e8f0'}
			stroke-width="2"
		/>
		<text
			x="78"
			y={TEMP_4C_Y + 4}
			text-anchor="end"
			font-size="11"
			font-weight="bold"
			fill={step >= 1 ? '#ef4444' : '#cbd5e1'}>4°C</text
		>

		<!-- ── 分界線 ── -->
		<line
			x1="175"
			y1="0"
			x2="175"
			y2="260"
			stroke="#94a3b8"
			stroke-width="1.5"
			stroke-dasharray="5 4"
		/>

		<!-- 因果箭頭（step>=2） -->
		{#if step >= 2}
			<defs>
				<marker
					id="arr122a1"
					viewBox="0 0 10 10"
					refX="9"
					refY="5"
					markerWidth="6"
					markerHeight="6"
					orient="auto"
				>
					<path d="M0,0 L10,5 L0,10 z" fill="#0284c7" />
				</marker>
			</defs>
			<line
				x1="155"
				y1="130"
				x2="196"
				y2="130"
				stroke="#0284c7"
				stroke-width="2"
				stroke-dasharray="4 3"
				marker-end="url(#arr122a1)"
			/>
			<text x="175" y="123" text-anchor="middle" font-size="9" fill="#0284c7">∴</text>
		{/if}

		<!-- ── 右半：1ml水 + 電子秤 ── -->
		<rect x="175" y="0" width="195" height="260" rx="8" fill="#f8fafc" />

		<!-- 量筒（精密感） -->
		<rect
			x="248"
			y="65"
			width="28"
			height="80"
			rx="4"
			fill="#bae6fd"
			fill-opacity={step >= 2 ? 0.6 : 0.3}
			stroke="#38bdf8"
			stroke-width="2"
		/>
		<!-- 量筒刻度 -->
		{#each [0, 1] as mark, i (`${mark}-${i}`)}
			<line
				x1="254"
				y1={140 - i * 40}
				x2="260"
				y2={140 - i * 40}
				stroke="#0284c7"
				stroke-width="1"
				opacity="0.6"
			/>
			<text x="246" y={144 - i * 40} text-anchor="end" font-size="8" fill="#0369a1">
				{i === 0 ? '0' : '1ml'}
			</text>
		{/each}
		<!-- 水位線（1ml） -->
		{#if step >= 1}
			<rect x="250" y="100" width="24" height="40" rx="2" fill="#38bdf8" fill-opacity="0.7" />
		{/if}

		<!-- 電子秤（共用元件） -->
		<DigitalScale x={262} y={218} reading={step >= 2 ? '1 g' : '---'} />

		<!-- 結論標注 -->
		{#if step >= 3}
			<rect
				x="10"
				y="228"
				width="350"
				height="26"
				rx="6"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="185" y="245" text-anchor="middle" font-size="12" font-weight="bold" fill="#16a34a">
				密度=1g/ml → 1ml水=1公克=1g
			</text>
		{/if}
	</svg>
</div>
