<script lang="ts">
	import type { CourseState } from '$lib/course/courseState.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	// ── 狀態 ─────────────────────────────────────────────────
	let started = $state(false);
	let dropCount = $state(0);
	let dropVisible = $state(false);
	let dropCx = $state(0);
	let dropCy = $state(0);
	let done = $state(false);

	// ── 3D 立方體常數（Cabinet projection 30°） ──────────────
	// 前面 (front face)
	const FX = 70,
		FY = 190,
		FW = 110,
		FH = 100;
	const FB = FY + FH; // 前面底部 Y = 290
	// 深度向量 (depth vector at ~30°)
	const DX = 40,
		DY = 22;
	// 深度邊中點（用於尺寸標記）
	const depMidX = FX + FW + DX / 2; // = 135
	const depMidY = FY - DY / 2; // = 179
	// Top face:  FL(70,190) FR(180,190) BR(220,168) BL(110,168)
	// Right face: TF(180,190) BF(180,290) BB(220,268) BT(220,168)

	// 水滴落點：方盒頂面中心 X
	const DROP_CX = FX + FW / 2 + DX / 2; // ≈ 135
	const DROP_TIP = FY - DY - 18; // 滴管尖端 Y（頂面上方）
	const DROP_R = 6;

	// ── 水位計算 ─────────────────────────────────────────────
	// 前面水面 Y（從底部往上長）
	function wfy(): number {
		return FB - (dropCount / 20) * FH;
	}
	// 後面水面 Y（套用深度向量）
	function wby(): number {
		return wfy() - DY;
	}

	// ── 工具 ─────────────────────────────────────────────────
	function sleep(ms: number): Promise<void> {
		return new Promise((r) => setTimeout(r, ms));
	}

	function animateDrop(fromCx: number, fromCy: number, toCx: number, toCy: number): Promise<void> {
		return new Promise((resolve) => {
			dropCx = fromCx;
			dropCy = fromCy;
			dropVisible = true;
			const t0 = performance.now(),
				dur = 360;
			function tick(now: number) {
				const t = Math.min((now - t0) / dur, 1);
				const e = t * t; // easeIn
				dropCx = fromCx + (toCx - fromCx) * e;
				dropCy = fromCy + (toCy - fromCy) * e;
				if (t < 1) requestAnimationFrame(tick);
				else resolve();
			}
			requestAnimationFrame(tick);
		});
	}

	async function runSequence() {
		// 滴管尖端位置（approx center of top face opening）
		const tipCx = DROP_CX;
		const tipCy = DROP_TIP;
		for (let i = 0; i < 20; i++) {
			// 落在當前水面上方（頂面中心）
			const targetCx = DROP_CX;
			const targetCy = wfy() - DY / 2 - DROP_R;
			await animateDrop(tipCx, tipCy, targetCx, targetCy);
			dropVisible = false;
			dropCount++;
			await sleep(160);
		}
		done = true;
		await sleep(700);
		onCorrect();
	}

	async function handleClick() {
		if (started || done || courseState.isUnlocked(courseState.currentStage.id)) return;
		started = true;
		await runSequence();
	}
</script>

<div class="flex w-full flex-col items-center gap-2 p-4 select-none">
	<p class="text-center text-sm font-bold text-gray-600">
		{#if !started}
			點擊滴管，觀察 20 滴水能裝滿多少空間
		{:else if done}
			✓ 20 滴水 = 1 毫升 = 1 cm³
		{:else}
			{dropCount} / 20 滴
		{/if}
	</p>

	<svg
		width="100%"
		viewBox="0 0 300 340"
		preserveAspectRatio="xMidYMid meet"
		class="max-w-[260px]"
		role="img"
		aria-label="20滴水裝滿1cm³方盒模擬器"
	>
		<!-- ── 滴管（可點擊） ── -->
		<g
			onclick={handleClick}
			class="cursor-pointer"
			role="button"
			tabindex="0"
			aria-label="點擊開始滴水"
		>
			<!-- 橡皮球 -->
			<ellipse
				cx={DROP_CX}
				cy="48"
				rx="20"
				ry="18"
				fill={started ? '#94a3b8' : '#f97316'}
				class="transition-colors duration-300"
			/>
			<!-- 玻璃管 -->
			<rect
				x={DROP_CX - 7}
				y="64"
				width="14"
				height="58"
				fill="white"
				stroke="#94a3b8"
				stroke-width="1.5"
				rx="3"
			/>
			<!-- 管內液體 -->
			<rect x={DROP_CX - 5} y="66" width="10" height="54" fill="#bfdbfe" rx="2" />
			<!-- 尖端 -->
			<polygon
				points="{DROP_CX - 6},{122} {DROP_CX + 6},{122} {DROP_CX + 2},{148} {DROP_CX - 2},{148}"
				fill="#e2e8f0"
				stroke="#94a3b8"
				stroke-width="1.5"
			/>
			{#if !started}
				<text x={DROP_CX + 28} y="95" fill="#f97316" font-size="12" font-weight="bold">← 點擊</text>
			{/if}
		</g>

		<!-- ── 水滴動畫 ── -->
		{#if dropVisible}
			<ellipse
				cx={dropCx}
				cy={dropCy}
				rx={DROP_R}
				ry={DROP_R * 1.3}
				fill="#3b82f6"
				fill-opacity="0.85"
			/>
		{/if}

		<!-- ── 3D 立方體 ── -->
		<!-- 渲染順序：頂面背景 → 右面背景 → 水體 → 前面背景（透明） → 所有邊框 -->

		<!-- 頂面（Top face）背景 -->
		<polygon
			points="{FX},{FY} {FX + FW},{FY} {FX + FW + DX},{FY - DY} {FX + DX},{FY - DY}"
			fill="#dde6f0"
			stroke="none"
		/>
		<!-- 右面（Right face）背景 -->
		<polygon
			points="{FX + FW},{FY} {FX + FW},{FB} {FX + FW + DX},{FB - DY} {FX + FW + DX},{FY - DY}"
			fill="#c8d6e5"
			stroke="none"
		/>

		<!-- 水體（當有水時） -->
		{#if dropCount > 0}
			<!-- 水：前面 -->
			<polygon
				points="{FX},{wfy()} {FX + FW},{wfy()} {FX + FW},{FB} {FX},{FB}"
				fill="#3b82f6"
				fill-opacity="0.6"
			/>
			<!-- 水：右面（較深，陰影感） -->
			<polygon
				points="{FX + FW},{wfy()} {FX + FW + DX},{wby()} {FX + FW + DX},{FB - DY} {FX + FW},{FB}"
				fill="#2563eb"
				fill-opacity="0.45"
			/>
			<!-- 水：頂面（較亮，受光） -->
			<polygon
				points="{FX},{wfy()} {FX + FW},{wfy()} {FX + FW + DX},{wby()} {FX + DX},{wby()}"
				fill="#93c5fd"
				fill-opacity="0.75"
			/>
		{/if}

		<!-- 前面透明玻璃（淡色填充模擬玻璃反光，畫在水的上層） -->
		<rect x={FX} y={FY} width={FW} height={FH} fill="white" fill-opacity="0.08" stroke="none" />

		<!-- 邊框線（全部最後畫，壓在最上層） -->
		<!-- 前面外框 -->
		<rect x={FX} y={FY} width={FW} height={FH} fill="none" stroke="#6b8aaa" stroke-width="2" />
		<!-- 頂面外框 -->
		<polygon
			points="{FX},{FY} {FX + FW},{FY} {FX + FW + DX},{FY - DY} {FX + DX},{FY - DY}"
			fill="none"
			stroke="#6b8aaa"
			stroke-width="2"
		/>
		<!-- 右面外框 -->
		<polygon
			points="{FX + FW},{FY} {FX + FW},{FB} {FX + FW + DX},{FB - DY} {FX + FW + DX},{FY - DY}"
			fill="none"
			stroke="#6b8aaa"
			stroke-width="2"
		/>

		<!-- ── 尺寸標記 ── -->
		<!-- 寬度（前面底邊） -->
		<line x1={FX} y1={FB + 8} x2={FX + FW} y2={FB + 8} stroke="#94a3b8" stroke-width="1" />
		<line x1={FX} y1={FB + 4} x2={FX} y2={FB + 12} stroke="#94a3b8" stroke-width="1.5" />
		<line x1={FX + FW} y1={FB + 4} x2={FX + FW} y2={FB + 12} stroke="#94a3b8" stroke-width="1.5" />
		<text
			x={FX + FW / 2}
			y={FB + 22}
			text-anchor="middle"
			font-size="10"
			fill="#475569"
			font-weight="bold">1 cm</text
		>

		<!-- 高度（前面左邊） -->
		<line x1={FX - 10} y1={FY} x2={FX - 10} y2={FB} stroke="#94a3b8" stroke-width="1" />
		<line x1={FX - 6} y1={FY} x2={FX - 14} y2={FY} stroke="#94a3b8" stroke-width="1.5" />
		<line x1={FX - 6} y1={FB} x2={FX - 14} y2={FB} stroke="#94a3b8" stroke-width="1.5" />
		<text
			x={FX - 24}
			y={(FY + FB) / 2}
			text-anchor="middle"
			dominant-baseline="middle"
			font-size="10"
			fill="#475569"
			font-weight="bold"
			transform="rotate(-90, {FX - 24}, {(FY + FB) / 2})">1 cm</text
		>

		<!-- 深度（右上方斜邊：從 (FX+FW, FY) 到 (FX+FW+DX, FY-DY)） -->
		<!-- 平行偏移線（往右下偏 6px 畫一條輔助線） -->
		<line
			x1={FX + FW + 4}
			y1={FY + 5}
			x2={FX + FW + DX + 4}
			y2={FY - DY + 5}
			stroke="#94a3b8"
			stroke-width="1"
		/>
		<line
			x1={FX + FW}
			y1={FY + 1}
			x2={FX + FW + 6}
			y2={FY + 8}
			stroke="#94a3b8"
			stroke-width="1.5"
		/>
		<line
			x1={FX + FW + DX}
			y1={FY - DY + 1}
			x2={FX + FW + DX + 6}
			y2={FY - DY + 8}
			stroke="#94a3b8"
			stroke-width="1.5"
		/>
		<text
			x={depMidX + 10}
			y={depMidY + 14}
			text-anchor="middle"
			font-size="10"
			fill="#475569"
			font-weight="bold">1 cm</text
		>

		<!-- ── 計數器 ── -->
		{#if started && !done}
			<text x="285" y="25" text-anchor="end" font-size="17" font-weight="black" fill="#3b82f6"
				>{dropCount}<tspan font-size="11" fill="#64748b"> / 20</tspan></text
			>
		{/if}

		<!-- ── 完成標示 ── -->
		{#if done}
			<rect
				x={FX}
				y={FB + 28}
				width={FW + DX}
				height="34"
				rx="7"
				fill="#dcfce7"
				stroke="#4ade80"
				stroke-width="1.5"
			/>
			<text
				x={FX + (FW + DX) / 2}
				y={FB + 50}
				text-anchor="middle"
				font-size="13"
				font-weight="bold"
				fill="#16a34a">= 1 ml = 1 c.c. ✓</text
			>
		{/if}
	</svg>
</div>
