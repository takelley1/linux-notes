## GitLab

### GitLab Runner

- Adding runner to an offline server:
  - Determine the latest release [here](https://gitlab.com/gitlab-org/gitlab-runner/-/releases)
  - See official docs [here](https://docs.gitlab.com/runner/install/linux-manually.html)
  ```bash
  wget \
    https://packages.gitlab.com/runner/gitlab-runner/packages/fedora/33/gitlab-runner-15.1.1-1.x86_64.rpm/download.rpm
  # Rename.
  mv download.rpm gitlab_runner.rpm
  # Copy runner package to remote server
  scp gitlab_runner.rpm remote_server:~/
  # SSH onto server and Install runner.
  ssh remote_server
  yum install -y --nogpgcheck gitlab_runner.rpm
  # Install runner as different user if needed
  gitlab-runner uninstall
  gitlab-runner install --user myuser --working-directory /home/myuser
  systemctl restart gitlab-runner
  # Register and configure runner.
  gitlab-runner register
  # Start runner.
  gitlab-runner start && journalctl -fu gitlab-runner
