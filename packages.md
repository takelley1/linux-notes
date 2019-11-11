
## packages

- `package-cleanup --cleandupes` = remove packages that have duplicate older versions
- `rpm -ivh file.rpm` or `yum install ./file.rpm` = install .rpm file as package
  - `i` install .rpm
  - `v` verbose
  - `h` use hash marks to display progress
- `tar xzvf file.tar.gz` = extract archive into current path (xtract ze v'ing files)
  - `x` extract tar archive
  - `z` use gzip
  - `v` verbose
  - `f` extract files
- `rpm –qa` = show all rpm packages
  - `q` query
  - `a` all


## repositories 

#### show repos
- `yum repolist` = view installed yum repositories
- `yum repolist all` = view all possible yum repositories, including disabled ones 

#### edit repos
- `yum-config-manager --enable "[repository name]"` = enable a yum repository
- `yum --enablerepo=extras` = install extras repo
- `yum install epel-release` = install EPEL repo

#### groups
- `yum group list` = list package group
- `yum groupinstall 'GNOME Desktop'` = install GNOME Desktop package group 

#### add iso repo to centos
- go to centos.org
- click 'get centos now'
- click 'alternative downloads'
- click 'i386' in the row corresponding to centos version 6
- click any mirror link
- click the iso you wish to download. It will likely be the largest one. Don't download the torrent.
- save it anywhere
- launch the UPT_Dev VM and in the top-left corner of VMWare, click VM -> Removable Devices -> CD/DVD -> Conenct
- navigate to the iso image file you downloaded
- inside the UPT_Dev VM, run 'sudo mount -o /dev/cdrom /[mount location]'
- the disk is now mounted and you can browse the packages
- to turn the packages into a full repo, you need to add the disk ID to the yum configuration. you can do that as follows:
- run 'head -1 /[mount location]/.discinfo'
- copy that number
- run your favorite text editor to open /etc/yum.repos.d/CentOS-Base.repo
- for each repo you'd like to add, next to 'mediaid=' , enter the number you copied
- next to 'baseurl=', enter the path of the mounted disk. For example, if you mounted the disk on /test, the row would read 'baseurl=file:///test'
- run 'yum clean all'
- yum should now recognize the disk as a repository
