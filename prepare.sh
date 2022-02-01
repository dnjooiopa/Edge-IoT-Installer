#!/bin/bash
docker-compose up -d --build edge_timescaledb
docker-compose up -d --build edge_emqx
