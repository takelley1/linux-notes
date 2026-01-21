# BigBang

## Troubleshooting

- Issue: SOPS issue on kustomization: `cannot get sops data key: failed to get the data key required to decrypt the SOPS file`
- Fix:
  - Make sure the sops secret in the cluster contains the correct secret key. Export your local gpg key with `--armor` and compare it to what’s in the cluster.
<br><br>
- Issue: Pod can't talk to the k8s API
- Fix:
  - Does the pod's ServiceAccount have a ServiceAccountToken mounted? If not, is Kyverno mutating the ServiceAccount so it doesn't get mounted?
  - Does the pod's ServiceAccount have the correct ClusterRole and ClusterRoleBinding to access the API endpoints it needs?
<br><br>
- Issue: helmrepo failed to fetch helmrelease at grafana.github.io.
- Symptoms: It resolves to the correct IP but the issue is `read tcp IP->IP read: connection reset by peer`
- Fix:
  - Is Istio injected into the fluxcd pod? If so, are the Istio egress-gateway NetworkPolicies blocking the outbound traffic?
  - Describe the fluxcd pods and verify they have the `HTTPS_PROXY` env vars.
<br><br>
- Issue: Cannot reach a cluster service endpoint from INSIDE the cluster.
- Symptoms: TCP connection refused
- Fix:
  - Is the service up and healthy? Does it have endpoints? Are the pods healthy?
  - Check NetworkPolicies. Is any NetworkPolicy targeting the source or destination pod? If so, make sure another policy allows the traffic.
  - Check the host's firewalld. Is the port allowed? `firewall-cmd --list-all && firewall-cmd --add-port=PORT/tcp --permanent`
  - Check Istio. Is Istio enforcing mTLS on the connection? Add an annotation `sidecar.istio.io/inject: "false"`
<br><br>
- Issue: Cannot reach a cluster service endpint from OUTSIDE the cluster.
- Symptoms: TCP connection refused.
- Fix:
  - Is the service up and healthy? Does it have endpoints? Are the pods healthy?
  - Check Istio NetworkPolicies. Delete them if needed to test. Is `istio-ingressgateway` allowing traffic in on the right port? Do other NetworkPolicies block it?
<br><br>
- Issue: FluxCD issues -- not reconciling, manifests not getting updated, etc.
- Fix:
  - Check kustomizations, helmrelease, helmrepo, clusterpolicies, netpol
  - Run `flux get all -n bigbang | less -XRFS` to check for suspended resources
<br><br>
- Issue: Failed to call Kyverno's mutating webhook endpoint.
- Fix:
  1. Suspend the Kyverno hr `flux suspend hr kyverno -n bigbang && flux suspend hr kyverno-policies -n bigbang`
  2. Scale down the Kyverno deployments to 0
  3. Retry reconciling the issue Kustomization 
  4. Wait for all other Kustomizations to reconcile
  5. Resume the Kyverno helm releases `flux resume hr kyverno -n bigbang && flux resume hr kyverno-policies -n bigbang`
  6. Scale back up the Kyverno deployment
<br><br>
- Issue: helmrelease suck in reconciliation
- Fix:
  - Suspend the hr, then resume it `flux suspend hr <RELEASE>`, `flux resume hr <RELEASE>`

## PostRenderers

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

4. Create a postRenderer to add the block, since grafana.ini exists in the values for the `grafana` sub-chart.
   ```yaml
   - op: add
     path: /spec/values/grafana/values/upstream/grafana.ini
     value:
       database:
         type: postgres
         host: host.com
   ```
5. If the block doesn't exist, we need to create it first in our postRenderer
  ```yaml
   - op: add
     path: /spec/values/grafana/values/upstream/extraSecretMounts
     value: []

   - op: add
     path: /spec/values/grafana/values/upstream/extraSecretMounts/-
     value:
       name: mySecret
   ```
5. Git commit and push, then monitor changes:
   - `flux reconcile hr grafana -n bigbang` = Force reconciliation.
   - `kubectl describe hr grafana -n bigbang` = Monitor status and errors.
   - `kubectl get hr bigbang -n bigbang -o yaml | yq '.spec.values.grafana.values.upstream'` = See the changed helm chart values to see if they're correct.
