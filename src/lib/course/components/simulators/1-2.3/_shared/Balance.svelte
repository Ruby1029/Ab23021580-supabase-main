<!--
  共用元件：上皿天平（1-2.3 全單元核心）
  Props:
    cx, cy       : 天平底座中心 SVG 座標
    tiltAngle    : 傾斜角度（正=右盤重，負=左盤重，單位:deg）
    zeroOffset   : 歸零偏移量（deg，未歸零時的初始偏移，0=已歸零）
    highlightPart: 高亮部位 'needle'|'screw'|'leftPan'|'rightPan'|null
    showLabels   : 是否顯示部位文字標籤
    leftLabel    : 左盤標示文字（空=不顯示）
    rightLabel   : 右盤標示文字（空=不顯示）
-->
<script lang="ts">
	let {
		cx = 160,
		cy = 160,
		tiltAngle = 0,
		zeroOffset = 0,
		highlightPart = null,
		showLabels = false,
		leftLabel = '',
		rightLabel = ''
	}: {
		cx?: number;
		cy?: number;
		tiltAngle?: number;
		zeroOffset?: number;
		highlightPart?: 'needle' | 'screw' | 'leftPan' | 'rightPan' | null;
		showLabels?: boolean;
		leftLabel?: string;
		rightLabel?: string;
	} = $props();

	// 實際角度 = 傾斜 + 未歸零偏移
	const totalAngle = $derived(tiltAngle + zeroOffset);
	const rad = $derived((totalAngle * Math.PI) / 180);

	// 樑的半長
	const BEAM = 75;
	// 盤懸掛高度
	const HANG = 28;

	// 樑兩端座標（以 cx,cy 為支點）
	const leftEnd = $derived({
		x: cx - BEAM * Math.cos(rad),
		y: cy - BEAM * Math.sin(rad)
	});
	const rightEnd = $derived({
		x: cx + BEAM * Math.cos(rad),
		y: cy + BEAM * Math.sin(rad)
	});

	// 指針（從支點向上延伸60px，隨樑旋轉）
	const needleTip = $derived({
		x: cx + 60 * Math.sin(rad),
		y: cy - 60 * Math.cos(rad)
	});

	// 顏色
	const HL = '#f97316'; // highlight 橙色
	const BEAM_COLOR = '#64748b';
	const PAN_COLOR = '#cbd5e1';
</script>

<!-- 底座 -->
<rect x={cx - 35} y={cy + 40} width={70} height={10} rx="4" fill="#475569" />
<!-- 柱子 -->
<rect x={cx - 5} y={cy - 30} width={10} height={75} rx="3" fill="#64748b" />

<!-- 校準螺絲 -->
<circle
	cx={cx - 16}
	cy={cy + 28}
	r="7"
	fill={highlightPart === 'screw' ? HL : '#94a3b8'}
	stroke={highlightPart === 'screw' ? '#ea580c' : '#64748b'}
	stroke-width="2"
/>
<line
	x1={cx - 19}
	y1={cy + 28}
	x2={cx - 13}
	y2={cy + 28}
	stroke={highlightPart === 'screw' ? '#fff' : '#64748b'}
	stroke-width="1.5"
/>
<line
	x1={cx - 16}
	y1={cy + 25}
	x2={cx - 16}
	y2={cy + 31}
	stroke={highlightPart === 'screw' ? '#fff' : '#64748b'}
	stroke-width="1.5"
/>

<!-- 橫樑 -->
<line
	x1={leftEnd.x}
	y1={leftEnd.y}
	x2={rightEnd.x}
	y2={rightEnd.y}
	stroke={BEAM_COLOR}
	stroke-width="5"
	stroke-linecap="round"
/>

<!-- 指針 -->
<line
	x1={cx}
	y1={cy}
	x2={needleTip.x}
	y2={needleTip.y}
	stroke={highlightPart === 'needle' ? HL : '#334155'}
	stroke-width="3"
	stroke-linecap="round"
/>
<!-- 指針刻度背景 -->
<rect
	x={cx - 14}
	y={cy - 68}
	width={28}
	height={12}
	rx="3"
	fill="#f1f5f9"
	stroke="#e2e8f0"
	stroke-width="1"
/>
<line
	x1={cx}
	y1={cy - 68}
	x2={cx}
	y2={cy - 56}
	stroke="#94a3b8"
	stroke-width="1"
	stroke-dasharray="2 2"
/>

<!-- 懸線 + 盤 -->
<!-- 左盤 -->
<line
	x1={leftEnd.x}
	y1={leftEnd.y}
	x2={leftEnd.x}
	y2={leftEnd.y + HANG}
	stroke="#94a3b8"
	stroke-width="1.5"
/>
<ellipse
	cx={leftEnd.x}
	cy={leftEnd.y + HANG + 5}
	rx="28"
	ry="5"
	fill={highlightPart === 'leftPan' ? HL : PAN_COLOR}
	stroke={highlightPart === 'leftPan' ? '#ea580c' : '#94a3b8'}
	stroke-width={highlightPart === 'leftPan' ? 2 : 1.5}
/>

<!-- 右盤 -->
<line
	x1={rightEnd.x}
	y1={rightEnd.y}
	x2={rightEnd.x}
	y2={rightEnd.y + HANG}
	stroke="#94a3b8"
	stroke-width="1.5"
/>
<ellipse
	cx={rightEnd.x}
	cy={rightEnd.y + HANG + 5}
	rx="28"
	ry="5"
	fill={highlightPart === 'rightPan' ? HL : PAN_COLOR}
	stroke={highlightPart === 'rightPan' ? '#ea580c' : '#94a3b8'}
	stroke-width={highlightPart === 'rightPan' ? 2 : 1.5}
/>

<!-- 盤上標示文字 -->
{#if leftLabel}
	<text
		x={leftEnd.x}
		y={leftEnd.y + HANG + 5}
		text-anchor="middle"
		dominant-baseline="middle"
		font-size="11"
		font-weight="bold"
		fill="#1e293b"
	>
		{leftLabel}
	</text>
{/if}
{#if rightLabel}
	<text
		x={rightEnd.x}
		y={rightEnd.y + HANG + 5}
		text-anchor="middle"
		dominant-baseline="middle"
		font-size="11"
		font-weight="bold"
		fill="#1e293b"
	>
		{rightLabel}
	</text>
{/if}

<!-- 部位標籤（showLabels=true 時顯示） -->
{#if showLabels}
	<!-- 指針標籤 -->
	<rect
		x={needleTip.x + 6}
		y={needleTip.y - 10}
		width="36"
		height="18"
		rx="4"
		fill="#fef3c7"
		stroke="#fbbf24"
		stroke-width="1.5"
	/>
	<text
		x={needleTip.x + 24}
		y={needleTip.y + 3}
		text-anchor="middle"
		font-size="10"
		font-weight="bold"
		fill="#92400e">指針</text
	>

	<!-- 螺絲標籤 -->
	<rect
		x={cx - 60}
		y={cy + 22}
		width="40"
		height="18"
		rx="4"
		fill="#fef3c7"
		stroke="#fbbf24"
		stroke-width="1.5"
	/>
	<text x={cx - 40} y={cy + 34} text-anchor="middle" font-size="9" font-weight="bold" fill="#92400e"
		>校準螺絲</text
	>

	<!-- 左盤標籤 -->
	<rect
		x={leftEnd.x - 20}
		y={leftEnd.y + HANG + 14}
		width="40"
		height="18"
		rx="4"
		fill="#dbeafe"
		stroke="#93c5fd"
		stroke-width="1.5"
	/>
	<text
		x={leftEnd.x}
		y={leftEnd.y + HANG + 26}
		text-anchor="middle"
		font-size="10"
		font-weight="bold"
		fill="#1d4ed8">左盤</text
	>

	<!-- 右盤標籤 -->
	<rect
		x={rightEnd.x - 20}
		y={rightEnd.y + HANG + 14}
		width="40"
		height="18"
		rx="4"
		fill="#dbeafe"
		stroke="#93c5fd"
		stroke-width="1.5"
	/>
	<text
		x={rightEnd.x}
		y={rightEnd.y + HANG + 26}
		text-anchor="middle"
		font-size="10"
		font-weight="bold"
		fill="#1d4ed8">右盤</text
	>
{/if}
