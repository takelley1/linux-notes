## [Graylog](https://docs.graylog.org/)

Change Graylog from read-only to read-write mode:
```bash
curl \
-XPUT \
-H "Content-Type: application/json" \
https://localhost:9200/_all/_settings \
-d '{"index.blocks.read_only_allow_delete": null}'
```
