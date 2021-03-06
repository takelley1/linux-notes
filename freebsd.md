
## FREEBSD

| Linux command      | FreeBSD equivalent    |
|--------------------|-----------------------|
| `useradd`          | `adduser`             |
| `userdel`          | `rmuser`              |
| `chage`            | `chpass`              |
| `usermod -a -G`    | `pw groupmod`         |
| `yay (Arch Linux)` | `portsnap/portmaster` |

### Tips

- Use `sudo -i` instead of `sudo su` to ensure root's environment variables are loaded properly.
- If this is not done, running `crontab -e` as root won't invoke root's editor set by `$EDITOR`.

#### Jails

- Set `devfs_ruleset` to `2` to give the jail access to all the */dev* devices that are on the host.

#### `/etc/rc.conf`

- `sendmail_enable="NONE"` = fully disable sendmail.
- `moused_nondefault_enable="NO"` = Disable moused daemon.

### Useful commands

- `bsdconfig` = Text-based GUI for general system configuration.

### Misc

#### [BSDs compared](https://jameshoward.us/archive/the-bsd-family-tree/)

- FreeBSD is focused on robustness and stablility
- NetBSD is focused on portability
- OpenBSD is focused on security
