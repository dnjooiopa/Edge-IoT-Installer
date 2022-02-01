#!/bin/bash
export edge_version=0.7.2

docker rm -f edge_api-server
docker-compose up -d --build edge_api-server

docker rm -f edge_web
docker-compose up -d --build edge_web
