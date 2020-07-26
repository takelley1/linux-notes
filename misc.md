
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

### log locations

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

### interesting lesser-known commands <sup>[2]</sup> 

- `set` 
- `type`
- `info`  
- `finger`
- `sar` 
- `at`        = Run a command at a certain time, similar to crontab.<br>
- `read` 
- `case`      = Test multiple conditions, similar to `if`.<br>
- `column`    = Create columns from text input.<br>
- `join`      = Like a database join but for text.<br>
- `comm`      = File comparison like a db join.<br>
- `paste`     = Put lines in a file next to each other.<br>
- `rs`        = Reshape arrays.<br>
- `jot`       = Generate data.<br>
- `expand`    = Replace spaces and/or tabs.<br>
- `time`      = Track time and resourcing.<br>
- `watch`     = Execute something on a schedule in realtime.<br>
- `iftop`     = Visually show network traffic.<br>
- `jnettop`   = More detailed iftop.<br>
- `xxd`       = Manipulate files in hex.<br>
- `mtr`       = Powerful traceroute replacement.<br>
- `iotop`     = I/o stats.<br>
- `dig`       = Dns queries.<br>
- `host`      = Dns queries.<br>
- `man ascii` = Lookup your ascii.<br>
- `dstat`     = Powerful system statistics.<br>
- `jq`        = Command line JSON parsing.<br>
- `pushd`     = Push your pwd to a stack.<br>
- `popd`      = Pop pwd off your stack.<br>
- `ncat`      = Nmap-based replacement for nc.<br>
- `fuser`     = Kills locking processes.<br>
- `tac`       = Cat in reverse.<br>
- `slurm`     = Network interface stats.<br>
- `rename`    = Change spaces to underscores in names.<br>
- `bmon`      = A simple bandwidth monitor.<br>
- `lsmod`     = Show kernel modules.<br>
- `printf`    = Change the format of output.<br>
- `timeout`   = Execute something and kill it soon after.<br>
- `disown`    = Protect a job from disconnect.<br>
- `fc`        = Edit your last command in your editor and execute it.<br>
- `tee`       = Send output to stdout as well.<br>
- `pgrep`     = Greps through processes.<br>
- `pkill`     = Kills processes based on search.<br>
- `fmt`       = Text formatter.<br>
- `multitail` = See logs in separate views.<br>
- `bc`        = An interactive calculator language.<br>
- `apropos`   = Info on commands.<br>
- `strace`    = The uber debug tool.<br>
- `man units  = Interesting.<br>
- `pstree`    = Shows processes in a…well…tree.<br>
- `pv`        = A progress bar for piped commands.<br>
- `zgrep`     = Grep within compressed files.<br>
- `zless`     = Look at compressed files.<br>
- `nping`     = Nmap-based custom packet creation.<br>
- `readlink`  = Read values of links.<br>
- `iostate`   = Look at your disk i/o.<br>
- `atop`      = Another top.<br>
- `split`     = Break a file into pieces.<br>
- `dd`        = Disk writing.<br>
- `ndiff`     = Show differences in nmap scans.<br>
- `ss`        = Socket statistics (show apps using the Internet).<br>

[1]: https://www.geeksforgeeks.org/linux-man-page-entries-different-types/  
[2]: https://danielmiessler.com/blog/collection-of-less-commonly-used-unix-commands/  
