## RUNLEVELS

| `init` runlevel | `systemd` target                         | result                          |
| --------------- | ---------------------------------------- | ------------------------------- |
| `0`             | `poweroff.target` / `runlevel0.target`   | shutdown                        |
| `1`             | `rescue.target` / `runlevel1.target`     | single-user mode / rescue shell |
| `2`             | `multi-user.target` / `runlevel2.target` | multi-user mode                 |
| `3`             | `multi-user.target` / `runlevel3.target` | multi-user mode                 |
| `5`             | `graphical.target` / `runlevel5.target`  | multi-user mode w/ GUI          |
| `6`             | `reboot.target` / `runlevel6.target`     | reboot                          |

#### get default runlevel
systemd - `systemctl get-default`

#### change default runlevel
- init - edit `/etc/init/rc-sysinit.conf`
- systemd - `systemd set-default [TARGET]`

#### change current runlevel
- init - `init #`
- systemd - `systemd isolate [TARGET]`

#### runlevel scripts
- init - place script in `/etc/rc#.d/`, in which `#` corresponds to the desired runlevel in which you'd like the script to run
- systemd - place script in `/etc/systemd/system/[TARGET].wants/`

#### system recovery
- init - drop to runlevel 1 `init 1`
- systemd - enter rescue mode `systemctl rescue`
  - systemd - if rescue mode is not possible, enter emergency mode `systemctl emergency`


## MISC

#### `shutdown` command
`shutdown -r now` or `reboot` = immediately reboot system \
`shutdown 2 this machine is shutting down in 2 minutes!` = power off system in 2 minutes and send the provided message to all logged-in users \
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
