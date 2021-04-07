package contract

#Blueprint: #Contract & {
	type:    "blueprint"
	version: "1.0.0"
	data:    close({
		selector: [...#Ref]
		links: [string]: [string]: string // source: alias: target
	})
}
