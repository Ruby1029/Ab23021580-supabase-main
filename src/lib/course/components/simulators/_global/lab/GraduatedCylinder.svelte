<!--
  共用量筒元件（全科實驗通用）
  Props:
    x, y       : 量筒底部中心 SVG 座標
    height     : 量筒高度（SVG unit，預設 200）
    waterLevel : 水位 0~1（0=空, 1=滿，預設 0.6）
    showTicks  : 是否顯示刻度（預設 true）
    tickCount  : 刻度數量（預設 10）
    highlightY : 高亮某個 Y 座標（如平視線，可選）
-->
<script lang="ts">
	let {
		x = 0,
		y = 0,
		height = 200,
		waterLevel = 0.6,
		showTicks = true,
		tickCount = 10,
		highlightY = -1
	}: {
		x?: number;
		y?: number;
		height?: number;
		waterLevel?: number;
		showTicks?: boolean;
		tickCount?: number;
		highlightY?: number;
	} = $props();

	// 量筒幾何
	const CW = 44; // 筒身寬
	const HALF = CW / 2;
	const BASE = 14; // 底座額外高
	const BASEW = CW + 16; // 底座寬

	// 座標計算（y 是底部中心）
	const topY = y - height;
	const waterH = waterLevel * (height - BASE);
	const waterY = y - BASE - waterH;

	// 彎月面（meniscus）曲線控制點
	const menL = x - HALF + 3;
	const menR = x + HALF - 3;
	const menDip = 4; // 凹陷深度
</script>

<g>
	<!-- 底座 -->
	<rect
		x={x - BASEW / 2}
		y={y - BASE}
		width={BASEW}
		height={BASE}
		fill="#e2e8f0"
		stroke="#94a3b8"
		stroke-width="2"
		rx="2"
	/>

	<!-- 筒身背景 -->
	<rect x={x - HALF} y={topY} width={CW} height={height - BASE} fill="#f8fafc" stroke="none" />

	<!-- 水體 -->
	{#if waterLevel > 0}
		<rect
			x={x - HALF + 2}
			y={waterY}
			width={CW - 4}
			height={waterH}
			fill="#3b82f6"
			fill-opacity="0.4"
		/>
		<!-- 彎月面（凹液面） -->
		<path
			d="M {menL},{waterY} Q {x},{waterY + menDip} {menR},{waterY}"
			fill="none"
			stroke="#2563eb"
			stroke-width="1.5"
		/>
	{/if}

	<!-- 刻度線 -->
	{#if showTicks}
		{#each Array(tickCount + 1) as tickMarker, i (`${tickMarker}-${i}`)}
			{@const tickY = y - BASE - (i / tickCount) * (height - BASE)}
			{@const isMajor = i % 5 === 0}
			<line
				x1={x + HALF - (isMajor ? 10 : 6)}
				y1={tickY}
				x2={x + HALF}
				y2={tickY}
				stroke="#94a3b8"
				stroke-width={isMajor ? 1.5 : 0.8}
			/>
			{#if isMajor && i > 0}
				<text x={x + HALF + 5} y={tickY + 3} font-size="8" fill="#94a3b8">{i * 10}</text>
			{/if}
		{/each}
	{/if}

	<!-- 筒身外框 -->
	<rect
		x={x - HALF}
		y={topY}
		width={CW}
		height={height - BASE}
		fill="none"
		stroke="#94a3b8"
		stroke-width="2"
		rx="1"
	/>

	<!-- 筒口（略微外擴） -->
	<line
		x1={x - HALF - 3}
		y1={topY}
		x2={x - HALF + 2}
		y2={topY}
		stroke="#94a3b8"
		stroke-width="2.5"
	/>
	<line
		x1={x + HALF - 2}
		y1={topY}
		x2={x + HALF + 3}
		y2={topY}
		stroke="#94a3b8"
		stroke-width="2.5"
	/>

	<!-- 高亮線（平視法用） -->
	{#if highlightY >= 0}
		<line
			x1={x - HALF - 15}
			y1={highlightY}
			x2={x + HALF + 15}
			y2={highlightY}
			stroke="#ef4444"
			stroke-width="1.5"
			stroke-dasharray="4 2"
		/>
	{/if}
</g>
