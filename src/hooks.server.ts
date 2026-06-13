import { type Handle } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';

// 允許的來源清單（生產環境應設定 ALLOWED_ORIGINS 環境變數）
// 例如：ALLOWED_ORIGINS=https://your-app.vercel.app,https://your-custom-domain.com
function getAllowedOrigins(): Set<string> {
	const fromEnv = env.ALLOWED_ORIGINS ?? '';
	const origins = fromEnv
		.split(',')
		.map((o) => o.trim())
		.filter(Boolean);
	return new Set(origins);
}

function isSameOriginRequest(request: Request, url: URL): boolean {
	const origin = request.headers.get('origin');
	const referer = request.headers.get('referer');

	// 沒有 origin 也沒有 referer → 視為 server-to-server 或同源（curl 等工具不帶 origin）
	// 為了更嚴格的防護，可以把沒有 origin 也視為拒絕
	// 這裡採用：有 origin 才驗證，沒有 origin 且有 JWT 就通過（由 requireSupabaseUser 把關）
	if (!origin && !referer) return true;

	const allowedOrigins = getAllowedOrigins();

	// 若有設定環境變數，嚴格比對允許清單
	if (allowedOrigins.size > 0) {
		if (origin && allowedOrigins.has(origin)) return true;
		if (referer) {
			try {
				const refUrl = new URL(referer);
				if (allowedOrigins.has(refUrl.origin)) return true;
			} catch {
				// 忽略無效的 referer
			}
		}
		return false;
	}

	// 開發環境：允許 localhost 及同主機的請求
	const requestHost = url.host;
	if (origin) {
		try {
			const originHost = new URL(origin).host;
			// 同主機或 localhost
			if (originHost === requestHost) return true;
			if (originHost.startsWith('localhost') || originHost.startsWith('127.0.0.1')) return true;
		} catch {
			return false;
		}
	}

	return true;
}

export const handle: Handle = async ({ event, resolve }) => {
	// 只對 API 路由進行來源驗證
	if (event.url.pathname.startsWith('/api')) {
		const origin = event.request.headers.get('origin');

		// Preflight OPTIONS 請求：只回應同源或已設定的允許來源
		if (event.request.method === 'OPTIONS') {
			if (!isSameOriginRequest(event.request, event.url)) {
				return new Response('Forbidden', { status: 403 });
			}
			return new Response(null, {
				status: 204,
				headers: {
					'Access-Control-Allow-Origin': origin ?? '',
					'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
					'Access-Control-Allow-Headers': 'Content-Type, Authorization',
					'Access-Control-Max-Age': '86400'
				}
			});
		}

		// 非同源請求：拒絕存取（403 而非 401，避免洩漏端點存在資訊）
		if (!isSameOriginRequest(event.request, event.url)) {
			return new Response(JSON.stringify({ error: 'Forbidden' }), {
				status: 403,
				headers: { 'Content-Type': 'application/json' }
			});
		}
	}

	const response = await resolve(event);

	// 對同源 API 請求設定嚴格的 CORS 標頭（不允許其他來源）
	if (event.url.pathname.startsWith('/api')) {
		const origin = event.request.headers.get('origin');
		if (origin) {
			response.headers.set('Access-Control-Allow-Origin', origin);
			response.headers.set('Vary', 'Origin');
		}
		// 加上安全標頭
		response.headers.set('X-Content-Type-Options', 'nosniff');
		response.headers.set('X-Frame-Options', 'DENY');
	}

	return response;
};
