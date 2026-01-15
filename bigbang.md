# BigBang

## How to modify BigBang values

Task: override Grafana config to use Postgres instead of SQLite

1. Look at the upstream Grafana Helm Chart values.yml to find the path we need to edit.
    - https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml#L883
    - Here we can see the config we want to edit is likely in the `grafan.ini` block, so we need to find that block in the BigBang chart.
2. Figure out which chart BigBang is using for Grafana
   - `kubectl get hr -n bigbang`
   - We can see a dedicated `grafana` chart deployed by BigBang.
2. So BigBang uses the `grafana` sub-chart for deploying Grafana. Now look at the `grafana` chart's `values.yml` to find the equivalent path:
    - https://repo1.dso.mil/big-bang/product/packages/grafana/-/blob/main/chart/values.yaml?ref_type=heads
    - We can see here the path is `upstream.grafana.ini`
3. Look at the BigBang HelmRelease and find the same block so we can edit it.
    - `kubectl get hr bigbang -n bigbang -o yaml | yq '.spec.values.grafana'`
    - The `grafana` block appears to have a `values.upstream` section. So it looks like we need to add a `grafana.ini` block to `.spec.values.grafana.values.upstream`
4. Create a postRenderer to add the block.
   ```yaml
   - op: add
     path: /spec/values/grafana/values/upstream/grafana.ini
     value:
       database:
         type: postgres
         host: host.com
   ```
5. Git commit and push, then monitor changes:
   - `flux reconcile hr grafana -n bigbang` = Force reconciliation.
   - `kubectl describe hr grafana -n bigbang` = Monitor status and errors.
   - `kubectl get hr bigbang -n bigbang -o yaml | yq '.spec.values.grafana.values.upstream` = See the changed helm chart values to see if they're correct.
