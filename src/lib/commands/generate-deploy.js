'use strict'

const _ = require('lodash')
const path = require('path')
const deploySpec = require('../controllers/deploy-spec')
const { validateEnvironmentConfiguration } = require('../utils')
const deployAdapters = require('../controllers/deploy-adapters/all')
const deploySpecAdapters = require('../controllers/deploy-spec-adapters/all')
const { loadFromJSONFileOrNull } = require('../utils')

module.exports = args => {
	const {
		target,
		configuration,
		environment,
		mode = 'defensive',
		deploy = false,
		keyframe = path.join(process.cwd(), 'keyframe.json'),
		buildComponents,
		verbose = false,
	} = args

	// Validate and process environment info
	return validateEnvironmentConfiguration(configuration, environment)
		.then(environmentObj => {
			if (target) {
				if (!_.has(deploySpecAdapters, target)) {
					throw new Error(
						'Target not implemented. \nAvailable options: ' +
							String(_.keys(deployAdapters)),
					)
				}
				environmentObj = _.pick(environmentObj, [
					target,
					'archive-store',
					'version',
				])
			}

			return loadFromJSONFileOrNull(keyframe).then(kf => {
				return new deploySpec(
					environment,
					environmentObj,
					configuration,
					kf,
					mode,
					buildComponents,
				)
					.generate()
					.then(() => {
						if (deploy) {
							return new deployAdapters[target](
								environment,
								environmentObj,
							).run()
						}
					})
			})
		})
		.then(() => {
			console.log('Done...')
		})
}