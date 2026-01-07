# [Kyverno](https://kyverno.io/docs/introduction/)

- `kubectl delete pods -n kyverno --all` = Force Kyverno policies to reload by removing pods. Helps with FluxCD reconciliation.
<br><br>
- Extends the baseline Pod Security Admission with more flexible controls on any resource, not just Pods.
- `kyverno apply`, `kyverno test`, `kyverno validate`  
- Workflow: Admission request → Kyverno evaluates → allow, deny, or mutate

Require every Pod to have an `app` label:
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-app-label
spec:
  validationFailureAction: enforce
  rules:
    - name: check-app-label
      match:
        resources:
          kinds: ["Pod"]
      validate:
        message: "All pods must have 'app' label"
        pattern:
          metadata:
            labels:
              app: "?*"
```

Require every Pod to run as non-root:
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: enforce-run-as-nonroot
spec:
  validationFailureAction: enforce
  background: true
  rules:
  - name: check-run-as-nonroot
    match:
      resources:
        kinds:
          - Pod
    validate:
      message: "All containers must run as non-root."
      pattern:
        spec:
          containers:
          - securityContext:
              runAsNonRoot: true
          initContainers:
          - securityContext:
              runAsNonRoot: true
```

Example job that rests Kyverno policies against an ArgoCD w/ Kustomize infra repo in CI:
- Also see [testing policies](https://kyverno.io/docs/testing-policies/)
- The job runs in the app repo. It clones the infra repo and renders the ArgoCD kustomize overlay to rendered.yaml, then checks the Kyverno policy against it.
```yaml
# .gitlab-ci.yml (app repo)
stages: [test]

variables:
  INFRA_REPO: "https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.com/org/infra-repo.git"
  INFRA_REF: "main"
  # kustomize overlay that ArgoCD uses for this app/env
  INFRA_OVERLAY_PATH: "apps/my-service/overlays/prod"
  # where Kyverno policies live in the infra repo
  POLICY_PATH: "policies"
  # optional: limit to a subdir or glob if you have many policies
  POLICY_GLOB: "*.yaml"

kyverno-validate:
  stage: test
  image: ghcr.io/kyverno/kyverno-cli:latest
  before_script:
    - apk add --no-cache git curl
    # install kustomize (standalone) so we can render the ArgoCD+kustomize app
    - curl -sSLo /usr/local/bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.4.2/kustomize_v5.4.2_linux_amd64
    - chmod +x /usr/local/bin/kustomize

    # fetch infra repo at the same commit you deploy from
    - git clone --depth 1 --branch "${INFRA_REF}" "${INFRA_REPO}" infra

    # render the deployment manifests exactly like ArgoCD would
    - kustomize build "infra/${INFRA_OVERLAY_PATH}" > rendered.yaml

    # collect policies
    - find "infra/${POLICY_PATH}" -maxdepth 1 -name "${POLICY_GLOB}" -print0 | xargs -0 cat > policies.yaml
  script:
    # validate the rendered manifests against Kyverno policies from infra repo
    - |
      set -euo pipefail
      echo "Policies:"
      yq '. | length' policies.yaml || true
      echo "Resources to validate:"
      yq '. | length' rendered.yaml || true

      # Fail on any deny; show a readable summary
      kyverno apply policies.yaml --resource rendered.yaml --strict --audit-warn=false

      # Optionally print a table of results
      kyverno apply policies.yaml --resource rendered.yaml --summary
  artifacts:
    when: always
    paths:
      - rendered.yaml
      - policies.yaml
```
