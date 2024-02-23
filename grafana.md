## Grafana

- **See also:**
  - [Backup and restore](https://grafana.com/docs/grafana/latest/administration/back-up-grafana/)

### Upgrade process (Helm chart deployed on AWS EKS)
- Exec into the Grafana container
```bash
kubectl get pods -n grafana
kubectl exec -it grafana-7ff646d7ff-49qk2 -n grafana -- /bin/bash
```
- Back up the Grafana database and config file
```bash
kubectl cp grafana/grafana-7ff646d7ff-49qk2:/var/lib/grafana/grafana.db grafana.db
kubectl cp grafana/grafana-7ff646d7ff-49qk2:/etc/grafana/grafana.ini grafana.ini
```
- Pull latest Helm release
```bash
helm repo update
```
- Update chart
```bash
helm upgrade --namespace grafana grafana -f values.yml grafana/grafana
```
