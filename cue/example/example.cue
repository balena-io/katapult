package example

import (
	"github.com/product-os/katapult/cue/contract"
)

contracts: {
	"balena-ui": {
		type: "sw.containerized-web-service"
		requires: [
			{slug: "balena-api"},
			{slug: "balena-data"},
		]
		// TODO: Work on the config.
		//  config: [
		//      {name: "LOG_LEVEL", required: false, value: "error" | "debug" | "info"}
		//  ]
	}

	"balena-api": {
		type: "sw.containerized-scalable-service"
		requires: [{slug: "redis"}]
		provides: [
			{type: "endpoint", data: {port: 80}, as:   "main"},
			{type: "endpoint", data: {port: 8000}, as: "metrics"},
		]
	}

	"balena-git": {
		type: "sw.containerized-service"
		requires: [{type: "hw.disk", data: {path: "/mnt/git-data"}, as: "disk"}]
	}

	"balena-data": {
		type: "sw.containerized-scalable-service"
		requires: [{slug: "redis"}]
	}

	"redis": {
		type: "sw.datastore"
	}
}

blueprints: "balena-cloud": {
	data: selector: [
		{slug: "balena-api", as:       "api", version: "^1.3.0", cardinality: "1"},
		{slug: "balena-ui", as:        "ui"},
		{slug: "balena-data", as:      "data"},
		{slug: "balena-git", as:       "git"},
		{type: "hw.disk", cardinality: "*", as: "git-volume"},
		{slug: "redis", as:            "api-redis"},
		{slug: "redis", as:            "data-redis"},
	]
	data: links: {
		ui: {
			"balena-api":  "balena-api"
			"balena-data": "data"
		}
		"balena-api": {
			"redis": "api-redis"
		}
		data: {
			"redis": "data-redis"
		}
		git: {
			"disk": "git-volume"
		}
	}
}

keyframes: "balena-cloud": {
	children: [
		{slug: "balena-api", version:  "v1.2.3", type: "sw.containerized-scaled-service"},
		{slug: "balena-ui", version:   "v2.2.3", type: "sw.containerized-scaled-service"},
		{slug: "balena-data", version: "v3.2.3", type: "sw.containerized-scaled-service"},
		{slug: "balena-git", version:  "v4.2.3", type: "sw.containerized-service"},
		// {slug: "ebs-disk", version:    "v5.2.3", type: "hw.disk", as:      "git-volume"},
		{slug: "redis", version: "v6.2.3", type: "sw.datastore", as: "api-redis"},
		{slug: "redis", version: "v7.2.3", type: "sw.datastore", as: "data-redis"},
	]
	links: {
		"balena-ui": {
			"balena-api": "balena-api"
		}
		"balena-api": {
			"redis": "api-redis"
		}
		"balena-data": {
			"redis": "data-redis"
		}
		"balena-git": {
			"disk": "git-volume"
		}
	}
}
