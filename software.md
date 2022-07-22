## Zabbix

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

## vSphere / VMWare

`Actions -> Edit Settings -> VM Options -> VMWare Remote Console Options` = Edit max number of connected console sessions for a guest.

## Borg Backup

Extract */mnt/tank/share/pictures* in repo *backup-2020-01-19-01-00* to current path:
```bash
borg extract \
--progress \
--list \
--verbose \
/mnt/backup/borgrepo::backup-2020-01-19-01-00 mnt/tank/share/pictures/
```

## Graylog

Change Graylog from RO to RW mode:
```bash
curl \
-XPUT \
-H "Content-Type: application/json" \
https://localhost:9200/_all/_settings \
-d '{"index.blocks.read_only_allow_delete": null}'
```

## Ranger

- `m<KEY>`         = Bookmark path at *\<KEY\>*.
- `` `<KEY> ``     = Jump to bookmark at *\<KEY\>*.
- `cd /path`       = Jump to /path.
- `gh` *(go home)* = Jump to ~
<br><br>
- `I` = Rename from beginning of file.
- `A` = Rename from end of file (including extension).
- `a` = Rename from end of file (excluding extension).

