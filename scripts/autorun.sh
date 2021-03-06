#!/bin/bash

export SERVER_CN=$1
export EDGE_VERSION=$2
export DB_PATH=$3

rm -rf certificates
rm -rf db

mkdir $DB_PATH
mkdir $DB_PATH/timescale

mv example.api_server.env .api_server.env
mv example.emqx.env .emqx.env
mv example.timescaledb.env .timescaledb.env

sh ./scripts/issue-root-ca.sh
sh ./scripts/issue-server-cert.sh $SERVER_CN 192.168.1.1

sh ./scripts/prepare.sh
sh ./scripts/start.sh