package k8s

import (
	"strings"
)

Data: close({
	namespace: [string]: {}
	d: {}
})

// Common namespace data layout.

Data: namespace: [Name=string]: #Base & {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: name: Name
}

// Common parts of definitions that belong to a namespace.

Data: d: [Namespace=string]: [string]: [Name=string]: #Namespaced & {
	metadata: namespace: Namespace
	metadata: name:      Name
	metadata: labels: {
		"app.kubernetes.io/instance": Name
		"app.kubernetes.io/name":     Name
		"app.kubernetes.io/version":  string
	}
}

for kindName in ["deployment", "service", "serviceAccount"] {
	Data: d: [#namespace]: "\(kindName)": [string]: #Namespaced & {
		apiVersion: string | *"v1"
		kind:       strings.ToTitle(kindName)
	}
}

#containerPort: {
	containerPort: number
	name:          string
	protocol:      *"TCP" | "UDP"
}

Data: d: [#namespace]: deployment: [Name=string]: {
	apiVersion: "apps/v1"
	let labelsData = {
		"app.kubernetes.io/instance": Name
		"app.kubernetes.io/name":     Name
	}
	spec: {
		selector: matchLabels: labelsData
		template: {
			metadata: labels: labelsData
			spec: {
				terminationGracePeriodSeconds: 60
				imagePullSecrets: [{name: "image-pull-secret"}]
				serviceAccountName: Name
				containers: [{
					name:            Name
					imagePullPolicy: "IfNotPresent"
					image:           string

					ports: [...#containerPort]

					#probe: {
						httpGet: {
							path:   "/ping"
							port:   "main-endpoint"
							scheme: "HTTP"
						}
						periodSeconds: int
						...
					}
					livenessProbe: #probe & {
						initialDelaySeconds: 60
						periodSeconds:       6
						timeoutSeconds:      5
					}
					readinessProbe: #probe & {
						failureThreshold: 6
						periodSeconds:    10
					}
					// TODO: env, volumes, logging
				}]
			}
		}
	}
}

Data: d: [#namespace]: service: [Name=string]: spec: {
	type: "LoadBalancer"
	selector: {
		"app.kubernetes.io/instance": Name
		"app.kubernetes.io/name":     Name
	}
	ports: [...#ServicePort]
}
