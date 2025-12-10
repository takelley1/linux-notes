# Zarf

## Troubleshooting
```
zarf tools registry catalog
zarf tools kubectl get pods -A
zarf tools connect registry
```

## Inspect zarf registry outside the cluster
```
kubectl get svc -A | grep zarf
kubectl port-forward -n zarf svc/zarf-docker-registry 31999:31999
zarf tools registry ls localhost:31999
```
