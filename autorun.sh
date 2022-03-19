#!/bin/bash

rm -rf certificates
rm -rf db

mkdir db
mkdir db/timescale

export SERVER_CN=$1
export EDGE_VERSION=$2

sh ./scripts/issue-root-ca.sh
sh ./scripts/issue-server-cert.sh $SERVER_CN 192.168.1.1

sh ./scripts/prepare.sh
sh ./scripts/start.sh