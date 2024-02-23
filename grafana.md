## Grafana

### Upgrade process (Helm chart deployed on AWS EKS)
- Exec into the Grafana container
```bash
kubectl exec -it grafana-cc88f94b6-tc7sj -n grafana -- /bin/bash
```
- [Backup and restore](https://grafana.com/docs/grafana/latest/administration/back-up-grafana/)
