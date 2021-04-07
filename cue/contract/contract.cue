package contract

// import "list"

#Base: {
	type?: string
	slug?: string
	data?: {...}
	...
}

#Ref: #Base & {
	as?:          string
	cardinality?: string
	version?:     string
}

capabilityType: [Name=string]: {
	type: Name
}

capabilityType: endpoint: {
	data: {
		port:     uint | *8000
		protocol: "TCP" | "UDP" | *"TCP"
	}
}

#Contract: {

	type:    string
	name?:   string
	as?:     string
	slug:    string
	version: string

	data: {...}
	requires: [...#Ref]
	provides: [...#Ref]
	config: [string]: {required: bool | *true, value: _}

	// Default capabilities inferred from the type.
	// if (list.Contains(ServiceTypes, type)) {
	//  provides: [...#Ref] | *[capabilityType.endpoint & {as: "main"}]
	// }
}
