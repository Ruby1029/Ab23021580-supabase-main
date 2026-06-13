import { PUBLIC_SUPABASE_PUBLISHABLE_KEY, PUBLIC_SUPABASE_URL } from '$env/static/public';
import { error } from '@sveltejs/kit';
import { prisma } from './prisma';
import { MOCK_ACCESS_TOKEN, MOCK_USER_ID, ALLOW_MOCK } from './config';

const supabaseUrl = PUBLIC_SUPABASE_URL.replace(/\/$/, '');
const supabaseKey = PUBLIC_SUPABASE_PUBLISHABLE_KEY;

export interface SupabaseUser {
	id: string;
	email?: string;
	user_metadata?: Record<string, unknown>;
}

function readBearerToken(request: Request) {
	const authorization = request.headers.get('authorization');
	if (!authorization?.toLowerCase().startsWith('bearer ')) return null;
	return authorization.slice('bearer '.length).trim();
}

export async function getSupabaseUser(request: Request) {
	const token = readBearerToken(request);
	if (!token || (ALLOW_MOCK && token === MOCK_ACCESS_TOKEN)) return null;

	try {
		const response = await fetch(`${supabaseUrl}/auth/v1/user`, {
			headers: {
				apikey: supabaseKey,
				Authorization: `Bearer ${token}`
			}
		});

		if (!response.ok) return null;
		return (await response.json()) as SupabaseUser;
	} catch {
		return null;
	}
}

export async function requireSupabaseUser(request: Request) {
	const user = await getSupabaseUser(request);
	if (!user?.id) {
		throw error(401, '請先登入');
	}
	return user;
}

export async function ensureProfile(user: SupabaseUser) {
	const displayName =
		typeof user.user_metadata?.display_name === 'string'
			? user.user_metadata.display_name
			: (user.email?.split('@')[0] ?? null);

	if (ALLOW_MOCK && user.id === MOCK_USER_ID) {
		return {
			id: user.id,
			role: 'premium',
			displayName: displayName || '測試使用者',
			createdAt: new Date()
		};
	}

	try {
		return await prisma.profile.upsert({
			where: { id: user.id },
			update: {},
			create: {
				id: user.id,
				displayName
			}
		});
	} catch (err) {
		console.warn('Profile upsert failed, returning mock profile:', err);
		return {
			id: user.id,
			role: 'premium',
			displayName: displayName || '測試使用者',
			createdAt: new Date()
		};
	}
}
