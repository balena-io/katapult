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
import * as _ from 'lodash';

import { ConfigStoreError, ValidationError } from '../../error-types';
import { reduce, replace } from 'lodash';
import { ConfigManifest } from '../config-manifest/config-manifest';
import { ConfigMap, ConfigStore } from '../config-store/config-store';
import { validateConfig } from '../config-validator';

interface ConfigurationManagerArgs {
	configManifest: ConfigManifest;
	configStore: ConfigStore;
	configMap: ConfigMap;
	mode?: string;
}

interface ConfigurationManagerCreateArgs {
	configManifest: ConfigManifest;
	configStore: ConfigStore;
	configMap?: ConfigMap;
	mode?: string;
}
type ErrorMap = _.Dictionary<ValidationError>;

/**
 * ConfigurationManager class
 * Used for managing configuration stored in a config store, using a config-manifest schema.
 * Depending on the mode, invalid configuration may be autogenerated, inquired or raise an error.
 */
export class ConfigurationManager {
	/**
	 * Creates ConfigurationManager using:
	 * @param {ConfigurationManagerCreateArgs} args
	 * @returns {Promise<ConfigurationManager>}
	 */
	static async create(
		args: ConfigurationManagerCreateArgs,
	): Promise<ConfigurationManager> {
		const {
			configManifest,
			configStore,
			configMap,
			mode = 'interactive',
		} = args;

		return new ConfigurationManager({
			configManifest,
			configStore,
			configMap: configMap || (await configStore.list()),
			mode,
		});
	}

	private readonly configManifest: ConfigManifest;
	private readonly mode: string;
	private configMap: ConfigMap;
	private configStore: ConfigStore;

	/**
	 * ConfigurationManager constructor
	 * @param {ConfigurationManagerArgs} args
	 */
	public constructor(args: ConfigurationManagerArgs) {
		const {
			configManifest,
			configStore,
			configMap,
			mode = 'interactive',
		} = args;
		this.configManifest = configManifest;
		this.configStore = configStore;
		this.configMap = configMap;
		this.mode = mode;
	}

	/**
	 * Syncs config-store with config-manifest returning a ConfigMap of result configuration
	 * @returns {Promise<ConfigMap>}
	 */
	public async sync(): Promise<ConfigMap> {
		const invalidProperties = this.validateConfigMap();

		if (_.size(invalidProperties) > 0) {
			let errorString =
				'Required properties are missing from the config store:\n';
			for (const property in invalidProperties) {
				errorString += `  - ${invalidProperties[property].property}\n`;
			}
			throw new ConfigStoreError(errorString);
		}

		return await this.configStore.updateMany(this.configMap);
	}

	/**
	 * Validates this.configMap against this.configManifest
	 * @returns {ErrorMap}
	 */
	private validateConfigMap(): ErrorMap {
		const errors = validateConfig({
			configMap: this.configMap,
			configManifest: this.configManifest,
			throwErrors: false,
		});
		return _.mapKeys(errors, e => replace(e.property, /^instance\./g, ''));
	}
}
