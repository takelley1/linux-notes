# FluxCD

## Useful commands

- `flux get all -A | less -XRFS` = Get all resources managed by flux.
- `kubectl apply -k clusters/kustomization-files` = Bootstrap fluxcd in the cluster to begin reconciling kustomizations.
