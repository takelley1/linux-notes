
---
## MISC

`minute of hour | hour of day | day of month | month # | day of week` = Crontab syntax.<br>

if `/sys/firmware/efi exists`, system is UEFI 

`man -k string` search man pages for given string 

### Shutdown

`shutdown -r now` or `reboot`                            = Immediately reboot system.<br>
`shutdown 2 this machine is shutting down in 2 minutes!` = Power off system in 2 minutes and send the provided message to all logged-in users.<br>
`shutdown -r 0:00`                                       = Reboot at midnight tonight.<br>

`who` or `w`  = View users currently logged in.<br>
`write alice` = Compose a message to the user alice (assuming she's logged in), use `CTRL-D` to send your message <sup>[3]</sup>

---
## FIPS

`cat /proc/sys/crypto/fips_enabled` = Check if FIPS is enabled.<br>


---
## PAM

`authconfig --disablesssdauth --update` = Remove pam sssd module.<br>

#### /etc/pam.d/ syntax
`TODO`


---
## MANPAGES

`man 1 crontab` = View the `crontab` entry in manpage section 1.<br>
`man 5 crontab` = View the `crontab` entry in manpage section 5.<br>

| manpage section | category                                              |
|-----------------|-------------------------------------------------------|
| 1	              | shell commands and executables                        |
| 2               |	sernel functions (system calls)                       |
| 3               |	library functions                                     |
| 4               |	special files (usually devices in `/dev`) and drivers |
| 5	              | file formats and conventions (e.g. `/etc/passwd`)     |
| 6	              | games                                                 |
| 7	              | miscellaneous                                         |
| 8	              | system administration commands and daemons            |
<sup>[1]</sup> 


---
## LOGS

`logger test123`   = Send a test log to `/var/log/mesages`.<br>
`tail -f file.txt` = View text file in as it updates in realtime (`-f` for follow).<br>
`ls -ltrh`         = List files sorted by last modified time, include filesize (`-h`).<br>
`journalctl -xe`   = Show system log files with explanatory (`-x`) text included (systemd only).<br>
`strace`           = Trace system call.<br>


`/etc/logrotate.d/` = Log rotation scripts.<br>
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

### Log locations

`/var/log/messages` or `/var/log/syslog` = Generic system activity logs.<br>
`/var/log/secure` or `/var/log/auth`     = Authentication logs.<br>
`/var/log/kernel`                        = Logs from the kernel.<br>
`/var/log/cron`                          = Record of cron jobs.<br>
`/var/log/maillog`                       = Log of all mail messages.<br>
`/var/log/faillog`                       = Failed logon attempts.<br>
`/var/log/boot.log`                      = Dump location of `init.d`.<br>
`/var/log/dmesg`                         = Kernel ring buffer logs for hardware drivers.<br>
`/var/log/httpd`                         = Apache server logs.<br>


[1]: https://www.geeksforgeeks.org/linux-man-page-entries-different-types/  
[3]: https://www.tecmint.com/send-a-message-to-logged-users-in-linux-terminal/
