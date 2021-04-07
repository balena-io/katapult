package katapult

import (
	"tool/exec"
	"tool/cli"
	"path"
	// "encoding/yaml"
	// "encoding/json"
)

var: {
	component: *"" | string @tag(component)
}

let slug = "\(input.product.slug)-\(var.component)"
let srcpath = path.Join(["./src/", var.component])
let contract = keyframeComponentBySlug[slug]

command: clone: {

	task: init: {
		cli.Print & {text: "Cloning \(input.product.slug) component \(var.component) into \(srcpath)..."}
	}

	task: pull: {
		if keyframeComponentBySlug[slug] != _|_ {
			exec.Run & {
				cmd: ["git", "clone", contract.data.assets.repo.ssh, srcpath]
			}
		}
		if keyframeComponentBySlug[slug] == _|_ {
			cli.Print & {text: "keyframe \(input.product.slug) component \(var.component) does not exist"}
		}
	}
}

command: pull: {

	task: {
		init: cli.Print & {text: "Pulling \(input.product.slug) component \(var.component)..."}

		if keyframeComponentBySlug[slug] != _|_ {
			pull: exec.Run & {
				cmd: ["git", "-C", srcpath, "pull"]
			}
		}

		if keyframeComponentBySlug[slug] == _|_ {
			task: error: cli.Print & {
				text: "keyframe \(input.product.slug) component \(var.component) does not exist"
			}
		}
	}
}
