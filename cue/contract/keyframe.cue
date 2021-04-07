package contract

#Keyframe: #Contract & {
	type:    "keyframe"
	version: "1.0.0"
	data:    close({
		children: [string]: #Contract
		links: [string]: [string]: string
	})
}
