1. Edit environment variables

```
cp example.api_server.env .api_server.env
cp example.emqx.env .emqx.env
cp example.timescaledb.env .timescaledb.env
```

2. Change volume mapping for timescaledb

```
#Change this
#1.edge_timescaledb
    volumes:
      - ./db/timescale:/var/lib/postgresql/data

#2.edge_api-server
    volumes:
      - ./db:/usr/src/app/data/
```

3. Run

```
chmod +x ./srcipts/autorun.sh
./srcipts/autorun.sh {SERVER_CN} {EDGE_VERSION}
```

4. Add client
```
chmod +x ./scripts/addclient.sh
./scripts/addclient.sh {CLIENT_NAME}
```
