#Animal: {
	data: {...}
}

#Dog: #Animal & {// conjunction inherit open/closed constraints

	#Animal// "embed" does not inherit constraints

	data: close({// Required to close #Animal.data
		hasBone: bool
	})

	hello: "world" // not allowed since #Animal is closed
}

puppy: #Dog & {
	data: {
		hasCollar: true
	}

	anything: "baby!" // not allowed since #Animal is closed
}
