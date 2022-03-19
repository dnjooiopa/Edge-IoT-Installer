#!/bin/bash

# Define Variable
DEVICE_UUID=$1

WORKDIR=./certificates
CERT_WORKDIR=./clients/$DEVICE_UUID
KEY_FILE=$CERT_WORKDIR/$DEVICE_UUID.key
CSR_FILE=$CERT_WORKDIR/$DEVICE_UUID.csr
PEM_FILE=$CERT_WORKDIR/$DEVICE_UUID.pem

CA_PEM_FILE=./ca.pem
CA_KEY_FILE=./ca.key

# Validate Input
if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a domain and ip"
  exit 1
fi

# Change Directory
cd "$(dirname "$0")"
cd ../
mkdir -p $WORKDIR
cd $WORKDIR
mkdir -p $CERT_WORKDIR

openssl genrsa -out $KEY_FILE 2048
openssl req -new \
            -key $KEY_FILE \
            -out $CSR_FILE \
            -subj "/C=TH/ST=Bangkok/L=Latkrabang/O=KMITL/CN=$DEVICE_UUID"
openssl x509 -req \
            -days 3650 \
            -in $CSR_FILE \
            -CA $CA_PEM_FILE \
            -CAkey $CA_KEY_FILE \
            -CAcreateserial \
            -out $PEM_FILE

openssl verify -CAfile $CA_PEM_FILE $PEM_FILE