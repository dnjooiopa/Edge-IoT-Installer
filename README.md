1. Edit environment variables

```sh
cp example.api_server.env .api_server.env
cp example.emqx.env .emqx.env
cp example.timescaledb.env .timescaledb.env
```

2. Change volume mapping for timescaledb

```yaml
#Change this
#1.edge_timescaledb
    volumes:
      - ./db/timescale:/var/lib/postgresql/data

#2.edge_api-server
    volumes:
      - ./db:/usr/src/app/data/
```

3. Run

```sh
chmod +x ./srcipts/autorun.sh
./srcipts/autorun.sh {SERVER_CN} {EDGE_VERSION} ${DB_PATH}

# Example
# ./srcipts/autorun.sh helloworld.local 1.0.0 ./db
```

4. Add client
```sh
chmod +x ./scripts/addclient.sh
./scripts/addclient.sh {CLIENT_NAME}
```
