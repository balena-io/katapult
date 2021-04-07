package katapult

import (
	"github.com/product-os/katapult/cue/productos"
)

contracts:  productos.contracts
blueprints: productos.blueprints

input: {
	product: {
		slug: "product-os"
		data: children: {
			"api": config: {
				REGISTRY_TOKEN_AUTH_CERT_KEY: value: ""
				REGISTRY_TOKEN_AUTH_CERT_KID: value: ""
			}
			"worker": data: {
				replicas: input.config.WORKERS
			}
		}
	}
	environment: {
		slug: "balena-compose"
		data: {
			children: {
				"mdns": {
					config: {
						MDNS_TLD: {value: "ly.fish.local"}
						MDNS_SUBDOMAINS: {value: "[\"jel\", \"livechat\", \"api\", \"registry\"]"}

						DBUS_SESSION_BUS_ADDRESS: {value: "unix:path=/host/run/dbus/system_bus_socket"}
						CONFD_BACKEND: {value: "ENV"}
					}
				}
				"haproxy": {
					requires: [
						{type: "aliases", data: {aliases: [ "jel.ly.fish.local", "livechat.ly.fish.local", "api.ly.fish.local", "postgres.ly.fish.local", "redis.ly.fish.local"]}},
						{type: "ports", data: {ports: [ "80:80", "5432:5432", "6379:6379"]}},
						...,
					]
					config: {
						DOMAIN_INC_UUID: {value: "false"}
						AUTOGENERATE_CERTS: {value: "false"}
						AUTH_TOKEN: {value: input.config.AUTH_TOKEN}
						STATIC_DNS_IP: {value: input.config.IP}
						CONFD_BACKEND: {value: "ENV"}
						PROXY_CONFIG: {value: "ewoJImRlZmF1bHRzIjogWwoJCSJ0aW1lb3V0IGNvbm5lY3QgNTAwMCIsCgkJInRpbWVvdXQgY2xpZW50IDYwMDAwIiwKCQkidGltZW91dCBzZXJ2ZXIgNjAwMDAiLAoJCSJkZWZhdWx0LXNlcnZlciBpbml0LWFkZHIgbGFzdCxsaWJjLG5vbmUiCgldLAoJInJlc29sdmVycyI6IFsKCQl7CgkJCSJpZCI6ICJkb2NrZXItYnJpZGdlLXJlc29sdmVyIiwKCQkJIm5hbWVzZXJ2ZXJzIjogewoJCQkJImRvY2tlci1yZXNvbHZlciI6ICIxMjcuMC4wLjExOjUzIgoJCQl9LAoJCQkiaG9sZCI6IHsKCQkJCSJ2YWxpZCI6ICIwbXMiCgkJCX0KCQl9CgldLAoJInVpIjogewoJCSJiYWNrZW5kIjogWwoJCQl7CgkJCQkidXJsIjogImh0dHA6Ly91aTo4MCIsCgkJCQkic2VydmVyIjogewoJCQkJCSJyZXNvbHZlcnMiOiAiZG9ja2VyLWJyaWRnZS1yZXNvbHZlciIsCgkJCQkJInJlc29sdmUtcHJlZmVyIjogImlwdjQiLAoJCQkJCSJjaGVjayI6IG51bGwsCgkJCQkJInBvcnQiOiAiPHBvcnQ+IgoJCQkJfQoJCQl9CgkJXSwKCQkiZnJvbnRlbmQiOiBbCgkJCXsKCQkJCSJwcm90b2NvbCI6ICJodHRwIiwKCQkJCSJkb21haW4iOiAibHkuZmlzaC5sb2NhbCIsCgkJCQkic3ViZG9tYWluIjogImplbCIsCgkJCQkicG9ydCI6ICI4MCIKCQkJfQoJCV0KCX0sCgkicmVkaXMiOiB7CgkJImJhY2tlbmQiOiBbCgkJCXsKCQkJCSJ1cmwiOiAidGNwOi8vcmVkaXM6NjM3OSIsCgkJCQkic2VydmVyIjogewoJCQkJCSJyZXNvbHZlcnMiOiAiZG9ja2VyLWJyaWRnZS1yZXNvbHZlciIsCgkJCQkJInJlc29sdmUtcHJlZmVyIjogImlwdjQiLAoJCQkJCSJjaGVjayI6IG51bGwsCgkJCQkJInBvcnQiOiAiPHBvcnQ+IgoJCQkJfQoJCQl9CgkJXSwKCQkiZnJvbnRlbmQiOiBbCgkJCXsKCQkJCSJwcm90b2NvbCI6ICJ0Y3AiLAoJCQkJImRvbWFpbiI6ICJseS5maXNoLmxvY2FsIiwKCQkJCSJzdWJkb21haW4iOiAicmVkaXMiLAoJCQkJInBvcnQiOiAiNjM3OSIKCQkJfQoJCV0KCX0sCgkicG9zdGdyZXMiOiB7CgkJImJhY2tlbmQiOiBbCgkJCXsKCQkJCSJ1cmwiOiAidGNwOi8vcG9zdGdyZXM6NTQzMiIsCgkJCQkic2VydmVyIjogewoJCQkJCSJyZXNvbHZlcnMiOiAiZG9ja2VyLWJyaWRnZS1yZXNvbHZlciIsCgkJCQkJInJlc29sdmUtcHJlZmVyIjogImlwdjQiLAoJCQkJCSJjaGVjayI6IG51bGwsCgkJCQkJInBvcnQiOiAiPHBvcnQ+IgoJCQkJfQoJCQl9CgkJXSwKCQkiZnJvbnRlbmQiOiBbCgkJCXsKCQkJCSJwcm90b2NvbCI6ICJ0Y3AiLAoJCQkJImRvbWFpbiI6ICJseS5maXNoLmxvY2FsIiwKCQkJCSJzdWJkb21haW4iOiAicG9zdGdyZXMiLAoJCQkJInBvcnQiOiAiNTQzMiIKCQkJfQoJCV0KCX0sCgkibGl2ZWNoYXQiOiB7CgkJImJhY2tlbmQiOiBbCgkJCXsKCQkJCSJ1cmwiOiAiaHR0cDovL2xpdmVjaGF0OjgwIiwKCQkJCSJzZXJ2ZXIiOiB7CgkJCQkJInJlc29sdmVycyI6ICJkb2NrZXItYnJpZGdlLXJlc29sdmVyIiwKCQkJCQkicmVzb2x2ZS1wcmVmZXIiOiAiaXB2NCIsCgkJCQkJImNoZWNrIjogbnVsbCwKCQkJCQkicG9ydCI6ICI8cG9ydD4iCgkJCQl9CgkJCX0KCQldLAoJCSJmcm9udGVuZCI6IFsKCQkJewoJCQkJInByb3RvY29sIjogImh0dHAiLAoJCQkJImRvbWFpbiI6ICJseS5maXNoLmxvY2FsIiwKCQkJCSJzdWJkb21haW4iOiAibGl2ZWNoYXQiLAoJCQkJInBvcnQiOiAiODAiCgkJCX0KCQldCgl9LAoJImFwaSI6IHsKCQkiYmFja2VuZCI6IFsKCQkJewoJCQkJInVybCI6ICJodHRwOi8vYXBpOjgwIiwKCQkJCSJzZXJ2ZXIiOiB7CgkJCQkJInJlc29sdmVycyI6ICJkb2NrZXItYnJpZGdlLXJlc29sdmVyIiwKCQkJCQkicmVzb2x2ZS1wcmVmZXIiOiAiaXB2NCIsCgkJCQkJImNoZWNrIjogbnVsbCwKCQkJCQkicG9ydCI6ICI8cG9ydD4iCgkJCQl9CgkJCX0KCQldLAoJCSJmcm9udGVuZCI6IFsKCQkJewoJCQkJInByb3RvY29sIjogImh0dHAiLAoJCQkJImRvbWFpbiI6ICJseS5maXNoLmxvY2FsIiwKCQkJCSJzdWJkb21haW4iOiAiYXBpIiwKCQkJCSJwb3J0IjogIjgwIgoJCQl9CgkJXQoJfSwKCSJyZWdpc3RyeSI6IHsKCQkiYmFja2VuZCI6IFsKCQkJewoJCQkJInVybCI6ICJodHRwOi8vcmVnaXN0cnk6ODAiLAoJCQkJInNlcnZlciI6IHsKCQkJCQkicmVzb2x2ZXJzIjogImRvY2tlci1icmlkZ2UtcmVzb2x2ZXIiLAoJCQkJCSJyZXNvbHZlLXByZWZlciI6ICJpcHY0IiwKCQkJCQkiY2hlY2siOiBudWxsLAoJCQkJCSJwb3J0IjogIjxwb3J0PiIKCQkJCX0KCQkJfQoJCV0sCgkJImZyb250ZW5kIjogWwoJCQl7CgkJCQkicHJvdG9jb2wiOiAiaHR0cCIsCgkJCQkiZG9tYWluIjogImx5LmZpc2gubG9jYWwiLAoJCQkJInN1YmRvbWFpbiI6ICJyZWdpc3RyeSIsCgkJCQkicG9ydCI6ICI4MCIKCQkJfQoJCV0KCX0KfQoK"}
					}
				}
			}
			links: {
				"haproxy": {
					"worker":   "worker"
					"ui":       "ui"
					"tick":     "tick"
					"livechat": "livechat"
					"api":      "api"
					"mdns":     "mdns"
				}
			}
		}
	}
	config: {
		"WORKERS":    2
		"DATABASE":   "<database>"
		"AUTH_TOKEN": "<token>"
		"IP":         "<ip>"
	}
}

configs: "\(input.product.slug)": {
	data: {
		networks: internal: {}
	}
}
