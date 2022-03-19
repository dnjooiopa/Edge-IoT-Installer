#!/bin/bash
docker rm -f edge_api-server
docker rm -f edge_web

docker-compose up -d --build edge_api-server
docker-compose up -d --build edge_web
