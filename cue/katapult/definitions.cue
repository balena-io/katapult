import (
	"github.com/product-os/katapult/cue/contract"
)

#SwContainerizedService: contract.#Contract & {
	type: "sw.containerized-service"
	data: close({
		command?: string | [...string]
		restart:  *"no" | "always" | "on-failure" | "unless-stopped"
		replicas: *1 | number
		assets: {
			image: {
				url: string
			}
			repo: {
				https: string
				ssh:   string
			}
		}
	})
}

#CapabilitiesRef: contract.#Ref & {
	type: "capabilities"
	data: close({
		add: [...string]
		drop: [...string]
	})
}

#SecurityOptRef: contract.#Ref & {
	type: "security_opt"
	data: close({
		labels: [...string]
	})
}

#TmpfsRef: contract.#Ref & {
	type: "tmpfs"
	data: close({
		paths: [...string]
	})
}

#LabelRef: contract.#Ref & {
	type: "label"
	data: close({
		labels: [...string]
	})
}

#DiskRef: contract.#Ref & {
	type: "disk"
	data: close({
		name:     string
		target:   string
		readonly: string
	})
}

#HealthcheckRef: contract.#Ref & {
	type: "healthcheck"
	data: close({
		interval: string
		retries:  number
		timeout:  string
		test: [...string]
	})
}

#AliasesRef: contract.#Ref & {
	type: "aliases"
	data: close({
		aliases: [...string]
	})
}

#PortsRef: contract.#Ref & {
	type: "ports"
	data: close({
		ports: [...string]
	})
}
