<script lang="ts">
	import { onMount } from 'svelte';
	import type { CourseState } from '$lib/course/courseState.svelte';

	let {
		courseState,
		onCorrect
	}: {
		courseState: CourseState;
		onCorrect: () => void;
	} = $props();

	// ── 響應式狀態 ────────────────────────────────────────────
	let isDropped = $state(false);
	let stoneY = $state(80);
	let baseWaterY = $state(250); // 波浪基準線（越小越高）
	let wavePath = $state(''); // 每幀重建的 SVG path d

	// ── 石頭動畫常數 ─────────────────────────────────────────
	const STONE_START = 80;
	const STONE_HIT = 235; // 石頭底端（+15）碰到水面
	const STONE_END = 290;
	const WATER_START = 250;
	const WATER_END = 200;
	const PHASE1_MS = 700;
	const PHASE2_MS = 700;

	// ── 波浪：三層正弦疊加，模擬自然水面 ─────────────────────
	// 容器寬 92 SVG unit，振幅約 4~6 unit 視覺上已很明顯
	const WAVES = [
		{ amp: 5, freq: 0.07, spd: 0.9, ph: 0.0 },
		{ amp: 3, freq: 0.16, spd: 1.6, ph: 2.1 },
		{ amp: 1.8, freq: 0.29, spd: 2.4, ph: 0.7 }
	];

	// ── 漣漪：石頭入水時從落點向外擴散衰減 ──────────────────
	const RIPPLE_X = 300; // 石頭 X 座標
	let rippleT0 = 0; // 漣漪開始時間 (ms)
	let rippleOn = false;
	let waveStarted = false; // 投石前水面保持水平

	function rippleY(x: number, nowMs: number): number {
		if (!rippleOn) return 0;
		const rt = (nowMs - rippleT0) / 1000;
		if (rt > 2.5) {
			rippleOn = false;
			return 0;
		}
		const dx = x - RIPPLE_X;
		const decay = Math.exp(-rt * 1.6);
		const spread = 10 + rt * 80;
		return 16 * decay * Math.exp(-(dx * dx) / (spread * spread)) * Math.sin(0.5 * dx - 12 * rt);
	}

	// ── SVG path 產生器 ──────────────────────────────────────
	const XL = 254,
		XR = 346; // 玻璃杯內壁 X 範圍

	function buildPath(tSec: number, baseY: number, nowMs: number): string {
		let d = '';
		for (let x = XL; x <= XR; x += 2) {
			let y = baseY;
			if (waveStarted) {
				for (const w of WAVES) {
					y += w.amp * Math.sin(w.freq * x + w.spd * tSec + w.ph);
				}
				y += rippleY(x, nowMs);
			}
			d += `${x === XL ? 'M' : 'L'}${x},${y.toFixed(1)} `;
		}
		// 填滿水體：沿右壁往下 → 底部 → 左壁
		d += `L${XR},350 L${XL},350 Z`;
		return d;
	}

	// ── 主動畫迴圈（onMount 啟動，元件銷毀時清除）────────────
	let dropT0 = 0;
	let dropDone = false;

	onMount(() => {
		let rafId: number;
		const origin = performance.now();

		function loop(now: number) {
			const tSec = (now - origin) / 1000;

			// 石頭 / 水位更新
			if (isDropped && !dropDone) {
				const e = now - dropT0;
				if (e < PHASE1_MS) {
					// Phase 1：落體，水位不動
					stoneY = STONE_START + (STONE_HIT - STONE_START) * (e / PHASE1_MS) ** 2;
					baseWaterY = WATER_START;
				} else if (e < PHASE1_MS + PHASE2_MS) {
					// Phase 2：入水，漣漪 + 波浪啟動，水位同步上升
					if (!rippleOn) {
						rippleOn = true;
						rippleT0 = now;
						waveStarted = true;
					}
					const t2 = (e - PHASE1_MS) / PHASE2_MS;
					stoneY = STONE_HIT + (STONE_END - STONE_HIT) * t2;
					baseWaterY = WATER_START - (WATER_START - WATER_END) * t2;
				} else {
					stoneY = STONE_END;
					baseWaterY = WATER_END;
					dropDone = true;
					setTimeout(() => onCorrect(), 800);
				}
			}

			wavePath = buildPath(tSec, baseWaterY, now);
			rafId = requestAnimationFrame(loop);
		}

		rafId = requestAnimationFrame(loop);
		return () => cancelAnimationFrame(rafId);
	});

	function handleDrop() {
		if (courseState.isUnlocked(courseState.currentStage.id)) return;
		if (isDropped) return;
		isDropped = true;
		dropT0 = performance.now();
	}
</script>

<div
	class="flex flex-col items-center gap-4 overflow-hidden rounded-xl border border-gray-100 bg-white p-6 shadow-sm"
>
	<p class="text-center font-bold text-gray-600">點擊烏鴉讓牠鬆口投石，觀察水面的變化！</p>

	<div class="h-[350px] w-full max-w-[500px]">
		<svg
			width="100%"
			height="100%"
			viewBox="0 0 600 400"
			preserveAspectRatio="xMidYMid meet"
			class="cursor-pointer select-none"
			role="img"
			aria-label="烏鴉投石排水法示意圖"
			onclick={handleDrop}
		>
			<defs>
				<marker
					id="arrow"
					viewBox="0 0 10 10"
					refX="5"
					refY="5"
					markerWidth="6"
					markerHeight="6"
					orient="auto-start-reverse"
				>
					<path d="M 0 0 L 10 5 L 0 10 z" fill="#ef4444" />
				</marker>
				<clipPath id="glassClip">
					<rect x="254" y="0" width="92" height="400" />
				</clipPath>
			</defs>

			<!-- 實驗桌 -->
			<line
				x1="100"
				y1="350"
				x2="500"
				y2="350"
				stroke="#94a3b8"
				stroke-width="4"
				stroke-linecap="round"
			/>

			<!-- 水體（波浪 path，clipPath 限制在玻璃內） -->
			<g clip-path="url(#glassClip)">
				<path d={wavePath} fill="#3b82f6" fill-opacity="0.65" />
			</g>

			<!-- 玻璃杯（後畫蓋在水上，形成杯壁遮擋效果） -->
			<path
				d="M 250 150 L 250 350 L 350 350 L 350 150"
				fill="none"
				stroke="#cbd5e1"
				stroke-width="8"
				stroke-linejoin="round"
			/>

			<!-- 石頭 -->
			<g transform="translate(300, {stoneY})">
				<path
					d="M -15 -10 L 10 -15 L 20 5 L 5 15 L -10 10 Z"
					fill="#64748b"
					stroke="#475569"
					stroke-width="2"
				/>
			</g>

			<!-- 烏鴉 -->
			<g transform="translate(200, 100)">
				<ellipse cx="0" cy="0" rx="30" ry="20" fill="#1e293b" transform="rotate(-15)" />
				<circle cx="25" cy="-15" r="15" fill="#1e293b" />
				<circle cx="30" cy="-18" r="3" fill="white" />
				<circle cx="31" cy="-18" r="1.5" fill="black" />
				<path d="M 38 -15 L 60 -10 L 38 -5 Z" fill="#f59e0b" />
				<line x1="-10" y1="15" x2="-15" y2="30" stroke="#f59e0b" stroke-width="3" />
				<line x1="5" y1="18" x2="5" y2="35" stroke="#f59e0b" stroke-width="3" />
				<path d="M -10 -5 Q 10 10 -20 15 Z" fill="#0f172a" />
			</g>

			<!-- 輔助標示（水位確實上升後才顯示） -->
			{#if isDropped && baseWaterY < 245}
				<g class="fade-in" style="animation-delay:0.3s; animation-fill-mode:both;">
					<line
						x1="220"
						y1="250"
						x2="380"
						y2="250"
						stroke="#ef4444"
						stroke-width="2"
						stroke-dasharray="4 2"
					/>
					<line
						x1="370"
						y1="240"
						x2="370"
						y2={baseWaterY + 12}
						stroke="#ef4444"
						stroke-width="2"
						marker-end="url(#arrow)"
					/>
					<text x="380" y="230" fill="#ef4444" font-size="14" font-weight="bold">水面上升</text>
					<text x="380" y="250" fill="#ef4444" font-size="12">佔據空間</text>
				</g>
			{/if}
		</svg>
	</div>
</div>

<style>
	@keyframes fadeIn {
		from {
			opacity: 0;
		}
		to {
			opacity: 1;
		}
	}
	.fade-in {
		animation: fadeIn 0.5s ease-in-out;
		opacity: 0;
	}
</style>
