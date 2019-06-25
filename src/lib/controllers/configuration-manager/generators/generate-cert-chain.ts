import { GenerateCertArgs, generateCertificate } from '.';

/**
 * GENERATE_CERT_CHAIN
 * @param attributes: Attribute object with the following properties:
 * 	certAttrsMap: Attributes object for generateCertificate generation (Subject).
 * 	Example Object:
 * 	{
 * 		C:'GR',
 * 		ST: 'Attiki',
 * 		L:'Athens',
 * 		O:'Balena Ltd.',
 * 		OU: 'DevOps',
 * 		CN:'custom-domain.io'
 * 		}
 * 	caCertPEM: Pem string of CA certificate, base64 encoded
 * 	caPrivateKeyPEM: Pem private key string of CA, base64 encoded
 * 	privateKeyPEM: Pem private key string for certificate
 * 	altDomains: List of alt domains.
 * 		Example: ['*.custom-domain.io', '*.devices.custom-domain.io']
 * 	validFrom: Date parsable string for generateCertificate validFrom field.
 * 	validTo: Date parsable string for generateCertificate validTo field.
 * 	bits: Integer. Defaults to 2048. RSA bits for generated key.
 * 	@returns {Promise<string>} CertificateChainPEM, base64 encoded
 */

export async function generateCertChain(
	attributes: GenerateCertArgs,
): Promise<string> {
	const { caCertPEM, privateKeyPEM } = attributes;
	const certPEM = await generateCertificate(attributes);
	return certPEM + caCertPEM + privateKeyPEM;
}
