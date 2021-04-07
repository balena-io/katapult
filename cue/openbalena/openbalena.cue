package openbalena

import (
	"github.com/product-os/katapult/cue/balenaio"
)

distribution: slug: "open-balena"
contracts: balenaio.contracts

blueprints: "\(distribution.slug)": {
	data: selector: [
		{slug: "open-balena-api"},
		{slug: "open-balena-registry"},
		{slug: "open-balena-db"},
		{slug: "open-balena-s3"},
		{slug: "balena-haproxy"},
		{slug: "balena-cert-provider"},
		{slug: "redis"},
	]
}

// contracts: {
//  "open-balena-api": {
//   config: {
//    API_VPN_SERVICE_API_KEY: {
//     value: input.OPENBALENA_API_VPN_SERVICE_API_KEY
//    }
//    BALENA_ROOT_CA: {
//     value: input.OPENBALENA_ROOT_CA
//    }
//    COOKIE_SESSION_SECRET: {
//     value: input.OPENBALENA_COOKIE_SESSION_SECRET
//    }
//    DB_HOST: {
//     value: "open-balena-db"
//    }
//    DB_PASSWORD: {
//     value: "docker"
//    }
//    DB_PORT: {
//     value: 5432
//    }
//    DB_USER: {
//     value: "docker"
//    }
//    DELTA_HOST: {
//     value: "delta.\(input.OPENBALENA_HOST_NAME)"
//    }
//    DEVICE_CONFIG_OPENVPN_CA: {
//     value: input.OPENBALENA_VPN_CA_CHAIN
//    }
//    DEVICE_CONFIG_SSH_AUTHORIZED_KEYS: {
//     value: input.OPENBALENA_SSH_AUTHORIZED_KEYS
//    }
//    HOST: {
//     value: "api.\(input.OPENBALENA_HOST_NAME)"
//    }
//    IMAGE_MAKER_URL: {
//     value: "img.\(input.OPENBALENA_HOST_NAME)"
//    }
//    IMAGE_STORAGE_BUCKET: {
//     value: "resin-production-img-cloudformation"
//    }
//    IMAGE_STORAGE_PREFIX: {
//     value: "images"
//    }
//    IMAGE_STORAGE_ENDPOINT: {
//     value: "s3.amazonaws.com"
//    }
//    JSON_WEB_TOKEN_EXPIRY_MINUTES: {
//     value: 10080
//    }
//    SON_WEB_TOKEN_SECRET: {
//     value: input.OPENBALENA_JWT_SECRET
//    }
//    MIXPANEL_TOKEN: {
//     value: "__unused__"
//    }
//    PRODUCTION_MODE: {
//     value: input.OPENBALENA_PRODUCTION_MODE
//    }
//    PUBNUB_PUBLISH_KEY: {
//     value: "__unused__"
//    }
//    PUBNUB_SUBSCRIBE_KEY: {
//     value: "__unused__"
//    }
//    REDIS_HOST: {
//     value: "redis"
//    }
//    REDIS_PORT: {
//     value: 6379
//    }
//    REGISTRY2_HOST: {
//     value: "registry.\(input.OPENBALENA_HOST_NAME)"
//    }
//    REGISTRY_HOST: {
//     value: "registry.\(input.OPENBALENA_HOST_NAME)"
//    }
//    SENTRY_DSN: {
//     value: ""
//    }
//    TOKEN_AUTH_BUILDER_TOKEN: {
//     value: input.OPENBALENA_TOKEN_AUTH_BUILDER_TOKEN
//    }
//    TOKEN_AUTH_CERT_ISSUER: {
//     value: "api.\(input.OPENBALENA_HOST_NAME)"
//    }
//    TOKEN_AUTH_CERT_KEY: {
//     value: input.OPENBALENA_TOKEN_AUTH_KEY
//    }
//    TOKEN_AUTH_CERT_KID: {
//     value: input.OPENBALENA_TOKEN_AUTH_KID
//    }
//    TOKEN_AUTH_CERT_PUB: {
//     value: input.OPENBALENA_TOKEN_AUTH_PUB
//    }
//    TOKEN_AUTH_JWT_ALGO: {
//     value: "ES256"
//    }
//    VPN_HOST: {
//     value: "vpn.\(input.OPENBALENA_HOST_NAME)"
//    }
//    VPN_PORT: {
//     value: 443
//    }
//    VPN_SERVICE_API_KEY: {
//     value: input.OPENBALENA_VPN_SERVICE_API_KEY
//    }
//    SUPERUSER_EMAIL: {
//     value: input.OPENBALENA_SUPERUSER_EMAIL
//    }
//    SUPERUSER_PASSWORD: {
//     value: input.OPENBALENA_SUPERUSER_PASSWORD
//    }
//   }
//  }
//  "open-balena-registry": {
//   config: {
//    API_TOKENAUTH_CRT: {
//     value: input.OPENBALENA_TOKEN_AUTH_PUB
//    }
//    BALENA_REGISTRY2_HOST: {
//     value: "registry.\(input.OPENBALENA_HOST_NAME)"
//    }
//    BALENA_ROOT_CA: {
//     value: input.OPENBALENA_ROOT_CA
//    }
//    BALENA_TOKEN_AUTH_ISSUER: {
//     value: "api.\(input.OPENBALENA_HOST_NAME)"
//    }
//    BALENA_TOKEN_AUTH_REALM: {
//     value: "https://api.\(input.OPENBALENA_HOST_NAME)/auth/v1/token"
//    }
//    COMMON_REGION: {
//     value: input.OPENBALENA_S3_REGION
//    }
//    REGISTRY2_CACHE_ENABLED: {
//     value: "false"
//    }
//    REGISTRY2_CACHE_ADDR: {
//     value: "127.0.0.1:6379"
//    }
//    REGISTRY2_CACHE_DB: {
//     value: 0
//    }
//    REGISTRY2_CACHE_MAXMEMORY_MB: {
//     value: 1024
//    }
//    REGISTRY2_CACHE_MAXMEMORY_POLICY: {
//     value: "allkeys-lru"
//    }
//    REGISTRY2_S3_REGION_ENDPOINT: {
//     value: input.OPENBALENA_S3_ENDPOINT
//    }
//    REGISTRY2_S3_BUCKET: {
//     value: input.OPENBALENA_REGISTRY2_S3_BUCKET
//    }
//    REGISTRY2_S3_KEY: {
//     value: input.OPENBALENA_S3_ACCESS_KEY
//    }
//    REGISTRY2_S3_SECRET: {
//     value: input.OPENBALENA_S3_SECRET_KEY
//    }
//    REGISTRY2_SECRETKEY: {
//     value: input.OPENBALENA_REGISTRY_SECRET_KEY
//    }
//    REGISTRY2_STORAGEPATH: {
//     value: "/data"
//    }
//   }
//  }
//  "open-balena-vpn": {
//   config: {
//    API_SERVICE_API_KEY: {
//     value: input.OPENBALENA_API_VPN_SERVICE_API_KEY
//    }
//    BALENA_API_HOST: {
//     value: "api.\(input.OPENBALENA_HOST_NAME)"
//    }
//    BALENA_ROOT_CA: {
//     value: input.OPENBALENA_ROOT_CA
//    }
//    BALENA_VPN_PORT: {
//     value: 443
//    }
//    PRODUCTION_MODE: {
//     value: input.OPENBALENA_PRODUCTION_MODE
//    }
//    RESIN_VPN_GATEWAY: {
//     value: "10.2.0.1"
//    }
//    SENTRY_DSN: {
//     value: ""
//    }
//    VPN_HAPROXY_USEPROXYPROTOCOL: {
//     value: "true"
//    }
//    VPN_OPENVPN_CA_CRT: {
//     value: input.OPENBALENA_VPN_CA
//    }
//    VPN_OPENVPN_SERVER_CRT: {
//     value: input.OPENBALENA_VPN_SERVER_CRT
//    }
//    VPN_OPENVPN_SERVER_DH: {
//     value: input.OPENBALENA_VPN_SERVER_DH
//    }
//    VPN_OPENVPN_SERVER_KEY: {
//     value: input.OPENBALENA_VPN_SERVER_KEY
//    }
//    VPN_SERVICE_API_KEY: {
//     value: input.OPENBALENA_VPN_SERVICE_API_KEY
//    }
//   }
//  }
//  "open-balena-db": config: {}
//  "open-balena-s3": {
//   config: {
//    S3_MINIO_ACCESS_KEY: {
//     value: input.OPENBALENA_S3_ACCESS_KEY
//    }
//    S3_MINIO_SECRET_KEY: {
//     value: input.OPENBALENA_S3_SECRET_KEY
//    }
//    BUCKETS: {
//     value: input.OPENBALENA_S3_BUCKETS
//    }
//   }
//  }
//  "redis": config: {}
//  "balena-haproxy": {
//   config: {
//    BALENA_HAPROXY_CRT: {
//     value: input.OPENBALENA_ROOT_CRT
//    }
//    BALENA_HAPROXY_KEY: {
//     value: input.OPENBALENA_ROOT_KEY
//    }
//    BALENA_ROOT_CA: {
//     value: input.OPENBALENA_ROOT_CA
//    }
//    BAPROXY_HOSTNAME: {
//     value: input.OPENBALENA_HOST_NAME
//    }
//   }
//  }
//  "balena-cert-provider": {
//   config: {
//    ACTIVE: {
//     value: input.OPENBALENA_ACME_CERT_ENABLED
//    }
//    DOMAINS: {
//     value: "api.\(input.OPENBALENA_HOST_NAME),registry.\(input.OPENBALENA_HOST_NAME),s3.\(input.OPENBALENA_HOST_NAME),vpn.\(input.OPENBALENA_HOST_NAME)"
//    }
//    OUTPUT_PEM: {
//     value: "/certs/open-balena.pem"
//    }
//   }
//  }
// }
