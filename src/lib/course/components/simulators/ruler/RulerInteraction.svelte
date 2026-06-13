<script lang="ts">
	let {
		type,
		config,
		sliderX,
		startDragX,
		pullHistory = [],
		activePullIndex = 0,
		onStaticClick
	}: {
		type: string;
		config?: { pulls?: number; range?: [number, number] };
		sliderX: number;
		startDragX: number;
		pullHistory?: { startMm: number; currentMm: number }[];
		activePullIndex?: number;
		onStaticClick: () => void;
	} = $props();

	const pxPerMm = 4;
	const offsetX = 50;
	const colors = ['#3b82f6', '#10b981', '#fbbf24', '#f97316', '#ef4444'];

	function handleStaticKeydown(event: KeyboardEvent) {
		if (event.key === 'Enter' || event.key === ' ') {
			event.preventDefault();
			onStaticClick();
		}
	}
</script>

<!-- A1 點擊 -->
{#if type === 'STATIC'}
	<!-- 將點擊位置移至 19.5cm 的 cm 字樣處 -->
	<g
		role="button"
		tabindex="0"
		onclick={onStaticClick}
		onkeydown={handleStaticKeydown}
		class="group cursor-pointer"
	>
		<circle
			cx={offsetX + 19.5 * pxPerCm}
			cy={65}
			r="30"
			fill="#DABEA7"
			fill-opacity="0.3"
			class="group-hover:fill-opacity-100 transition-all"
		/>
		<circle
			cx={offsetX + 19.5 * pxPerCm}
			cy={65}
			r="18"
			stroke="#ef4444"
			stroke-width="2"
			fill="none"
			stroke-dasharray="4 2"
		/>
		<text
			x={offsetX + 19.5 * pxPerCm}
			y="30"
			text-anchor="middle"
			font-size="12"
			font-weight="bold"
			fill="#ef4444"
			class="animate-bounce">點擊此處</text
		>
	</g>
{/if}

<!-- 拖曳視覺指示 -->
{#if type && (type.includes('DRAG') || type === 'PRECISION')}
	<!-- 1. 渲染歷史路徑 -->
	{#each pullHistory as pull, i (`${pull.startMm}-${pull.currentMm}-${i}`)}
		{@const y = 150 + i * 30}
		{@const color = colors[i % colors.length]}
		{@const hStartX = offsetX + pull.startMm * pxPerMm}
		{@const hEndX = offsetX + pull.currentMm * pxPerMm}

		<g opacity="0.8">
			<line
				x1={hStartX}
				y1={y}
				x2={hEndX}
				y2={y}
				stroke={color}
				stroke-width="6"
				stroke-linecap="round"
				stroke-dasharray="1 1"
			/>
			<circle cx={hStartX} cy={y} r="3" fill={color} />
			<circle cx={hEndX} cy={y} r="3" fill={color} />
			<g transform="translate({hEndX}, {y}) rotate(-15) scale(0.6)">
				<path d="M -4 -10 L 0 0 L 4 -10 Z" fill="#2d3436" />
				<rect x="-4" y="-50" width="8" height="40" rx="1" fill={color} />
			</g>
		</g>
	{/each}

	<!-- 2. 渲染當前活躍路徑 -->
	{#if !config?.pulls || activePullIndex < config.pulls}
		{@const currentY = 150 + activePullIndex * 30}
		{@const currentColor = colors[activePullIndex % colors.length] || '#3b82f6'}
		{@const range = config?.range ?? [0, 20]}
		{@const startX = range[0] * pxPerCm + offsetX}
		{@const endX = range[1] * pxPerCm + offsetX}

		<line
			x1={startX}
			y1={currentY}
			x2={endX}
			y2={currentY}
			stroke="#f3f4f6"
			stroke-width="12"
			stroke-linecap="round"
		/>
		<line
			x1={startDragX}
			y1={currentY}
			x2={sliderX}
			y2={currentY}
			stroke={currentColor}
			stroke-width="6"
			stroke-linecap="round"
			stroke-dasharray="1 1"
		/>

		<g transform="translate({sliderX}, {currentY})" class="pointer-events-none">
			<g transform="rotate(-15)">
				<path d="M -4 -10 L 0 0 L 4 -10 Z" fill="#2d3436" />
				<rect x="-4" y="-50" width="8" height="40" rx="1" fill={currentColor} />
				<rect x="-4" y="-55" width="8" height="5" rx="1" fill="#ff7675" />
			</g>
			<!-- 移除紅色的倒三角形指針 -->
			<circle cx="0" cy="0" r="3" fill="#1f2937" />
		</g>

		<circle cx={startX} cy={currentY} r="4" fill="#9ca3af" />
		<circle cx={endX} cy={currentY} r="4" fill="#9ca3af" />
	{/if}
{/if}
