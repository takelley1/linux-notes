## ZABBIX

- `zabbix_proxy -R config_cache_reload` = Reload Zabbix proxy configuration without restarting service.

```bash
curl -L -s -X POST -H 'Content-Type: application/json-rpc' \
    -d '{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password":"zabbix"
    },
    "id":1,
    "auth":null
    }' \
https://zabbix.example.mil/api_jsonrpc.php
```
