## [GitLab](https://docs.gitlab.com/ee/)

### Troubleshooting

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

1. Snapshot GitLab server
2. Snapshot GitLab database
3. [View available packages with](https://unix.stackexchange.com/a/151690) `yum --showduplicates list gitlab-ee | less`
4. Upgrade with `yum install gitlab-ee-16.11.10-ee.0.el7`
