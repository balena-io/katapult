package productos

contracts: {
	"open-balena-db": {
		slug: "open-balena-db"
		type: "sw.containerized-service"
		requires: []
		provides: []
		data: {
			assets: {
				image: {
					url: "balena/open-balena-db"
				}
				repo: {
					https: "https://github.com/balena-io/open-balena-db.git"
					ssh:   "git@github.com:balena-io/open-balena-db.git"
				}
			}
			restart: "always"
		}
		config: {}
		version: "4.1.0"
	}
	"balena-redis": {
		name: "Redis"
		slug: "redis"
		type: "sw.containerized-service"
		requires: []
		provides: []
		data: {
			assets: {
				image: {
					url: "balena/balena-redis"
				}
				repo: {
					https: "https://github.com/product-os/balena-redis.git"
					ssh:   "git@github.com:product-os/balena-redis.git"
				}
			}
			command: ["sh", "-c", "redis-server /usr/local/etc/redis/redis.conf --save ''"]
			restart: "always"
		}
		config: {}
		version: "0.0.3"
	}
	"jellyfish-api": {
		name: "Jellyfish API Server"
		slug: "jellyfish-api"
		type: "sw.containerized-service"
		requires: [
			{type: "healthcheck", data: {interval: "30s", retries: 5, url: "http://localhost:80/health"}},
		]
		provides: []
		data: {
			assets: {
				image: url: "balena/jellyfish"
				repo: {
					https: "https://github.com/balena-io/jellyfish.git"
					ssh:   "git@github.com:product-os/jellyfish.git"
				}
			}
			restart: "always"
		}
		config: {
			"DATABASE": {value: *"postgres" | string}
			"LOGENTRIES_TOKEN": {value: *"" | string}
			"LOGLEVEL": {value: *"crit" | string}
			"NODE_ENV": {value: *"" | string}
			"POD_NAME": {value: *"localhost" | string}
			"PORT": {value: *"80" | string}
			"POSTGRES_DATABASE": {value: *"jellyfish" | string}
			"POSTGRES_HOST": {value: *"postgres" | string}
			"POSTGRES_PASSWORD": {value: *"docker" | string}
			"POSTGRES_PORT": {value: *"5432" | string}
			"POSTGRES_USER": {value: *"docker" | string}
			"REDIS_HOST": {value: *"redis" | string}
			"REDIS_PASSWORD": {value: *"" | string}
			"REDIS_PORT": {value: *"6379" | string}
			"SENTRY_DSN_SERVER": {value: *"" | string}
			"SERVER_DATABASE": {value: *"jellyfish" | string}
			"SERVER_HOST": {value: *"http://api.ly.fish.local" | string}
			"SERVER_PORT": {value: *"80" | string}
			"TEST_USER_ORGANIZATION": {value: *"balena" | string}
			"TEST_USER_PASSWORD": {value: *"jellyfish" | string}
			"TEST_USER_ROLE": {value: *"user-test" | string}
			"TEST_USER_USERNAME": {value: *"jellyfish" | string}
			"FS_DRIVER": {value: *"" | string}
			"AWS_ACCESS_KEY_ID": {value: *"" | string}
			"AWS_S3_BUCKET_NAME": {value: *"" | string}
			"AWS_SECRET_ACCESS_KEY": {value: *"" | string}
			"INTEGRATION_BALENA_API_APP_SECRET": {value: *"foobar" | string}
			"INTEGRATION_BALENA_API_OAUTH_BASE_URL": {value: *"https://api.balena-cloud.com" | string}
			"INTEGRATION_BALENA_API_PRIVATE_KEY": {value: *"" | string}
			"INTEGRATION_BALENA_API_PUBLIC_KEY_PRODUCTION": {value: *"" | string}
			"INTEGRATION_BALENA_API_PUBLIC_KEY_STAGING": {value: *"foobar" | string}
			"INTEGRATION_DEFAULT_USER": {value: *"" | string}
			"INTEGRATION_DISCOURSE_SIGNATURE_KEY": {value: *"" | string}
			"INTEGRATION_DISCOURSE_TOKEN": {value: *"" | string}
			"INTEGRATION_DISCOURSE_USERNAME": {value: *"" | string}
			"INTEGRATION_FLOWDOCK_SIGNATURE_KEY": {value: *"" | string}
			"INTEGRATION_FLOWDOCK_TOKEN": {value: *"" | string}
			"INTEGRATION_FRONT_TOKEN": {value: *"" | string}
			"INTEGRATION_GITHUB_APP_ID": {value: *"" | string}
			"INTEGRATION_GITHUB_PRIVATE_KEY": {value: *"" | string}
			"INTEGRATION_GITHUB_SIGNATURE_KEY": {value: *"" | string}
			"INTEGRATION_GITHUB_TOKEN": {value: *"" | string}
			"INTEGRATION_GOOGLE_MEET_CREDENTIALS": {value: *"" | string}
			"INTEGRATION_INTERCOM_TOKEN": {value: *"" | string}
			"INTEGRATION_OUTREACH_APP_ID": {value: *"" | string}
			"INTEGRATION_OUTREACH_APP_SECRET": {value: *"" | string}
			"INTEGRATION_OUTREACH_SIGNATURE_KEY": {value: *"" | string}
			"INTEGRATION_TYPEFORM_SIGNATURE_KEY": {value: *"" | string}
			"MAILGUN_DOMAIN": {value: *"" | string}
			"MAILGUN_BASE_URL": {value: *"" | string}
			"MAILGUN_TOKEN": {value: *"" | string}
			"MONITOR_SECRET_TOKEN": {value: *"" | string}
			"NPM_TOKEN": {value: *"" | string}
			"RESET_PASSWORD_SECRET_TOKEN": {value: *"" | string}
			"CI": {value: *"" | string}
			"REGISTRY_TOKEN_AUTH_CERT_ISSUER": {value: *"api.ly.fish.local" | string}
			"REGISTRY_TOKEN_AUTH_CERT_KEY": {value: string}
			"REGISTRY_TOKEN_AUTH_CERT_KID": {value: string}
			"REGISTRY_TOKEN_AUTH_JWT_ALGO": {value: *"ES256" | string}
			"REGISTRY_HOST": {value: *"registry.ly.fish.local" | string}
		}
		version: "28.13.1"
	}
	"jellyfish-livechat": {
		name: "The Jellyfish Livechat App"
		slug: "jellyfish-livechat"
		type: "sw.containerized-service"
		requires: []
		provides: []
		data: {
			assets: {
				image: url: "balena/jellyfish-tick-server"
				repo: {
					https: "https://github.com/balena-io/jellyfish.git"
					ssh:   "git@github.com:product-os/jellyfish.git"
				}
			}
			restart: "always"
		}
		config: {
			"NGINX_PORT": {value: *"80" | string}
			"LIVECHAT_PORT": {value: *"80" | string}
		}
		version: "28.13.1"
	}
	"jellyfish-tick-server": {
		name: "Jellyfish Tick Server"
		slug: "jellyfish-tick-server"
		type: "sw.containerized-service"
		requires: []
		provides: []
		data: {
			assets: {
				image: url: "balena/jellyfish-tick-server"
				repo: {
					https: "https://github.com/balena-io/jellyfish.git"
					ssh:   "git@github.com:product-os/jellyfish.git"
				}
			}
			restart: "always"
		}
		config: {
			"DATABASE": value:          *"postgres" | string
			"LOGENTRIES_TOKEN": value:  *"" | string
			"NODE_ENV": value:          *"" | string
			"POSTGRES_DATABASE": value: *"jellyfish" | string
			"POSTGRES_HOST": value:     *"postgres" | string
			"POSTGRES_PASSWORD": value: *"docker" | string
			"POSTGRES_PORT": value:     *"5432" | string
			"POSTGRES_USER": value:     *"docker" | string
			"REDIS_HOST": value:        *"redis" | string
			"REDIS_PASSWORD": value:    *"" | string
			"REDIS_PORT": value:        *"6379" | string
			"LOGLEVEL": value:          *"crit" | string
			"SENTRY_DSN_SERVER": value: *"" | string
			"CI": value:                *"" | string
		}
		version: "28.13.1"
	}
	"jellyfish-ui": {
		name: "Jellyfish UI"
		slug: "jellyfish-ui"
		type: "sw.containerized-service"
		requires: []
		provides: []
		data: {
			assets: {
				image: url: "balena/jellyfish-ui"
				repo: {
					https: "https://github.com/balena-io/jellyfish.git"
					ssh:   "git@github.com:product-os/jellyfish.git"
				}
			}
			restart: "always"
		}
		config: {
			"NGINX_PORT": value: *"80" | string
			"UI_PORT": value:    *"80" | string
			"NODE_ENV": value:   *"" | string
		}
		version: "28.13.1"
	}
	"jellyfish-action-server": {
		name: "Jellyfish Action Server"
		slug: "jellyfish-action-server"
		type: "sw.containerized-service"
		requires: []
		provides: []
		data: {
			assets: {
				image: url: "balena/jellyfish-action-server"
				repo: {
					https: "https://github.com/balena-io/jellyfish.git"
					ssh:   "git@github.com:product-os/jellyfish.git"
				}
			}
			restart: "always"
		}
		config: {
			"DATABASE": value:                                     *"postgres" | string
			"LOGLEVEL": value:                                     *"crit" | string
			"NODE_ENV": value:                                     *"" | string
			"POSTGRES_DATABASE": value:                            *"jellyfish" | string
			"POSTGRES_HOST": value:                                *"postgres" | string
			"POSTGRES_PASSWORD": value:                            *"docker" | string
			"POSTGRES_PORT": value:                                *"5432" | string
			"POSTGRES_USER": value:                                *"docker" | string
			"REDIS_HOST": value:                                   *"redis" | string
			"REDIS_PASSWORD": value:                               *"" | string
			"REDIS_PORT": value:                                   *"6379" | string
			"SENTRY_DSN_SERVER": value:                            *"" | string
			"LOGENTRIES_TOKEN": value:                             *"" | string
			"FS_DRIVER": value:                                    *"" | string
			"AWS_ACCESS_KEY_ID": value:                            *"" | string
			"AWS_S3_BUCKET_NAME": value:                           *"" | string
			"AWS_SECRET_ACCESS_KEY": value:                        *"" | string
			"INTEGRATION_BALENA_API_APP_SECRET": value:            *"foobar" | string
			"INTEGRATION_BALENA_API_OAUTH_BASE_URL": value:        *"https://api.balena-cloud.com" | string
			"INTEGRATION_BALENA_API_PRIVATE_KEY": value:           *"" | string
			"INTEGRATION_BALENA_API_PUBLIC_KEY_PRODUCTION": value: *"" | string
			"INTEGRATION_BALENA_API_PUBLIC_KEY_STAGING": value:    *"foobar" | string
			"INTEGRATION_DEFAULT_USER": value:                     *"" | string
			"INTEGRATION_DISCOURSE_SIGNATURE_KEY": value:          *"" | string
			"INTEGRATION_DISCOURSE_TOKEN": value:                  *"" | string
			"INTEGRATION_DISCOURSE_USERNAME": value:               *"" | string
			"INTEGRATION_FLOWDOCK_SIGNATURE_KEY": value:           *"" | string
			"INTEGRATION_FLOWDOCK_TOKEN": value:                   *"" | string
			"INTEGRATION_FRONT_TOKEN": value:                      *"" | string
			"INTEGRATION_GITHUB_APP_ID": value:                    *"" | string
			"INTEGRATION_GITHUB_PRIVATE_KEY": value:               *"" | string
			"INTEGRATION_GITHUB_SIGNATURE_KEY": value:             *"" | string
			"INTEGRATION_GITHUB_TOKEN": value:                     *"" | string
			"INTEGRATION_GOOGLE_MEET_CREDENTIALS": value:          *"" | string
			"INTEGRATION_INTERCOM_TOKEN": value:                   *"" | string
			"INTEGRATION_OUTREACH_APP_ID": value:                  *"" | string
			"INTEGRATION_OUTREACH_APP_SECRET": value:              *"" | string
			"INTEGRATION_OUTREACH_SIGNATURE_KEY": value:           *"" | string
			"INTEGRATION_TYPEFORM_SIGNATURE_KEY": value:           *"" | string
			"MAILGUN_DOMAIN": value:                               *"" | string
			"MAILGUN_BASE_URL": value:                             *"" | string
			"MAILGUN_TOKEN": value:                                *"" | string
			"MONITOR_SECRET_TOKEN": value:                         *"" | string
			"NPM_TOKEN": value:                                    *"" | string
			"RESET_PASSWORD_SECRET_TOKEN": value:                  *"" | string
			"CI": value:                                           *"" | string
		}
		version: "33.50.5"
	}
}
