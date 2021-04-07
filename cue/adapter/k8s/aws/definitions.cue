package aws

import (
	"github.com/product-os/katapult/cue/adapter/k8s"
)

Data: k8s.Data
Data: d: [string]: service: [string]: {
	metadata: annotations: {
		"service.beta.kubernetes.io/aws-load-balancer-backend-protocol":                  string | *"http"
		"service.beta.kubernetes.io/aws-load-balancer-ssl-ports":                         string | *"https"
		"service.beta.kubernetes.io/aws-load-balancer-ssl-cert":                          "TODO" // arn:aws:acm:us-east-1:account:certificate/uuid
		"service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy":            "ELBSecurityPolicy-TLS-1-2-2017-01"
		"service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout":           "63"
		"service.beta.kubernetes.io/aws-load-balancer-connection-draining-enabled":       "true"
		"service.beta.kubernetes.io/aws-load-balancer-connection-draining-timeout":       "60"
		"service.beta.kubernetes.io/aws-load-balancer-access-log-enabled":                "true"
		"service.beta.kubernetes.io/aws-load-balancer-access-log-emit-interval":          "5"
		"service.beta.kubernetes.io/aws-load-balancer-access-log-s3-bucket-name":         "TODO" // data-elb-access-logs-uuid
		"service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled": "true"

		// TODO: Should be defined on the blueprint level.
		"external-dns.alpha.kubernetes.io/hostname": "TODO" // somesrevice.balena-env.com
		"external-dns.alpha.kubernetes.io/ttl":      "120"
	}
}
