package katapult

import (
	"encoding/yaml"
	"tool/cli"
)

command: printCompose: {
	task: print: cli.Print & {
		text: yaml.MarshalStream([configs[input.product.slug].data])
	}
}
