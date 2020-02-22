
## `.service` FILES

**see also:** [systemd man pages](http://0pointer.de/public/systemd-man/)

```bash
man systemd.unit
man systemd.service
man systemd.target
```
service files can be placed in `$HOME/.config/systemd/user/my_daemon.service` or `/etc/systemd/system/my_daemon.service`

example syntax
```bash
[Unit]
Description=My Miscellaneous Service
After=network.target

[Service]
Type=simple
# Another Type: forking
User=austin
WorkingDirectory=/home/austin
ExecStart=/home/austin/my_daemon --option=123
Restart=on-failure
# Other restart options: always, on-abort, etc

# The install section is needed to use
# `systemctl enable` to start on boot
# For a user service that you want to enable
# and start automatically, use `default.target`
# For system level services, use `multi-user.target`
[Install]
WantedBy=multi-user.target
```

```bash
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

```bash
[Unit]
Description=Example systemd service.

[Service]
Type=simple
ExecStart=/bin/bash /usr/bin/test_service.sh

[Install]
WantedBy=multi-user.target
```
<sup>[1], [2], [3]</sup> 

viewing service file logs
```bash
# See if running, uptime, view latest logs
sudo systemctl status
sudo systemctl status my_service
# Or for a user service
systemctl --user status my_service

# See all systemd logs
sudo journalctl

# Tail logs
sudo journalctl -f

# Show logs for specific service
sudo journalctl -u my_daemon
# For user service
journalctl --user-unit my_user_daemon
```
<sup>[1]</sup> 

systemd-analyze blame = show startup times by process


---
## RUNLEVELS

| `init` runlevel | `systemd` target                         | result                          |
|-----------------|------------------------------------------|---------------------------------|
| `0`             | `poweroff.target` / `runlevel0.target`   | shutdown                        |
| `1`             | `rescue.target` / `runlevel1.target`     | single-user mode / rescue shell |
| `2`             | `multi-user.target` / `runlevel2.target` | multi-user mode                 |
| `3`             | `multi-user.target` / `runlevel3.target` | multi-user mode                 |
| `5`             | `graphical.target` / `runlevel5.target`  | multi-user mode w/ GUI          |
| `6`             | `reboot.target` / `runlevel6.target`     | reboot                          |

| action                  | init                      | systemd                                   |
|-------------------------|---------------------------|-------------------------------------------|
|change default runlevel  |`/etc/init/rc-sysinit.conf`|`systemd set-default [TARGET]`             |
|change current runlevel  |`init #`                   |`systemd isolate [TARGET]`                 |
|get default runlevel     |                           |`systemctl get-default`                    |
|enter system rescue mode |`init 1`                   |`systemctl rescue` or `systemctl emergency`|


#### runlevel scripts

init:    place script in `/etc/rc#.d/`, in which `#` corresponds to the desired runlevel in which you'd like the script to run  
systemd: place script in `/etc/systemd/system/[TARGET].wants`  

[1]: https://www.devdungeon.com/content/creating-systemd-service-files  
[2]: https://www.shellhacks.com/systemd-service-file-example/  
[3]: https://www.linode.com/docs/quick-answers/linux/start-service-at-boot/ 

