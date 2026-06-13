import { error, json, type RequestHandler } from '@sveltejs/kit';
import { ensureProfile, requireSupabaseUser } from '$lib/server/supabaseAuth';
import { prisma } from '$lib/server/prisma';
import { validateString } from '$lib/server/validation';
import { MOCK_USER_ID, ALLOW_MOCK } from '$lib/server/config';

export const GET: RequestHandler = async ({ request }) => {
	const user = await requireSupabaseUser(request);
	const profile = await ensureProfile(user);

	return json({ user, profile });
};

export const POST: RequestHandler = async ({ request }) => {
	const user = await requireSupabaseUser(request);
	const body = await request.json().catch(() => ({}));

	let displayName: string | undefined;
	if (body.displayName !== undefined) {
		displayName = validateString(body.displayName, 1, 50, 'displayName');
	}

	if (ALLOW_MOCK && user.id === MOCK_USER_ID) {
		return json({
			user,
			profile: {
				id: user.id,
				role: 'premium',
				displayName: displayName || '測試使用者',
				createdAt: new Date().toISOString()
			}
		});
	}

	const profile = displayName
		? await prisma.profile.upsert({
				where: { id: user.id },
				update: { displayName },
				create: { id: user.id, displayName }
			})
		: await ensureProfile(user);

	return json({ user, profile });
};

export const PUT: RequestHandler = async ({ request }) => {
	const user = await requireSupabaseUser(request);
	const body = await request.json().catch(() => ({}));

	if (body.displayName === undefined || body.displayName === null) {
		throw error(400, 'displayName 不可為空');
	}
	const displayName = validateString(body.displayName, 1, 50, 'displayName');

	if (ALLOW_MOCK && user.id === MOCK_USER_ID) {
		return json({
			user,
			profile: {
				id: user.id,
				role: 'premium',
				displayName,
				createdAt: new Date().toISOString()
			}
		});
	}

	const profile = await prisma.profile.update({
		where: { id: user.id },
		data: { displayName }
	});

	return json({ user, profile });
};
