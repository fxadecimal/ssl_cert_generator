#!/usr/bin/env bash
# Certificate coverter for server and client

source "./config.sh"

set -x
## Convert client cerficate to PK12 format certificate for browsers
openssl pkcs12 -export -clcerts -in $CERT_CLIENT\
		-inkey $KEY_CLIENT -out "$BUILD/client-cert.p12" -password "pass:password"

## Convert Server certificate to DER formate for Tomcat
openssl x509 -in $CERT_CA -inform PEM -out "$BUILD/ca-cert.der" -outform DER

openssl pkcs8 -topk8 -nocrypt -in $KEY_SERVER -inform PEM -out "$BUILD/server-key.der" -outform DER
openssl x509 -in $CERT_SERVER -inform PEM -out "$BUILD/server-cert.der" -outform DER
