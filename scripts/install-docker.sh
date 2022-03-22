#!/bin/bash

curl -sSL https://get.docker.com | sh
sudo usermod -aG docker ${USER}

sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip

sudo pip3 install docker-compose
