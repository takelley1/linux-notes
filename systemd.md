
## UNIT FILES

**See also:** [systemd man pages](http://0pointer.de/public/systemd-man/)

```bash
man systemd.unit
man systemd.service
man systemd.target
```
User service files can be placed in `$HOME/.config/systemd/user/my_daemon.service` or `/etc/systemd/system/my_daemon.service`.

Example syntax:
```
[Unit]
Description=My Miscellaneous Service
After=network.target

[Service]
# Systemd forks "simple"-type services immediately into the background without
# waiting to see if the service encountered an error for 

Type=simple
User=austin
WorkingDirectory=/home/austin
ExecStart=/home/austin/my_daemon --option=123
Restart=on-failure # Other restart options: always, on-abort

# The install section is needed to use `systemctl enable` to start on boot.
# For a user service that you want to enable and start automatically,
# use `default.target`. For system level services, use `multi-user.target`.
[Install]
WantedBy=multi-user.target
```

```
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

```
[Unit]
Description=Example systemd service.

[Service]
Type=simple
ExecStart=/bin/bash /usr/bin/test_service.sh

[Install]
WantedBy=multi-user.target
```
<sup>[1], [2], [3]</sup> 

Viewing service file logs:
```bash
# See if running, uptime, view latest logs:
sudo systemctl status
sudo systemctl status my_service

# Or for a user service:
systemctl --user status my_service

# See all systemd logs:
sudo journalctl

# Tail logs:
sudo journalctl -xef

# Tail logs for the httpd service only:
sudo journalctl -fu httpd

# For user service:
journalctl -f --user-unit my_user_daemon
```
<sup>[1]</sup> 

`systemd-analyze time` = Show startup times by process.


---
## RUNLEVELS

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


#### Runlevel scripts

init:    Place script in `/etc/rc#.d/`, in which `#` corresponds to the desired runlevel in which you'd like the script to run.
systemd: Place or symlink script in `/etc/systemd/system/` and enable service.

[1]: https://www.devdungeon.com/content/creating-systemd-service-files  
[2]: https://www.shellhacks.com/systemd-service-file-example/  
[3]: https://www.linode.com/docs/quick-answers/linux/start-service-at-boot/ 

