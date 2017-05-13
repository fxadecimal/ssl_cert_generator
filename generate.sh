#!/usr/bin/env bash
echo "CA, Server & Client Certificate Generator "
# read -n1 -r -p "Press any key to continue..." key


source "./config.sh"
set -x
####################################################
# Generate our own Certificate Authority (CA) to issue certificates with
## Generate a private key
openssl genrsa -out $KEY_CA 2048
## Generate a CA certificate
openssl req -new -x509 -days 3650 \
	-key $KEY_CA -config $CONFIG_CA -out $CERT_CA

####################################################
# Issue a server certificate from the CA using Certificate Signing Request (CSR)
## Generate a private key
openssl genrsa -out $KEY_SERVER 2048
## Generate a CSR
openssl req -new -config $CONFIG_SERVER -key $KEY_SERVER -out $CSR_SERVER
## Generate a certificate for the server signed by the CA
openssl x509 -req -extfile $CONFIG_SERVER \
	-days 999 -passin "pass:password" \
	-in $CSR_SERVER \
	-CA $CERT_CA \
	-CAkey $KEY_CA \
	-CAcreateserial \
	-out $CERT_SERVER

####################################################
# Issue a client certificate from the CA using Certificate Signing Request (CSR)
## Generate a private key
openssl genrsa -out $KEY_CLIENT 2048
## Generate a CSR
openssl req -new -config $CONFIG_CLIENT -key $KEY_CLIENT -out $CSR_CLIENT
## Generate a certificate for the server signed by the CA
openssl x509 -req -extfile $CONFIG_CLIENT \
	-days 999 -passin "pass:password" \
	-in $CSR_CLIENT \
	-CA $CERT_CA \
	-CAkey $KEY_CA \
	-CAcreateserial \
	-out $CERT_CLIENT

set +x
# Verify certificates
echo -e "\n\nVerifying Certificates\n"
openssl verify -CAfile $CERT_CA $CERT_SERVER
openssl verify -CAfile $CERT_CA $CERT_CLIENT
