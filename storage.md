
## LOGICAL VOLUME MANAGEMENT (LVM)

### Physical volumes (PV)

- `pvcreate /dev/sdb`            = Create a physical volume.
- `pvremove /dev/sdb1 /dev/sdc1` = Remove physical volumes on partitions sdb1 and sdc1.
- `pvmove /dev/sdb1 /dev/sdb2`   = Copy all data from sdb1 to sdb2.
<br><br>
- `pvdisplay` or `pvscan`        = Show physical volumes.

### Logical volumes (LV)

- `lvcreate -l 2500 centos -n vol_1` = Create a new volume called vol_1 with 2500 extents in vgroup centos.
- `lvextend -L 1.5G /dev/mapper/LV1` = Extend volume LV1 to 1.5 GB.
- `lvreduce -l -200 /dev/mapper/LV1` = Reduce volume LV1 by 200 extents.
<br><br>
- `lvdisplay` or `lvscan`            = Show logical volumes.

### Volume groups (VG)

- `vgcreate VG1 /dev/sdb1 /dev/sdc1` = Create a volume group called VG1, containing physical volumes sdb1 and sdc1.
- `vgextend VG1 /dev/sdb1`           = Add physical volume sdb1 to volume group VG1.
<br><br>
- `vgdisplay` or `vgscan`            = Show volume groups.

Extending */var* XFS filesystem with LVM:
```bash
1. fdisk /dev/sdb                      # Create partition from new disk.
2. pvcreate /dev/sdb1                  # Create a physical volume from the new partition.
3. vgextend vgname /dev/sdb1           # Add the new physical volume to the relevant volume group.
4. pvdisplay                           # Show the number of new extents available.
5. lvextend -l +127999 /dev/centos/var # Extend the relevant logical volume by adding 127,999 free extents.
6. xfs_growfs /var                     # Grow the filesystem on the extended logical volume.
```


---
## ARCHIVES <sup>[2]</sup>
`TODO`

| compression algorithms | gzip | bzip2 | xz | lzip | lzma | zstd |
|------------------------|------|-------|----|------|------|------|
| Released               |      |       |    |      |      |      |
| Compression speed      |      |       |    |      |      |      |
| Decompression speed    |      |       |    |      |      |      |
| Compression ratio      |      |       |    |      |      |      |

| Archive formats | tar | zip | 7z | tar.gz |
|-----------------|-----|-----|----|--------|
|                 |     |     |    |        |

**See also**: [Squash compression benchmark](https://quixdb.github.io/squash-benchmark/#results)

### Tar

- `tar xzvf myarchive.tar.gz` = Extract myarchive.tar.gz to current path (*xtract ze v'ing files*).
  - `x` = Extract.
  - `z` = Decompress with gzip (only works with extracting `tar.gz` or `.tgz` tarballs).
  - `v` = Be verbose.
  - `f` = Work in file mode (rather than tape mode).
<br><br>
- `tar czvf myarchive.tar.gz dir1/ dir2/ dir3/` = Create myarchive.tar.gz from dir1, dir2, and dir3 (*create ze v'ing files*).

### 7zip

- `7za x myarchive.7z` = Extract myarchive.7z to current path (DO NOT USE THE 'e' SWITCH, USE 'x' INSTEAD TO PRESERVE FILEPATHS).
<br><br>
- `7za a -mx=10 myarchive.7z dir1/ dir2/` = Create myarchive.7z from dir1 and dir2.
  - `-mx=10` = Use compression lvl 10.


---
## DISKS & MOUNTS

- `partprobe` = Scan for new disks.
<br><br>
- `lsblk -f` = Show disk tree layout, including logical volumes.
 - `-f` = Show filysystem type.
<br><br>
- `df -Th` = Show space used by mounted drives.
  - `-h` = Make output human-readable.
  - `-T` = Show filesystem type.
<br><br>
- `blkid` = Show partition UUIDs.
<br><br>
- `fdisk -l`       = Show drives and their partition tables.
- `fdisk /dev/sdb` = Edit the partition table of sdb.
<br><br>
- `mount`                                     = Show mounted volumes and their mount locations.
- `mount –o remount,rw /dev/sda1 /mountpoint` = Remount drive with read-write permissions.

### Disk testing <sup>[3]</sup>

- `badblocks -b 4096 -s -v -w /dev/sdb` = Destructively test disk sdb for bad data blocks (useful for testing new drive).
- `bonnie++`
<br><br>
- `dd if=/dev/zero of=./test1.img bs=1G count=1 oflag=dsync` = Test disk write speed. <sup>[8]</sup>

---
### SMART

#### SMART testing

- `smartctl -t long /dev/sdc` = Start a long HDD self test. After the test is done (could take 12+ hours), check the results with `smartctl -a /dev/sdc`.
<br><br>
- `smartctl -a /dev/ | grep Current_Pending_Sector`         = Pending sector reallocations.
- `smartctl -a /dev/ | grep Reallocated_Sector_Ct`          = Reallocated sector count.
- `smartctl -a /dev/ | grep UDMA_CRC_Error_Count`           = UDMA CRC errors.
- `diskinfo -wS`                                            = HDD and SSD write latency consistency (unformatted drives only!).
- `smartctl -a /dev/ | grep Power_On_Hours`                 = HDD and SSD hours.
- `nvmecontrol logpage -p 2 nvme0 | grep “Percentage used”` = NVMe percentage used.

#### SMART field names

- `Normalized value` = Commonly referred to as just "value". This is a most universal measurement, on the scale from 0
                       (bad) to some maximum (good) value. Maximum values are typically 100, 200 or 253. Rule of thumb
                       is: high values are good, low values are bad.
- `Threshold` = The minimum normalized value limit for the attribute. If the normalized value falls below the threshold,
                the disk is considered defective and should be replaced under warranty. This situation is called "T.E.C."
                (Threshold Exceeded Condition).
- `Raw value` = The value of the attribute as it is tracked by the device, before any normalization takes place. Some
                raw numbers provide valuable insight when properly interpreted. These cases will be discussed later on.
                Raw values are typically listed in hexadecimal numbers.

| SMART attributes <sup>[5]</sup>                                           |                                                                            |
|---------------------------------------------------------------------------|----------------------------------------------------------------------------|
| Reallocated sectors count                                                 | How many defective sectors were discovered on drive and remapped to spare sectors. Low values in absence of other fault indications point to a disk surface problem. Raw value indicates the exact number of such sectors. |
| Current pending sectors count                                             | How many suspected defective sectors are pending "investigation." These will not necessarily be remapped. In fact, such sectors my be not defective at all (e.g. if some transient condition prevented reading of the sector, it will be marked "pending") - they will be then re-tested by the device off-line scan1 procedure and returned to the pool of serviceable sectors. Raw value indicates the exact number of such sectors. |
| Off-line uncorrectable sectors count                                      | Similar to "Reallocated sectors count". Indicates how many defective sectors were found during the off-line scan1. |
| Read error rate, read error retry rate, write error rate, seek error rate | Rate at which the specified errors occur. Lower value indicates more errors. Retries do not necessarily indicate a persistent problem, but one should proceed with caution if any of these attributes is degraded. |
| Recalibration retries                                                     | How often the drive is unable to recalibrate at the first attempt. Raw value may show the exact number of recalibration events (at least with some vendors) but this should be taken with a grain of salt. |
| Spin up time                                                              | Low value indicates that a drive takes longer than expected to spin up to its rated speed. May indicate either a controller or a spindle bearing problem. |
| Spin retry count                                                          | How many times the drive was unable to spin its platters up to the rated rotation speed in due time. Spin-up attempt was aborted and retried. This typically indicates severe controller or bearing problem, but may sometimes be caused by power supply problems. |
| Drive start/stop count, Power off/retract cycle count                     | Estimation of drive wear. Vendor estimates the supposed device lifetime and the number of cycles. The value for these attributes is then computed based on this estimation. The T.E.C. condition with one of these attributes does not necessarily indicate a drive failure, but rather suggests that a drive should be considered unreliable due to the wear and tear. Raw values are typically just the count of events. |
| Power on hours count, Head flying hours count                             | Normalized values are computed similar to the above. Despite what the name suggests, the raw value of the attribute is stored using all sorts of measurement units (hours, half-hours, or ten-minute intervals to name a few) depending on the manufacturer of the device. |
| Temperature                                                               | Device temperature, if the appropriate sensor is fitted. Lowest byte of the raw value contains the exact temperature value (in Celsius). |
| Ultra DMA CRC error rate                                                  | Low value of this attribute typically indicates that something is wrong with the connectors and/or cables. Disk-to-host transfers are protected by CRC error detection code when Ultra-DMA 66 or 100 is used. So if the data gets garbled between the disk and the host machine, the receiving controller senses this and the retransmission is initiated. Such a situation is called "UDMA CRC error." Once the problem is rectified (typically by replacing a cable), the attribute value returns to normal levels. |
| G-sense error rate                                                        | Indicates if errors are occurring from physical shocks to the drive (either due to the environmental factors or due to improper installation). The hard drive must be fitted with the appropriate sensor to get information about the G-loads. This attribute is mainly limited to notebook (2.5") drives. Once the operation conditions are corrected, the attribute value will return to normal. |


---
## FILES & FILESYSTEMS

### Metadata

- `stat file.txt`         = Get file metadata on file.txt.
- `atime` (*access time*) = Last time file's contents were read.
- `mtime` (*modify time*) = Last time file's contents were changed.
- `ctime` (*change time*) = Last time file's inode was changed (permissions, ownership, name, hard links, etc.).

```
inode:

A special data structure holding a file's metadata, contains the file's physical address on the storage medium, size,
permissions, and modification timestamps. The file that the user interacts with is only a pointer to its
corresponding inode.
```
<sup>[6]</sup>

### Sizing

- `du -sh /home/alice` = Display disk space used by specified directory or file.
  - `-s` (*summarize*)  = List total storage used by entire directory and all subdirectories.
  - `-h` (*human*)      = Use human-readable format for filesizes (ex. `8.7M` instead of `8808`).
<br><br>
- `du -d 1 -h /` = List the sizes of each directory one level beneath the specified directory.
  - `d 1` (*depth*) = Recurse at a depth of 1 directory.

### Filesystems

- `mkfs.ext4 /dev/mapper/LV1` or `mkfs -t ext4 /dev/mapper/LV1` = Create ext4 filesystem on LV1 logical volume.
<br><br>
- `e2fsck -f /dev/mapper/LV1 && resize2fs /dev/mapper/LV1` = Expand filesystem to fit size of LV1 (must be unmounted).
- `xfs_growfs /dev/centos/var`                             = Expand mounted xfs filesystem (must be mounted).
<br><br>
- `e4degrag /`     = Defragment all partitions.
- `fsck /dev/sda2` = Check sda2 partition for errors (supported filesystems only).

> NOTE: Xfs filesystems cannot be shrunk; use ext4 instead.

#### Ext4 vs xfs <sup>[4]</sup>

```
Ext4 is better with lots of smaller files and metadata-intensive tasks.
Xfs is better with very large files (>30GB).
```

| Filesystem features <sup>[1]</sup> | ext4 | xfs  | btrfs | zfs  | ufs | ntfs | bcachefs | FAT32 | exFAT |
|------------------------------------|------|------|-------|------|-----|------|----------|-------|-------|
| Online growing                     | no   | yes  | yes   | yes  | ?   | yes  | ?        | no    | no    |
| Online shrinking                   | no   | no   | yes   | no   | no  | yes  | ?        | no    | no    |
| Transparent data compression       | no   | no   | yes   | yes  | ?   | yes  | yes      | no    | no    |
| Native encryption                  | LUKS | LUKS | yes   | yes  | ?   | yes  | yes      | no    | no    |
| Data deduplication                 | no   | no   | yes   | yes  | no  | yes  | yes      | no    | no    |
| Immutable snapshots                | LVM  | LVM  | yes   | yes  | ?   | no   | yes      | no    | no    |
| Data + metadata checksumming       | no   | no   | yes   | yes  | no  | no   | yes      | no    | no    |
| Native RAID support                | no   | no   | yes   | yes  | no  | yes  | yes      | no    | no    |
| Journaling support                 | yes  | yes  | COW   | COW  | ?   | yes  | COW      | no    | no    |
| Max filesize                       | -    | -    | -     | -    | -   | -    | -        | 4GB   | -     |
| Max filesystem size                | -    | -    | -     | -    | -   | -    | -        | 2TB   | -     |

LUKS = Encrypting these filesystems is usually handled through LUKS and/or dm-crypt.
LVM  = Can provide limited snapshot functionality through LVM.
COW  = Journaling is superceded by copy-on-write mechanisms.
\-   = Maximum theoretical size is so large that it's effectively irrelevant.
?    = Currently unknown and/or no reliable data available.


---
## SAMBA
`TODO`
`smbclient`
- Samba debug logging:
```
root@sambaserver:~# cat /etc/samba/smb.conf.client-debug
[global]
# no log file size limitation
max log size = 0
# specific log file name
log file = /var/log/samba/log.%I
# set the debug level
log level = 3
# add the pid to the log
debug pid = yes
# add the uid to the log
debug uid = yes
# add the debug class to the log
debug class = yes
# add microsecond resolution to timestamp
debug hires timestamp = yes
```

---
## NFS

> NOTE: assumes fedora-based system

### Server

1. `yum install nfs-utils`
1. `systemctl enable nfs`
1. `systemctl start nfs`
1. create entry in `/etc/exports` (see examples at bottom of man page for `exports`)
`/[mountpoint being shared] [authorized ips or fqdns]([mount options])`
ex: `/mirror 192.168.1.1/24(rw)`
1. `exportfs -a`
1. `sync`

### Client

1. `mount -t nfs [server ip or fqdn]:/[directory being shared] /[local mount location]`
1. `showmount`
1. create entry in `/etc/fstab`
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

### Transfer root Linux installation to another drive: <sup>[7]</sup>

1. Install the `update-grub` package on the source drive (optional).
1. Boot from a live OS and use `gparted` to copy the source drive's root partition to an empty partition on the target drive.
1. Physically disconnect the source drive.
1. Open a terminal and generate a new UUID for the new partition on the target drive.
   1. Use `blkid` to list partition UUIDs.
   1. Use `tune2fs -U random /dev/sdx1` (if ext4) or `xfs_admin -U generate /dev/sdx1` (if xfs) to generate a new UUID for the copied partition on the target drive.
1. Mount the target drive and bind mount `/dev`, `/run`, `/proc`, and `/sys` from the currently booted live OS to the target drive.
1. `chroot` into the target drive.
1. Edit `fstab` and replace the copied partition's UUID with the new UUID.
1. Run `grub-mkconfig -o /boot/grub/grub.cfg` or `update-grub` (if `update-grub` was installed).
1. Reboot. if you're dropped into an emergency shell, try regenerating grub.

[1]: https://www.tldp.org/LDP/sag/html/filesystems.html
[2]: https://clearlinux.org/news-blogs/linux-os-data-compression-options-comparing-behavior
[3]: https://calomel.org/badblocks_wipe.html
[4]: https://unix.stackexchange.com/questions/467385/should-i-use-xfs-or-ext4
[5]: https://www.z-a-recovery.com/manual/smart.aspx
[6]: http://www.linfo.org/inode.html
[7]: https://askubuntu.com/questions/741723/moving-entire-linux-installation-to-another-drive
[8]: https://www.cyberciti.biz/faq/howto-linux-unix-test-disk-performance-with-dd-command/
