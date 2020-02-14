
## PROCESSES

`CTRL-z` = suspend current foreground job  
`bg`     = push most recently suspended job into background  
`fg`     = pull most recent background job into foreground

`ps -efH | less` = view current running process  
            `-H` = hierarchy in tree structure  
            `-e` = everything  
            `-f` = full-format

### signals

| name      | ID | hotkey | description                                     |
|-----------|----|--------|-------------------------------------------------|
| `SIGHUP`  | 1  |        | process' controlling terminal has been closed   |
| `SIGINT`  | 2  | Ctrl-c | nicely ask process to cleanup and terminate     |
| `SIGQUIT` | 3  | Ctrl-\ | ask the process to perform a core dump          |
| `SIGKILL` | 9  |        | forcefully terminate process, cannot be ignored |
| `SIGTERM` | 15 |        | identical to `SIGINT`                           |
| `SIGSTP`  | 20 | Ctrl-z | ask the process to stop temporarily             |

[1]

### status codes

`D` = uninterruptible sleep (CPU waiting for I/O to complete)  
`S` = interruptible sleep (waiting for event)  
`T` = stopped by job control signal  
`R` = running or in run queue

### commands

`top -u alice` = show user alice’s currently running processes, use O to sort by column  
`kill -s 9 7423` or `kill -9 7423` = end process with PID 7423 by sending it a `SIGKILL` signal  

`exec bash`        = restart bash shell  
`strace [command]` = trace system call

![performance-observation-tools](/images/performance-observation-tools.png)
 
## `top` COMMAND

### upper section

`15:39:37`          = system time  
`up 90 days, 15:26` = uptime in days, hours:minutes

`load average: 0.00, 0.00, 0.00` = average total system load over 1min, 5min, 15min  
(a value of 1 indicates one cpu core is fully occupied) (cat /proc/cpuinfo to find # of cores)

ex. for a single-core system -- `0.4` = cpu at 40% capacity, `1.12` = cpu 'overloaded' by 12% capacity  

ex. For a quad-core system – `1.0` = 3 cores idle, 1 core at full capacity, or all cores at 33% load (on average)  

ex. `5.35` = system overloaded at 135% capacity, `1.35` processes were waiting for cpu time during the specified interval (1min, 5min or 15min)  

`%cpu(s):` = cpu time usage statistics, in % of total cpu time available  
      `us` = % cpu time running userpace processes  
      `sy` = % cpu time running kernel processes  
      `ni` = % cpu time running processes with manually set nice value (lower nice value = higher priority)  
      `id` = % cpu time idle (likely in a power save mode)  
      `wa` = % time cpu waiting for I/O requests to complete (e.g. waiting for HDD to locate and read data)  
      `hi` = % cpu time handling hardware interrupts (keyboard & mouse events, peripherals, etc)  
      `si` = % cpu time handling software interrupts  
      `st` = (virtualized environments) % time OS is waiting for cpu to finish executing processes on another VM (st for steal) 

### lower section

`PID`     = process ID  
`USER`    = process' 'effective' username  
`PR & NI` = priority & nice value, a lower nice value correlates to higher priority  
`VIRT`    = total memory consumed (includes physical memory and swap)  
`RES`     = physical memory consumed  
`SHR`     = memory shared with other processes  
`S`       = process state

`%CPU`    = % of non-idle cpu time spent on process  
`%MEM`    = % of physical memory consumed  
`TIME+`   = total cpu time used on process in format minutes:seconds:0.01 seconds  
`COMMAND` = process name 

### hotkeys (case sensitive!)

`P` = sort by %CPU column (default sort)  
`M` = sort by %MEM column  
`N` = sort by PID column  
`T` = sort by TIME+ column  
`R` = reverse sort 

`k` = specify pid to kill the specified process  
`c` = show full process paths  
`V` = toggle tree view  
`O` = show search field  
(ex. `COMMAND=audit`  = filter processes with 'audit' in the COMMAND attribute)  
(ex. `!COMMAND=getty` = filter processes which do NOT have 'getty' in the COMMAND attribute)  

Filters can be stacked via multiple searches, use = to clear all filters  


---
## HARDWARE

`lsof -u alice` = list files currently open by processes (useful when unmounting a disk) 
     `-u alice` = show files open by user alice 

`lsmod` = show status of kernel modules  
`lspci` = list pci devices  
`lsblk` = list bock devices  

---
#### sources

[1] https://www.computerhope.com/unix/signals.htm
