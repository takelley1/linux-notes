
## PACKAGES

#### yum/dnf & rpm

`package-cleanup --cleandupes` = remove packages that have duplicate older versions

`rpm -ivh file.rpm` or `yum install ./file.rpm` = install .rpm file as package \
`-i` install .rpm \
`-v` verbose \
`-h` use hash marks to display progress

`rpm –qa` = show all installed rpm packages \
`-q` query \
`-a` all

#### tarballs

`tar xzvf file.tar.gz` = extract archive into current path (*xtract ze v'ing files*) \
`x` extract tar archive \
`z` use `gzip` (only works with `tar.gz` or `.tgz` archives) \
`v` verbose \
`f` extract files


## REPOS

### yum/dnf & rpm

#### show repos
`yum repolist` = view installed yum repositories \
`yum repolist all` = view all possible yum repositories, including disabled ones 

#### edit repos
`yum-config-manager --enable "[repository name]"` = enable a yum repository \
`yum --enablerepo=extras` = install extras repo \
`yum install epel-release` = install EPEL repo

#### groups
`yum group list` = list package group \
`yum groupinstall 'GNOME Desktop'` = install GNOME Desktop package group 

---
### apt & deb

#### add iso repo to centos
1. go to centos.org
1. click 'get centos now'
1. click 'alternative downloads'
1. click 'i386' in the row corresponding to centos version 6
1. click any mirror link
1. click the iso you wish to download. It will likely be the largest one. Don't download the torrent.
1. save it anywhere
1. launch the UPT_Dev VM and in the top-left corner of VMWare, click VM -> Removable Devices -> CD/DVD -> Conenct
1. navigate to the iso image file you downloaded
1. inside the UPT_Dev VM, run 'sudo mount -o /dev/cdrom /[mount location]'
1. the disk is now mounted and you can browse the packages
1. to turn the packages into a full repo, you need to add the disk ID to the yum configuration. you can do that as follows:
1. run 'head -1 /[mount location]/.discinfo'
1. copy that number
1. run your favorite text editor to open /etc/yum.repos.d/CentOS-Base.repo
1. for each repo you'd like to add, next to 'mediaid=' , enter the number you copied
1. next to 'baseurl=', enter the path of the mounted disk. For example, if you mounted the disk on /test, the row would read 'baseurl=file:///test'
1. run 'yum clean all'
1. yum should now recognize the disk as a repository
