package environment

contracts: {
	"open-balena-haproxy": {
		slug:    "balena-haproxy"
		type:    "sw.containerized-service"
		version: "2.11.3"
		data: {
			assets: {
				image: url: "balena/open-balena-haproxy:\(version)"
				repo: {
					ssh:   "git@github.com:balena-io/open-balena-haproxy.git"
					https: "https://github.com/balena-io/open-balena-haproxy"
				}
			}
			restart: "always"
		}
		requires: [
			{type: "aliases", data: {aliases: [...string]}},
			{type: "ports", data: {ports: [...string]}},
			{type: "capabilities", data: {add: ["SYS_RESOURCE", "SYS_ADMIN"], drop: []}},
			{type: "security_opt", data: {labels: ["apparmor=unconfined"]}},
			{type: "tmpfs", data: {paths: ["/run", "/sys/fs/cgroup"]}},
		]
		provides: []
		config: {
			DOMAIN_INC_UUID: value:    string
			AUTOGENERATE_CERTS: value: string
			AUTH_TOKEN: value:         string
			STATIC_DNS_IP: value:      string
			CONFD_BACKEND: value:      string
			PROXY_CONFIG: value:       string
		}
	}
	"balena-mdns-publisher": {
		slug:    "balena-mdns-publisher"
		type:    "sw.containerized-service"
		version: "master"
		data: {
			assets: {
				image: url: "balena/balena-mdns-publisher:\(version)"
				repo: {
					ssh:   "git@github.com:balena-io/balena-mdns-publisher.git"
					https: "https://github.com/balena-io/balena-mdns-publisher.git"
				}
			}
			restart: "always"
		}
		requires: [
			{type: "network_mode", data: {value: "host"}},
			{type: "capabilities", data: {add: ["SYS_RESOURCE", "SYS_ADMIN"], drop: []}},
			{type: "security_opt", data: {labels: ["apparmor=unconfined"]}},
			{type: "tmpfs", data: {paths: ["/run", "/sys/fs/cgroup"]}},
			{type: "label", data: {labels: ["io.balena.features.dbus=1", "io.balena.features.supervisor-api=1"]}},
		]
		config: {
			MDNS_TLD: {value: string}
			MDNS_SUBDOMAINS: {value: string}
			DBUS_SESSION_BUS_ADDRESS: {value: string}
			CONFD_BACKEND: {value: string}
		}
	}
}
