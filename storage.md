
## LOGICAL VOLUME MANAGEMENT (LVM)

### physical volumes (PV)

`pvcreate /dev/sdb`            = create a physical volume (PV) from sdb  
`pvremove /dev/sdb1 /dev/sdc1` = remove physical volumes on partitions sdb1 and sdc1  
`pvmove /dev/sdb1 /dev/sdb2`   = copy all data from sdb1 to sdb2  
`pvdisplay` or `pvscan`        = show physical volumes

### logical volumes (LV)

`lvcreate -l 2500 centos -n vol_1` = create a new volume called vol_1 with 2500 extents in vgroup centos   
`lvcreate -L 5G LV1 -n LV2`        = create 5 GB logical volumes called LV1 and LV2  
`lvdisplay` or `lvscan`            = show logical volumes  
`lvextend -L 1.5G /dev/mapper/LV1` = extend volume LV1 to 1.5 GB  
`lvreduce -l -200 /dev/mapper/LV1` = reduce volume LV1 by 200 extents 

### volume groups (VG)

`vgcreate VG1 /dev/sdb /dev/sdc` = create a volume group containing PVs sdb and sdc called VG1  
`vgdisplay` or `vgscan`          = show volume groups  
`vgextend vgroup /dev/sdb1`      = add PV sdb1 to “vgroup” volume group 


### extending /var xfs filesystem with LVM

```bash
1. fdisk /dev/sdb                      # create partition from new disk
2. pvcreate /dev/sdb1                  # create a physical volume from the new partition
3. vgextend vgname /dev/sdb1           # add the new physical volume to the relevant volume group
4. pvdisplay                           # show the number of new extents available
5. lvextend -l +127999 /dev/centos/var # extend the relevant logical volume by adding free extents
6. xfs_growfs /var                     # grow the filesystem on the extended logical volume
```


---
## ARCHIVES

| compression algorithms | gzip | bzip2 | xz | lzip | lzma | zstd |
| compression speed      |      |       |    |      |      |      |
| decompression speed    |      |       |    |      |      |      |
| compression            |      |       |    |      |      |      |

[2]

| archive formats | tar | zip | 7z | tar.gz |
|                 |     |     |    |        |

**see also**: https://quixdb.github.io/squash-benchmark/#results

### tar

`tar xzvf myarchive.tar.gz` = extract myarchive.tar.gz to current path (*xtract ze v'ing files*)  
                        `x` = extract  
                        `z` = decompress with gzip (only works with extracting `tar.gz` or `.tgz` tarballs)  
                        `v` = verbose  
                        `f` = work in file mode (rather than tape mode)

`tar czvf myarchive.tar.gz dir1/ dir2/ dir3/` = create myarchive.tar.gz from dir1, dir2, and dir3 (*create ze v'ing files*)

### 7zip

`7za x myarchive.7z` = extract myarchive.7z to current path (DO NOT USE THE 'e' SWITCH, USE 'x' INSTEAD TO PRESERVE FILEPATHS)

`7za a -mx=10 myarchive.7z dir1/ dir2/` = create myarchive.7z from dir1 and dir2
                               `-mx=10` = use compression lvl 10


---
## DISKS & MOUNTS

`partprobe` = scan for new disks

`lsblk -f` = show disk tree layout, including logical volumes  
      `-f` = show filysystem type
  
`df -Th` = show space used by mounted drives  
    `-h` = make output human-readable  
    `-T` = show filesystem type

`blkid` = show partition UUIDs

`fdisk -l`       = show drives and their partition tables  
`fdisk /dev/sdb` = edit the partition table of sdb

`mount`                                     = show mounted volumes and their mount locations  
`mount –o remount,rw /dev/sda1 /mountpoint` = remount drive with read-write permissions 

### disk testing

`badblocks -b 4096 -s -v -w /dev/sdb` = destructively test disk hda for bad data blocks (useful for testing new drive)  
`bonnie++`
[3]

### SMART

#### SMART testing

`smartctl -t long /dev/sdc` = start a long HDD self test - after the test is done (could take 12+ hours), check the results with `smartctl -a /dev/sdc`

`smartctl -a /dev/ | grep Current_Pending_Sector`         = pending sector reallocations  
`smartctl -a /dev/ | grep Reallocated_Sector_Ct`          = reallocated sector count  
`smartctl -a /dev/ | grep UDMA_CRC_Error_Count`           = UDMA CRC errors  
`diskinfo -wS`                                            = HDD and SSD write latency consistency (unformatted drives only!)
`smartctl -a /dev/ | grep Power_On_Hours`                 = HDD and SSD hours  
`nvmecontrol logpage -p 2 nvme0 | grep “Percentage used”` = NVMe percentage used  

#### SMART field names

`Normalized value` = commonly referred to as just "value". This is a most universal measurement, on the scale from 0 (bad) to some maximum (good) value. Maximum values are typically 100, 200 or 253. Rule of thumb is: high values are good, low values are bad.

`Threshold` = the minimum normalized value limit for the attribute. If the normalized value falls below the threshold, the disk is considered defective and should be replaced under warranty. This situation is called "T.E.C." (Threshold Exceeded Condition).

`Raw value` = the value of the attribute as it is tracked by the device, before any normalization takes place. Some raw numbers provide valuable insight when properly interpreted. These cases will be discussed later on. Raw values are typically listed in hexadecimal numbers.

| SMART attributes                                                      |                                                                            | 
|---------------------------------------------------------------------------|----------------------------------------------------------------------------|
| Reallocated sectors count                                                 | How many defective sectors were discovered on drive and remapped using a spare sectors pool. Low values in absence of other fault indications point to a disk surface problem. Raw value indicates the exact number of such sectors. |
| Current pending sectors count                                             | How many suspected defective sectors are pending "investigation". These will not necessarily be remapped. In fact, such sectors my be not defective at all (e.g. if some transient condition prevented reading of the sector, it will be marked "pending") - they will be then re-tested by the device off-line scan1 procedure and returned to the pool of serviceable sectors. Raw value indicates the exact number of such sectors. |
| Off-line uncorrectable sectors count                                      | Similar to "Reallocated sectors count". Indicates how many defective sectors were found during the off-line scan1. |
| Read error rate, read error retry rate, write error rate, seek error rate | Rate at which specified events (errors) occur. Lower value indicates more events (errors). Retries are not necessarily indicate a persistent problem, but one should proceed with caution if any of these attributes is degraded. |
| Recalibration retries                                                     | How often the drive is unable to recalibrate at the first attempt. Raw value may show the exact number of recalibration events (at least with some vendors) but this should be taken with a grain of salt. |
| Spin up time                                                              | Low value indicates that a drive takes longer than expected to spin up to its rated speed. Might indicate either a controller or a spindle bearing problem |
| Spin retry count                                                          | Spin retry event is logged each time the drive was unable to spin its platters up to the rated rotation speed in the due time. Spin-up attempt was aborted and retried. This typically indicates severe controller or bearing problem, but may be sometimes caused by power supply problems. |
| Drive start/stop count, Power off/retract cycle count                     | Estimation of the drive wear. Vendor estimates the supposed device lifetime and the number of cycles. The value for these attributes is then computed based on this estimation. The T.E.C. condition with one of these attributes does not necessarily indicate a drive failure, but rather suggests that a drive should be considered unreliable due to the wear and tear. Raw values are typically just the count of events. |
| Power on hours count, Head flying hours count                             | Normalized values are computed similar to the above. Despite what the name suggests, the raw value of the attribute is stored using all sorts of measurement units (hours, half-hours, or ten-minute intervals to name a few) depending on the manufacturer of the device. |
| Temperature                                                               | Device temperature, if the appropriate sensor is fitted. Lowest byte of the raw value contains the exact temperature value (Celsius degrees). |
| Ultra DMA CRC error rate                                                  | Low value of this attribute typically indicates that something is wrong with the connectors and/or cables. Disk-to-host transfers are protected by CRC error detection code when Ultra-DMA 66 or 100 is used. So if the data gets garbled between the disk and the host machine, the receiving controller senses this and the retransmission is initiated. Such a situation is called "UDMA CRC error". Once the problem is rectified (typically by replacing a cable), the attribute value returns to the normal levels pretty quick. |
| G-sense error rate                                                        | Indicates if the errors are occurring attributed to the drive shocking (either due to the environmental factors or due to improper installation). The hard drive must be fitted with the appropriate sensor to get information about the G-loads. This attribute is mainly limited to the notebook (2.5") drives. Once the operation conditions are corrected, the attribute value will  return to normal. |

[5]


---
## FILES & FILESYSTEMS

### metadata

`stat file.txt`         = get file metadata on file.txt  
`atime` (*access time*) = last time file's contents were read  
`mtime` (*modify time*) = last time file's contents were changed  
`ctime` (*change time*) = last time file's inode was changed (permissions, ownership, name, hard links, etc.)

`inode` = a special data structure holding a file's metadata, contains the file's physical address on the storage medium, size, permissions, and modification timestamps. The file that the user interacts with is only a pointer to its corresponding inode [6]

### sizing

`du -sh /home/alice` = display disk space used by specified directory or file  
`-s` (*summarize*)   = list total storage used by entire directory and all subdirectories  
`-h` (*human*)       = use human-readable format for filesizes (ex. `8.7M` instead of `8808`)

`du -d 1 -h /`   = list the sizes of each directory one level beneath the specified directory  
`-d 1` (*depth*) = recurse at a depth of 1

### filesystems

`mkfs.ext4 /dev/mapper/LV1` or `mkfs -t ext4 /dev/mapper/LV1` = create ext4 filesystem on LV1 logical volume

`e2fsck -f /dev/mapper/LV1 && resize2fs /dev/mapper/LV1` = expand filesystem to fit size of LV1 (must be unmounted)  
`xfs_growfs /dev/centos/var`                             = expand mounted xfs filesystem (must be mounted)

`e4degrag /`     = defragment all partitions  
`fsck /dev/sda2` = check sda2 partition for errors (supported filesystems only)

> NOTE: xfs filesystems cannot be shrunk; use ext4 instead

#### ext4 vs xfs

-ext4 is better with lots of smaller files and metadata-intensive tasks  
-xfs is better with very large files (>30GB)  
[4]

| filesystem features          | ext4 | xfs  | btrfs | zfs  | ufs | ntfs | bcachefs | FAT32 | exFAT |
|------------------------------|------|------|-------|------|-----|------|----------|-------|-------|
| online growing               | no   | yes  | yes   | yes  | ?   | yes  | ?        | no    | no    |
| online shrinking             | no   | no   | yes   | no   | no  | yes  | ?        | no    | no    |
| transparent data compression | no   | no   | yes   | yes  | ?   | yes  | yes      | no    | no    |
| native encryption            | LUKS | LUKS | yes   | yes  | ?   | yes  | yes      | no    | no    |
| data deduplication           | no   | no   | yes   | yes  | no  | yes  | yes      | no    | no    |
| immutable snapshots          | LVM  | LVM  | yes   | yes  | ?   | no   | yes      | no    | no    |
| data + metadata checksumming | no   | no   | yes   | yes  | no  | no   | yes      | no    | no    |
| native RAID support          | no   | no   | yes   | yes  | no  | yes  | yes      | no    | no    |
| journaling support           | yes  | yes  | COW   | COW  | ?   | yes  | COW      | no    | no    |
| max filesize                 | -    | -    | -     | -    | -   | -    | -        | 4GB   | -     |
| max filesystem size          | -    | -    | -     | -    | -   | -    | -        | 2TB   | -     |

LUKS = encrypting these filesystems is usually handled through LUKS and/or dm-crypt  
LVM = can provide limited snapshot functionality through LVM  
COW = journaling is superceded by copy-on-write mechanisms  
\-  = maximum theoretical size so large it's effectively irrelevant  
?   = currently unknown and/or no reliable data available  
[1]


---
## SAMBA

`smbclient`

TODO: fill out section


---
## NFS

> NOTE: assumes fedora-based system

### server 

1. `yum install nfs-utils`
1. `systemctl enable nfs`
1. `systemctl start nfs`
1. create entry in `/etc/exports` (see examples at bottom of man page for `exports`)  
`/[mountpoint being shared] [authorized ips or fqdns]([mount options])`  
ex: `/mirror 192.168.1.1/24(rw)`
1. `exportfs -a`
1. `sync`

### client 

1. `mount -t nfs [server ip or fqdn]:/[directory being shared] /[local mount location]`
1. `showmount`
1. create entry in `/etc/fstab`  
`[server ip or fqdn]:/[directory being shared] /[local mount location] nfs defaults 0 0`  
ex: `10.0.0.10:/data  /mnt/data  nfs  defaults  0 0`


---
## MISC

### hard & symbolic links 

`ln /home/sourcefile.txt /var/hardlink.txt` = create hard link to file (`ln -s` for soft/symbolic link), 

> hard links create an additional pointer to a file’s inode and remains even if the original file from which the link was created is deleted. Similar to copying a file but without taking up extra space on the physical storage medium 

> symbolic links can be made for directories as well as files and work across partitions (unlike hard links), but break if the location they're pointing to is deleted. Similar to Windows shortcuts

### transfer root linux installation to another drive

1. install the `update-grub` package on the source drive (optional)
1. use `gparted` to copy the source drive's root partition to an empty partition on the target drive
1. physically disconnect the source drive
1. open a terminal and generate a new UUID for the new partition on the target drive
   1. use `blkid` to list partition UUIDs
   1. use `tune2fs -U random /dev/sdx1` (if ext4) or `xfs_admin -U generate /dev/sdx1` (if xfs) to generate a new UUID for the copied partition on the target drive
1. mount the target drive and bind mount `/dev`, `/run`, `/proc`, and `/sys` from the currently booted drive to the target drive
1. `chroot` into the target drive
1. update `fstab` with the copied partition's new UUID
1. run `grub-mkconfig -o /boot/grub/grub.cfg` or `update-grub` (if `update-grub` was installed)
1. reboot. If you're dropped into an emergency shell, try regenerating grub


---
#### sources

[1] https://www.tldp.org/LDP/sag/html/filesystems.html  
[2] https://clearlinux.org/news-blogs/linux-os-data-compression-options-comparing-behavior  
[3] https://calomel.org/badblocks_wipe.html  
[4] https://unix.stackexchange.com/questions/467385/should-i-use-xfs-or-ext4  
[5] https://www.z-a-recovery.com/manual/smart.aspx  
[6] http://www.linfo.org/inode.html  

