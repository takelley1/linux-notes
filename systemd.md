## [Systemd](https://systemd.io/)

- **See also:**
  - [systemd man pages](http://0pointer.de/public/systemd-man/)
  - systemd service file examples:
  [1,](https://www.devdungeon.com/content/creating-systemd-service-files)
  [2,](https://www.shellhacks.com/systemd-service-file-example/)
  [3](https://www.linode.com/docs/quick-answers/linux/start-service-at-boot/)
  - [cgroups](https://www.redhat.com/sysadmin/cgroups-part-one)

```bash
man systemd.unit
man systemd.service
man systemd.target
```

---
## [Unit Files](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#)

- User service files can be placed in `$HOME/.config/systemd/user/my_daemon.service` or
  `/etc/systemd/system/my_daemon.service`.

<details>
  <summary>Example 1: simple service</summary>

```systemd
[Unit]
Description=My Miscellaneous Service
After=network.target

[Service]
# Systemd forks "simple"-type services immediately into the background without
#   waiting to see if the service encountered an error.

Type=simple
User=austin
WorkingDirectory=/home/austin
ExecStart=/home/austin/my_daemon --option=123
# Other restart options: always, on-abort
Restart=on-failure

# The [Install] section is needed to use `systemctl enable` in order to start
#   the service on boot. For a user service that you want to enable and start
#   automatically, use `default.target`. For system level services, use
#   `multi-user.target`.
# See systemd.special(7) for details on each target.
[Install]
WantedBy=multi-user.target
```
</details>

<details>
  <summary>Example 2: nginx daemon</summary>

```systemd
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
</details>

<details>
  <summary>Example 3: service activated by a timer</summary>

```systemd
[Unit]
Description=My backup script service
After=network-online.target multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/backup.sh

# The [Install] section isn't used here because this unit isn't started on boot.
#   Rather, this unit is started by a timer.
```

```systemd
[Unit]
Description=My backup script service timer
After=network-online.target multi-user.target

[Timer]
OnCalendar=06:00:00
RandomizedDelaySec=120
```

</details>

### Overriding unit files

- Allows easily overriding the options in a a systemd unit file without editing the unit file itself.
- Search for "drop-in" in `systemd.unit(5)` for more information.
- Use `systemctl edit <SERVICE>` to automatically create an override file.
```
/etc/systemd/system/myservice.service.d/override.conf
```
```systemd
[Service]
# If the entry is parsed as a list (like ExecStart), it first must be "cleared".
ExecStart=
ExecStart=nice -n 5 /sbin/myservice
ExecReload=
ExecReload=nice -n 5 /sbin/myservice -r
```

---
## Commands

- `sudo systemctl status <SERVICE_NAME>` = See if running, uptime, view latest logs.
<br><br>
- `systemctl --user status <SERVICE_NAME>` = See status for user service.
<br><br>
- `systemd-analyze time` = Show startup times by process.


---
## Runlevels

| Init runlevel | Systemd target      | Result                          |
|---------------|---------------------|---------------------------------|
| 0             | `poweroff.target`   | Shutdown                        |
| 1             | `rescue.target`     | Single-user mode / rescue shell |
| 2             | `multi-user.target` | Multi-user mode                 |
| 3             | `multi-user.target` | Multi-user mode                 |
| 5             | `graphical.target`  | Multi-user mode w/ GUI          |
| 6             | `reboot.target`     | Reboot                          |

| Action                   | Init                        | Systemd                                     |
|--------------------------|-----------------------------|---------------------------------------------|
| Change default runlevel  | `/etc/init/rc-sysinit.conf` | `systemd set-default <TARGET>`              |
| Change current runlevel  | `init <RUNLEVEL>`           | `systemd isolate <TARGET>`                  |
| Get default runlevel     | -                           | `systemctl get-default`                     |
| Enter system rescue mode | `init 1`                    | `systemctl rescue` or `systemctl emergency` |


### Runlevel scripts

- init:    Place script in `/etc/rc#.d/`, in which `#` corresponds to the desired runlevel in which you'd like the script to run.
- systemd: Place or symlink script in `/etc/systemd/system/` and enable service.
