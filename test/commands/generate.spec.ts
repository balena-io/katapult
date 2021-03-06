/*
Copyright 2019 Balena Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
import { expect, test } from '@oclif/test';
import { getTestDir } from '../files';
import * as fs from 'mz/fs';
import * as path from 'path';
import * as temp from 'temp';

import Generate from '../../src/commands/generate';

describe('generate', () => {
	let configDir = '';
	let outputDir = '';

	before(async () => {
		configDir = await getTestDir('test-product-staging');
		outputDir = temp.track().mkdirSync();
	});

	after(() => {
		temp.cleanupSync();
	});

	test
		.stdout()
		.command(['generate'])
		.exit(2)
		.it('should exit with an error code 2 when missing required flags');

	test
		.stdout()
		.command([
			'generate',
			'-e',
			configDir,
			'-o',
			'/a-really-bad-directory',
			'-t',
			'docker-compose',
		])
		.exit(2)
		.it(
			'should exit with an error code 2 when the output directory is bad/missing',
		);

	test
		.stdout()
		.command([
			'generate',
			'-e',
			configDir,
			'-o',
			'/tmp/this-doesnt-exist',
			'-t',
			'docker-compose',
		])
		.exit(2)
		.it(
			'should exit with an error code 2 when the output directory is bad/missing',
		);

	it('should generate a Frame from a valid product repo (docker-compose)', async () => {
		expect(outputDir).to.not.equal('');

		process.env.GENERATE_TEST = 'value_from_env';

		await Generate.run([
			'-e',
			configDir,
			'-o',
			outputDir,
			'-t',
			'docker-compose',
		]);

		const templateDirectory = path.join(
			configDir,
			'product/deploy/docker-compose/templates',
		);
		const templateCheckDirectory = path.join(
			configDir,
			'product/deploy/docker-compose/templates_check',
		);

		// make sure the files exist...
		for (const file of ['docker-compose/docker-compose.yml']) {
			const filePath = path.join(outputDir, file);
			expect(await fs.exists(filePath)).to.equal(true);

			const content = await fs.readFile(filePath, 'utf8');
			expect(content).contains('value_from_env');
		}

		// make sure the tempates where correctly generated
		for (const file of ['docker-compose.yml']) {
			const filePathGenerated = path.join(templateDirectory, file);
			expect(await fs.exists(filePathGenerated)).to.equal(true);

			const generatedcontent = await fs.readFile(filePathGenerated, 'utf8');

			const filePath = path.join(templateCheckDirectory, file);
			expect(await fs.exists(filePath)).to.equal(true);

			const assertedcontent = await fs.readFile(filePath, 'utf8');

			expect(generatedcontent).to.be.equal(assertedcontent);
		}
	});
});
