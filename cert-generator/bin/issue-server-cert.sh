#!/bin/bash

DOMAIN=$1
IP=$2

WORKDIR=./certificates
CERT_WORKDIR=./servers/$DOMAIN
KEY_FILE=$CERT_WORKDIR/$DOMAIN.key
CSR_FILE=$CERT_WORKDIR/$DOMAIN.csr
CNF_FILE=$CERT_WORKDIR/$DOMAIN.cnf
PEM_FILE=$CERT_WORKDIR/$DOMAIN.pem

CA_PEM_FILE=./ca.pem
CA_KEY_FILE=./ca.key



if [ "$#" -ne 2 ]
then
  echo "Usage: Must supply a domain and ip"
  exit 1
fi

cd "$(dirname "$0")"
cd ../
mkdir -p $WORKDIR
cd $WORKDIR
mkdir -p $CERT_WORKDIR

cat > $CNF_FILE << EOF
[req]
default_bits  = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
countryName = TH
stateOrProvinceName = Bangkok
localityName = Ladkrabang
organizationName = KMITL
commonName = $DOMAIN
[req_ext]
subjectAltName = @alt_names
[v3_req]
subjectAltName = @alt_names
[alt_names]
IP.1 = $IP
DNS.1 = $DOMAIN
EOF
``


openssl genrsa -out $KEY_FILE 2048
openssl req -new \
            -key $KEY_FILE \
            -config $CNF_FILE \
            -out $CSR_FILE
openssl x509 -req \
            -in $CSR_FILE \
            -CA $CA_PEM_FILE \
            -CAkey $CA_KEY_FILE \
            -CAcreateserial \
            -out $PEM_FILE \
            -days 3650 \
            -sha256 \
            -extensions v3_req \
            -extfile $CNF_FILE\

openssl verify -CAfile $CA_PEM_FILE $PEM_FILE