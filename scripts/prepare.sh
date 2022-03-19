#!/bin/bash
docker rm -f -v edge_emqx
docker rm -f -v edge_timescaledb

docker-compose up -d --build edge_emqx
docker-compose up -d --build edge_timescaledb
