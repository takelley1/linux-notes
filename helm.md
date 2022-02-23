
- [Helm configuration for a GitLab runner:](https://docs.gitlab.com/runner/install/kubernetes.html)
```bash
# Create namespace for gitlab.
kubectl create namespace gitlab
# To add 2 runner pods to the cluster:
helm upgrade --install --namespace gitlab gitlab-runner -f values.yml gitlab/gitlab-runner
helm upgrade --install --namespace gitlab gitlab-runner2 -f values.yml gitlab/gitlab-runner
```
```yaml
gitlabUrl: http://gitlab.example.com
runnerRegistrationToken: "PUT_REGISTRATION_TOKEN_HERE"

# Enable RBAC
# https://docs.gitlab.com/runner/install/kubernetes.html#enabling-rbac-support
# https://gitlab.com/gitlab-org/gitlab/-/issues/25135
rbac:
  create: true
  serviceAccountName: gitlab-runner

# Runner name
name: eks

check_interval: 0

# [session_server]
#   session_timeout = 1800

runners:
  config: |
    [[runners]]
    name = "eks"
    url = "http://gitlab.example.com"
    token = "PUT_REGISTRATION_TOKEN_HERE"
    executor = "docker"
    environment = ["DOCKER_AUTH_CONFIG={ \"credsStore\": \"ecr-login\" }"]

    [runners.custom_build_dir]
    [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]

    [runners.docker]
    tls_verify = false
    # pull_policy = "if-not-present"
    image = "docker:20.10.12"
    dns = ["8.8.8.8"]
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
    shm_size = 0
 ```
