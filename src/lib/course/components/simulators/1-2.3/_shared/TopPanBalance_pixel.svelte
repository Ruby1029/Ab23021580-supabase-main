<script lang="ts">
	/**
	 * 擬真上皿天平 (Realistic Top-Pan Balance)
	 * 使用羅伯瓦爾機構 (Roberval Mechanism) 原理，確保托盤始終保持水平
	 */
	let {
		cx = 185,
		cy = 160,
		tiltAngle = 0,
		zeroOffset = 0,
		highlightPart = null,
		showLabels = false
	}: {
		cx?: number;
		cy?: number;
		tiltAngle?: number;
		zeroOffset?: number;
		highlightPart?: 'needle' | 'screw' | 'leftPan' | 'rightPan' | null;
		showLabels?: boolean;
	} = $props();

	// 實際角度 = 傾斜 + 未歸零偏移
	const totalAngle = $derived(tiltAngle + zeroOffset);
	const rad = $derived((totalAngle * Math.PI) / 180);

	// 天平尺寸
	const BEAM_LENGTH = 110; // 單側臂長
	const BEAM_THICKNESS = 12;
	const PAN_SUPPORT_HEIGHT = 15; // 托盤支架高度 (從橫樑到托盤)
	const PAN_WIDTH = 75;

	// 復古像素/色塊風格配色 (16-bit Retro Style)
	const METAL_LIGHT = '#e2e8f0';
	const METAL_BASE = '#94a3b8';
	const METAL_DARK = '#475569';
	const METAL_OUTLINE = '#1e293b';

	const GREEN_LIGHT = '#6b9c7b';
	const GREEN_BASE = '#4a7c59';
	const GREEN_DARK = '#2f523a';
	const GREEN_OUTLINE = '#142b1c';

	const PAN_LIGHT = '#ffffff';
	const PAN_BASE = '#e2e8f0';
	const PAN_DARK = '#94a3b8';

	const HIGHLIGHT = '#f97316';
	const HIGHLIGHT_OUTLINE = '#7c2d12';

	// ── 運動學計算 ──
	// 中央支點 (Pivot)
	const pivotX = cx;
	const pivotY = cy;

	// 主橫樑兩端座標 (Beam Ends)
	const leftBeam = $derived({
		x: pivotX - BEAM_LENGTH * Math.cos(rad),
		y: pivotY - BEAM_LENGTH * Math.sin(rad)
	});
	const rightBeam = $derived({
		x: pivotX + BEAM_LENGTH * Math.cos(rad),
		y: pivotY + BEAM_LENGTH * Math.sin(rad)
	});

	// 托盤中心點 (Pan Centers)
	const leftPanCenter = $derived({ x: leftBeam.x, y: leftBeam.y - PAN_SUPPORT_HEIGHT });
	const rightPanCenter = $derived({ x: rightBeam.x, y: rightBeam.y - PAN_SUPPORT_HEIGHT });

	// 指針 (Needle) - 朝上
	const needleLength = 80;
	const needleTip = $derived({
		x: pivotX + needleLength * Math.sin(rad),
		y: pivotY - needleLength * Math.cos(rad)
	});
</script>

<!-- 底座 (Base) -->
<g>
	<!-- 梯形綠色底座 (色塊風格) -->
	<!-- 主體暗面 -->
	<path
		d="M {cx - 85} {cy + 30} L {cx + 85} {cy + 30} L {cx + 105} {cy + 95} L {cx - 105} {cy + 95} Z"
		fill={GREEN_DARK}
		stroke={GREEN_OUTLINE}
		stroke-width="3"
		stroke-linejoin="round"
	/>
	<!-- 主體亮面 (左上受光) -->
	<path
		d="M {cx - 85} {cy + 30} L {cx + 60} {cy + 30} L {cx + 80} {cy + 90} L {cx - 100} {cy + 90} Z"
		fill={GREEN_BASE}
		stroke="none"
	/>
	<!-- 頂部高光面 -->
	<ellipse
		{cx}
		cy={cy + 30}
		rx="85"
		ry="6"
		fill={GREEN_LIGHT}
		stroke={GREEN_OUTLINE}
		stroke-width="3"
	/>
</g>

<!-- 金屬銘版 (Silver Label Plate) -->
<g>
	<rect
		x={cx - 35}
		y={cy + 55}
		width="70"
		height="25"
		fill={METAL_DARK}
		stroke={METAL_OUTLINE}
		stroke-width="2"
	/>
	<rect x={cx - 35} y={cy + 55} width="65" height="20" fill={METAL_LIGHT} stroke="none" />
	<text
		x={cx}
		y={cy + 64}
		text-anchor="middle"
		font-size="6"
		fill={METAL_OUTLINE}
		font-family="monospace"
		font-weight="bold">100g / 100mg</text
	>
	<text
		x={cx}
		y={cy + 74}
		text-anchor="middle"
		font-size="7"
		fill={METAL_OUTLINE}
		font-weight="bold"
		font-family="sans-serif">MARUMO</text
	>
	<!-- 四顆鉚釘 -->
	<rect x={cx - 32} y={cy + 58} width="3" height="3" fill={METAL_OUTLINE} />
	<rect x={cx + 29} y={cy + 58} width="3" height="3" fill={METAL_OUTLINE} />
	<rect x={cx - 32} y={cy + 73} width="3" height="3" fill={METAL_OUTLINE} />
	<rect x={cx + 29} y={cy + 73} width="3" height="3" fill={METAL_OUTLINE} />
</g>

<!-- 中央立柱與刻度板 (Central Pillar & Scale) -->
<g>
	<!-- 立柱基座 -->
	<path
		d="M {cx - 12} {cy + 30} L {cx + 12} {cy + 30} L {cx + 8} {cy - 10} L {cx - 8} {cy - 10} Z"
		fill={METAL_BASE}
		stroke={METAL_OUTLINE}
		stroke-width="3"
	/>
	<path
		d="M {cx - 12} {cy + 30} L {cx} {cy + 30} L {cx} {cy - 10} L {cx - 8} {cy - 10} Z"
		fill={METAL_LIGHT}
		stroke="none"
	/>

	<!-- 立柱塔 (A字型) -->
	<path
		d="M {cx - 8} {cy - 10} L {cx + 8} {cy - 10} L {cx + 15} {cy - 70} L {cx - 15} {cy - 70} Z"
		fill={METAL_BASE}
		stroke={METAL_OUTLINE}
		stroke-width="3"
		stroke-linejoin="round"
	/>
	<path
		d="M {cx - 8} {cy - 10} L {cx} {cy - 10} L {cx} {cy - 70} L {cx - 15} {cy - 70} Z"
		fill={METAL_LIGHT}
		stroke="none"
	/>
	<polygon
		points="{cx}, {cy - 20} {cx + 5}, {cy - 65} {cx - 5}, {cy - 65}"
		fill={METAL_DARK}
		stroke={METAL_OUTLINE}
		stroke-width="2"
	/>

	<!-- 頂部刻度板 -->
	<rect
		x={cx - 25}
		y={cy - 85}
		width="50"
		height="15"
		fill={METAL_BASE}
		stroke={METAL_OUTLINE}
		stroke-width="3"
	/>
	<rect x={cx - 25} y={cy - 85} width="45" height="10" fill={METAL_LIGHT} stroke="none" />
	<!-- 刻度線 -->
	<line x1={cx} y1={cy - 85} x2={cx} y2={cy - 70} stroke={METAL_OUTLINE} stroke-width="2" />
	<line x1={cx - 8} y1={cy - 82} x2={cx - 8} y2={cy - 70} stroke={METAL_OUTLINE} stroke-width="2" />
	<line x1={cx + 8} y1={cy - 82} x2={cx + 8} y2={cy - 70} stroke={METAL_OUTLINE} stroke-width="2" />
</g>

<!-- 向下導柱 (Guide Pins) -->
<g>
	<line
		x1={leftBeam.x + 15}
		y1={leftBeam.y}
		x2={leftBeam.x + 15}
		y2={cy + 35}
		stroke={METAL_BASE}
		stroke-width="4"
	/>
	<line
		x1={leftBeam.x + 13}
		y1={leftBeam.y}
		x2={leftBeam.x + 13}
		y2={cy + 35}
		stroke={METAL_LIGHT}
		stroke-width="1.5"
	/>
	<line
		x1={leftBeam.x + 15}
		y1={leftBeam.y}
		x2={leftBeam.x + 15}
		y2={cy + 35}
		stroke={METAL_OUTLINE}
		stroke-width="6"
		style="mix-blend-mode: overlay;"
	/>

	<line
		x1={rightBeam.x - 15}
		y1={rightBeam.y}
		x2={rightBeam.x - 15}
		y2={cy + 35}
		stroke={METAL_BASE}
		stroke-width="4"
	/>
	<line
		x1={rightBeam.x - 17}
		y1={rightBeam.y}
		x2={rightBeam.x - 17}
		y2={cy + 35}
		stroke={METAL_LIGHT}
		stroke-width="1.5"
	/>
</g>

<!-- ── 活動部件 ── -->

<!-- 1. 左側托盤支架與托盤 -->
<g>
	<!-- U型塊狀支架 -->
	<path
		d="M {leftBeam.x - 18} {leftPanCenter.y + 10} L {leftBeam.x - 12} {leftBeam.y +
			15} L {leftBeam.x + 12} {leftBeam.y + 15} L {leftBeam.x + 18} {leftPanCenter.y + 10} Z"
		fill={METAL_BASE}
		stroke={METAL_OUTLINE}
		stroke-width="3"
		stroke-linejoin="round"
	/>
	<circle
		cx={leftBeam.x}
		cy={leftBeam.y}
		r="5"
		fill={METAL_LIGHT}
		stroke={METAL_OUTLINE}
		stroke-width="2"
	/>
	<circle cx={leftBeam.x} cy={leftBeam.y} r="2" fill={METAL_OUTLINE} />
</g>

<!-- 左托盤三爪與托盤 (像素塊狀感) -->
<g>
	<path
		d="M {leftPanCenter.x - PAN_WIDTH / 2 + 2} {leftPanCenter.y - 12} L {leftPanCenter.x -
			PAN_WIDTH / 2 +
			10} {leftPanCenter.y + 10} L {leftPanCenter.x + PAN_WIDTH / 2 - 10} {leftPanCenter.y +
			10} L {leftPanCenter.x + PAN_WIDTH / 2 - 2} {leftPanCenter.y - 12}"
		fill="none"
		stroke={METAL_OUTLINE}
		stroke-width="4"
	/>

	<!-- 托盤厚度 -->
	<path
		d="M {leftPanCenter.x - PAN_WIDTH / 2} {leftPanCenter.y - 10} A {PAN_WIDTH /
			2} 15 0 0 0 {leftPanCenter.x + PAN_WIDTH / 2} {leftPanCenter.y - 10} L {leftPanCenter.x +
			PAN_WIDTH / 2 -
			5} {leftPanCenter.y} A {PAN_WIDTH / 2 - 5} 10 0 0 1 {leftPanCenter.x -
			PAN_WIDTH / 2 +
			5} {leftPanCenter.y} Z"
		fill={PAN_DARK}
		stroke={highlightPart === 'leftPan' ? HIGHLIGHT_OUTLINE : METAL_OUTLINE}
		stroke-width="3"
	/>
	<!-- 托盤頂面白面 -->
	<ellipse
		cx={leftPanCenter.x}
		cy={leftPanCenter.y - 10}
		rx={PAN_WIDTH / 2}
		ry="12"
		fill={highlightPart === 'leftPan' ? HIGHLIGHT : PAN_LIGHT}
		stroke={highlightPart === 'leftPan' ? HIGHLIGHT_OUTLINE : METAL_OUTLINE}
		stroke-width="3"
	/>
	<ellipse
		cx={leftPanCenter.x}
		cy={leftPanCenter.y - 10}
		rx={PAN_WIDTH / 2 - 5}
		ry="8"
		fill={PAN_BASE}
		stroke="none"
	/>
</g>

<!-- 2. 右側托盤支架與托盤 -->
<g>
	<path
		d="M {rightBeam.x - 18} {rightPanCenter.y + 10} L {rightBeam.x - 12} {rightBeam.y +
			15} L {rightBeam.x + 12} {rightBeam.y + 15} L {rightBeam.x + 18} {rightPanCenter.y + 10} Z"
		fill={METAL_BASE}
		stroke={METAL_OUTLINE}
		stroke-width="3"
		stroke-linejoin="round"
	/>
	<circle
		cx={rightBeam.x}
		cy={rightBeam.y}
		r="5"
		fill={METAL_LIGHT}
		stroke={METAL_OUTLINE}
		stroke-width="2"
	/>
	<circle cx={rightBeam.x} cy={rightBeam.y} r="2" fill={METAL_OUTLINE} />
</g>

<g>
	<path
		d="M {rightPanCenter.x - PAN_WIDTH / 2 + 2} {rightPanCenter.y - 12} L {rightPanCenter.x -
			PAN_WIDTH / 2 +
			10} {rightPanCenter.y + 10} L {rightPanCenter.x + PAN_WIDTH / 2 - 10} {rightPanCenter.y +
			10} L {rightPanCenter.x + PAN_WIDTH / 2 - 2} {rightPanCenter.y - 12}"
		fill="none"
		stroke={METAL_OUTLINE}
		stroke-width="4"
	/>

	<path
		d="M {rightPanCenter.x - PAN_WIDTH / 2} {rightPanCenter.y - 10} A {PAN_WIDTH /
			2} 15 0 0 0 {rightPanCenter.x + PAN_WIDTH / 2} {rightPanCenter.y - 10} L {rightPanCenter.x +
			PAN_WIDTH / 2 -
			5} {rightPanCenter.y} A {PAN_WIDTH / 2 - 5} 10 0 0 1 {rightPanCenter.x -
			PAN_WIDTH / 2 +
			5} {rightPanCenter.y} Z"
		fill={PAN_DARK}
		stroke={highlightPart === 'rightPan' ? HIGHLIGHT_OUTLINE : METAL_OUTLINE}
		stroke-width="3"
	/>
	<ellipse
		cx={rightPanCenter.x}
		cy={rightPanCenter.y - 10}
		rx={PAN_WIDTH / 2}
		ry="12"
		fill={highlightPart === 'rightPan' ? HIGHLIGHT : PAN_LIGHT}
		stroke={highlightPart === 'rightPan' ? HIGHLIGHT_OUTLINE : METAL_OUTLINE}
		stroke-width="3"
	/>
	<ellipse
		cx={rightPanCenter.x}
		cy={rightPanCenter.y - 10}
		rx={PAN_WIDTH / 2 - 5}
		ry="8"
		fill={PAN_BASE}
		stroke="none"
	/>
</g>

<!-- 3. 主橫樑 (Main Beam) 色塊邊緣 -->
<g>
	<path
		d="M {leftBeam.x + 12} {leftBeam.y - BEAM_THICKNESS / 2} L {rightBeam.x - 12} {rightBeam.y -
			BEAM_THICKNESS / 2} L {rightBeam.x - 12} {rightBeam.y + BEAM_THICKNESS / 2} L {leftBeam.x +
			12} {leftBeam.y + BEAM_THICKNESS / 2} Z"
		fill={METAL_BASE}
		stroke={METAL_OUTLINE}
		stroke-width="3"
		stroke-linejoin="round"
	/>
	<path
		d="M {leftBeam.x + 12} {leftBeam.y - BEAM_THICKNESS / 2} L {rightBeam.x - 12} {rightBeam.y -
			BEAM_THICKNESS / 2} L {rightBeam.x - 12} {rightBeam.y} L {leftBeam.x + 12} {leftBeam.y} Z"
		fill={METAL_LIGHT}
		stroke="none"
	/>

	<!-- 橫樑中央樞紐 -->
	<path
		d="M {pivotX - 15} {pivotY - 12} L {pivotX + 15} {pivotY - 12} L {pivotX + 12} {pivotY +
			12} L {pivotX - 12} {pivotY + 12} Z"
		fill={METAL_BASE}
		stroke={METAL_OUTLINE}
		stroke-width="3"
		stroke-linejoin="round"
	/>
	<rect x={pivotX - 5} y={pivotY - 12} width="10" height="24" fill={METAL_LIGHT} stroke="none" />

	<!-- 中央金屬螺絲 -->
	<circle cx={pivotX} cy={pivotY} r="6" fill={METAL_BASE} stroke={METAL_OUTLINE} stroke-width="3" />
	<circle cx={pivotX} cy={pivotY} r="3" fill="#fcd34d" stroke={METAL_OUTLINE} stroke-width="2" />
</g>

<!-- 左側校準螺絲 (Left Screw) -->
<g transform="translate({leftBeam.x - 18}, {leftBeam.y})">
	<line x1="0" y1="0" x2="-25" y2="0" stroke={METAL_BASE} stroke-width="6" />
	<line x1="0" y1="-1" x2="-25" y2="-1" stroke={METAL_LIGHT} stroke-width="2" />
	<line
		x1="0"
		y1="0"
		x2="-25"
		y2="0"
		stroke={METAL_OUTLINE}
		stroke-width="6"
		style="mix-blend-mode: overlay;"
	/>

	<rect
		x="-28"
		y="-8"
		width="10"
		height="16"
		rx="2"
		fill={highlightPart === 'screw' ? HIGHLIGHT : METAL_BASE}
		stroke={highlightPart === 'screw' ? HIGHLIGHT_OUTLINE : METAL_OUTLINE}
		stroke-width="3"
	/>
	<line x1="-24" y1="-8" x2="-24" y2="8" stroke={METAL_OUTLINE} stroke-width="2" />
</g>

<!-- 右側校準螺絲 (Right Screw) -->
<g transform="translate({rightBeam.x + 18}, {rightBeam.y})">
	<line x1="0" y1="0" x2="25" y2="0" stroke={METAL_BASE} stroke-width="6" />
	<line x1="0" y1="-1" x2="25" y2="-1" stroke={METAL_LIGHT} stroke-width="2" />
	<line
		x1="0"
		y1="0"
		x2="25"
		y2="0"
		stroke={METAL_OUTLINE}
		stroke-width="6"
		style="mix-blend-mode: overlay;"
	/>

	<rect
		x="18"
		y="-8"
		width="10"
		height="16"
		rx="2"
		fill={highlightPart === 'screw' ? HIGHLIGHT : METAL_BASE}
		stroke={highlightPart === 'screw' ? HIGHLIGHT_OUTLINE : METAL_OUTLINE}
		stroke-width="3"
	/>
	<line x1="24" y1="-8" x2="24" y2="8" stroke={METAL_OUTLINE} stroke-width="2" />
</g>

<!-- 4. 指針 (Needle) 朝上 -->
<g>
	<polygon
		points="{pivotX - 4},{pivotY - 12} {pivotX + 4},{pivotY - 12} {needleTip.x +
			1},{needleTip.y} {needleTip.x - 1},{needleTip.y}"
		fill={highlightPart === 'needle' ? HIGHLIGHT : METAL_OUTLINE}
	/>
</g>

<!-- 部位標籤 (Labels) -->
{#if showLabels}
	<rect
		x={leftPanCenter.x - 20}
		y={leftPanCenter.y - 30}
		width="40"
		height="18"
		rx="4"
		fill="#dbeafe"
		stroke="#93c5fd"
		stroke-width="1.5"
	/>
	<text
		x={leftPanCenter.x}
		y={leftPanCenter.y - 18}
		text-anchor="middle"
		font-size="10"
		font-weight="bold"
		fill="#1d4ed8">左盤</text
	>

	<rect
		x={rightPanCenter.x - 20}
		y={rightPanCenter.y - 30}
		width="40"
		height="18"
		rx="4"
		fill="#dbeafe"
		stroke="#93c5fd"
		stroke-width="1.5"
	/>
	<text
		x={rightPanCenter.x}
		y={rightPanCenter.y - 18}
		text-anchor="middle"
		font-size="10"
		font-weight="bold"
		fill="#1d4ed8">右盤</text
	>

	<!-- 修改標籤位置以配合向上的指針 -->
	<rect
		x={leftBeam.x - 65}
		y={leftBeam.y + 10}
		width="40"
		height="18"
		rx="4"
		fill="#fef3c7"
		stroke="#fbbf24"
		stroke-width="1.5"
	/>
	<text
		x={leftBeam.x - 45}
		y={leftBeam.y + 22}
		text-anchor="middle"
		font-size="9"
		font-weight="bold"
		fill="#92400e">校準螺絲</text
	>

	<rect
		x={needleTip.x + 10}
		y={needleTip.y + 5}
		width="36"
		height="18"
		rx="4"
		fill="#fef3c7"
		stroke="#fbbf24"
		stroke-width="1.5"
	/>
	<text
		x={needleTip.x + 28}
		y={needleTip.y + 18}
		text-anchor="middle"
		font-size="10"
		font-weight="bold"
		fill="#92400e">指針</text
	>
{/if}
