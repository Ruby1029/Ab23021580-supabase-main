<!--
  共用水瓶元件（Cabinet Projection 3D）
  Props:
    x, y     : 瓶身左上角 SVG 座標
    scale    : 縮放倍率（預設 1）
    fillRatio: 水位 0~1（0=空, 1=滿）
    label    : 瓶身下方標籤文字（可選）
    sublabel : 標籤第二行（可選）
-->
<script lang="ts">
	let {
		x = 0,
		y = 0,
		scale = 1,
		fillRatio = 0,
		label = '',
		sublabel = ''
	}: {
		x?: number;
		y?: number;
		scale?: number;
		fillRatio?: number;
		label?: string;
		sublabel?: string;
	} = $props();

	// 基準尺寸（scale=1 時）
	const BW = 52,
		BH = 130,
		DX = 26,
		DY = 14;
	const fillH = $derived(fillRatio * BH);
</script>

<g transform="translate({x}, {y}) scale({scale})">
	<!-- 瓶蓋 -->
	<rect
		x={8}
		y={-26}
		width={BW - 16}
		height="14"
		rx="5"
		fill="#1d4ed8"
		stroke="#1e40af"
		stroke-width="1.5"
	/>
	<!-- 瓶頸 -->
	<rect
		x={10}
		y={-13}
		width={BW - 20}
		height="14"
		rx="3"
		fill="#dbeafe"
		stroke="#93c5fd"
		stroke-width="1.5"
	/>

	<!-- 瓶身：頂面 -->
	<polygon points="0,0 {BW},0 {BW + DX},{-DY} {DX},{-DY}" fill="#dde6f0" stroke="none" />
	<!-- 瓶身：右面 -->
	<polygon
		points="{BW},0 {BW},{BH} {BW + DX},{BH - DY} {BW + DX},{-DY}"
		fill="#c8d6e5"
		stroke="none"
	/>

	<!-- 水體前面 -->
	{#if fillH > 0}
		<rect x={1} y={BH - fillH} width={BW - 2} height={fillH} fill="#3b82f6" fill-opacity="0.5" />
		<!-- 水體右面 -->
		<polygon
			points="{BW},{BH - fillH} {BW + DX},{BH - fillH - DY} {BW + DX},{BH - DY} {BW},{BH}"
			fill="#2563eb"
			fill-opacity="0.35"
		/>
	{/if}

	<!-- 玻璃反光 -->
	<rect x={0} y={0} width={BW} height={BH} rx="4" fill="white" fill-opacity="0.08" stroke="none" />

	<!-- 邊框 -->
	<polygon
		points="0,0 {BW},0 {BW + DX},{-DY} {DX},{-DY}"
		fill="none"
		stroke="#6b8aaa"
		stroke-width="1.5"
	/>
	<polygon
		points="{BW},0 {BW},{BH} {BW + DX},{BH - DY} {BW + DX},{-DY}"
		fill="none"
		stroke="#6b8aaa"
		stroke-width="1.5"
	/>
	<rect x={0} y={0} width={BW} height={BH} rx="4" fill="none" stroke="#6b8aaa" stroke-width="2" />

	<!-- 標籤 -->
	{#if label}
		<text x={BW / 2} y={BH + 16} text-anchor="middle" font-size="10" fill="#64748b">{label}</text>
	{/if}
	{#if sublabel}
		<text
			x={BW / 2}
			y={BH + 29}
			text-anchor="middle"
			font-size="11"
			fill="#3b82f6"
			font-weight="bold">{sublabel}</text
		>
	{/if}
</g>
