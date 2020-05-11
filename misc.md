
## MANPAGES

`man 1 crontab` = View the `crontab` entry in manpage section 1.  
`man 5 crontab` = View the `crontab` entry in manpage section 5.  

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

`logger test123`   = Send a test log to `/var/log/mesages`.  
`tail -f file.txt` = View text file in as it updates in realtime (`-f` for follow).  
`ls -ltrh`         = List files sorted by last modified time, include filesize (`-h`).  
`journalctl -xe`   = Show system log files with explanatory (`-x`) text included (systemd only).  
`strace`           = Trace system call.  


`/etc/logrotate.d/` = Log rotation scripts.   
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

`/var/log/messages` or `/var/log/syslog` = Generic system activity logs.    
`/var/log/secure` or `/var/log/auth`     = Authentication logs.    
`/var/log/kernel`                        = Logs from the kernel.    
`/var/log/cron`                          = Record of cron jobs.    
`/var/log/maillog`                       = Log of all mail messages.    
`/var/log/faillog`                       = Failed logon attempts.    
`/var/log/boot.log`                      = Dump location of `init.d`.  
`/var/log/dmesg`                         = Kernel ring buffer logs for hardware drivers.    
`/var/log/httpd`                         = Apache server logs.  


---
## MISC

`minute of hour | hour of day | day of month | month # | day of week` = Crontab syntax.   

if `/sys/firmware/efi exists`, system is UEFI 

`man -k string` search man pages for given string 

### `shutdown` command

`shutdown -r now` or `reboot`                            = Immediately reboot system.    
`shutdown 2 this machine is shutting down in 2 minutes!` = Power off system in 2 minutes and send the provided message to all logged-in users.    
`shutdown -r 0:00`                                       = Reboot at midnight tonight.  

### interesting lesser-known commands <sup>[2]</sup> 

- `set` 
- `type`
- `info`  
- `finger`
- `sar` 
- `at`        = Run a command at a certain time, similar to crontab.  
- `read` 
- `case`      = Test multiple conditions, similar to `if`.  
- `column`    = Create columns from text input.    
- `join`      = Like a database join but for text.      
- `comm`      = File comparison like a db join.      
- `paste`     = Put lines in a file next to each other.      
- `rs`        = Reshape arrays.      
- `jot`       = Generate data.      
- `expand`    = Replace spaces and/or tabs.      
- `time`      = Track time and resourcing.      
- `watch`     = Execute something on a schedule in realtime.      
- `iftop`     = Visually show network traffic.      
- `jnettop`   = More detailed iftop.      
- `xxd`       = Manipulate files in hex.      
- `mtr`       = Powerful traceroute replacement.      
- `iotop`     = I/o stats.      
- `dig`       = Dns queries.      
- `host`      = Dns queries.      
- `man ascii` = Lookup your ascii.      
- `dstat`     = Powerful system statistics.      
- `jq`        = Command line JSON parsing.      
- `pushd`     = Push your pwd to a stack.      
- `popd`      = Pop pwd off your stack.      
- `ncat`      = Nmap-based replacement for nc.      
- `fuser`     = Kills locking processes.      
- `tac`       = Cat in reverse.      
- `slurm`     = Network interface stats.      
- `rename`    = Change spaces to underscores in names.      
- `bmon`      = A simple bandwidth monitor.      
- `lsmod`     = Show kernel modules.      
- `printf`    = Change the format of output.      
- `timeout`   = Execute something and kill it soon after.      
- `disown`    = Protect a job from disconnect.      
- `fc`        = Edit your last command in your editor and execute it.      
- `tee`       = Send output to stdout as well.      
- `pgrep`     = Greps through processes.      
- `pkill`     = Kills processes based on search.      
- `fmt`       = Text formatter.      
- `multitail` = See logs in separate views.      
- `bc`        = An interactive calculator language.      
- `apropos`   = Info on commands.      
- `strace`    = The uber debug tool.      
- `man units  = Interesting.      
- `pstree`    = Shows processes in a…well…tree.      
- `pv`        = A progress bar for piped commands.      
- `zgrep`     = Grep within compressed files.      
- `zless`     = Look at compressed files.      
- `nping`     = Nmap-based custom packet creation.      
- `readlink`  = Read values of links.      
- `iostate`   = Look at your disk i/o.      
- `atop`      = Another top.      
- `split`     = Break a file into pieces.      
- `dd`        = Disk writing.      
- `ndiff`     = Show differences in nmap scans.      
- `ss`        = Socket statistics (show apps using the Internet).  

[1]: https://www.geeksforgeeks.org/linux-man-page-entries-different-types/  
[2]: https://danielmiessler.com/blog/collection-of-less-commonly-used-unix-commands/  
