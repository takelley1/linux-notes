## STORAGE

- **See also:**
  - [Storage 101 blog series](https://www.red-gate.com/simple-talk/homepage/storage-101-welcome-to-the-wonderful-world-of-storage/)
  - [File vs block vs object storage](https://www.redhat.com/en/topics/data-storage/file-block-object-storage)
  - [Synchronous vs asynchronous I/O](https://stackoverflow.com/questions/35012494/difference-between-synchronous-and-asychnchronus-i-o)


---
## LOGICAL VOLUME MANAGEMENT (LVM)

### Examples

Extending */var* XFS filesystem by 127,999 extents with LVM:
```bash
1. fdisk /dev/sdb                      # Create partition from new disk.
2. pvcreate /dev/sdb1                  # Create a physical volume from the new partition.
3. vgextend vgname /dev/sdb1           # Add the new physical volume to the relevant volume group.
4. pvdisplay                           # Show the number of new extents available.
5. lvextend -l +127999 /dev/centos/var # Extend the relevant logical volume by adding 127,999 free extents.
6. xfs_growfs /var                     # Grow the filesystem on the extended logical volume.
```

### Physical volumes (PV)

- `pvdisplay` or `pvscan`        = Show physical volumes.
- `pvcreate /dev/sdb`            = Create a physical volume.
- `pvremove /dev/sdb1 /dev/sdc1` = Remove physical volumes on partitions *sdb1* and *sdc1*.
- `pvmove /dev/sdb1 /dev/sdb2`   = Copy all data from *sdb1* to *sdb2*.

### Logical volumes (LV)

- `lvdisplay` or `lvscan`            = Show logical volumes.
- `lvcreate -l 2500 centos -n vol_1` = Create a new volume called *vol_1* with *2500* extents in vgroup *centos*.
- `lvextend -L 1.5G /dev/mapper/LV1` = Extend volume *LV1* to *1.5 GB*.
- `lvreduce -l -200 /dev/mapper/LV1` = Reduce volume *LV1* by *200* extents.

### Volume groups (VG)

- `vgdisplay` or `vgscan`            = Show volume groups.
- `vgcreate VG1 /dev/sdb1 /dev/sdc1` = Create a volume group called *VG1*, containing physical volumes *sdb1* and
                                       *sdc1*.
- `vgextend VG1 /dev/sdb1`           = Add physical volume sdb1 to volume group VG1.


---
## [COMPRESSION](https://clearlinux.org/news-blogs/linux-os-data-compression-options-comparing-behavior)
`TODO`

- **See also:**
  - [Squash compression benchmark](https://quixdb.github.io/squash-benchmark/#results)
  - [ZFS zstd compression comparison](https://docs.google.com/spreadsheets/d/1TvCAIDzFsjuLuea7124q-1UtMd0C9amTgnXm2yPtiUQ/edit#gid=1215810192)

[BtrFS compression benchmarks](https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git/commit/?h=next&id=5c1aab1dd5445ed8bdcdbb575abc1b0d7ee5b2e7)
| Method  | Ratio | Compress MB/s | Decompress |
|---------|-------|---------------|------------|
| None    |  0.99 |           504 |        686 |
| lzo     |  1.66 |           398 |        442 |
| zlib    |  2.58 |            65 |        241 |
| zstd 1  |  2.57 |           260 |        383 |
| zstd 3  |  2.71 |           174 |        408 |
| zstd 6  |  2.87 |            70 |        398 |
| zstd 9  |  2.92 |            43 |        406 |
| zstd 12 |  2.93 |            21 |        408 |
| zstd 15 |  3.01 |            11 |        354 |

| compression algorithms | gzip | bzip2 | xz | lzip | lzma | zstd |
|------------------------|------|-------|----|------|------|------|
| Released               |      |       |    |      |      |      |
| Compression speed      |      |       |    |      |      |      |
| Decompression speed    |      |       |    |      |      |      |
| Compression ratio      |      |       |    |      |      |      |

| Archive formats | tar | zip | 7z | tar.gz |
|-----------------|-----|-----|----|--------|
|                 |     |     |    |        |

### Tar

- `tar xzvf myarchive.tar.gz` = Extract myarchive.tar.gz to current path (*xtract ze v'ing files*).
  - `x` = Extract.
  - `z` = Decompress with gzip (only works with extracting *tar.gz* or *.tgz* tarballs).
  - `v` = Be verbose.
  - `f` = Work in file mode (rather than tape mode).
<br><br>
- `tar czvf myarchive.tar.gz dir1/ dir2/` = Create *myarchive.tar.gz* from *dir1* and *dir2*
                                            (*create ze v'ing files*).

### [7zip](https://sevenzip.osdn.jp/chm/cmdline/index.htm)

- `7za x myarchive.7z` = Extract *myarchive.7z* to current path (DO NOT USE THE 'e' SWITCH, USE 'x' INSTEAD TO PRESERVE FILEPATHS).
<br><br>
- `7za a -mx=10 myarchive.7z dir1/ dir2/` = Create *myarchive.7z* from *dir1* and *dir2*.
  - `-mx=9` = Use max compression level.
  - `-myx=9` = Use max analysis level.

[Settings for maximum compression:](https://superuser.com/a/1449735)
```bash
7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 archive.7z dir/
```


---
## DISKS & MOUNTS

- **See also:**
  - [Fixing 3.3v Pin issue in SATA drives](https://imgur.com/a/A0JXgrQ)
<br><br>
- `partprobe` = Scan for new disks.
<br><br>
- `lsblk -f` = Show disk tree layout, including logical volumes.
 - `-f`      = Show filesystem type.
<br><br>
- `df -Th` = Show space used by mounted drives.
  - `-h`   = Make output human-readable.
  - `-T`   = Show filesystem type.
<br><br>
- `blkid` = Show partition UUIDs.
<br><br>
- `fdisk -l`       = Show drives and their partition tables.
- `fdisk /dev/sdb` = Edit the partition table of sdb.
<br><br>
- `mount`                                     = Show mounted volumes and their mount locations.
- `mount –o remount,rw /dev/sda1 /mountpoint` = Remount drive with read-write permissions.

Creating swap and/or a swapfile on btrfs
```bash
1. touch /swapfile
2. chmod 0600 /swapfile
3. chattr -c /swapfile  # Disable compression
4. chattr +C /swapfile  # Disable COW
5. dd if=/dev/zero of=/swapfile bs=1M count=1024  # 1G
6. mkswap /swapfile
7. swapon /swapfile
```

### [Disk testing](https://calomel.org/badblocks_wipe.html)

- `badblocks -b 4096 -s -v -w /dev/sdb` = Destructively test disk sdb for bad data blocks (useful for testing new drive).
- `bonnie++`
- `dd if=/dev/zero of=./test1.img bs=1G count=1 oflag=dsync` = [Test disk write speed.](https://www.cyberciti.biz/faq/howto-linux-unix-test-disk-performance-with-dd-command/)


---
## FILES & FILESYSTEMS

### Metadata

- `stat file.txt`         = Get file metadata on file.txt.
- `atime` (*access time*) = Last time file's contents were read.
- `mtime` (*modify time*) = Last time file's contents were changed.
- `ctime` (*change time*) = Last time file's inode was changed (permissions, ownership, name, hard links, etc.).

[inode:](http://www.linfo.org/inode.html)
  > A special data structure holding a file's metadata, contains the file's physical address on the storage medium, size,
  > permissions, and modification timestamps. The file that the user interacts with is only a pointer to its
  > corresponding inode.

### Sizing

- `du -sh /home/alice` = Display disk space used by specified directory or file.
  - `-s` (*summarize*)  = List total storage used by entire directory and all subdirectories.
  - `-h` (*human*)      = Use human-readable format for filesizes (ex. `8.7M` instead of `8808`).
<br><br>
- `du -d 1 -h /` = List the sizes of each directory one level beneath the specified directory.
  - `d 1` (*depth*) = Recurse at a depth of 1 directory.

---
## [SAMBA](https://wiki.samba.org/index.php/Main_Page)

- Enable debug logging:
```
/etc/samba/smb.conf.client-debug

[global]
max log size = 0                  # No log file size limitation.
log file = /var/log/samba/log.%I  # Specific log file name.
log level = 3                     # Set the debug level.
debug pid = yes                   # Add the pid to the log.
debug uid = yes                   # Add the uid to the log.
debug class = yes                 # Add the debug class to the log.
debug hires timestamp = yes       # Add microsecond resolution to timestamp.
```

### Linux-Windows interoperability

- **See also:**
  - [Mapping shares between Windows and RHEL](https://www.redhat.com/sysadmin/samba-windows-linux)
  - [Mapping Windows shares on Linux](https://linuxize.com/post/how-to-mount-cifs-windows-share-on-linux/)
  - [Configure Ubuntu for Samba + Winbind + Kerberos](https://serverfault.com/questions/135396/how-to-authenticate-linux-accounts-against-an-active-directory-and-mount-a-windo)
<br><br>
- `smbclient -U janedoe@domain.example.com -L 192.168.1.122` = Check Windows share availability.
- `mount -t cifs -o credentials=/<CREDENTIALS_FILE> //WIN_SHARE_IP/<SHARE_NAME> /<MOUNT_PATH>` = Mount Windows share.
  - Create credentials file:
    ```
    username=<USERNAME>
    password=<PASSWORD>
    domain=<DOMAIN>
    ```
  - `chown root:root /<CREDENTIALS_FILE> && chmod 0600 /<CREDENTIALS_FILE>` = Secure credentials file.

---
## NFS

- **See also:**
  - [Troubleshooting NFS performance](https://www.redhat.com/sysadmin/using-nfsstat-nfsiostat)
  - [NFS performance benchmarks](https://blog.ja-ke.tech/2019/08/27/nas-performance-sshfs-nfs-smb.html)
  - [NFS performance tuning](https://docstore.mik.ua/orelly/networking_2ndEd/nfs/ch18_01.htm)

`nfsstat`
`nfsiostat`
`mountstats`

### Server

1. `yum install nfs-utils`
2. `systemctl enable nfs`
3. `systemctl start nfs`
4. create entry in `/etc/exports` (see examples at bottom of man page for `exports`)
`/[mountpoint being shared] [authorized ips or fqdns]([mount options])`
ex: `/mirror 192.168.1.1/24(rw)`
5. `exportfs -a`
6. `sync`

### Client

7. `mount -t nfs [server ip or fqdn]:/[directory being shared] /[local mount location]`
8. `showmount`
9. create entry in `/etc/fstab`
`[server ip or fqdn]:/[directory being shared] /[local mount location] nfs defaults 0 0`
ex: `10.0.0.10:/data  /mnt/data  nfs  defaults  0 0`


---
## MISC

### Hard & symbolic links

- `ln /home/sourcefile.txt /var/hardlink.txt` = Create hard link to file (`ln -s` for soft/symbolic link).

```
Hard links create an additional pointer to a file’s inode and remains even if the original file from which the link
was created is deleted. Similar to copying a file but without taking up extra space on the physical storage medium.

Symbolic links can be made for directories as well as files and work across partitions (unlike hard links), but
break if the location they're pointing to is deleted. Similar to Windows shortcuts.
```

### [Transfer root Linux installation to another drive:](https://askubuntu.com/questions/741723/moving-entire-linux-installation-to-another-drive)

1. Boot from a live OS and use `gparted` to copy the source drive's boot and root partitions to the target drive.
2. Right-click the new partitions on the target drive and generate a new UUID for each.
3. Mount the target drive and bind mount `/dev`, `/run`, `/proc`, and `/sys` (`mount -o bind /src /dest`) from the currently booted live OS to the target drive.
4. `chroot` into the target drive.
5. Edit `fstab` and replace the copied partition's UUID with the new UUID.
6. Make sure the target drive's `/boot` directory contains a Linux image. If not, copy the directory from the source drive manually.
7. Run `grub-mkconfig -o /boot/grub/grub.cfg` or `update-grub` (if `update-grub` is installed).
8. Reboot. if you're dropped into an emergency shell, try regenerating grub.

### How VMWare snapshots work

In VMware VMs, the virtual disk is a .vmdk file residing on a data store (LUN). When a snapshot is created in
Snapshot Manager, the original disk becomes read-only, and all the new data changes are written into a temporary
.vmdk delta disk, pointing to the original one. The delta disk is the difference between the current state of
the virtual disk and the state at the moment the snapshot was taken. After a snapshot is deleted (committed),
the .vmdk delta disk is merged with the original .vmdk file, and it returns to read-write mode.

If the VM is reverted to the snapshot, the temporary .vmdk delta disk is simply deleted and the VM begins writing
to its original disk.

Snapshots are not backups because if the original disk's data is lost, the delta .vmdk becomes useless as it only
contains the changes to the original data, not the data itself.

### Storage latency and performance

- **See also:**
  - [Interactive latency](https://colin-scott.github.io/personal_website/research/interactive_latency.html)
  - [How much faster is memory than flash?](https://stackoverflow.com/questions/1371400/how-much-faster-is-the-memory-usually-than-the-disk)
  - [Drive performance metrics](https://www.red-gate.com/simple-talk/databases/sql-server/database-administration-sql-server/storage-101-monitoring-storage-metrics/)
  - [Drive benchmarks - 4K IOPS at queue depth 1](https://www.harddrivebenchmark.net/iops-4kqd1.html)

```
Latency Comparison Numbers (~2012)
----------------------------------
L1 cache reference                           0.5 ns
Branch mispredict                            5   ns
L2 cache reference                           7   ns .................... 14x slower than L1 cache
Mutex lock/unlock                           25   ns
Main memory reference                      100   ns .................... 20x slower than L2 cache, 200x slower than L1 cache
Compress 1K bytes with Zippy             3,000   ns        3 us
Send 1K bytes over 1 Gbps network       10,000   ns       10 us
Read 4K randomly from SSD              150,000   ns      150 us ........ ~1GB/sec SSD
Read 1 MB sequentially from memory     250,000   ns      250 us
Round trip within same datacenter      500,000   ns      500 us
Read 1 MB sequentially from SSD      1,000,000   ns    1,000 us    1 ms  ~1GB/sec SSD, 4x slower than memory
Disk seek                           10,000,000   ns   10,000 us   10 ms
Read 1 MB sequentially from disk    20,000,000   ns   20,000 us   20 ms  80x slower than memory, 20x slower than SSD
Send packet CA->Netherlands->CA    150,000,000   ns  150,000 us  150 ms  .150 s
```

<img src="images/raid10.png" width="300"/> <sup>[9]</sup>


[9]: https://blog.ssdnodes.com/blog/what-is-raid-10-vps/
