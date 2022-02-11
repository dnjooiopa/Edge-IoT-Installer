# MVP EMQX SSL
## Getting Start
1. issue root ca
   ```
   sh bin/issue-root-ca.sh
   ```
2. issue server cert
   ```
   sh bin/issue-server-cert.sh mqtt.hybiot.io 192.168.0.1
   ```
3. issue client cert
   ```
   sh bin/issue-client-cert.sh 64524fe7-aed9-43c0-9f70-6088c17153f0
   ```
4. run emqx container
   ```
   sh start.sh
   ```
## References
* [emqx two way ssl](https://www.emqx.com/en/blog/enable-two-way-ssl-for-emqx)