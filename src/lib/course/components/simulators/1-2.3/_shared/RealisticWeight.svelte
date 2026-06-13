<script lang="ts">
	/**
	 * 高擬真砝碼 (Realistic Weight)
	 * 根據質量大小等比例縮放，並使用金屬漸層呈現真實質感
	 */
	let {
		mass = 50,
		x = 0,
		y = 0,
		material = 'brass', // 'brass' (黃銅) or 'silver' (不鏽鋼)
		interactive = false,
		selected = false,
		disabled = false
	}: {
		mass?: number;
		x?: number;
		y?: number;
		material?: 'brass' | 'silver';
		interactive?: boolean;
		selected?: boolean;
		disabled?: boolean;
	} = $props();

	// 根據質量計算大小 (非線性縮放，讓 5g 不會太小，100g 不會太大)
	const scale = $derived(Math.pow(mass / 10, 0.4) * 0.8);

	const width = $derived(24 * scale);
	const baseHeight = $derived(20 * scale);
	const knobWidth = $derived(8 * scale);
	const knobHeight = $derived(10 * scale);
	const totalHeight = $derived(baseHeight + knobHeight);

	// 顏色漸層設定
	const colors = $derived(
		material === 'brass'
			? { main: '#b48a3a', light: '#fcd34d', dark: '#78350f', highlight: '#fef3c7' }
			: { main: '#94a3b8', light: '#e2e8f0', dark: '#475569', highlight: '#f8fafc' }
	);

	const gradientId = $derived(`weight-grad-${material}-${mass}`);
</script>

<defs>
	<!-- 金屬圓柱漸層 -->
	<linearGradient id={gradientId} x1="0%" y1="0%" x2="100%" y2="0%">
		<stop offset="0%" stop-color={colors.dark} />
		<stop offset="20%" stop-color={colors.light} />
		<stop offset="50%" stop-color={colors.main} />
		<stop offset="85%" stop-color={colors.light} />
		<stop offset="100%" stop-color={colors.dark} />
	</linearGradient>
</defs>

<g
	transform="translate({x}, {y})"
	style="{interactive && !disabled ? 'cursor: pointer;' : ''} {disabled ? 'opacity: 0.5;' : ''}"
	class="transition-transform duration-200 {selected ? '-translate-y-2' : ''}"
>
	<!-- 陰影 -->
	{#if !disabled}
		<ellipse
			cx="0"
			cy="0"
			rx={width / 2 + 2}
			ry={width / 6 + 1}
			fill="rgba(0,0,0,0.3)"
			filter="blur(2px)"
		/>
	{/if}

	<!-- 底部圓柱體主體 -->
	<!-- 圓柱下半部弧形 -->
	<path
		d="M {-width / 2} {-baseHeight} L {-width / 2} 0 A {width / 2} {width / 6} 0 0 0 {width /
			2} 0 L {width / 2} {-baseHeight} Z"
		fill="url(#{gradientId})"
		stroke={selected ? '#4ade80' : colors.dark}
		stroke-width={selected ? 2 : 0.5}
	/>
	<!-- 圓柱頂部橢圓 -->
	<ellipse
		cx="0"
		cy={-baseHeight}
		rx={width / 2}
		ry={width / 6}
		fill={colors.light}
		stroke={selected ? '#4ade80' : colors.dark}
		stroke-width={selected ? 2 : 0.5}
	/>

	<!-- 頂部拿取圓鈕 (Knob) -->
	<path
		d="M {-knobWidth / 2} {-baseHeight} L {-knobWidth / 3} {-totalHeight} A {knobWidth /
			3} {knobWidth / 6} 0 0 1 {knobWidth / 3} {-totalHeight} L {knobWidth / 2} {-baseHeight} Z"
		fill="url(#{gradientId})"
	/>
	<ellipse cx="0" cy={-totalHeight} rx={knobWidth / 1.5} ry={knobWidth / 3} fill={colors.light} />

	<!-- 質量標示 -->
	<text
		x="0"
		y={-baseHeight / 2 + 2}
		text-anchor="middle"
		dominant-baseline="middle"
		font-size={8 * scale}
		font-family="sans-serif"
		font-weight="bold"
		fill={colors.dark}
		opacity="0.8"
	>
		{mass}g
	</text>

	<!-- 隱形點擊熱區 -->
	{#if interactive}
		<rect x={-width / 2} y={-totalHeight} {width} height={totalHeight} fill="transparent" />
	{/if}
</g>
