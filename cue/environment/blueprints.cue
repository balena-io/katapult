package environment

blueprints: "balena-compose": {
	data: {
		selector: [
			{as: "haproxy", slug: "open-balena-haproxy"},
			{as: "mdns", slug:    "balena-mdns-publisher"},
		]
	}
}
