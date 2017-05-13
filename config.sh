####################################################
# Set up bash Varibables

## Directories
BUILD="./build"
CONFIG="./config"

## Config files
CONFIG_CA="$CONFIG/ca.cnf"
CONFIG_SERVER="$CONFIG/server.cnf"
CONFIG_CLIENT="$CONFIG/client.cnf"

## Private keys
KEY_CA="$BUILD/ca-key.pem"
KEY_SERVER="$BUILD/server-key.pem"
KEY_CLIENT="$BUILD/client-key.pem"

## Certificates
CERT_CA="$BUILD/ca-cert.pem"
CERT_SERVER="$BUILD/server-cert.pem"
CERT_CLIENT="$BUILD/client-cert.pem"

## Certificate Signing Requests
CSR_SERVER="$BUILD/server-csr.pem"
CSR_CLIENT="$BUILD/client-csr.pem"
