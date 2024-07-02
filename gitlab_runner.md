## GitLab Runner

- **See also**
  - [Gitlab-runner releases](https://gitlab.com/gitlab-org/gitlab-runner/-/releases)
  - [Official docs](https://docs.gitlab.com/runner/install/linux-manually.html)
 
### Troubleshooting

- Issue: GitLab runner on Helm in EKS doesn't register
  ```
  Merging configuration from template file "/configmaps/config.template.toml"
  ERROR: Verifying runner... failed  runner=7Bzg4bMt3 status=GET https://gitlab.example.com:443/api/v4/runners/verify: 401 Unauthorized
  PANIC: Failed to verify the runner.
  ```
  - Solution: Ensure ALL configuration settings for the runner use HTTPS rather than HTTP
    ```terraform
    set {
      name  = "gitlabUrl"
      value = "https://gitlab.${local.domain_name}"
    }
    set {
      name  = "runners.config"
      value = <<EOT
    [[runners]]
    url = "https://gitlab.${local.domain_name}"
    EOT
    }
    ```

### Installation

#### Shell runner
  ```bash
  wget \
    https://packages.gitlab.com/runner/gitlab-runner/packages/fedora/33/gitlab-runner-15.1.1-1.x86_64.rpm/download.rpm

  # Rename.
  mv download.rpm gitlab_runner.rpm

  # Copy runner package to remote server.
  scp gitlab_runner.rpm remote_server:~/

  # SSH onto server and Install runner.
  ssh remote_server
  sudo yum install -y --nogpgcheck gitlab_runner.rpm

  # Install runner as different user if needed.
  sudo gitlab-runner uninstall
  sudo gitlab-runner install --user myuser --working-directory /home/myuser
  sudo systemctl restart gitlab-runner

  # Register and configure runner.
  sudo gitlab-runner register

  # Start runner.
  sudo gitlab-runner start && sudo journalctl -fu gitlab-runner
  ```

### Updating

#### Shell runner
```bash
# Check the information of the current GitLab runner.
# Note the --working-directory and the --user
systemctl status gitlab-runner

# Check original version
gitlab-runner --version

# Install the newest package on the server.
yum install --nogpgcheck gitlab_runner.rpm

# Check new version
gitlab-runner --version

# Reinstall using the user and working directory.
gitlab-runner uninstall
gitlab-runner install --user myuser --working-directory /home/myuser
systemctl restart gitlab-runner

# Verify --working-directory and --user is correct
systemctl status gitlab-runner
```
