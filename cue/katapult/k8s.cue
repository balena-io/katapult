package katapult

import (
	"list"

	"github.com/product-os/katapult/cue/contract"
	"github.com/product-os/katapult/cue/adapter/k8s"
	"github.com/product-os/katapult/cue/adapter/k8s/aws"
)

contracts: {...}
keyframes: {...}

k8sData: k8s.Data & aws.Data

k8sData: d: [Namespace=string]: {
	for componentRef in keyframes[Namespace].children {
		let component = contracts[componentRef.slug]
		let componentType = component.type

		let versionMetadata = {
			metadata: labels: "app.kubernetes.io/version": componentRef.version
		}

		// Services for corresponding component types.
		if (list.Contains(contract.ServiceTypes, componentType)) {
			serviceAccount: "\(componentRef.as)": versionMetadata

			service: {
				let httpExposedTypes = [
					"sw.containerized-web-service",
				]

				"\(componentRef.as)": versionMetadata

				"\(componentRef.as)": spec: {
					let httpsPorts = [
						for capability in component.provides if capability.type == "endpoint" && capability.as == "main" {
							name:       "https"
							port:       443
							targetPort: capability.as
							protocol:   capability.data.protocol | *"TCP"
						},
					]
					let httpPorts = [ if list.Contains(httpExposedTypes, componentType) {
						name:       "http"
						port:       80
						targetPort: "main" // TODO: Derive from the capability.
						protocol:   "TCP"
					},
					]
					ports: list.FlattenN([httpsPorts, httpPorts], 2)
				}
			}
		}

		// Deployment per service component.
		if (list.Contains(contract.ServiceTypes, componentType)) {
			deployment: {
				"\(componentRef.as)": versionMetadata & {
					spec: template: spec: containers: [{
						image: "balena/\(component.slug):\(componentRef.version)"
						ports: [ for capability in component.provides if capability.type == "endpoint" {
							containerPort: capability.data.port
							name:          capability.as
							protocol:      capability.data.protocol | *"TCP"
						},
						]
					}]
				}
			}
		}
	}
}

configData: [Namespace=string]: {
	for componentRef in keyframes[Namespace].children {
		"\(componentRef.as)": {
			behaviour: {}
			integration: {}
		}
	}
}

// Namespaces per product keyframe.
for name, k in keyframes {
	k8sData: namespace: "\(name)": {}
	k8sData: d: "\(name)": {}
	configData: "\(name)": {}
}
