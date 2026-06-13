import { error } from '@sveltejs/kit';

const uuidRegex = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/;
const legacyIdRegex = /^legacy-[a-zA-Z0-9._:-]+$/;
const cleanIdRegex = /^[a-zA-Z0-9._:-]+$/;
const contentUrlRegex = /^\/[a-zA-Z0-9._/-]*$/;
const validStatuses = new Set(['not_started', 'in_progress', 'completed']);

export function validateUuid(value: unknown, fieldName: string): string {
	if (typeof value !== 'string' || !uuidRegex.test(value)) {
		throw error(400, `${fieldName} 格式不正確，必須是 UUID`);
	}
	return value;
}

export function validateLessonOrQuizId(value: unknown, fieldName: string): string {
	if (typeof value !== 'string') {
		throw error(400, `${fieldName} 必須是字串`);
	}
	if (uuidRegex.test(value) || legacyIdRegex.test(value) || cleanIdRegex.test(value)) {
		return value;
	}
	throw error(400, `${fieldName} 格式不正確`);
}

export function validateContentUrl(value: unknown, fieldName: string): string {
	if (typeof value !== 'string' || !contentUrlRegex.test(value)) {
		throw error(400, `${fieldName} 格式不正確`);
	}
	return value;
}

export function validateStatus(value: unknown): string {
	if (typeof value !== 'string' || !validStatuses.has(value)) {
		throw error(400, 'status 必須是 not_started、in_progress 或 completed');
	}
	return value;
}

export function validateString(
	value: unknown,
	min: number,
	max: number,
	fieldName: string
): string {
	if (typeof value !== 'string') {
		throw error(400, `${fieldName} 必須是字串`);
	}
	const trimmed = value.trim();
	if (trimmed.length < min || trimmed.length > max) {
		throw error(400, `${fieldName} 長度限制在 ${min} 至 ${max} 字元之間`);
	}
	return trimmed;
}

export function sanitizeSqlIdentifier(value: string): string {
	if (!cleanIdRegex.test(value)) {
		throw error(400, '偵測到不安全的字元輸入');
	}
	return value;
}
