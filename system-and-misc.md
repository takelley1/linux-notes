 ## SHELL

`while true; do [COMMAND] ; sleep 10; done` = loop command indefinitely 

`[COMMAND] &` = run command in background \
`[COMMAND1] && [COMMAND2]` = run command2 only if command1 is successful \
`[COMMAND1] || [COMMAND2]` = run command2 only if command1 is NOT successful \ 
`[COMMAND1] ; [COMMAND2]` = run command2 immediately after command1, even if command1 is not successful (ex: `cd /home ; ls`)

`sudo !!` = execute last command (`!!`) with sudo privileges

`1>` or `>` = stdout \
`2>` = stderr \
`2>&1` or `&>` = stdout and stderr 

`cat /file.log 2>&1 | grep -i error` = pass both stdout and stderr to grep through pipe, by default pipe only passes stdout \
`stat /home/file.txt` = show last modified date, creation date, and other metadata about given file 


## BASH HOTKEYS

`CTRL-r` = search command history \
`CTRL-l` = clear screen \
`CTRL-z` = suspend command

`ALT-f` = jump forward one word (when editing a command) \
`ALT-b` = jump backward one word (when editing a command) 

 
## ENVIRONMENT VARIABLES 

`echo $VARIABLE-NAME` = get value of VARIABLE-NAME \
`printenv` = get values of all environment variables \
`export HOME=/home/newhomedir` = set value of environment variable (note lack of `$`)
 
`DISPLAY` = name of X window display \
`EDITOR` = default text editor \
`HOME` = path of current user's home directory \
`LOGNAME` = current user's login name \
`MAIL` = path of current user's mailbox \
`OLDPWD` = the shell's previous working directory \
`PATH` = where the shell looks for command binaries, paths separated by a colon \
`PWD` = the shell's current working directory \
`SHELL` = path of the shell's binary \
`TERM` = type of terminal being used \
`USER` = current username 


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
