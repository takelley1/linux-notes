# GitOps

- This flow uses **Argo CD** for deployment and **GitLab CI** for automation.  
- Each environment’s desired state lives in Git. Argo CD continuously reconciles it.
- The `dev` environment auto-tracks the env repo's `main` branch (auto-deploy).
- `staging` and `prod` environments use PRs/MRs to promote versions.

Each app repo keeps its own code and base k8s manifests:
```
src/
Dockerfile
charts/payments/         # Helm chart (or k8s/base for Kustomize)
k8s/base/
.gitlab-ci.yml
```

Env repo keeps ArgoCD config and per-environment configs:
```
apps/
  dev/payments.yaml
  staging/payments.yaml
  prod/payments.yaml
overlays/
  dev/payments/values.yaml
  staging/payments/values.yaml
  prod/payments/values.yaml
```

1. **Tag in App Repo**
   - Developer tags a commit: `v1.2.3`.
   - CI builds and pushes `image: ghcr.io/acme/payments:v1.2.3`.

2. **Promote to Dev**
   - CI checks out the env repo.
   - Updates `dev` overlay (`image.tag` or `targetRevision` → `v1.2.3`).
   - Commits directly to `main` (auto-deploys via Argo CD).

3. **Verify Health**
   - CI polls Argo CD API until app is `Healthy` and `Synced`.
   - If unhealthy, rollback (revert to last tag).

4. **Promote to Staging**
   - After dev passes, CI opens MR in env repo bumping `staging` to same tag.
   - Merge triggers staging deploy.

5. **Promote to Prod**
   - Env repo pipeline detects staging merge.
   - Waits for Argo CD `Healthy`.
   - Opens MR to bump prod to same tag.
   - Merge = promote to prod.

## Rollback Strategy

### Automatic (CI-Level)
- If Argo CD health check fails (Degraded or OutOfSync beyond timeout):
  - CI clones env repo.
  - Reads previous tag from Git history.
  - Reverts file to previous tag and commits or opens rollback MR.

### Argo Rollouts (Optional)
- Use canary/blue-green strategy.
- Failed analysis auto-triggers rollback.
- CI follows up with a Git revert to maintain declarative state.

## GitLab CI Templates

### `.gitlab-ci.yml` (App Repo)

```yaml
stages: [build, promote-dev, gate-dev, open-staging-mr]

variables:
  IMAGE: $CI_REGISTRY_IMAGE
  APP_NAME: payments
  ENV_REPO_URL: https://gitlab.com/acme/gitops-env.git
  ENV_REPO_PROJECT_ID: "12345678"
  ARGO_SERVER: $ARGO_SERVER
  ARGO_TOKEN: $ARGO_TOKEN

build:
  stage: build
  rules: [ { if: '$CI_COMMIT_TAG' } ]
  image: docker:27
  services: [docker:27-dind]
  script:
    - echo "$CI_REGISTRY_PASSWORD" | docker login -u "$CI_REGISTRY_USER" "$CI_REGISTRY"
    - docker build -t "$IMAGE:$CI_COMMIT_TAG" .
    - docker push "$IMAGE:$CI_COMMIT_TAG"

promote_dev:
  stage: promote-dev
  image: alpine:3.20
  rules: [ { if: '$CI_COMMIT_TAG' } ]
  before_script:
    - apk add git yq kustomize
    - git config --global user.name "ci-bot"
    - git config --global user.email "ci@acme"
    - git clone "https://oauth2:${ENV_REPO_TOKEN}@${ENV_REPO_URL#https://}"
    - cd gitops-env
  script:
    - yq -i '.image.tag = env(CI_COMMIT_TAG)' overlays/dev/payments/values.yaml
    - git commit -am "dev(payments): $CI_COMMIT_TAG"
    - git push origin HEAD:main

wait_for_dev_healthy:
  stage: gate-dev
  image: alpine:3.20
  needs: ["promote_dev"]
  before_script:
    - apk add --no-cache curl jq git yq
  script:
    - APP="${APP_NAME}-dev"
    - |
      ok=0
      for i in $(seq 1 60); do
        s=$(curl -sk -H "Authorization: Bearer $ARGO_TOKEN" "$ARGO_SERVER/api/v1/applications/$APP")
        h=$(echo "$s" | jq -r '.status.health.status')
        y=$(echo "$s" | jq -r '.status.sync.status')
        echo "health=$h sync=$y"
        if [ "$h" = "Healthy" ] && [ "$y" = "Synced" ]; then ok=1; break; fi
        sleep 10
      done
      if [ $ok -eq 0 ]; then
        echo "Dev failed. Rolling back."
        git clone "https://oauth2:${ENV_REPO_TOKEN}@${ENV_REPO_URL#https://}"
        cd gitops-env
        # For Helm values rollback, read previous tag from git history
        FILE="$HELM_VALUES_DEV"
        PREV_TAG=$(git show HEAD~1:$FILE | yq -r '.image.tag')
        yq -i ".image.tag = \"$PREV_TAG\"" "$FILE"
        git config user.name ci-bot && git config user.email ci@acme
        git commit -am "rollback(dev ${APP_NAME}) to ${PREV_TAG}"
        git push origin HEAD:main
        exit 1
      fi

open_staging_mr:
  stage: open-staging-mr
  image: alpine:3.20
  needs: ["wait_for_dev_healthy"]
  script:
    - apk add git yq curl jq
    - git clone "https://oauth2:${ENV_REPO_TOKEN}@${ENV_REPO_URL#https://}"
    - cd gitops-env
    - BR="promote-payments-${CI_COMMIT_TAG}-staging"
    - git checkout -b "$BR"
    - yq -i '.image.tag = env(CI_COMMIT_TAG)' overlays/staging/payments/values.yaml
    - git add -A && git commit -m "staging(payments): $CI_COMMIT_TAG"
    - git push origin "$BR"
    - curl --header "PRIVATE-TOKEN: ${ENV_REPO_TOKEN}" \
        --data-urlencode "source_branch=$BR" \
        --data-urlencode "target_branch=main" \
        --data-urlencode "title=staging(payments): $CI_COMMIT_TAG" \
        "https://gitlab.com/api/v4/projects/${ENV_REPO_PROJECT_ID}/merge_requests"
```

### `.gitlab-ci.yml` (Env Repo)

```yaml
stages: [gate-staging, open-prod-mr]

variables:
  APP_NAME: payments
  ARGO_SERVER: $ARGO_SERVER
  ARGO_TOKEN: $ARGO_TOKEN

# This job will trigger when the MR created by `open_staging_mr` merges.
# It ensures the `staging` env is healthy before creating the MR to merge to `prod`.
gate_staging_and_rollback:
  stage: gate-staging
  rules:
    - changes:
        - $HELM_VALUES_STG
        - apps/staging/${APP_NAME}.yaml
  image: alpine:3.20
  before_script:
    - apk add --no-cache curl jq git yq
  script:
    - APP="${APP_NAME}-staging"
    - FILE="$HELM_VALUES_STG"
    - NEW_TAG=$(yq -r '.image.tag' "$FILE")
    - OLD_TAG=$(git show HEAD~1:$FILE | yq -r '.image.tag')
    - |
      ok=0
      for i in $(seq 1 60); do
        s=$(curl -sk -H "Authorization: Bearer $ARGO_TOKEN" "$ARGO_SERVER/api/v1/applications/$APP")
        h=$(echo "$s" | jq -r '.status.health.status')
        y=$(echo "$s" | jq -r '.status.sync.status')
        echo "health=$h sync=$y"
        if [ "$h" = "Healthy" ] && [ "$y" = "Synced" ]; then ok=1; break; fi
        sleep 10
      done
      if [ $ok -eq 0 ]; then
        echo "Staging unhealthy. Opening rollback MR to $OLD_TAG."
        BR="rollback-${APP_NAME}-${OLD_TAG}-staging"
        git checkout -b "$BR"
        yq -i ".image.tag = \"$OLD_TAG\"" "$FILE"
        git config user.name ci-bot && git config user.email ci@acme
        git commit -am "rollback(staging ${APP_NAME}) -> ${OLD_TAG}"
        git push origin "$BR"
        curl --header "PRIVATE-TOKEN: ${ENV_REPO_TOKEN}" \
          --data-urlencode "source_branch=$BR" \
          --data-urlencode "target_branch=main" \
          --data-urlencode "title=rollback staging(${APP_NAME}) to ${OLD_TAG}" \
          "https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/merge_requests"
        exit 1
      fi

open_prod_mr:
  stage: open-prod-mr
  needs: ["gate_staging"]
  image: alpine:3.20
  script:
    - apk add git yq curl jq
    - TAG=$(cat tag.txt)
    - BR="promote-payments-${TAG}-prod"
    - git fetch origin
    - git checkout -b "$BR"
    - yq -i ".image.tag = \"$TAG\"" overlays/prod/payments/values.yaml
    - git commit -am "prod(payments): $TAG"
    - git push origin "$BR"
    - curl --header "PRIVATE-TOKEN: ${ENV_REPO_TOKEN}" \
        --data-urlencode "source_branch=$BR" \
        --data-urlencode "target_branch=main" \
        --data-urlencode "title=prod(payments): $TAG" \
        "https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/merge_requests"
```        
