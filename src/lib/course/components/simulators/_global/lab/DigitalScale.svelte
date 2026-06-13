<!--
  共用元件：電子秤（全科實驗通用）
  Props:
    x, y     : 秤底部中心 SVG 座標
    reading  : 顯示的讀數字串（如 "0.6 kg"）
    scale    : 縮放（預設 1）
-->
<script lang="ts">
	let {
		x = 0,
		y = 0,
		reading = '0.0',
		scale = 1
	}: {
		x?: number;
		y?: number;
		reading?: string;
		scale?: number;
	} = $props();

	const W = 100,
		H = 20; // 秤盤尺寸
	const BODY_H = 30; // 秤身高度
	const SCREEN_W = 60,
		SCREEN_H = 18;
</script>

<g transform="translate({x}, {y}) scale({scale})">
	<!-- 秤身 -->
	<rect
		x={-W / 2}
		y={-BODY_H}
		width={W}
		height={BODY_H}
		rx="6"
		fill="#e2e8f0"
		stroke="#94a3b8"
		stroke-width="2"
	/>

	<!-- 螢幕 -->
	<rect
		x={-SCREEN_W / 2}
		y={-BODY_H + 6}
		width={SCREEN_W}
		height={SCREEN_H}
		rx="3"
		fill="#0f172a"
	/>
	<text
		x={0}
		y={-BODY_H + 6 + SCREEN_H / 2 + 4}
		text-anchor="middle"
		font-size="12"
		font-weight="bold"
		fill="#4ade80"
		font-family="monospace"
	>
		{reading}
	</text>

	<!-- 秤盤 -->
	<rect
		x={-W / 2 - 5}
		y={-BODY_H - H}
		width={W + 10}
		height={H}
		rx="3"
		fill="#cbd5e1"
		stroke="#94a3b8"
		stroke-width="1.5"
	/>

	<!-- 底座 -->
	<rect x={-W / 2 + 10} y={0} width={W - 20} height={6} rx="2" fill="#94a3b8" />
</g>
