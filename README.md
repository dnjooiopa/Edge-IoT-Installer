## Prerequisite
Install Docker
```sh
./scripts/install-docker.sh
sudo reboot
```
Login to Github Packages Registry
```
export CR_PAT={YOUR_TOKEN}

echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
```
## Installation
1. Edit environment variables

```sh
example.api_server.env (required)
example.emqx.env (optional)
example.timescaledb.env (optional)
```

2. Install

```sh
./srcipts/autorun.sh {SERVER_CN} {EDGE_VERSION} ${DB_PATH}

# Example
# ./srcipts/autorun.sh helloworld.local 1.0.0 ./db
```

## Add new MQTT client
```sh
./scripts/addclient.sh {DEVICE_UUID}
```
