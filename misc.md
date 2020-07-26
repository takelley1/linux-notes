
## FIPS

`cat /proc/sys/crypto/fips_enabled` = Check if FIPS is enabled.<br>


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


---
## MISC

`minute of hour | hour of day | day of month | month # | day of week` = Crontab syntax.<br>

if `/sys/firmware/efi exists`, system is UEFI 

`man -k string` search man pages for given string 

### `shutdown` command

`shutdown -r now` or `reboot`                            = Immediately reboot system.<br>
`shutdown 2 this machine is shutting down in 2 minutes!` = Power off system in 2 minutes and send the provided message to all logged-in users.<br>
`shutdown -r 0:00`                                       = Reboot at midnight tonight.<br>

### Interesting lesser-known commands <sup>[2]</sup> 

- `apropos`   = Info on commands.<br>
- `at`        = Run a command at a certain time, similar to crontab.<br>
- `atop`      = Another top.<br>
- `bc`        = An interactive calculator language.<br>
- `bmon`      = A simple bandwidth monitor.<br>
- `case`      = Test multiple conditions, similar to `if`.<br>
- `column`    = Create columns from text input.<br>
- `comm`      = File comparison like a db join.<br>
- `dd`        = Disk writing.<br>
- `dig`       = Dns queries.<br>
- `disown`    = Protect a job from disconnect.<br>
- `dstat`     = Powerful system statistics.<br>
- `expand`    = Replace spaces and/or tabs.<br>
- `fc`        = Edit your last command in your editor and execute it.<br>
- `finger`
- `fmt`       = Text formatter.<br>
- `fuser`     = Kills locking processes.<br>
- `host`      = Dns queries.<br>
- `iftop`     = Visually show network traffic.<br>
- `info`  
- `iostate`   = Look at your disk i/o.<br>
- `iotop`     = I/o stats.<br>
- `jnettop`   = More detailed iftop.<br>
- `join`      = Like a database join but for text.<br>
- `jot`       = Generate data.<br>
- `jq`        = Command line JSON parsing.<br>
- `lsmod`     = Show kernel modules.<br>
- `man ascii` = Lookup your ascii.<br>
- `man units  = Interesting.<br>
- `mtr`       = Powerful traceroute replacement.<br>
- `multitail` = See logs in separate views.<br>
- `ncat`      = Nmap-based replacement for nc.<br>
- `ndiff`     = Show differences in nmap scans.<br>
- `nping`     = Nmap-based custom packet creation.<br>
- `paste`     = Put lines in a file next to each other.<br>
- `pgrep`     = Greps through processes.<br>
- `pkill`     = Kills processes based on search.<br>
- `popd`      = Pop pwd off your stack.<br>
- `printf`    = Change the format of output.<br>
- `pstree`    = Shows processes in a…well…tree.<br>
- `pushd`     = Push your pwd to a stack.<br>
- `pv`        = A progress bar for piped commands.<br>
- `read` 
- `readlink`  = Read values of links.<br>
- `rename`    = Change spaces to underscores in names.<br>
- `rs`        = Reshape arrays.<br>
- `sar` 
- `set` 
- `slurm`     = Network interface stats.<br>
- `split`     = Break a file into pieces.<br>
- `ss`        = Socket statistics (show apps using the Internet).<br>
- `strace`    = The uber debug tool.<br>
- `tac`       = Cat in reverse.<br>
- `tee`       = Send output to stdout as well.<br>
- `time`      = Track time and resourcing.<br>
- `timeout`   = Execute something and kill it soon after.<br>
- `type`
- `watch`     = Execute something on a schedule in realtime.<br>
- `xxd`       = Manipulate files in hex.<br>
- `zgrep`     = Grep within compressed files.<br>
- `zless`     = Look at compressed files.<br>

[1]: https://www.geeksforgeeks.org/linux-man-page-entries-different-types/  
[2]: https://danielmiessler.com/blog/collection-of-less-commonly-used-unix-commands/  
