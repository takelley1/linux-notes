
## [FREEBSD](https://www.freebsd.org/)

- **See also:**
  - [FreeBSD handbook](https://docs.freebsd.org/en/books/handbook/)
  - [FreeBSD wiki](https://wiki.freebsd.org/FrontPage)
  - [Recommended steps for new FreeBSD servers](https://www.digitalocean.com/community/tutorials/recommended-steps-for-new-freebsd-12-0-servers)

| Linux command      | FreeBSD equivalent    |
|--------------------|-----------------------|
| `useradd`          | `adduser`             |
| `userdel`          | `rmuser`              |
| `chage`            | `chpass`              |
| `usermod -a -G`    | `pw groupmod`         |
| `yay` (Arch Linux) | `portsnap/portmaster` |

### Tips

- **See also:**
  - [Network tuning](https://calomel.org/freebsd_network_tuning.html)
  - [Sysctl tuning](https://serverfault.com/questions/64356/freebsd-performance-tuning-sysctl-parameter-loader-conf-kernel)
<br><br>
- Use `sudo -i` instead of `sudo su` to ensure root's environment variables are loaded properly.
- If this is not done, running `crontab -e` as root won't invoke root's editor set by `$EDITOR`.

#### [Jails](https://docs.freebsd.org/en/books/handbook/jails/)

- Set `devfs_ruleset` to `2` to give the jail access to all the */dev* devices that are on the host.

#### /etc/rc.conf

- `sendmail_enable="NONE"` = fully disable sendmail.
- `moused_nondefault_enable="NO"` = Disable moused daemon.

### Useful commands

- `bsdconfig` = Text-based GUI for general system configuration.

### Misc

#### [BSDs compared](https://jameshoward.us/archive/the-bsd-family-tree/)

- FreeBSD is focused on robustness and stablility
- NetBSD is focused on portability
- OpenBSD is focused on security
