## [GitLab](https://docs.gitlab.com/ee/)

### Troubleshooting

- [GitLab troubleshooting Linux cheat sheet](https://docs.gitlab.com/ee/administration/troubleshooting/linux_cheat_sheet.html)
- [`gitlab-ctl` commands](https://docs.gitlab.com/omnibus/maintenance/)
<br><br>
- `gitlab-ctl logs`
- `gitlab-ctl status`

### [`.gitlab-ci.yml`](https://docs.gitlab.com/ee/ci/yaml/)

- Long lines:
  - Join long lines with ` ` (a space).
    ```yaml
    my_job:
      script:
        - apt-get -qq install
          curl
          git
          unzip
    ```
  - Join long lines with `\n` (a new line).
    ```yaml
    my_job:
      script:
        - |
            if ! curl -Lks --retry 5 https://icanhazip.com; then
            echo "Unable to reach internet!"
            exit 1
            fi
    ```

### GitLab Runner

- Adding runner to an offline server:
  - Determine the latest release [here](https://gitlab.com/gitlab-org/gitlab-runner/-/releases)
  - See official docs [here](https://docs.gitlab.com/runner/install/linux-manually.html)
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
