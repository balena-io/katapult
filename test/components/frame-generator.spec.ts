import { Frame } from '../../src/lib/controllers/frame/frame';
import * as frameGenerator from '../../src/lib/controllers/frame/frame-generator';
import * as frameTemplate from '../../src/lib/controllers/frame-template';
import { exportAdapters } from '../../src/lib/controllers/frame/adapter';
import { mustacheRenderer } from '../../src/lib/controllers/frame-template/renderer/mustache';
import {
	ConfigStore,
	ConfigMap,
} from '../../src/lib/controllers/config-store/config-store';

import { expect } from 'chai';
import * as fs from 'mz/fs';
import * as path from 'path';
import * as temp from 'temp';
import { getTestFile, getTestDir } from '../files';

describe('frame-generator', () => {
	const configMap: ConfigMap = {
		SERVICE_API_VERSION: 'master',
		CERT_ROOT_CA: 'abcde12345',
	};

	const configStore: ConfigStore = {
		list: async () => configMap,
		updateMany: async () => configMap,
	};

	let frameTemplateDir = '';
	let frame: Frame = { files: {} };
	let tempDir = '';

	before(async () => {
		frameTemplateDir = await getTestDir(
			'deploy-templates/test/v1.0.0/docker-compose/templates',
		);
		tempDir = temp.track().mkdirSync();
	});

	after(() => {
		temp.cleanupSync();
	});

	it('should create a Frame from a mustache-formatted FrameTemplate', async () => {
		const ft = await frameTemplate.fromDirectory(frameTemplateDir);
		frame = await frameGenerator.generate(ft, mustacheRenderer, configStore);

		expect(frame.files['certs/balena-root-ca.pem']).is.not.undefined;
		expect(frame.files['certs/balena-root-ca.pem']).contains('abcde12345');

		expect(frame.files['docker-compose.yml']).is.not.undefined;
		expect(frame.files['docker-compose.yml']).contains(
			'image: "balena/api:master"',
		);
	});

	it('should export the Frame to the filesystem', async () => {
		// export the Frame to the filesystem...
		await exportAdapters.filesystem(tempDir).export(frame);

		// make sure the files exist...
		for (const file of ['docker-compose.yml', 'certs/balena-root-ca.pem']) {
			const filePath = path.join(tempDir, file);
			expect(await fs.exists(filePath)).to.equal(true);
		}
	});
});