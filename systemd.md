## RUNLEVELS

| `init` runlevel | `systemd` target                         | result                          |
| --------------- | ---------------------------------------- | ------------------------------- |
| `0`             | `poweroff.target` / `runlevel0.target`   | shutdown                        |
| `1`             | `rescue.target` / `runlevel1.target`     | single-user mode / rescue shell |
| `2`             | `multi-user.target` / `runlevel2.target` | multi-user mode                 |
| `3`             | `multi-user.target` / `runlevel3.target` | multi-user mode                 |
| `5`             | `graphical.target` / `runlevel5.target`  | multi-user mode w/ GUI          |
| `6`             | `reboot.target` / `runlevel6.target`     | reboot                          |

| action                  | init | systemd |
|-------------------------|------|---------|
|change default runlevel|edit`/etc/init/rc- sysinit.conf`|`systemd set-default [TARGET]`|
|change current runlevel|`init #`|`systemd isolate [TARGET]`|
|get default runlevel|`systemctl get-default`||

#### runlevel scripts
- init - place script in `/etc/rc#.d/`, in which `#` corresponds to the desired runlevel in which you'd like the script to run
- systemd - place script in `/etc/systemd/system/[TARGET].wants/`

#### system recovery
- init - drop to runlevel 1 `init 1`
- systemd - enter rescue mode `systemctl rescue`
  - systemd - if rescue mode is not possible, enter emergency mode `systemctl emergency`
