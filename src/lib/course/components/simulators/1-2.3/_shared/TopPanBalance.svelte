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

	// 金屬材質漸層
	const METAL_LIGHT = '#f1f5f9';
	const METAL_BASE = '#cbd5e1';
	const METAL_DARK = '#94a3b8';
	const METAL_DARKER = '#64748b';
	const BASE_GREEN_LIGHT = '#6b9c7b';
	const BASE_GREEN = '#4a7c59';
	const BASE_GREEN_DARK = '#2f523a';
	const HIGHLIGHT = '#f97316';

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

<defs>
	<linearGradient id="metal-grad" x1="0%" y1="0%" x2="0%" y2="100%">
		<stop offset="0%" stop-color={METAL_DARK} />
		<stop offset="20%" stop-color={METAL_LIGHT} />
		<stop offset="50%" stop-color={METAL_BASE} />
		<stop offset="85%" stop-color={METAL_LIGHT} />
		<stop offset="100%" stop-color={METAL_DARK} />
	</linearGradient>
	<linearGradient id="metal-grad-h" x1="0%" y1="0%" x2="100%" y2="0%">
		<stop offset="0%" stop-color={METAL_DARK} />
		<stop offset="20%" stop-color={METAL_LIGHT} />
		<stop offset="50%" stop-color={METAL_BASE} />
		<stop offset="85%" stop-color={METAL_LIGHT} />
		<stop offset="100%" stop-color={METAL_DARK} />
	</linearGradient>
	<linearGradient id="green-grad" x1="0%" y1="0%" x2="0%" y2="100%">
		<stop offset="0%" stop-color={BASE_GREEN_DARK} />
		<stop offset="20%" stop-color={BASE_GREEN_LIGHT} />
		<stop offset="50%" stop-color={BASE_GREEN} />
		<stop offset="80%" stop-color={BASE_GREEN_LIGHT} />
		<stop offset="100%" stop-color={BASE_GREEN_DARK} />
	</linearGradient>
	<linearGradient id="pan-grad" x1="0%" y1="0%" x2="100%" y2="0%">
		<stop offset="0%" stop-color="#cbd5e1" />
		<stop offset="30%" stop-color="#ffffff" />
		<stop offset="70%" stop-color="#f8fafc" />
		<stop offset="100%" stop-color="#cbd5e1" />
	</linearGradient>
	<filter id="drop-shadow" x="-20%" y="-20%" width="140%" height="140%">
		<feDropShadow dx="0" dy="8" stdDeviation="6" flood-opacity="0.3" />
	</filter>
	<filter id="light-shadow" x="-20%" y="-20%" width="140%" height="140%">
		<feDropShadow dx="0" dy="2" stdDeviation="2" flood-opacity="0.2" />
	</filter>
</defs>

<!-- 底座 (Base) -->
<!-- 梯形綠色底座 -->
<path
	d="M {cx - 85} {cy + 30} L {cx + 85} {cy + 30} L {cx + 105} {cy + 95} L {cx - 105} {cy + 95} Z"
	fill="url(#green-grad)"
	filter="url(#drop-shadow)"
/>
<!-- 底座立體頂面 -->
<ellipse {cx} cy={cy + 30} rx="85" ry="5" fill={BASE_GREEN_LIGHT} />

<!-- 金屬銘版 (Silver Label Plate) -->
<rect
	x={cx - 40}
	y={cy + 55}
	width="80"
	height="25"
	rx="2"
	fill="url(#metal-grad)"
	stroke={METAL_DARK}
	stroke-width="1"
	filter="url(#light-shadow)"
/>
<circle cx={cx - 35} cy={cy + 60} r="1.5" fill={METAL_DARKER} />
<circle cx={cx + 35} cy={cy + 60} r="1.5" fill={METAL_DARKER} />
<circle cx={cx - 35} cy={cy + 75} r="1.5" fill={METAL_DARKER} />
<circle cx={cx + 35} cy={cy + 75} r="1.5" fill={METAL_DARKER} />
<text x={cx} y={cy + 64} text-anchor="middle" font-size="6" fill="#333" font-family="monospace"
	>ひょう量 100g</text
>
<text x={cx} y={cy + 74} text-anchor="middle" font-size="6" fill="#333" font-weight="bold"
	>MARUMO</text
>

<!-- 中央立柱 (Central Pillar) -->
<path
	d="M {cx - 10} {cy + 30} L {cx + 10} {cy + 30} L {cx + 6} {cy - 10} L {cx - 6} {cy - 10} Z"
	fill="url(#metal-grad)"
/>
<path
	d="M {cx - 6} {cy - 10} L {cx + 6} {cy - 10} L {cx + 15} {cy - 60} L {cx - 15} {cy - 60} Z"
	fill="none"
	stroke="url(#metal-grad)"
	stroke-width="4"
/>

<!-- 刻度板 (Scale Plate) 位於頂部 -->
<rect
	x={cx - 20}
	y={cy - 85}
	width="40"
	height="15"
	rx="2"
	fill="url(#metal-grad)"
	filter="url(#light-shadow)"
/>
<path
	d="M {cx - 15} {cy - 70} Q {cx} {cy - 65} {cx + 15} {cy - 70}"
	fill="none"
	stroke={METAL_DARK}
	stroke-width="1"
/>
<line x1={cx} y1={cy - 80} x2={cx} y2={cy - 70} stroke="#000" stroke-width="1.5" />
<line x1={cx - 6} y1={cy - 78} x2={cx - 6} y2={cy - 70} stroke="#000" stroke-width="1" />
<line x1={cx + 6} y1={cy - 78} x2={cx + 6} y2={cy - 70} stroke="#000" stroke-width="1" />
<line x1={cx - 12} y1={cy - 76} x2={cx - 12} y2={cy - 70} stroke="#000" stroke-width="1" />
<line x1={cx + 12} y1={cy - 76} x2={cx + 12} y2={cy - 70} stroke="#000" stroke-width="1" />

<!-- 向下導柱 (Guide Pins into Base) -->
<line
	x1={leftBeam.x + 15}
	y1={leftBeam.y}
	x2={leftBeam.x + 15}
	y2={cy + 35}
	stroke="url(#metal-grad-h)"
	stroke-width="4"
/>
<line
	x1={rightBeam.x - 15}
	y1={rightBeam.y}
	x2={rightBeam.x - 15}
	y2={cy + 35}
	stroke="url(#metal-grad-h)"
	stroke-width="4"
/>

<!-- ── 活動部件 ── -->

<!-- 1. 左側托盤支架與托盤 -->
<!-- U型支架 -->
<path
	d="M {leftBeam.x - 15} {leftPanCenter.y + 5} L {leftBeam.x - 15} {leftBeam.y + 10} L {leftBeam.x +
		15} {leftBeam.y + 10} L {leftBeam.x + 15} {leftPanCenter.y + 5}"
	fill="none"
	stroke="url(#metal-grad)"
	stroke-width="8"
	stroke-linejoin="round"
/>
<circle cx={leftBeam.x} cy={leftBeam.y} r="4" fill="#1e293b" />
<!-- 支點螺絲 -->

<!-- 左托盤三爪固定架 -->
<line
	x1={leftPanCenter.x - PAN_WIDTH / 2 - 2}
	y1={leftPanCenter.y - 10}
	x2={leftPanCenter.x - PAN_WIDTH / 2 + 5}
	y2={leftPanCenter.y + 10}
	stroke="url(#metal-grad)"
	stroke-width="3"
/>
<line
	x1={leftPanCenter.x + PAN_WIDTH / 2 + 2}
	y1={leftPanCenter.y - 10}
	x2={leftPanCenter.x + PAN_WIDTH / 2 - 5}
	y2={leftPanCenter.y + 10}
	stroke="url(#metal-grad)"
	stroke-width="3"
/>
<line
	x1={leftPanCenter.x}
	y1={leftPanCenter.y}
	x2={leftPanCenter.x}
	y2={leftPanCenter.y + 15}
	stroke="url(#metal-grad)"
	stroke-width="4"
/>

<!-- 左托盤 (白色瓷盤感) -->
<g filter="url(#light-shadow)">
	<path
		d="M {leftPanCenter.x - PAN_WIDTH / 2} {leftPanCenter.y -
			5} Q {leftPanCenter.x} {leftPanCenter.y + 15} {leftPanCenter.x +
			PAN_WIDTH / 2} {leftPanCenter.y - 5} Z"
		fill="url(#pan-grad)"
		stroke={highlightPart === 'leftPan' ? HIGHLIGHT : '#cbd5e1'}
		stroke-width="1.5"
	/>
	<ellipse
		cx={leftPanCenter.x}
		cy={leftPanCenter.y - 5}
		rx={PAN_WIDTH / 2}
		ry="10"
		fill={highlightPart === 'leftPan' ? '#fdba74' : '#f8fafc'}
		stroke={highlightPart === 'leftPan' ? HIGHLIGHT : '#e2e8f0'}
		stroke-width="1.5"
	/>
</g>

<!-- 2. 右側托盤支架與托盤 -->
<!-- U型支架 -->
<path
	d="M {rightBeam.x - 15} {rightPanCenter.y + 5} L {rightBeam.x - 15} {rightBeam.y +
		10} L {rightBeam.x + 15} {rightBeam.y + 10} L {rightBeam.x + 15} {rightPanCenter.y + 5}"
	fill="none"
	stroke="url(#metal-grad)"
	stroke-width="8"
	stroke-linejoin="round"
/>
<circle cx={rightBeam.x} cy={rightBeam.y} r="4" fill="#1e293b" />
<!-- 支點螺絲 -->

<!-- 右托盤三爪固定架 -->
<line
	x1={rightPanCenter.x - PAN_WIDTH / 2 - 2}
	y1={rightPanCenter.y - 10}
	x2={rightPanCenter.x - PAN_WIDTH / 2 + 5}
	y2={rightPanCenter.y + 10}
	stroke="url(#metal-grad)"
	stroke-width="3"
/>
<line
	x1={rightPanCenter.x + PAN_WIDTH / 2 + 2}
	y1={rightPanCenter.y - 10}
	x2={rightPanCenter.x + PAN_WIDTH / 2 - 5}
	y2={rightPanCenter.y + 10}
	stroke="url(#metal-grad)"
	stroke-width="3"
/>
<line
	x1={rightPanCenter.x}
	y1={rightPanCenter.y}
	x2={rightPanCenter.x}
	y2={rightPanCenter.y + 15}
	stroke="url(#metal-grad)"
	stroke-width="4"
/>

<!-- 右托盤 (白色瓷盤感) -->
<g filter="url(#light-shadow)">
	<path
		d="M {rightPanCenter.x - PAN_WIDTH / 2} {rightPanCenter.y -
			5} Q {rightPanCenter.x} {rightPanCenter.y + 15} {rightPanCenter.x +
			PAN_WIDTH / 2} {rightPanCenter.y - 5} Z"
		fill="url(#pan-grad)"
		stroke={highlightPart === 'rightPan' ? HIGHLIGHT : '#cbd5e1'}
		stroke-width="1.5"
	/>
	<ellipse
		cx={rightPanCenter.x}
		cy={rightPanCenter.y - 5}
		rx={PAN_WIDTH / 2}
		ry="10"
		fill={highlightPart === 'rightPan' ? '#fdba74' : '#f8fafc'}
		stroke={highlightPart === 'rightPan' ? HIGHLIGHT : '#e2e8f0'}
		stroke-width="1.5"
	/>
</g>

<!-- 3. 主橫樑 (Main Beam) -->
<path
	d="M {leftBeam.x + 15} {leftBeam.y - BEAM_THICKNESS / 2} L {rightBeam.x - 15} {rightBeam.y -
		BEAM_THICKNESS / 2} L {rightBeam.x - 15} {rightBeam.y + BEAM_THICKNESS / 2} L {leftBeam.x +
		15} {leftBeam.y + BEAM_THICKNESS / 2} Z"
	fill="url(#metal-grad)"
	stroke={METAL_DARK}
	stroke-width="0.5"
	filter="url(#drop-shadow)"
/>
<!-- 橫樑中央凸起設計 -->
<path
	d="M {pivotX - 20} {pivotY - 10} L {pivotX + 20} {pivotY - 10} L {pivotX + 15} {pivotY +
		10} L {pivotX - 15} {pivotY + 10} Z"
	fill="url(#metal-grad)"
	stroke={METAL_DARK}
	stroke-width="0.5"
/>
<!-- 主橫樑雕刻凹槽 (裝飾) -->
<path
	d="M {leftBeam.x + 30} {leftBeam.y} L {pivotX - 25} {pivotY} M {pivotX +
		25} {pivotY} L {rightBeam.x - 30} {rightBeam.y}"
	stroke={METAL_DARK}
	stroke-width="2"
	stroke-linecap="round"
/>
<circle cx={pivotX} cy={pivotY} r="5" fill="#fcd34d" stroke="#b48a3a" stroke-width="1" />
<!-- 中央金色螺絲 -->

<!-- 左側校準螺絲 (Left Screw) 延伸出橫樑外 -->
<g transform="translate({leftBeam.x - 18}, {leftBeam.y})">
	<line x1="0" y1="0" x2="-20" y2="0" stroke="url(#metal-grad)" stroke-width="4" />
	<rect
		x="-24"
		y="-5"
		width="8"
		height="10"
		rx="1"
		fill={highlightPart === 'screw' ? HIGHLIGHT : 'url(#metal-grad)'}
		stroke={highlightPart === 'screw' ? '#9a3412' : METAL_DARKER}
		stroke-width="1.5"
	/>
	<line x1="-20" y1="-5" x2="-20" y2="5" stroke="#1e293b" stroke-width="1" />
	<line x1="-22" y1="-5" x2="-22" y2="5" stroke="#1e293b" stroke-width="1" />
</g>

<!-- 右側校準螺絲 (Right Screw) 延伸出橫樑外 -->
<g transform="translate({rightBeam.x + 18}, {rightBeam.y})">
	<line x1="0" y1="0" x2="20" y2="0" stroke="url(#metal-grad)" stroke-width="4" />
	<rect
		x="16"
		y="-5"
		width="8"
		height="10"
		rx="1"
		fill={highlightPart === 'screw' ? HIGHLIGHT : 'url(#metal-grad)'}
		stroke={highlightPart === 'screw' ? '#9a3412' : METAL_DARKER}
		stroke-width="1.5"
	/>
	<line x1="20" y1="-5" x2="20" y2="5" stroke="#1e293b" stroke-width="1" />
	<line x1="22" y1="-5" x2="22" y2="5" stroke="#1e293b" stroke-width="1" />
</g>

<!-- 4. 指針 (Needle) 朝上 -->
<line
	x1={pivotX}
	y1={pivotY}
	x2={needleTip.x}
	y2={needleTip.y}
	stroke={highlightPart === 'needle' ? HIGHLIGHT : '#1e293b'}
	stroke-width="2.5"
	stroke-linecap="round"
/>
<polygon
	points="{needleTip.x},{needleTip.y - 5} {needleTip.x - 3},{needleTip.y + 4} {needleTip.x +
		3},{needleTip.y + 4}"
	fill={highlightPart === 'needle' ? HIGHLIGHT : '#1e293b'}
/>

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
