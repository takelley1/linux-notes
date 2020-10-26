
## PACKAGE MANAGERS

- **See also**:
  - [Comparison of package managers](https://fusion809.github.io/comparison-of-package-managers/)

| Package managers compared         | yum/dnf (rpm files)            | apt (deb files)             | pacman (tgz, ztd files)       | pkg                 |
|-----------------------------------|--------------------------------|-----------------------------|-------------------------------|---------------------|
| Show installed packages           | `rpm -qa`                      | `dpkg --list`               | `pacman -Q`                   | `pkg info`          |
| Show package that provides file x | `yum whatprovides x`           | `dpkg -S x`                 | `pacman -F x`                 | `pkg which x`       |
| Show files from package x         | `repoquery --list x`           | ?                           | `pacman -Ql x`                | `pkg query '%Fp' x` |
| Show package x info               | `yum info x`                   | `apt-cache show x`          | `pacman -Qi x`                | `pkg info x`        |
| Install package group x           | `yum groupinstall x`           | ?                           | `pacman -S x`                 | ?                   |
| Show package groups               | `yum group list`               | ?                           | `pacman -Qg`                  | ?                   |
| Remove duplicate packages         | `package-cleanup --cleandupes` | -                           | -                             | ?                   |
| Remove orphaned packages          | -                              | `apt autoremove`            | `pacman -Rns $(pacman -Qdtq)` | `pkg autoremove`    |
| Show update history               | `yum history list all`         | `/var/log/apt/history.log`  | `/var/log/pacman.log`         | `/var/log/messages` |
| Show info from recent transaction | `yum history info <ID>`        | -                           | -                             | -                   |
| Rollback update                   | `yum history undo <ID>`        | `apt-history rollback`      | `pacman -U /var/cache/pacman/pkg/<pkg-version>`| -  |

| Repo actions compared   | yum/dnf               | apt                        | pacman                    | pkg |
|-------------------------|-----------------------|----------------------------|---------------------------|-----|
| Add repo x              | `yum --enablerepo=x`  | `add-apt-repository x`     | `/etc/pacman.conf`        | ?   |
| Add third-party repo x  | `/etc/yum.repos.d/`   | `add-apt-repository ppa:x` | ?                         | ?   |
| Show available repos    | `yum repolist all`    | `/etc/apt.sources.list`    | ?                         | ?   |
| Show installed repos    | `yum repolist`        | `/etc/apt.sources.list`    | `/etc/pacman.conf`        | ?   |

- `-` = Not supported.
- `?` = Unkown.

#### rpm

- `rpm -ivh file.rpm` = Install rpm file as package.
  - `-i` = Install rpm.
  - `-v` = Verbose.
  - `-h` = Use hash marks to display progress.
<br><br>
- `yum install ./file.rpm` = Install .rpm file and automatically resolve and install dependencies.
  - `-v` = Be verbose.
  - `-h` = Use hash marks to display progress.

### yum/dnf & rpm

- `yum install epel-release` = Install EPEL repo.

---
#### Add ISO repo to CentOS 6

1. Go to centos.org.
1. Click 'get centos now'.
1. Click 'alternative downloads'.
1. Click 'i386' in the row corresponding to CentOS version 6.
1. Click any mirror link.
1. Click the `.iso` you wish to download. It will likely be the largest one. Don't download the torrent.
1. Save it anywhere.
1. Launch the VM and in the top-left corner of VMWare, click VM -> Removable Devices -> CD/DVD -> Connect.
1. Navigate to the `.iso` image file you downloaded.
1. Inside the VM, run `sudo mount /dev/cdrom /[mount-location]`.
1. The disk is now mounted and you can browse the packages.
1. To turn the packages into a full repo, you need to add the disk ID to the yum configuration. you can do that as follows: `head -1 /[mount-location]/.discinfo`
1. Copy that number.
1. Run your favorite text editor to open `/etc/yum.repos.d/CentOS-Base.repo`.
1. For each repo you'd like to add, next to `mediaid=` , enter the number you copied.
1. Next to `baseurl=`, enter the path of the mounted disk. For example, if you mounted the disk on `/mnt`, the row would read `baseurl=file:///mnt`.
1. Run `yum clean all`.
1. Yum should now recognize the disk as a repository.
