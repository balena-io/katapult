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
import * as yaml from 'js-yaml';

describe.only('generate-cue with examples', () => {
	test
		.stdout()
		.command(['generate-cue', '-k', '!examples', '-t', 'kubernetes'])
		.it('should generate k8s frame', ctx => {
			const res = yaml.loadAll(ctx.stdout);
			expect(res).to.be.an('Array');

			console.log('Generated specs:', res);

			// The assertions here are based on example packages in cue folder.
			// See cue/contract/example and cue/keyframe/example.

			const deploymentNames = res
				.filter(r => r.kind === 'Deployment')
				.map(d => d.metadata.name);
			const serviceNames = res
				.filter(r => r.kind === 'Service')
				.map(d => d.metadata.name);

			const allComponents = [
				'balena-ui',
				'balena-api',
				'balena-git',
				'balena-data',
				'redis',
			];
			const serviceComponents = [
				'balena-ui',
				'balena-api',
				'balena-git',
				'balena-data',
			];

			expect(deploymentNames.sort()).to.be.deep.equal(serviceComponents.sort());
			expect(serviceNames.sort()).to.be.deep.equal(serviceComponents.sort());

			// UI should have 2 ports exposed. While other services have only one (https).
			expect(
				res.filter(
					r => r.kind === 'Service' && r.metadata.name === 'balena-ui',
				)[0].spec.ports,
			).to.have.length(2);
			expect(
				res.filter(
					r => r.kind === 'Service' && r.metadata.name === 'balena-api',
				)[0].spec.ports,
			).to.have.length(1);
		});
});
