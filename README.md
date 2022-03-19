1. Edit environment variables

```
cp example.api_server.env .api_server.env
cp example.emqx.env .emqx.env
cp example.timescaledb.env .timescaledb.env
```

2. Update emqx configurations

```
# .emqx.env
EMQX_LISTENER__SSL__EXTERNAL__KEYFILE=/etc/certs/{SERVER_CN}.key
EMQX_LISTENER__SSL__EXTERNAL__CERTFILE=/etc/certs/{SERVER_CN}.pem
```

3. Change volume mapping for timescaledb

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
chmod +x ./autorun.sh
./autorun {SERVER_CN} {EDGE_VERSION}
```
