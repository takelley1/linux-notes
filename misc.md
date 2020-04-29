
## MANPAGES

`man 1 crontab` = view the `crontab` entry in manpage section.   1  
`man 5 crontab` = view the `crontab` entry in manpage section.   5

| manpage section     | category                                              |
|---------------------|-------------------------------------------------------|
| 1	              | shell commands and executables                        |
| 2                   |	sernel functions (system calls)                       |
| 3                   |	library functions                                     |
| 4                   |	special files (usually devices in `/dev`) and drivers |
| 5	              | file formats and conventions (e.g. `/etc/passwd`)     |
| 6	              | games                                                 |
| 7	              | miscellaneous                                         |
| 8	              | system administration commands and daemons            |
<sup>[1]</sup> 

---
## LOGS

`logger test123`   = send a test log to `/var/log/mesages.  `  
`tail -f file.txt` = view text file in as it updates in realtime (`-f` for follow.  )  
`ls -ltrh`         = list files sorted by last modified time, include filesize (`-h.  `)  
`journalctl -xe`   = show system log files with explanatory (`-x`) text included (systemd only.  )  
`strace`           = trace system call.  


`/etc/logrotate.d/` = log rotation scripts.   
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

`/var/log/messages` or `/var/log/syslog` = generic system activity logs.    
`/var/log/secure` or `/var/log/auth`     = authentication logs.    
`/var/log/kernel`                        = logs from the kernel.    
`/var/log/cron`                          = record of cron jobs.    
`/var/log/maillog`                       = log of all mail messages.    
`/var/log/faillog`                       = failed logon attempts.    
`/var/log/boot.log`                      = dump location of `init.d.  `  
`/var/log/dmesg`                         = kernel ring buffer logs for hardware drivers.    
`/var/log/httpd`                         = apache server logs.  


---
## MISC

`minute of hour | hour of day | day of month | month # | day of week` = crontab syntax.   

if `/sys/firmware/efi exists`, system is UEFI 

`man -k string` search man pages for given string 

### `shutdown` command

`shutdown -r now` or `reboot`                            = immediately reboot system.    
`shutdown 2 this machine is shutting down in 2 minutes!` = power off system in 2 minutes and send the provided message to all logged-in users.    
`shutdown -r 0:00`                                       = reboot at midnight tonight.  

### interesting lesser-known commands <sup>[2]</sup> 

- `set` 
- `type`
- `info`  
- `finger`
- `sar` 
- `at`        = run a command at a certain time, similar to crontab.  
- `read` 
- `case`      = test multiple conditions, similar to `if.  `
- `column`    = create columns from text input.    
- `join`      = like a database join but for text.      
- `comm`      = file comparison like a db join.      
- `paste`     = put lines in a file next to each other.      
- `rs`        = reshape arrays.      
- `jot`       = generate data.      
- `expand`    = replace spaces and/or tabs.      
- `time`      = track time and resourcing.      
- `watch`     = execute something on a schedule in realtime.      
- `iftop`     = visually show network traffic.      
- `jnettop`   = more detailed iftop.      
- `xxd`       = manipulate files in hex.      
- `mtr`       = powerful traceroute replacement.      
- `iotop`     = i/o stats.      
- `dig`       = dns queries.      
- `host`      = dns queries.      
- `man ascii` = lookup your ascii.      
- `dstat`     = powerful system statistics.      
- `jq`        = command line JSON parsing.      
- `pushd`     = push your pwd to a stack.      
- `popd`      = pop pwd off your stack.      
- `ncat`      = nmap-based replacement for nc.      
- `fuser`     = kills locking processes.      
- `tac`       = cat in reverse.      
- `slurm`     = network interface stats.      
- `rename`    = change spaces to underscores in names.      
- `bmon`      = a simple bandwidth monitor.      
- `lsmod`     = show kernel modules.      
- `printf`    = change the format of output.      
- `timeout`   = execute something and kill it soon after.      
- `disown`    = protect a job from disconnect.      
- `fc`        = edit your last command in your editor and execute it.      
- `tee`       = send output to stdout as well.      
- `pgrep`     = greps through processes.      
- `pkill`     = kills processes based on search.      
- `fmt`       = text formatter.      
- `multitail` = see logs in separate views.      
- `bc`        = an interactive calculator language.      
- `apropos`   = info on commands.      
- `strace`    = the uber debug tool.      
- `man units  = interesting.      
- `pstree`    = shows processes in a…well…tree.      
- `pv`        = a progress bar for piped commands.      
- `zgrep`     = grep within compressed files.      
- `zless`     = look at compressed files.      
- `nping`     = nmap-based custom packet creation.      
- `readlink`  = read values of links.      
- `iostate`   = look at your disk i/o.      
- `atop`      = another top.      
- `split`     = break a file into pieces.      
- `dd`        = disk writing.      
- `ndiff`     = show differences in nmap scans.      
- `ss`        = socket statistics (show apps using the Internet.  )    

[1]: https://www.geeksforgeeks.org/linux-man-page-entries-different-types/  
[2]: https://danielmiessler.com/blog/collection-of-less-commonly-used-unix-commands/  
