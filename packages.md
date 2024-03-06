## Package Managers

- **See also**:
  - [Pacman rosetta](https://wiki.archlinux.org/index.php/Pacman/Rosetta)
  - [Comparison of package managers](https://fusion809.github.io/comparison-of-package-managers/)

| Package managers compared         | yum/dnf (rpm files)            | apt (deb files)            | pacman (tgz, ztsd files)      | pkg                             |
|-----------------------------------|--------------------------------|----------------------------|-------------------------------|---------------------------------|
| List installed packages by size   | ?                              | [1]                        | [2]                           | `pkg query '%sh %n' \| sort -h` |
| Show installed packages           | `rpm -qa`                      | `dpkg -l`                  | `pacman -Q`                   | `pkg info`                      |
| Show package that provides file x | `yum whatprovides x`           | `dpkg -S x`                | `pacman -F x`                 | `pkg which x`                   |
| Show files from package x         | `repoquery --list x`           | `dpkg -L x`                | `pacman -Ql x`                | `pkg query %Fp x`               |
| Show package x info               | `yum info x`                   | `apt info x`               | `pacman -Qi x`                | `pkg info x`                    |
| Show package x's dependencies     | `yum deplist x`                | `apt-rdepends x`           | `pacman -Qi x`                | `pkg query %do x`               |
| Show packages that depend on x    | `rpm -q --whatrequires x`      | `apt depends x`            | `pacman -Qi x`                | `pkg query %ro x`               |
| Install package group x           | `yum groupinstall 'x'`         | ?                          | `pacman -S x`                 | -                               |
| Show package groups               | `yum group list`               | ?                          | `pacman -Qg`                  | -                               |
| Remove orphaned packages          | -                              | `apt autoremove`           | `pacman -Rns $(pacman -Qdtq)` | `pkg autoremove`                |
| Show update history               | `yum history list all`         | `/var/log/apt/history.log` | `/var/log/pacman.log`         | `/var/log/messages`             |
| Rollback update                   | `yum history undo <ID>`        | `apt-history rollback`     | `pacman -U /var/cache/pacman/pkg/<pkg-version>`| -              |
| Show info from recent transaction | `yum history info <ID>`        | -                          | -                             | -                               |
| Remove duplicate packages         | `package-cleanup --cleandupes` | -                          | -                             | -                               |

- [1] `dpkg-query --show --showformat='${Installed-Size}\t${Package}\n' | sort -n`
- [2] `pacman -Qi | awk -F: '/^Name/ {name=$2} /^Installed/ {gsub(/ /,"");size=$2;print size,name}'`

| Repo actions compared  | yum/dnf                         | apt                        | pacman             | pkg |
|------------------------|---------------------------------|----------------------------|--------------------|-----|
| Add repo x             | `yum-config-manager --enable x` | `add-apt-repository x`     | `/etc/pacman.conf` | ?   |
| Add third-party repo x | `/etc/yum.repos.d/`             | `add-apt-repository ppa:x` | ?                  | ?   |
| Show available repos   | `yum repolist all`              | `/etc/apt.sources.list`    | ?                  | ?   |
| Show installed repos   | `yum repolist`                  | `/etc/apt.sources.list`    | `/etc/pacman.conf` | ?   |

- `-` = Not supported.
- `?` = Unkown.

#### apt

- Finding specific package versions
1. Go to https://launchpad.net
2. Click `Ubuntu package building and hosting`
3. Search for your package
4. Select your package (example: https://launchpad.net/ubuntu/+source/firefox)
5. Click `View full publishing history` (example: https://launchpad.net/ubuntu/+source/firefox/+publishinghistory)
6. Click your desired package version (example: https://launchpad.net/ubuntu/+source/firefox/120.0.1+build1-0ubuntu0.20.04.1)
7. Under`Builds`, click your desired architecture (example: https://launchpad.net/~ubuntu-mozilla-security/+archive/ubuntu/ppa/+build/27033836)
8. Scroll down to `Built files` to download the specific `.deb` file package you want

#### pacman

- Issue: `package is marginal trust`
  - Solution:
    ```
    pacman -Sy archlinux-keyring && pacman -Syu
    ```
- Issue: `invalud or corrupted database (PGP signature)`
  - Solution:
    ```
    1. Comment out the top mirror in `/etc/pacman.d/mirrorlist`
    2. rm /var/lib/pacman/sync/*
    3. pacman -Syu
    ```

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
2. Click 'get centos now'.
3. Click 'alternative downloads'.
4. Click 'i386' in the row corresponding to CentOS version 6.
5. Click any mirror link.
6. Click the `.iso` you wish to download. It will likely be the largest one. Don't download the torrent.
7. Save it anywhere.
8. Launch the VM and in the top-left corner of VMWare, click VM -> Removable Devices -> CD/DVD -> Connect.
9. Navigate to the `.iso` image file you downloaded.
10. Inside the VM, run `sudo mount /dev/cdrom /[mount-location]`.
11. The disk is now mounted and you can browse the packages.
12. To turn the packages into a full repo, you need to add the disk ID to the yum configuration. you can do that as follows: `head -1 /[mount-location]/.discinfo`
13. Copy that number.
14. Run your favorite text editor to open `/etc/yum.repos.d/CentOS-Base.repo`.
15. For each repo you'd like to add, next to `mediaid=` , enter the number you copied.
16. Next to `baseurl=`, enter the path of the mounted disk. For example, if you mounted the disk on `/mnt`, the row would read `baseurl=file:///mnt`.
17. Run `yum clean all`.
18. Yum should now recognize the disk as a repository.
