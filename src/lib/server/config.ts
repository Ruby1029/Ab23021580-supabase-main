import { env } from '$env/dynamic/private';

export const MOCK_USER_ID = env.MOCK_USER_ID || 'd4d1e6d8-9f8d-4fa4-bea1-bcdf04bb9c32';
export const MOCK_ACCESS_TOKEN = env.MOCK_ACCESS_TOKEN || 'mock-access-token';
export const ALLOW_MOCK = env.ALLOW_MOCK === 'true';
