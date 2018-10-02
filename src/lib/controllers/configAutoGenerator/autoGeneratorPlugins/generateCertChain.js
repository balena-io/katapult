'use strict'

const Promise = require('bluebird')
const generateCert = require('./generateCert')

/**
 * @param attributes: Attribute object with the following properties:
 * 	certAttrs: Attributes object for cert generation (Subject).
 * 	Example Object:
 * 	{
 * 		C:'GR',
 * 		ST: 'Attiki',
 * 		L:'Athens',
 * 		O:'Resin Ltd.',
 * 		OU: 'NOC',
 * 		CN:'custom-domain.io'
 * 		}
 * 	caCertPEM: Pem string of CA certificate, base64 encoded
 * 	caPrivateKeyPEM: Pem private key string of CA, base64 encoded
 * 	altDomains: List of alt domains.
 * 		Example: ['*.custom-domain.io', '*.devices.custom-domain.io']
 * 	validFrom: Date parsable string for cert validFrom field.
 * 	validTo: Date parsable string for cert validTo field.
 * 	bits: Integer. Defaults to 2048. RSA bits for generated key.
 * 	@returns {Promise<*String>} CertificateChainPEM, base64 encoded
 */
let generateCertChain = (attributes) => {
	const {
		caCertPEM
	} = attributes
	return generateCert(attributes)
		.then(([certPEM, privateKeyPEM]) => {
			return certPEM+caCertPEM+privateKeyPEM
		})
}

module.exports = generateCertChain
