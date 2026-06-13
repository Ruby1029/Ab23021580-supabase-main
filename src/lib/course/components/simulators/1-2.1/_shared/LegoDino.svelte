<!--
  共用元件：樂高積木小恐龍（像素風格 SVG）
  Props:
    x, y      : 恐龍中心座標
    scale     : 縮放（預設 1）
    builtCount: 已組裝的積木數 0~30（控制組裝動畫）
    floating  : 是否漂浮動畫（太空/水中用）
-->
<script lang="ts">
	let {
		x = 0,
		y = 0,
		scale = 1,
		builtCount = 30,
		floating = false
	}: {
		x?: number;
		y?: number;
		scale?: number;
		builtCount?: number;
		floating?: boolean;
	} = $props();

	// 30 塊積木座標（像素風恐龍：頭、身體、腿、尾巴）
	// 每塊 = {bx, by, w, h, color}，座標相對於恐龍中心
	const BRICKS = [
		// 頭（5 塊）
		{ bx: 20, by: -50, w: 18, h: 10, color: '#22c55e' },
		{ bx: 20, by: -40, w: 22, h: 10, color: '#16a34a' },
		{ bx: 18, by: -30, w: 24, h: 10, color: '#22c55e' },
		{ bx: 36, by: -44, w: 6, h: 6, color: '#1e293b' }, // 眼睛
		{ bx: 42, by: -38, w: 6, h: 4, color: '#ef4444' }, // 嘴巴

		// 脖子（3 塊）
		{ bx: 14, by: -20, w: 14, h: 10, color: '#16a34a' },
		{ bx: 10, by: -10, w: 14, h: 10, color: '#22c55e' },
		{ bx: 6, by: 0, w: 14, h: 10, color: '#16a34a' },

		// 身體（10 塊）
		{ bx: -20, by: 10, w: 40, h: 10, color: '#22c55e' },
		{ bx: -24, by: 20, w: 44, h: 10, color: '#16a34a' },
		{ bx: -26, by: 30, w: 46, h: 10, color: '#22c55e' },
		{ bx: -24, by: 40, w: 44, h: 10, color: '#16a34a' },
		{ bx: -22, by: 50, w: 42, h: 10, color: '#22c55e' },
		{ bx: -18, by: 60, w: 38, h: 10, color: '#16a34a' },
		{ bx: -14, by: 70, w: 34, h: 8, color: '#22c55e' },
		// 肚皮
		{ bx: -10, by: 30, w: 20, h: 30, color: '#bbf7d0' },
		// 背脊
		{ bx: -26, by: 15, w: 6, h: 50, color: '#15803d' },
		{ bx: -30, by: 25, w: 4, h: 10, color: '#15803d' },

		// 前腿（3 塊）
		{ bx: 4, by: 78, w: 10, h: 14, color: '#16a34a' },
		{ bx: 2, by: 92, w: 14, h: 6, color: '#22c55e' },
		{ bx: 0, by: 98, w: 18, h: 4, color: '#16a34a' },

		// 後腿（3 塊）
		{ bx: -18, by: 78, w: 10, h: 14, color: '#16a34a' },
		{ bx: -20, by: 92, w: 14, h: 6, color: '#22c55e' },
		{ bx: -22, by: 98, w: 18, h: 4, color: '#16a34a' },

		// 尾巴（6 塊）
		{ bx: -30, by: 10, w: 14, h: 8, color: '#22c55e' },
		{ bx: -40, by: 4, w: 14, h: 8, color: '#16a34a' },
		{ bx: -50, by: -2, w: 14, h: 8, color: '#22c55e' },
		{ bx: -58, by: -8, w: 12, h: 6, color: '#16a34a' },
		{ bx: -66, by: -12, w: 10, h: 5, color: '#22c55e' },
		{ bx: -72, by: -15, w: 8, h: 4, color: '#16a34a' }
	];

	const floatAnim = floating ? 'dino-float 3s ease-in-out infinite' : 'none';
</script>

<g transform="translate({x}, {y}) scale({scale})" style="animation: {floatAnim}">
	{#each BRICKS as brick, i (brick.x ?? i)}
		{#if i < builtCount}
			<rect
				x={brick.bx}
				y={brick.by}
				width={brick.w}
				height={brick.h}
				rx="1.5"
				fill={brick.color}
				stroke="#166534"
				stroke-width="0.8"
			>
				{#if builtCount <= 30 && i === builtCount - 1}
					<animate attributeName="opacity" from="0" to="1" dur="0.3s" fill="freeze" />
				{/if}
			</rect>
		{/if}
	{/each}
</g>

<style>
	@keyframes dino-float {
		0%,
		100% {
			transform: translateY(0px);
		}
		50% {
			transform: translateY(-8px);
		}
	}
</style>
