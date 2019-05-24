import * as Bluebird from 'bluebird';
import { stat } from 'fs';
import { isFQDN, isPort } from 'validator';

const statAsync = Bluebird.promisify(stat);

/**
 * Validate a directory exists
 * @param {string} path
 * @param {boolean} raise
 * @returns {Promise<boolean>}
 */
export async function validateDirectoryPath(
	path: string,
	raise = true,
): Promise<boolean> {
	try {
		const stat = await statAsync(path);
		if (!stat.isDirectory()) {
			throw new Error('Error: ' + path + ' is not a directory');
		}
		return true;
	} catch (error) {
		if (raise) {
			throw error;
		} else {
			return false;
		}
	}
}

export async function validateFilePath(
	path: string,
	raise = true,
): Promise<boolean> {
	try {
		const stat = await statAsync(path);
		if (!stat.isFile()) {
			throw new Error('Error: ' + path + ' is not a file');
		}
		return true;
	} catch (error) {
		if (raise) {
			throw error;
		}
		return false;
	}
}

export async function validatePath(
	path: string,
	raise = true,
): Promise<boolean> {
	try {
		await statAsync(path);
		return true;
	} catch (error) {
		if (raise) {
			throw error;
		}
		return false;
	}
}

export function validateFQDN(value: any, raise = true): boolean {
	if (isFQDN(value)) {
		return true;
	}
	if (raise) {
		throw new Error('Please enter a valid FQDN');
	}
	return false;
}

export function validatePort(value: any, raise = true): boolean {
	if (isPort(value)) {
		return true;
	}
	if (raise) {
		throw new Error('Please enter a valid port number in the range: 1-65535');
	}
	return false;
}

export function validateString(value: any, raise = true) {
	if (value.match(/^[\w-]+$/)) {
		return true;
	}

	if (raise) {
		throw new Error('Please enter a valid value');
	}

	return false;
}

export async function inquirerValidateFilePath(value: any): Promise<boolean> {
	return await validateFilePath(value, true);
}

export async function inquirerValidatePath(value: any): Promise<boolean> {
	return await validatePath(value, true);
}

export async function inquirerValidateDirectory(value: any): Promise<boolean> {
	return await validateDirectoryPath(value, true);
}

export async function inquirerValidateFQDN(value: any): Promise<boolean> {
	return validateFQDN(value, true);
}

export async function inquirerValidatePort(value: any): Promise<boolean> {
	return validatePort(value, true);
}

export async function inquirerValidateString(value: any): Promise<boolean> {
	return validateString(value, true);
}
