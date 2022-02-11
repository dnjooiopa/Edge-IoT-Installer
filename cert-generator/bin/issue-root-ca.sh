#!/bin/bash

WORKDIR=./certificates

cd "$(dirname "$0")"
cd ../
mkdir -p $WORKDIR
cd $WORKDIR
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -subj "/C=TH/CN=edge_iot" -key ca.key -sha256 -days 3650 -out ca.pem
