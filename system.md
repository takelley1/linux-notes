## MANPAGES

`man 1 crontab` = view the `crontab` entry in `manpage` section 1  
`man 5 crontab` = view the `crontab` entry in `manpage` section 5

| `manpage` section [1] | category                                              |
| --------------------- | ----------------------------------------------------- |
| 1	                    | shell commands and executables                        |
| 2                     |	sernel functions (system calls)                       |
| 3                     |	library functions                                     |
| 4                     |	special files (usually devices in `/dev`) and drivers |
| 5	                    | file formats and conventions (e.g. `/etc/passwd`)     |
| 6	                    | games                                                 |
| 7	                    | miscellaneous                                         |
| 8	                    | system administration commands and daemons            |


## MISC

#### `shutdown` command
`shutdown -r now` or `reboot` = immediately reboot system  
`shutdown 2 this machine is shutting down in 2 minutes!` = power off system in 2 minutes and send the provided message to all logged-in users  
`shutdown -r 0:00` = reboot at midnight tonight

crontab syntax 
`minofhour|hourofday|dayofmonth|month#|dayofweek`

if `/sys/firmware/efi exists`, system is UEFI 

`CTRL-SHIFT-j` or `CTRL-j` to get shell prompt back after `CTRL-c` has resulted in an unresponsive program 

#### commands I need to learn 

- `set` 
- `type`
- `info` 
- `uniq` 
- `watch` 
- `finger`
- `sar` 
- `at` 
- `read` 
- `case` 
- `fuser`

[1] https://www.geeksforgeeks.org/linux-man-page-entries-different-types/
