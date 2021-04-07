package katapult

import (
	"github.com/product-os/katapult/cue/contract"
)

environments: contract.environments

environments: {
	"balena-compose": {
		slug:    "balena-compose"
		type:    "environment"
		version: "v0.1"
		requires: [
			{type: "sw.balena-cli"},
		]
		provides: [
			{type: "net.load-balancer", slug: "open-balena-haproxy", version:   "2.11.3"},
			{type: "net.dns", slug:           "balena-mdns-publisher", version: "master"},
		]
	}
}
