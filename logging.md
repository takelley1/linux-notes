## LOGGING

- `logger test123`   = Send a test log to */var/log/mesages*.
- `strace`           = Trace system call.
  - `strace ls`   = Find out why *ls* is hanging.

### Journald

- `journalctl -xef` = Tail logs
- `journalctl -fu httpd` = Tail logs for the *httpd* service only:
- `journalctl -f --user-unit my_user_daemon` = Tail logs for *my_user_daemon*.
<br><br>
- `journalctl --no-full` = Don't wrap long lines

### [Rsyslog](https://www.rsyslog.com/)

- **See also:**
  - [Rsyslog aggregation](https://www.redhat.com/sysadmin/log-aggregation-rsyslog)
<br><br>
- `rsyslogd -f /etc/rsyslog.conf -N1` = Test validity of config file.

<details>
  <summary>/etc/rsyslog.conf example for a remote syslog server</summary>

```
# Run a TCP syslog listener on port 514.
Module (load="imtcp")
Input (type="imtcp" port="514")


Module (load="imuxsock")
Module (load="imklog")


# Allow logging to local system socket. Don't remove this!
$ModLoad imuxsock

# Template format for log messages. Since this is a remote server, each
#   host is placed in its own directory.
$template remote-incoming-logs, "/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* -?remote-incoming-logs


$OmitLocalLogging off
$IMJournalStateFile imjournal.state
# debug, info, notice, warning, warn (same as warning), err, error (same as err), crit, alert, or emerg.

# Include the config files from the below path.
$IncludeConfig /etc/rsyslog.d/*.conf
```
</details>

### Logrotate

- `logrotate -d /etc/logrotate.conf &>/dev/stdout | less` = Debug logrotate configuration.

- `/etc/logrotate.d/` = Log rotation scripts:
```
# Rotate the /var/log/syslog file daily and keep 7 copies of the rotated file,
#   limit file size to 100M.
/var/log/syslog
{
    rotate 7
    Size 100M
    daily

    missingok
    notifempty
    delaycompress
    compress

    postrotate
      reload rsyslog >/dev/null 2>&1 || true
    endscript
}
```

| Log locations                            |                                               |
|------------------------------------------|-----------------------------------------------|
| `/var/log/messages` or `/var/log/syslog` | Generic system activity logs.                 |
| `/var/log/secure` or `/var/log/auth`     | Authentication logs.                          |
| `/var/log/kernel`                        | Logs from the kernel.                         |
| `/var/log/cron`                          | Record of cron jobs.                          |
| `/var/log/maillog`                       | Log of all mail messages.                     |
| `/var/log/faillog`                       | Failed logon attempts.                        |
| `/var/log/boot.log`                      | Dump location of `init.d`.                    |
| `/var/log/dmesg`                         | Kernel ring buffer logs for hardware drivers. |
| `/var/log/httpd`                         | Apache server logs.                           |
