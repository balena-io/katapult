package katapult

import (
	"github.com/product-os/katapult/cue/contract"
	"github.com/product-os/katapult/cue/environment"
)

contracts: [Name=string]: contract.#Contract
contracts: environment.contracts

keyframes: [Name=string]: contract.#Keyframe & {
	slug: "\(Name)-keyframe"
	data: children: [string]: contract.#SwContainerizedService
}

blueprints: [Name=string]: contract.#Blueprint & {
	slug: "\(Name)-blueprint"
}
blueprints: environment.blueprints

input: {
	product: {
		slug: string
		data: {...}
	}
	environment: {
		slug: string
		data: {...}
	}
	config: {...}
}

keyframes: "\(input.product.slug)": data:     input.product.data
keyframes: "\(input.environment.slug)": data: input.environment.data

configs: [Name=string]: contract.#Contract & {}
