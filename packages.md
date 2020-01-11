
## PACKAGES

| package managers compared            | yum/dnf (.rpm files)                | apt (.deb files)              | pacman               | pkg          |
|--------------------------------------|-------------------------------------|-------------------------------|----------------------|--------------|
| update packages                      | `yum update`                        | `apt update && apt upgrade`   | `pacman -Syu`        | `pkg update` |
| show installed packages              | `rpm -qa`                           | `dpkg --list`                 | `pacman -Q`          |              |
| show package that provides file x    | `yum whatprovides x`                | `dpkg -S x`                   | `pacman -F x`        |              |
| get package x info                   | `yum info x`                        | `apt-cache show x`            | `pacman -Qi x`       |              |
| install package group x              | `yum groupinstall x`                | -                             | `pacman -S x`        |              |
| show package groups                  | `yum group list`                    | -                             | `pacman -Qg`         |              |
| remove duplicate packages            | `package-cleanup --cleandupes`      | -                             | -                    |              |
| remove orphaned packages             | -                                   | `apt autoremove`              | `pacman -Ru`         |              |
| show update history                  | `yum history list all`              | `/var/log/apt/history.log`    | `/var/log/pacman.log`|              |
| rollback update|`yum history undo [transaction-id]`|`apt-history rollback`|`pacman -U /var/cache/pacman/pkg/[old-package-version]`|              |

#### rpm

`rpm -ivh file.rpm` = install .rpm file as package  
               `-i` = install .rpm  
               `-v` = verbose  
               `-h` = use hash marks to display progress

`yum install ./file.rpm` = install .rpm file and automatically resolve and install dependencies


---
## REPOSITORIES

| action                  | yum/dnf               | apt                        | pacman                    | pkg |
|-------------------------|-----------------------|----------------------------|---------------------------|-----|
| show installed repos    | `yum repolist`        | `/etc/apt.sources.list`    | `/etc/pacman.conf`        |     |
| show available repos    | `yum repolist all`    | `/etc/apt.sources.list`    | -                         |     |
| add repo x              | `yum --enablerepo=x`  | `add-apt-repository x`     | `/etc/pacman.conf`        |     |
| add third-party repo x  | -                     | `add-apt-repository ppa:x` | -                         |     |

### yum/dnf & rpm

`yum install epel-release` = install EPEL repo

---
#### add iso repo to centos

1. go to centos.org
1. click 'get centos now'
1. click 'alternative downloads'
1. click 'i386' in the row corresponding to centos version 6
1. click any mirror link
1. click the `.iso` you wish to download. It will likely be the largest one. Don't download the torrent.
1. save it anywhere
1. launch the VM and in the top-left corner of VMWare, click VM -> Removable Devices -> CD/DVD -> Conenct
1. navigate to the `.iso` image file you downloaded
1. inside the VM, run `sudo mount /dev/cdrom /[mount-location]`
1. the disk is now mounted and you can browse the packages
1. to turn the packages into a full repo, you need to add the disk ID to the yum configuration. you can do that as follows:
1. run `head -1 /[mount-location]/.discinfo`
1. copy that number
1. run your favorite text editor to open `/etc/yum.repos.d/CentOS-Base.repo`
1. for each repo you'd like to add, next to `mediaid=` , enter the number you copied
1. next to `baseurl=`, enter the path of the mounted disk. For example, if you mounted the disk on `/mnt`, the row would read `baseurl=file:///mnt`
1. run `yum clean all`
1. yum should now recognize the disk as a repository

