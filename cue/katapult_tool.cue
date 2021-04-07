package katapult

import (
	"encoding/yaml"
	"list"
	"tool/cli"
	"tool/exec"
)

k8sAll: {
	let allNamespaced = [ for nsData in k8sData.d for kindData in nsData for spec in kindData {spec}]
	let namespaces = [ for spec in k8sData.namespace {spec}]
	data: list.FlattenN([namespaces, allNamespaced], 2)
}

command: dumpK8s: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(k8sAll.data)
	}
}

command: k8sApply: {
	task: apply: exec.Run & {
		cmd: ["kubectl", "apply", "-f", "-"]
		stdin: yaml.MarshalStream(k8sAll.data)
	}
}

command: dumpContracts: {
	task: print: cli.Print & {
		let selectedContracts = [ for c in contracts {c}]
		text: yaml.MarshalStream(selectedContracts)
	}
}

command: dumpKeyframes: {
	task: print: cli.Print & {
		let selectedKeyframes = [ for k in keyframes {k}]
		text: yaml.MarshalStream(selectedKeyframes)
	}
}

command: dumpCompose: {
	task: print: cli.Print & {
		let selectedKeyframes = [ for k in keyframes {k}]
		text: yaml.MarshalStream(selectedKeyframes)
	}
}

command: printCompose: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(composes)
	}
}
