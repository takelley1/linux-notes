## [GitLab](https://docs.gitlab.com/ee/)

### Troubleshooting

- Issue: `Invalid symmetric difference expression <SHA>...HEAD` when running `git diff` during a CICD pipeline
  - Fix: Increase the git shallow clone depth: `settings -> CI/CD -> General Pipelines -> Git shallow clone`, set it to `200`
<br><br>
- [GitLab troubleshooting Linux cheat sheet](https://docs.gitlab.com/ee/administration/troubleshooting/linux_cheat_sheet.html)
- [`gitlab-ctl` commands](https://docs.gitlab.com/omnibus/maintenance/)
  - `gitlab-ctl tail` = Tail all logs at once.
  - `gitlab-ctl status` = Show status of each service.
<br><br>
  - NOTE: Sometimes GitLab requires both a restart and a reconfigure for configuration changes to apply!
    - `gitlab-ctl restart && gitlab-ctl reconfigure`

### [`.gitlab-ci.yml`](https://docs.gitlab.com/ee/ci/yaml/)

- NOTE: `after_script:` blocks [ignore nonzero exit codes!](https://stackoverflow.com/a/72984677)
<br><br>
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

## Upgrades

1. [Read upgrade notes](https://docs.gitlab.com/ee/update/package/) and [Upgrade guide](https://docs.gitlab.com/update/upgrade/)
1. Post notification to users
2. Snapshot GitLab server
3. Snapshot GitLab database
4. Remove version lock
   ```
   dnf versionlock list
   dnf versionlock delete gitlab-ee
   ```
5. [View available packages](https://unix.stackexchange.com/a/151690)
   ```
   dnf --showduplicates list gitlab-ee | less
   ```
6. Upgrade package
   ```
   dnf install gitlab-ee-16.11.10-ee.0.el7
   ```
7. Add version lock
   ```
   dnf versionlock list
   dnf versionlock add gitlab-ee
   ```
