package balenaio

import (
	"github.com/product-os/katapult/cue/contract"
)

contracts: contract.contracts

contracts: {
	"open-balena-api": {
		slug:    "open-balena-api"
		type:    "sw.containerized-service"
		version: "v0.109.2"
		data: {
			image:      "balena/open-balena-api:\(version)"
			replicas:   *1 | >1 // scalable
			repository: "git@github.com:balena-io/open-balena.git"
		}
		requires: [
			{slug: "open-balena-db", type: "sw.containerized-service"},
			{slug: "open-balena-s3", type: "sw.containerized-service"},
			{slug: "redis", type:          "sw.containerized-service"},
			{type: "hw.disk", data: {name: "certs", target: "/certs", readonly: true}},
		]
		provides: []
		config: {
			API_VPN_SERVICE_API_KEY: {
				value: string
			}
			BALENA_ROOT_CA: {
				value: string
			}
			COOKIE_SESSION_SECRET: {
				value: string
			}
			DB_HOST: {
				value: "open-balena-db"
			}
			DB_PASSWORD: {
				value: "docker"
			}
			DB_PORT: {
				value: 5432
			}
			DB_USER: {
				value: "docker"
			}
			DELTA_HOST: {
				value: string
			}
			DEVICE_CONFIG_OPENVPN_CA: {
				value: string
			}
			DEVICE_CONFIG_SSH_AUTHORIZED_KEYS: {
				value: string
			}
			HOST: {
				value: string
			}
			IMAGE_MAKER_URL: {
				value: string
			}
			IMAGE_STORAGE_BUCKET: {
				value: "resin-production-img-cloudformation"
			}
			IMAGE_STORAGE_PREFIX: {
				value: "images"
			}
			IMAGE_STORAGE_ENDPOINT: {
				value: "s3.amazonaws.com"
			}
			JSON_WEB_TOKEN_EXPIRY_MINUTES: {
				value: 10080
			}
			SON_WEB_TOKEN_SECRET: {
				value: string
			}
			MIXPANEL_TOKEN: {
				value: "__unused__"
			}
			PRODUCTION_MODE: {
				value: string
			}
			PUBNUB_PUBLISH_KEY: {
				value: "__unused__"
			}
			PUBNUB_SUBSCRIBE_KEY: {
				value: "__unused__"
			}
			REDIS_HOST: {
				value: "redis"
			}
			REDIS_PORT: {
				value: 6379
			}
			REGISTRY2_HOST: {
				value: string
			}
			REGISTRY_HOST: {
				value: string
			}
			SENTRY_DSN: {
				value: ""
			}
			TOKEN_AUTH_BUILDER_TOKEN: {
				value: string
			}
			TOKEN_AUTH_CERT_ISSUER: {
				value: string
			}
			TOKEN_AUTH_CERT_KEY: {
				value: string
			}
			TOKEN_AUTH_CERT_KID: {
				value: string
			}
			TOKEN_AUTH_CERT_PUB: {
				value: string
			}
			TOKEN_AUTH_JWT_ALGO: {
				value: "ES256"
			}
			VPN_HOST: {
				value: string
			}
			VPN_PORT: {
				value: 443
			}
			VPN_SERVICE_API_KEY: {
				value: string
			}
			SUPERUSER_EMAIL: {
				value: string
			}
			SUPERUSER_PASSWORD: {
				value: string
			}
		}
	}
	"open-balena-registry": {
		slug:    "open-balena-registry"
		type:    "sw.containerized-service"
		version: "v2.13.11"
		data: {
			image:      "balena/open-balena-registry:\(version)"
			repository: "git@github.com:balena-io/open-balena-registry.git"
		}
		requires: [
			{slug: "open-balena-s3", type: "sw.containerized-service"},
			{slug: "redis", type:          "sw.containerized-service"},
		]
		config: {
			API_TOKENAUTH_CRT: {
				value: string
			}
			BALENA_REGISTRY2_HOST: {
				value: string
			}
			BALENA_ROOT_CA: {
				value: string
			}
			BALENA_TOKEN_AUTH_ISSUER: {
				value: string
			}
			BALENA_TOKEN_AUTH_REALM: {
				value: string
			}
			COMMON_REGION: {
				value: string
			}
			REGISTRY2_CACHE_ENABLED: {
				value: "false"
			}
			REGISTRY2_CACHE_ADDR: {
				value: "127.0.0.1:6379"
			}
			REGISTRY2_CACHE_DB: {
				value: 0
			}
			REGISTRY2_CACHE_MAXMEMORY_MB: {
				value: 1024
			}
			REGISTRY2_CACHE_MAXMEMORY_POLICY: {
				value: "allkeys-lru"
			}
			REGISTRY2_S3_REGION_ENDPOINT: {
				value: string
			}
			REGISTRY2_S3_BUCKET: {
				value: string
			}
			REGISTRY2_S3_KEY: {
				value: string
			}
			REGISTRY2_S3_SECRET: {
				value: string
			}
			REGISTRY2_SECRETKEY: {
				value: string
			}
			REGISTRY2_STORAGEPATH: {
				value: "/data"
			}
		}
	}
	"open-balena-vpn": {
		slug:    "open-balena-vpn"
		type:    "sw.containerized-service"
		version: "v9.16.1"
		data: {
			image:      "balena/open-balena-vpn:\(version)"
			repository: "git@github.com:balena-io/open-balena-vpn.git"
		}
		requires: [
			{slug: "open-balena-api", type: "sw.containerized-service"},
		]
		config: {
			API_SERVICE_API_KEY: {
				value: string
			}
			BALENA_API_HOST: {
				value: string
			}
			BALENA_ROOT_CA: {
				value: string
			}
			BALENA_VPN_PORT: {
				value: 443
			}
			PRODUCTION_MODE: {
				value: string
			}
			RESIN_VPN_GATEWAY: {
				value: "10.2.0.1"
			}
			SENTRY_DSN: {
				value: ""
			}
			VPN_HAPROXY_USEPROXYPROTOCOL: {
				value: "true"
			}
			VPN_OPENVPN_CA_CRT: {
				value: string
			}
			VPN_OPENVPN_SERVER_CRT: {
				value: string
			}
			VPN_OPENVPN_SERVER_DH: {
				value: string
			}
			VPN_OPENVPN_SERVER_KEY: {
				value: string
			}
			VPN_SERVICE_API_KEY: {
				value: string
			}
		}
	}
	"open-balena-db": {
		slug:    "open-balena-db"
		type:    "sw.containerized-service"
		version: "v4.1.0"
		data: {
			image:      "balena/open-balena-db:\(version)"
			repository: "git@github.com:balena-io/open-balena-db.git"
		}
		requires: [
			{slug: "open-balena-api", type: "sw.containerized-service"},
		]
		config: {}
	}
	"open-balena-s3": {
		slug:    "open-balena-s3"
		type:    "sw.containerized-service"
		version: "v2.9.9"
		data: {
			image:      "balena/open-balena-s3:\(version)"
			repository: "git@github.com:balena-io/open-balena-s3.git"
		}
		requires: [
			{slug: "open-balena-api", type: "sw.containerized-service"},
		]
		config: {
			S3_MINIO_ACCESS_KEY: {
				value: string
			}
			S3_MINIO_SECRET_KEY: {
				value: string
			}
			BUCKETS: {
				value: string
			}
		}
	}
	"redis": {
		slug:    "redis"
		type:    "sw.containerized-service"
		version: "alpine"
		data: {
			image: "redis:\(version)"
		}
	}
	"balena-haproxy": {
		slug:    "balena-haproxy"
		type:    "sw.containerized-service"
		version: "latest"
		data: {
			image: "balena/balena-haproxy:\(version)"
		}
		requires: [
			{slug: "open-balena-api", type:      "sw.containerized-service"},
			{slug: "open-balena-registry", type: "sw.containerized-service"},
			{slug: "open-balena-vpn", type:      "sw.containerized-service"},
			{slug: "open-balena-db", type:       "sw.containerized-service"},
			{slug: "open-balena-s3", type:       "sw.containerized-service"},
			{slug: "redis", type:                "sw.containerized-service"},
			{slug: "cert-provider", type:        "sw.containerized-service"},

			{type: "net.endpoint", data: {published: 80, target:   80}},
			{type: "net.endpoint", data: {published: 443, target:  443}},
			{type: "net.endpoint", data: {published: 3128, target: 3128}},

			{type: "net.alias", data: {network: "default", name: "api.\(config.BAPROXY_HOSTNAME.value)"}},
			{type: "net.alias", data: {network: "default", name: "registry.\(config.BAPROXY_HOSTNAME.value)"}},
			{type: "net.alias", data: {network: "default", name: "vpn.\(config.BAPROXY_HOSTNAME.value)"}},
			{type: "net.alias", data: {network: "default", name: "db.\(config.BAPROXY_HOSTNAME.value)"}},
			{type: "net.alias", data: {network: "default", name: "s3.\(config.BAPROXY_HOSTNAME.value)"}},
			{type: "net.alias", data: {network: "default", name: "redis.\(config.BAPROXY_HOSTNAME.value)"}},
		]
		provides: [
			{type: "net.expose", data: {port: 80}},
			{type: "net.expose", data: {port: 443}},
			{type: "net.expose", data: {port: 2222}},
			{type: "net.expose", data: {port: 3128}},
			{type: "net.expose", data: {port: 5432}},
			{type: "net.expose", data: {port: 6379}},
		]
		config: {
			BALENA_HAPROXY_CRT: {
				value: string
			}
			BALENA_HAPROXY_KEY: {
				value: string
			}
			BALENA_ROOT_CA: {
				value: string
			}
			BAPROXY_HOSTNAME: {
				value: string
			}
		}
	}
	"balena-cert-provider": {
		slug:    "balena-cert-provider"
		type:    "sw.containerized-service"
		version: "latest"
		data: {
			image: "balena/balena-cert-provider:\(version)"
		}
		requires: [
			{type: "hw.disk", data: {name: "certs", target:         "/certs", readonly:             false}},
			{type: "hw.disk", data: {name: "cert-provider", target: "/usr/src/app/certs", readonly: false}},
		]
		config: {
			ACTIVE: {
				value: string
			}
			DOMAINS: {
				value: string
			}
			OUTPUT_PEM: {
				value: "/certs/open-balena.pem"
			}
		}
	}
}
