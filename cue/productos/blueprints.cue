package productos

blueprints: "product-os": {
	data: {
		selector: [
			{as: "api", slug:      "jellyfish-api"},
			{as: "livechat", slug: "jellyfish-livechat"},
			{as: "postgres", slug: "open-balena-db", version: "4.1.0"}, // TODO: allow for managed postgres in some environments
			{as: "redis", slug:    "balena-redis", version:   "0.0.3"}, // TODO: allow for managed redis in some environments
			{as: "tick", slug:     "jellyfish-tick-server"},
			{as: "ui", slug:       "jellyfish-ui"},
			{as: "worker", slug:   "jellyfish-action-server"},
		]
		links: {
			"api": "postgres":    "postgres"
			"api": "redis":       "redis"
			"api": "tick":        "tick"
			"api": "worker":      "worker"
			"livechat": "api":    "api"
			"tick": "postgres":   "postgres"
			"tick": "redis":      "redis"
			"worker": "postgres": "postgres"
			"worker": "redis":    "redis"
			"ui": "api":          "api"
			"postgres": {}
			"redis": {}
		}
	}
}
