<script lang="ts">
	/**
	 * 1-2.3 A：測量質量的工具辨識
	 * 三種工具以黑色剪影顯示，逐一點擊揭曉真實外觀
	 * 教學核心：認識天平、電子秤作為質量測量工具
	 */
	import type { CourseState } from '$lib/course/courseState.svelte';

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

	const TOOLS = $state([
		{ id: 'balance_top', label: '上皿天平', revealed: false },
		{ id: 'balance_arm', label: '等臂天平', revealed: false },
		{ id: 'digital', label: '電子秤', revealed: false }
	]);

	let done = $state(false);

	async function reveal(idx: number) {
		if (done || courseState.isUnlocked(courseState.currentStage.id)) return;
		TOOLS[idx].revealed = true;
		if (TOOLS.every((t) => t.revealed)) {
			done = true;
			await sleep(600);
			onCorrect();
		}
	}
</script>

<div class="flex w-full flex-col items-center gap-1 p-3 select-none">
	<p class="h-5 text-center text-sm font-bold text-gray-600">
		{#if !done}點擊黑色輪廓，辨識測量質量的工具{:else}上皿天平、等臂天平、電子秤都可測量質量{/if}
	</p>

	<svg width="100%" viewBox="0 0 360 230" preserveAspectRatio="xMidYMid meet" class="max-w-[380px]">
		<!-- 上皿天平（左） -->
		<g onclick={() => reveal(0)} style="cursor:pointer">
			<!-- 剪影/揭曉 -->
			{#if !TOOLS[0].revealed}
				<rect x="15" y="30" width="100" height="140" rx="8" fill="#1e293b" />
				<text x="65" y="108" text-anchor="middle" font-size="11" fill="#94a3b8">？</text>
			{:else}
				<!-- 上皿天平 SVG -->
				<rect x="30" y="155" width="70" height="8" rx="3" fill="#475569" />
				<rect x="60" y="90" width="8" height="68" rx="2" fill="#64748b" />
				<line
					x1="25"
					y1="90"
					x2="110"
					y2="90"
					stroke="#64748b"
					stroke-width="5"
					stroke-linecap="round"
				/>
				<ellipse cx="35" cy="98" rx="22" ry="4" fill="#94a3b8" />
				<ellipse cx="100" cy="98" rx="22" ry="4" fill="#94a3b8" />
				<line x1="35" y1="90" x2="35" y2="96" stroke="#94a3b8" stroke-width="1.5" />
				<line x1="100" y1="90" x2="100" y2="96" stroke="#94a3b8" stroke-width="1.5" />
				<!-- 砝碼暗示 -->
				<circle cx="100" cy="88" r="6" fill="#fbbf24" stroke="#d97706" stroke-width="1.5" />
			{/if}
			<rect
				x="15"
				y="30"
				width="100"
				height="140"
				rx="8"
				fill="none"
				stroke={TOOLS[0].revealed ? '#4ade80' : '#475569'}
				stroke-width="2"
			/>
			<text
				x="65"
				y="185"
				text-anchor="middle"
				font-size="11"
				font-weight="bold"
				fill={TOOLS[0].revealed ? '#16a34a' : '#94a3b8'}>{TOOLS[0].label}</text
			>
		</g>

		<!-- 等臂天平（中） -->
		<g onclick={() => reveal(1)} style="cursor:pointer">
			{#if !TOOLS[1].revealed}
				<rect x="130" y="30" width="100" height="140" rx="8" fill="#1e293b" />
				<text x="180" y="108" text-anchor="middle" font-size="11" fill="#94a3b8">？</text>
			{:else}
				<!-- 等臂天平（兩盤懸掛更低，更對稱） -->
				<line
					x1="145"
					y1="95"
					x2="215"
					y2="95"
					stroke="#64748b"
					stroke-width="5"
					stroke-linecap="round"
				/>
				<rect x="176" y="95" width="8" height="55" rx="2" fill="#64748b" />
				<rect x="145" y="145" width="70" height="8" rx="3" fill="#475569" />
				<line x1="152" y1="95" x2="152" y2="125" stroke="#94a3b8" stroke-width="1.5" />
				<line x1="208" y1="95" x2="208" y2="125" stroke="#94a3b8" stroke-width="1.5" />
				<ellipse cx="152" cy="130" rx="22" ry="5" fill="#94a3b8" />
				<ellipse cx="208" cy="130" rx="22" ry="5" fill="#94a3b8" />
			{/if}
			<rect
				x="130"
				y="30"
				width="100"
				height="140"
				rx="8"
				fill="none"
				stroke={TOOLS[1].revealed ? '#4ade80' : '#475569'}
				stroke-width="2"
			/>
			<text
				x="180"
				y="185"
				text-anchor="middle"
				font-size="11"
				font-weight="bold"
				fill={TOOLS[1].revealed ? '#16a34a' : '#94a3b8'}>{TOOLS[1].label}</text
			>
		</g>

		<!-- 電子秤（右） -->
		<g onclick={() => reveal(2)} style="cursor:pointer">
			{#if !TOOLS[2].revealed}
				<rect x="245" y="30" width="100" height="140" rx="8" fill="#1e293b" />
				<text x="295" y="108" text-anchor="middle" font-size="11" fill="#94a3b8">？</text>
			{:else}
				<rect
					x="260"
					y="135"
					width="70"
					height="28"
					rx="5"
					fill="#334155"
					stroke="#475569"
					stroke-width="1.5"
				/>
				<rect x="264" y="115" width="62" height="22" rx="3" fill="#0f172a" />
				<text
					x="295"
					y="130"
					text-anchor="middle"
					font-size="12"
					font-family="monospace"
					fill="#4ade80">0.0 g</text
				>
				<rect x="255" y="105" width="80" height="12" rx="3" fill="#94a3b8" />
				<rect x="270" y="160" width="50" height="6" rx="2" fill="#64748b" />
			{/if}
			<rect
				x="245"
				y="30"
				width="100"
				height="140"
				rx="8"
				fill="none"
				stroke={TOOLS[2].revealed ? '#4ade80' : '#475569'}
				stroke-width="2"
			/>
			<text
				x="295"
				y="185"
				text-anchor="middle"
				font-size="11"
				font-weight="bold"
				fill={TOOLS[2].revealed ? '#16a34a' : '#94a3b8'}>{TOOLS[2].label}</text
			>
		</g>

		{#if done}
			<rect
				x="30"
				y="200"
				width="300"
				height="22"
				rx="5"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text x="180" y="215" text-anchor="middle" font-size="11" font-weight="bold" fill="#16a34a">
				天平與電子秤：測量質量的工具
			</text>
		{/if}
	</svg>
</div>
