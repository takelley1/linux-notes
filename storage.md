## LOGICAL VOLUMES (LVM)

#### physical volumes (PV)

`pvcreate /dev/sdb`            = create a physical volume (PV) from sdb  
`pvremove /dev/sdb1 /dev/sdc1` = remove physical volumes on partitions sdb1 and sdc1  
`pvmove /dev/sdb1 /dev/sdb2`   = copy all data from sdb1 to sdb2  
`pvdisplay` or `pvscan`        = show physical volumes

#### logical volumes (LV)

`lvcreate -L 5G LV1 -n LV2`        = create 5 GB logical volumes called LV1 and LV2  
`lvdisplay` or `lvscan`            = show logical volumes  
`lvextend -L 1.5G /dev/mapper/LV1` = extend logical volume LV1 to 1.5 GB  
`lvreduce -l -200 /dev/mapper/LV1` = reduce logical volume LV1 by 200 extents 

#### volume groups (VG)

`vgcreate VG1 /dev/sdb /dev/sdc` = create a volume group containing PVs sdb and sdc called VG1  
`vgdisplay` or `vgscan`          = show volume groups  
`vgextend vgroup /dev/sdb1`      = add PV sdb1 to “vgroup” volume group 

---
#### extend volume with LVM

```bash
1. fdisk /dev/sdb # create partition from new disk
2. pvcreate /dev/sdb1 # create a physical volume from the new partition
3. vgextend vgname /dev/sdb1 # add the new physical volume to the relevant volume group
4. pvdisplay # show the number of new extents available
5. lvextend -l +127999 /dev/centos/var # extend the relevant logical volume by adding free extents
6. xfs_growfs /var # grow the filesystem on the extended logical volume
```

---
## FILES & FILESYSTEMS

`du -sh /home/alice` = display disk space used by specified directory or file  
`-s` (*summarize*)   = list total storage used by entire directory and all subdirectories  
`-h` = use human-readable format for filesizes (ex. `8.7M` instead of `8808`)

`du -d 1 -h /`   = list the sizes of each directory one level beneath the specified directory  
`-d 1` (*depth*) = recurse at a depth of 1

---
`mkfs.ext4 /dev/mapper/LV1` or `mkfs -t ext4 /dev/mapper/LV1` = create ext4 filesystem on LV1 logical volume

`e2fsck -f /dev/mapper/LV1 && resize2fs /dev/mapper/LV1` = expand filesystem to fit size of LV1 (must be unmounted)  
`xfs_growfs /dev/centos/var` = expand mounted xfs filesystem (must be mounted)

`e4degrag /`     = defragment all partitions  
`fsck /dev/sda2` = check sda2 partition for errors (ext4 only)

> NOTE: xfs filesystems cannot be shrunk; use ext4 instead

| filesystems compared         | ext4 | xfs | btrfs | zfs  | ufs | ntfs | bcachefs | FAT32 | exFAT |
|------------------------------|------|-----|-------|------|-----|------|----------|-------|-------|
| online growing               | no   | yes | yes   | yes  |     | yes  |          | no    | no    |
| online shrinking             | no   | no  | yes   | no   | no  | yes  |          | no    | no    |
| transparent compression      | no   | no  | yes   | yes  |     | yes  | yes      | no    | no    |
| transparent encryption       | no   | no  | yes   | yes  |     | yes  | yes      | no    | no    |
| native deduplication         | no   | no  | yes   | yes  | no  | yes  | yes      | no    | no    |
| snapshots                    | LVM  | LVM | yes   | yes  |     | no   | yes      | no    | no    |
| checksumming                 | no   | no  | yes   | yes  | no  | no   | yes      | no    | no    |
| native RAID                  | no   | no  | yes   | yes  | no  | yes  | yes      | no    | no    |
| journaling                   | yes  | yes | COW   | COW  |     | yes  | COW      | no    | no    |
| max filesize                 | -    | -   | -     | -    | -   | -    | -        | 4GB   | -     |
| max filesystem size          | -    | -   | -     | -    | -   | -    | -        | 2TB   | -     |
[1]

LVM = can provide limited snapshot functionality through LVM
COW = copy-on-write (COW) filesystems, so their lack of journaling is not an issue
\-  = have maximum theoretical sizes so large they're effectively irrelevant

---
## DISKS & MOUNTS

`lsblk -f` = show disk tree layout, including logical volumes  
  `-f`     = show filysystem type
  
`df -Th` = show space used by mounted drives  
  `-h`   = make output human-readable  
  `-T`   = show filesystem type

`blkid` = show partition UUIDs

`fdisk -l`       = show drives and their partition tables  
`fdisk /dev/sdb` = edit the partition table of sdb

`mount` = show mounted volumes and their mount locations  
`mount –o remount,rw /dev/sda1 /mountpoint` = remount drive with read-write permissions 
 
---
## NFS

> NOTE: assumes fedora-based system

#### server 

1. `yum install nfs-utils`
2. `systemctl enable nfs`
3. `systemctl start nfs`
4. create entry in `/etc/exports` (see examples at bottom of man page for `exports`)  
`/[mountpoint being shared] [authorized ips or fqdns]([mount options])`  
ex: `/mirror 192.168.1.1/24(rw)`
5. `exportfs -a`
6. `sync`
 
#### client 

1. `mount -t nfs [server ip or fqdn]:/[directory being shared] /[local mount location]`
2. `showmount`
3. create entry in `/etc/fstab`  
`[server ip or fqdn]:/[directory being shared] /[local mount location] nfs defaults 0 0`  
ex: `10.0.0.10:/data  /mnt/data  nfs  defaults  0 0`

---
## MISC

 `inode` = a special data structure containing a file's metadata. Contains the file's physical address on the storage medium, size,
 permissions, and modification timestamps. The file that the user interacts with is only a pointer to its corresponding inode.
 http://www.linfo.org/inode.html 

---
#### hard & symbolic links 

`ln /home/sourcefile.txt /var/hardlink.txt` = create hard link to file (`ln -s` for soft/symbolic link), 

> hard links create an additional pointer to a file’s inode and remains even if the original file from which the link was created is deleted. Similar to copying a file but without taking up extra space on the physical storage medium 

> symbolic links can be made for directories as well as files and work across partitions (unlike hard links), but break if the location they're pointing to is deleted. Similar to Windows shortcuts

---
#### transfer root linux installation to another drive

1. install the `update-grub` package on the source drive (optional)
2. use `gparted` to copy the source drive's root partition to an empty partition on the target drive
3. physically disconnect the source drive
4. open a terminal and generate a new UUID for the new partition on the target drive
   - use `blkid` to list partition UUIDs
   - use `tune2fs -U random /dev/sdx1` (if ext4) or `xfs_admin -U generate /dev/sdx1` (if xfs) to generate a new UUID for the copied partition on the target drive
5. mount the target drive and bind mount `/dev`, `/run`, `/proc`, and `/sys` from the currently booted drive to the target drive
6. `chroot` into the target drive
7. update `fstab` with the copied partition's new UUID
8. run `grub-mkconfig -o /boot/grub/grub.cfg` or `update-grub` (if `update-grub` was installed)
9. reboot. If you're dropped into an emergency shell, try regenerating grub

[1] https://www.tldp.org/LDP/sag/html/filesystems.html

