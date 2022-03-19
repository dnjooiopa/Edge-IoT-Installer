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

3. Run

```
chmod +x ./autorun.sh
./autorun {SERVER_CN} {EDGE_VERSION}
```
