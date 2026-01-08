# FluxCD

## Useful commands

- `flux get all -A | less -XRFS` = Get all resources managed by flux.
- `kubectl apply -k clusters/kustomization-files` = Bootstrap fluxcd in the cluster to begin reconciling kustomizations.
- `flux reconcile kustomization install-alloy-metrics-cots` = Forcible reconcile a specific kustomization so it occurs faster.

## Troubleshooting

- Issue: FluxCD issues -- not reconciling, manifests not getting updated, etc.
- Fix:
  - Check `kustomizations`, `helmrelease`, `helmrepo`, `clusterpolicies`, `netpol`
  - Run `flux get all -n bigbang | less -XRFS` to check for suspended resources
