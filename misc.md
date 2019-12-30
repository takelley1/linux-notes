
## MANPAGES

`man 1 crontab` = view the `crontab` entry in `manpage` section 1  
`man 5 crontab` = view the `crontab` entry in `manpage` section 5

| manpage section [1] | category                                              |
|---------------------|-------------------------------------------------------|
| 1	              | shell commands and executables                        |
| 2                   |	sernel functions (system calls)                       |
| 3                   |	library functions                                     |
| 4                   |	special files (usually devices in `/dev`) and drivers |
| 5	              | file formats and conventions (e.g. `/etc/passwd`)     |
| 6	              | games                                                 |
| 7	              | miscellaneous                                         |
| 8	              | system administration commands and daemons            |

---
## MISC

#### `shutdown` command

`shutdown -r now` or `reboot` = immediately reboot system  
`shutdown 2 this machine is shutting down in 2 minutes!` = power off system in 2 minutes and send the provided message to all logged-in users  
`shutdown -r 0:00` = reboot at midnight tonight

crontab syntax 
`minofhour|hourofday|dayofmonth|month#|dayofweek`

if `/sys/firmware/efi exists`, system is UEFI 

`CTRL-SHIFT-j` or `CTRL-j` to get shell prompt back after `CTRL-c` has resulted in an unresponsive program 

`man -k string` search man pages for given string 

`history` = print past commands to stdout, grep and use ![line_number] to repeat command without retyping; [or] use CTRL+R to search history 

#### interestimg lesser-known commands

- `set` 
- `type`
- `info`  
- `watch` 
- `finger`
- `sar` 
- `at` 
- `read` 
- `case` 
- `fuser`


---
## LOGS

`logger test123`   = send a test log to `/var/log/mesages`  
`tail -f file.txt` = view text file in as it updates in realtime (`-f` for follow)  
`ls -ltrh`         = list files sorted by last modified time, include filesize (`-h`)  
`journalctl -xe`   = show system log files with explanatory (`-x`) text included (systemd only)  
`strace`           = trace system call


`/etc/logrotate.d/` = log rotation scripts 
```
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
rotate the `/var/log/syslog` file daily and keep 7 copies of the rotated file, limit size to 100M 

#### log locations

`/var/log/messages` or `/var/log/syslog` = generic system activity logs  
`/var/log/secure` or `/var/log/auth`     = authentication logs  
`/var/log/kernel`                        = logs from the kernel  
`/var/log/cron`                          = record of cron jobs  
`/var/log/maillog`                       = log of all mail messages  
`/var/log/faillog`                       = failed logon attempts  
`/var/log/boot.log`                      = dump location of `init.d`  
`/var/log/dmesg`                         = kernel ring buffer logs for hardware drivers  
`/var/log/httpd`                         = apache server logs


[1] https://www.geeksforgeeks.org/linux-man-page-entries-different-types/

