
## PROCESSES

`CTRL-z` = Suspend current foreground job.<br>
`bg`     = Push most recently suspended job into background.<br>
`fg`     = Pull most recent background job into foreground.<br>

`ps -efH | less` = View current running process.<br>
            `-H` = Hierarchy in tree structure.<br>
            `-e` = Everything.<br>
            `-f` = Full-format.<br>

### signals <sup>[1]</sup>

| name      | ID | hotkey | description                                     |
|-----------|----|--------|-------------------------------------------------|
| `SIGHUP`  | 1  |        | process' controlling terminal has been closed   |
| `SIGINT`  | 2  | Ctrl-c | nicely ask process to cleanup and terminate     |
| `SIGQUIT` | 3  | Ctrl-\ | ask the process to perform a core dump          |
| `SIGKILL` | 9  |        | forcefully terminate process, cannot be ignored |
| `SIGTERM` | 15 |        | identical to `SIGINT`                           |
| `SIGSTP`  | 20 | Ctrl-z | ask the process to stop temporarily             |

### status codes

`D` = Uninterruptible sleep (CPU waiting for I/O to complete).<br>
`S` = Interruptible sleep (waiting for event).<br>
`T` = Stopped by job control signal.<br>
`R` = Running or in run queue.<br>

### commands

`top -u alice` = Show user alice’s currently running processes, use O to sort by column.<br>
`kill -s 9 7423` or `kill -9 7423` = End process with PID 7423 by sending it a `SIGKILL` signal.<br>

`exec bash`        = Restart bash shell.<br>
`strace [command]` = Trace system call.<br>

![performance-observation-tools](/images/performance-observation-tools.png)

## `top` COMMAND

### upper section

`15:39:37`          = System time.<br>
`up 90 days, 15:26` = Uptime in days, hours:minutes.<br>

`load average: 0.00, 0.00, 0.00` = Average total system load over 1min, 5min, 15min.<br>
(a value of 1 indicates one cpu core is fully occupied) (cat /proc/cpuinfo to find # of cores)<br>

ex. for a single-core system -- `0.4` = Cpu at 40% capacity, `1.12` = Cpu 'overloaded' by 12% capacity  <br>

ex. For a quad-core system – `1.0` = 3 cores idle, 1 core at full capacity, or all cores at 33% load (on average)  <br>

ex. `5.35` = System overloaded at 135% capacity, `1.35` processes were waiting for cpu time during the specified interval (1min, 5min or 15min)  <br>

`%cpu(s):` = Cpu time usage statistics, in % of total cpu time available<br>
      `us` = % cpu time running userpace processes<br>
      `sy` = % cpu time running kernel processes<br>
      `ni` = % cpu time running processes with manually set nice value (lower nice value = higher priority)<br>
      `id` = % cpu time idle (likely in a power save mode)<br>
      `wa` = % time cpu waiting for I/O requests to complete (e.g. waiting for HDD to locate and read data)  <br>
      `hi` = % cpu time handling hardware interrupts (keyboard & mouse events, peripherals, etc)<br>
      `si` = % cpu time handling software interrupts<br>
      `st` = (virtualized environments) % time OS is waiting for cpu to finish executing processes on another VM (st for steal)<br>

### lower section

`PID`     = Process ID.<br>
`USER`    = Process' 'effective' username.<br>
`PR & NI` = Priority & nice value, a lower nice value correlates to higher priority.<br>
`VIRT`    = Total memory consumed (includes physical memory and swap).<br>
`RES`     = Physical memory consumed.<br>
`SHR`     = Memory shared with other processes.<br>
`S`       = Process state.<br>

`%CPU`    = % of non-idle cpu time spent on process.<br>
`%MEM`    = % of physical memory consumed.<br>
`TIME+`   = Total cpu time used on process in format minutes:seconds:0.01 seconds.<br>
`COMMAND` = Process name.<br>

### hotkeys (case sensitive!)

`P` = Sort by %CPU column (default sort).<br>
`M` = Sort by %MEM column.<br>
`N` = Sort by PID column.<br>
`T` = Sort by TIME+ column.<br>
`R` = Reverse sort.<br>

`k` = Specify pid to kill the specified process.<br>
`c` = Show full process paths.<br>
`V` = Toggle tree view.<br>
`O` = Show search field.<br>
(ex. `COMMAND=audit`  = Filter processes with 'audit' in the COMMAND attribute)  <br>
(ex. `!COMMAND=getty` = Filter processes which do NOT have 'getty' in the COMMAND attribute)  <br>

Filters can be stacked via multiple searches, use = To clear all filters


---
## HARDWARE

`lsof -u alice` = List files currently open by processes (useful when unmounting a disk).<br>
     `-u alice` = Show files open by user alice.<br>

`lsmod` = Show status of kernel modules.<br>
`lspci` = List pci devices.<br>
`lsblk` = List bock devices.<br>

[1]: https://www.computerhope.com/unix/signals.htm
