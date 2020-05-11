
## FREEBSD

| linux command    | freebsd equivalent  |
|------------------|---------------------|
| useradd          | adduser             |
| userdel          | rmuser              |
| chage            | chpass              |
| usermod -a -G    | pw groupmod         |
| apt/yum/pacman   | pkg                 |
| yay (Arch Linux) | portsnap/portmaster |

### tips

-use `sudo -i` instead of `sudo su` to ensure root's environment variables are loaded properly  
  -if this is not done, running `crontab -e` as root won't invoke root's editor set by `$EDITOR`

### useful commands

`bsdconfig` = Text-based GUI for general system configuration.

### misc <sup>[1]</sup> 

FreeBSD is focused on robustness and stablility  
NetBSD is focused on portability  
OpenBSD is focused on security

[1]: https://jameshoward.us/archive/the-bsd-family-tree/  

