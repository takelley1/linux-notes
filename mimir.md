# Mimir

## K8s troubleshooting
- `curl -vkL http://mimir-service-name.mimir-namespace.svc.cluster.local/prometheus/api/v1/query?query=up` = Check if mimir is receiving data
- Note that new metrics sent to Mimir may take a while to appear due to caching.
