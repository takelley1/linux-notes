## [Helm](https://helm.sh/docs/)

- `kubectl -n bigbang get hr bigbang -o yaml | less` = Inspect rendered values of a helm release.

- [Helm configuration for a GitLab runner:](https://docs.gitlab.com/runner/install/kubernetes.html)
```bash
# Create namespace for gitlab.
kubectl create namespace gitlab
# Create a runner pod for the cluster:
helm upgrade --install --namespace gitlab gitlab-runner -f values.yml gitlab/gitlab-runner
```
- The runner pod will listen for pipelines, then create a pod in the cluster to run each job in each pipeline.
  - A single kubernetes runner can handle multiple submitted pipelines in parallel
- See [here](https://docs.gitlab.com/runner/executors/kubernetes.html) for more info.
```yaml
gitlabUrl: http://gitlab.example.com
runnerRegistrationToken: "PUT_REGISTRATION_TOKEN_HERE"

# Enable RBAC
# https://docs.gitlab.com/runner/install/kubernetes.html#enabling-rbac-support
# https://gitlab.com/gitlab-org/gitlab/-/issues/25135
rbac:
  create: true
  serviceAccountName: gitlab-runner

check_interval: 0
concurrent: 20  # At most this runner can dispatch 20 individual jobs at once.

runners:
  name: eks_runner  # Name of the runner when it registers with GitLab.
  runUntagged: false  # Force the runner to only accept tagged jobs.
  tags: "EKS"

  config: |
    [[runners]]
    name = "eks"
    url = "http://gitlab.example.com"
    token = "PUT_REGISTRATION_TOKEN_HERE"
    executor = "kubernetes"

    [runners.kubernetes]                                                                                                                                                   
    namespace = "gitlab"
    [runners.kubernetes.dns_config]
#   vvv Set to override DNS configuration.
    nameservers = ["10.0.0.2"]  
 ```
