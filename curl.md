## CURL

Make POST API request to a Zabbix server:
```bash
curl -v -d \
  '{"jsonrpc": "2.0", "method": "host.get", \
    "params": {"startSearch": {"name": "BlaBlaBla"}}, \
    "id": 1, "auth": "f0fe38b3994cd953403477016e"}' \
    -H "Content-Type: application/json-rpc" \
    http://zabbix-server.example.com/api_jsonrpc.php
```
