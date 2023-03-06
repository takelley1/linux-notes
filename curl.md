## [cURL](https://curl.se/)

Make POST API request to a Zabbix server:
```bash
curl -v --data \
  '{"jsonrpc": "2.0", "method": "host.get", \
    "params": {"startSearch": {"name": "BlaBlaBla"}}, \
    "id": 1, "auth": "f0fe38b3994cd953403477016e"}' \
    -H "Content-Type: application/json-rpc" \
    http://zabbix-server.example.com/api_jsonrpc.php

curl -v --data '{"jsonrpc": "2.0", "method": "host.get", "params": {"startSearch": {"name": "BlaBlaBla"}}, "id": 1, "auth": "f0fe38b3994cd953403477016e"}' -H "Content-Type: application/json-rpc" http://zabbix-server.example.com/api_jsonrpc.php
```

Query GitLab for all users:
```bash
curl -s --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "http://gitlab.example.com/api/v4/users?per_page=100&page=1"
```
