package k8s

// TODO: Import from k8s API.
#namespace: string
#Base: {
	apiVersion: string
	kind:       "Deployment" | "Service" | "ConfigMap" | "SealedSecret" | "ServiceAccount" | "Namespace"
	metadata: {
		name: string
		...
	}
	...
}
#Namespaced: #Base & {
	metadata: namespace: string
}
#ServicePort: {
	name:       string
	port:       number
	protocol:   "TCP" | "UDP"
	targetPort: string
}
