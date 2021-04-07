slug: "open-balena"

command: hello: {
	task: {
		for _, contract in keyframes[slug].children {
			"\(contract.slug)": {
				cmd: ["echo", "\(contract.slug)"]
				// stdin: yaml.MarshalStream(k8sAll.data)
			}
		}
	}
}
