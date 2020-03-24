import { expect } from '@oclif/test';
import { ConfigStore } from '../../src/lib/controllers/config-store';
import { YamlConfigStore } from '../../src/lib/controllers/config-store/adapters/yaml-config-store';

describe('productOs contracts', () => {
	// ProductOS components.

	const jfUiContract = {
		type: 'sw.containerized-service',
		slug: 'jellyfish-ui',
		requires: [{ type: 'sw.containerized-service', slug: 'jellyfish-api' }],
	};

	const jfApiContract = {
		type: 'sw.containerized-service',
		slug: 'jellyfish-api',
		requires: [
			// TODO: Why do we specify type here? Isn't slug a unique name in the universe?
			{ type: 'sw.database', slug: 'postgres-db', version: '^12.2' },
			{ type: 'sw.database', slug: 'redis', version: '^5.0' },
		],
		data: {
			// TODO: Should this be embedded or a link to config manifest file?
			// Example: https://github.com/product-os/jellyfish/blob/master/deploy-templates/jellyfish-product/product/config-manifest.yml
			'behaviour-config': [
				{ name: 'NODE_ENV', type: 'string', secret: false },
				{ name: 'LOGLEVEL', type: 'string', secret: false },
			],
		},
		provides: [{ type: 'endpoint', as: 'api-endpoint', data: { port: 8000 } }],
	};

	const jfActionServerContract = {
		type: 'sw.containerized-worker',
		slug: 'jellyfish-action-server',
		requires: [
			// Note: external services are not covered atm. Configured as behaviour for now.
			{ type: 'sw.database', slug: 'postgres-db' },
			{ type: 'sw.containerized-service', slug: 'redis' },
		],
	};

	const jfTickServerContract = {
		type: 'sw.containerized-worker',
		slug: 'jellyfish-tick-server',
		requires: [
			{ type: 'sw.database', slug: 'postgres-db' },
			{ type: 'sw.containerized-service', slug: 'redis' },
		],
	};

	const jfLivechatContract = {
		type: 'sw.containerized-service',
		slug: 'jellyfish-livechat',
		requires: [{ type: 'sw.containerized-service', slug: 'jellyfish-api' }],
	};

	// Generic components.

	const redisContract = {
		type: 'sw.database',
		slug: 'redis',
		requires: [],
	};

	const postgresDbContract = {
		type: 'sw.database',
		slug: 'postgres-db',
		requires: [],
	};

	// Classes.

	const endpoint = {
		type: 'interface',
		slug: 'endpoint',
		provides: [{ type: 'string', as: 'connection-uri' }],
	};

	const containerizedService = {
		type: 'component-class',
		slug: 'sw.containerized-service',
		provides: [{ type: 'endpoint', as: 'default-endpoint' }],
	};

	const containerizedWorker = {
		type: 'component-class',
		slug: 'sw.containerized-worker',
		// Main difference from the service: it provides nothing.
		provides: [],
	};

	const database = {
		type: 'component-class',
		// Equivalent to the service for now. But can be useful to keep it separate.
		// For instance, to underline it persists the state.
		slug: 'sw.database',
		provides: [{ type: 'endpoint', as: 'default-endpoint' }],
	};

	// The universe (we are missing versions for now).
	const universe = [
		jfApiContract,
		jfActionServerContract,
		jfTickServerContract,
		jfUiContract,
		jfLivechatContract,
		postgresDbContract,
		redisContract,
	];

	// productOS blueprint.

	// Blueprint format is changed comparing to existing examples.
	// Compare to https://github.com/balena-io/contracts/blob/11cf69c31e6895b0c5bd88ece72ca1508183125b/contracts/sw.blueprint/device-instructions/contract.json
	const productOsBlueprint = {
		type: 'blueprint',
		slug: 'productOs',

		data: {
			// Selector now queries contracts giving an instance name ("as"). Slug is used by default.
			// Selector definition is very close to requirements definition, but also allows setting the cardinality.
			// Default cardinality is 1.
			selector: [
				{
					slug: 'jellyfish-api',
					as: 'api',
					version: '^1.3.0',
					cardinality: '1',
				},
				{ slug: 'jellyfish-ui', as: 'ui' },
				{ slug: 'jellyfish-action-server', as: 'action-server' },
				{ slug: 'jellyfish-tick-server', as: 'tick-server' },
				{ slug: 'jellyfish-livechat', as: 'livechat' },
				{ slug: 'redis' },
				{ slug: 'postgres-db' },
			],

			output: {
				slug: 'productOs-keyframe',
				// TODO: Agree on the typ here.
				// type: '?',

				data: {
					// Connections define how exactly we satisfy the component requirements.
					connections: {
						// Key: instance name ("as" in "requires").
						api: {
							// Key: name from contract requirement (as or slug).
							// Value: instance name.
							redis: 'redis',
							'postgres-db': 'postgres-db',
						},
						ui: {
							'jellyfish-api': 'api',
						},
						'action-server': {
							redis: 'redis',
							'postgres-db': 'postgres-db',
						},
						'tick-server': {
							redis: 'redis',
							'postgres-db': 'postgres-db',
						},
						livechat: {
							'jellyfish-api': 'api',
						},
					},

					'behaviour-config': [
						{ name: 'api.replicas', type: 'int' },
						// ...
					],

					// TODO: Discuss scaling.
					scaling: {
						api: {
							type: 'static',
							count: 'api.replicas',
						},
					},
				},
			},
		},
	};

	const keyframe = contrato(productOsBlueprint, universe);

	it('provides a valid keyframe', () => {
		expect(keyframe).to.deep.equal({
			type: 'keyframe',
			slug: 'productOs-keyframe',
			version: 'TODO',

			// From selector in the blueprint. Also, defines the instance names.
			requires: [
				{
					type: 'sw.containerized-service',
					slug: 'jellyfish-api',
					version: 'TODO',
					as: 'api',
				},
				{
					type: 'sw.containerized-service',
					slug: 'jellyfish-ui',
					version: 'TODO',
					as: 'ui',
				},
				{
					type: 'sw.containerized-worker',
					slug: 'jellyfish-action-server',
					version: 'TODO',
					as: 'action-server',
				},
				{
					type: 'sw.containerized-worker',
					slug: 'jellyfish-tick-server',
					version: 'TODO',
					as: 'tick-server',
				},
				{
					type: 'sw.containerized-service',
					slug: 'jellyfish-livechat',
					version: 'TODO',
					as: 'livechat',
				},
				{ type: 'sw.database', slug: 'redis', version: 'TODO', as: 'redis' },
				{
					type: 'sw.database',
					slug: 'postgres-db',
					version: 'TODO',
					as: 'postgres-db',
				},
			],

			data: {
				connections: productOsBlueprint.data.output.data.connections,
				scaling: productOsBlueprint.data.output.data.scaling,
				'behaviour-config':
					productOsBlueprint.data.output.data['behaviour-config'],
			},
		});
	});

	describe('k8s specs', () => {
		const configStore = new YamlConfigStore({
			yamlFile: { path: 'example-config.yaml' },
		});
		const k8sSpecs = katapult(keyframe, configStore);

		it('includes the namespace spec', () => {
			expect(k8sSpecs.namespace).to.have.length(1);
			expect(k8sSpecs.namespace[0]).to.be.deep.equal({
				apiVersion: 'app/v1',
				kind: 'Namespace',
				metadata: {
					name: 'productOs',
				},
			});
		});

		it('have correct deployment definitions', () => {
			expect(k8sSpecs.deployments).to.have.length(5);

			// Check jellyfish-api deployment.
			expect(k8sSpecs.deployments[0]).to.deep.equal({
				apiVersion: 'app/v1', // TODO: What is a good value here for us?
				kind: 'Deployment', // Per component type (sw.containerized-service or sw.containerized-worker).

				metadata: {
					namespace: 'productOs', // TODO: Resolve the slug/name question. Where exactly does this come from?
					name: 'api', // Instance name.
				},

				spec: {
					replicas: 4, // Taken from the keyframe behaviour config.

					selector: {
						matchLabels: {
							'app.kubernetes.io/name': 'api', // Instance name.
						},
					},

					template: {
						metadata: {
							labels: {
								// Matches the selector above.
								'app.kubernetes.io/name': 'api', // Instance name.
							},
						},

						spec: {
							// TODO: We need to agree on how we manage service accounts and roles in k8s.
							// 			 The attribute bellow is not required if wee see a serviceAccount on a pod and specify pull
							//			 to this account.
							imagePullSecrets: {},
							// TODO: If we set service accounts, do we have them per service, or is there a shared account?
							//       In the former case, katapult should generate the accounts as well.
							serviceAccountName: 'api',

							containers: [
								{
									name: 'api', // Instance name.
									imagePullPolicy: 'always', // TODO: Do we get if from the keyframe behaviour config? What is the default?
									image: 'balena/jellyfish-api:vTODO', // TODO: Registry here does not match the product/namespace.

									// jellyfish-api has explicit definition of "provides", and it includes an endpoint. The data below
									// is derived from it. See jellyfish-ui deployment for an implicit provides example.
									ports: [
										{
											name: 'api-endpoint',
											containerPort: 8000,
											protocol: 'TCP',
										},
									],
									readinessProbe: {
										httpGet: {
											path: '/health',
											port: 'api-endpoint',
											scheme: 'http',
										},
									},
									// TODO: Add livenessProbe.

									env: [
										// From behaviour config.
										{
											name: 'NODE_ENV',
											valueFrom: {
												configMapRef: {
													name: 'api-config',
													key: 'behaviour.NODE_ENV',
												},
											},
										},
										{
											name: 'LOGLEVEL',
											valueFrom: {
												configMapRef: {
													name: 'api-config',
													key: 'behaviour.LOGLEVEL',
												},
											},
										},
										// From requirements.
										{
											name:
												'integration.postgres-db.default-endpoint.connection-uri',
											// In this example, poostgres is defined as a sw.database.
											// Katapult k8s adapter does not kow how to handle it (as a opposed to sw.containerized-{something}),
											// so it falls back to declaring a secret reference according to the capabilities defined by sw.database.
											valueFrom: {
												secretKeyRef: {
													name: 'api-config',
													key:
														'integration.postgres-db.default-endpoint.connection-uri',
												},
											},
										},
										{
											name: 'integration.redis.default-endpoint.connection-uri',
											valueFrom: {
												secretKeyRef: {
													name: 'api-config',
													key:
														'integration.redis.default-endpoint.connection-uri',
												},
											},
										},
									],
								},
							],
						},
					},
				},
			});

			// Check jellyfish-ui deployment.
			expect(k8sSpecs.deployments[1]).to.deep.equal({
				apiVersion: 'app/v1',
				kind: 'Deployment',

				metadata: {
					namespace: 'productOs',
					name: 'ui',
				},

				spec: {
					replicas: 4,

					selector: {
						matchLabels: {
							'app.kubernetes.io/name': 'ui',
						},
					},

					template: {
						metadata: {
							labels: {
								'app.kubernetes.io/name': 'api',
							},
						},

						spec: {
							containers: [
								{
									name: 'ui',
									imagePullPolicy: 'always',
									image: 'balena/jellyfish-ui:vTODO',

									// jellyfish-ui contract has type sw.containerized-service which provides an endpoint, which defines
									// what goes below.
									ports: [
										{
											name: 'default-endpoint',
											containerPort: 80,
											protocol: 'TCP',
										},
									],
									readinessProbe: {
										httpGet: {
											path: '/health',
											port: 'default-endpoint',
											scheme: 'http',
										},
									},
									// TODO: Add livenessProbe.

									env: [
										// From requirements.
										{
											// Name pattern: integration.{name from "contract.requires"}.{expand what is defined by the type of the dependency}
											name:
												'integration.jellyfish-api.api-endpoint.connection-uri',
											// jellyfish-api dependency of ui is handled by connections in the blueprinnt.
											// katapult is responsible for declaring a service for jeellyfish-api and sets the value according to
											// the service name.
											value: 'http://api',
										},
									],
								},
							],
						},
					},
				},
			});
		});

		it('hav correct service definitions', () => {
			// Check jellyfish-api service.
			expect(k8sSpecs.services[0]).to.deep.equal({
				apiVersion: 'app/v1',
				kind: 'Service',

				metadata: {
					namespace: 'productOs',
					name: 'api',
				},

				spec: {
					type: 'LoadBalancer', // TODO: Where does this come from?
					selector: {
						'app.kubernetes.io/name': 'api',
					},
					ports: [
						{
							name: 'api-endpoint',
							port: 443,
							protocol: 'TCP',
							targetPort: 'api-endpoint',
						},
					],
				},
			});
		});

		// Current k8s resources of productOS.
		//
		// Services:
		// - jellyfish-api
		// - jellyfish-livechat
		// - jellyfish-ui
		// - redis
		//
		// Deployments:
		// - action-server
		// - jellyfish
		// - jellyfish-livechat
		// - jellyfish-ui
		// - redis
		// - tick-server
		//
		// Ingress:
		// - livechat
		// - jellyfish-api
		// - jellyfish-ui
	});
});

const katapult = (keyframe: any, configStore: ConfigStore) => ({
	namespace: [],
	deployments: [],
	services: [],
	ingress: [],
	jobs: [],
});

const contrato = (blueprint: any, contractsUniverse: any) => {
	throw new Error('TODO');
};
