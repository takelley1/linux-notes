## LOGICAL VOLUMES (LVM)

#### physical volumes (PV)

`pvcreate /dev/sdb` = create a physical volume (PV) from sdb \
`pvremove /dev/sdb1 /dev/sdc1` = remove physical volumes on partitions sdb1 and sdc1 \
`pvmove /dev/sdb1 /dev/sdb2` = copy all data from sdb1 to sdb2 \
`pvdisplay` or `pvscan` = show physical volumes 

#### logical volumes (LV)

`lvcreate -L 5G LV1 -n LV2` = create 5 GB logical volumes called LV1 and LV2 \
`lvdisplay` or `lvscan` = show logical volumes \
`lvextend -L 1.5G /dev/mapper/LV1` = extend logical volume LV1 to 1.5 GB \
`lvreduce -l -200 /dev/mapper/LV1` = reduce logical volume LV1 by 200 extents 

#### volume groups (VG)

`vgcreate VG1 /dev/sdb /dev/sdc` = create a volume group containing PVs sdb and sdc called VG1 \
`vgdisplay` or `vgscan` = show volume groups \
`vgextend vgroup /dev/sdb1` = add PV sdb1 to “vgroup” volume group 


## FILES & FILESYSTEMS

`mkfs.ext4 /dev/mapper/LV1` = create ext4 filesystem on LV1 logical volume \
`mkfs -t ext4 /dev/mapper/LV1` = create ext4 filesystem that fits size of logical volume LV1 

`e2fsck -f /dev/mapper/LV1` = expand filesystem to fit size of LV1 \
`xfs_growfs /dev/centos/tmp` = expand mounted xfs filesystem

`resize2fs /dev/mapper/LV1` = shrink or grow mounted ext4 filesystem of LV1 down to the size of currently used space (first use e2fsck)

`e4degrag /` = defragment all partitions 

`fsck /dev/sda2` = check sda2 partition for errors (ext4 only)

> NOTE: xfs filesystems cannot be shrunk; use ext4 instead 


## DISKS & MOUNTS

`lsblk` = show disk tree layout, including logical volumes 
`-f` = show filysystem type

`fdisk -l` = show drives and their partition tables 

`fdisk /dev/sdb` = edit the partition table of sdb 

df -Th = show space used by mounted drives \
  `-h` make output human-readable \
  `-T` show filesystem type

`mount` = show mounted volumes and their mount locations (the command reads the /etc/fstab file) \
`mount –o remount,rw /dev/sda1 /mountpoint` = remount drive with read-write permissions 
 
 
## NFS
> Note: assumes fedora-based system

#### server 

1. `yum install nfs-utils`
2. `systemctl enable nfs`
3. `systemctl start nfs`
4. create entry in `/etc/exports` (see examples at bottom of man page for `exports`) \
`/[mountpoint being shared] [authorized ips or fqdns]([mount options])` \
ex: `/mirror 192.168.1.1/24(rw)`
5. `exportfs -a`
6. `sync`
 
#### client 

1. `mount -t nfs [server ip or fqdn]:/[directory being shared] /[local mount location]`
2. `showmount`
3. create entry in `/etc/fstab` \
`[server ip or fqdn]:/[directory being shared] /[local mount location] nfs defaults 0 0` \
ex: `10.0.0.10:/data  /mnt/data  nfs  defaults  0 0`

 
## MISC
 
`du -sh /home/alice` display disk space used by specified directory or file \
-list total storage used by entire directory and all subdirectories, "summarize" (`-s`) \
-list human-readable format (`-h`)

`du -d 1 -h /` list total sizes of each directory one level beneath the specified directory (`-d 1`)

--- 
 > `inode` = a special data structure containing a file's metadata. Contains the file's physical address on the storage medium, size,
 permissions, and modification timestamps. The file that the user interacts with is only a pointer to its corresponding inode.
 http://www.linfo.org/inode.html 

---
#### hard & symbolic links 

`ln /home/sourcefile.txt /var/hardlink.txt` = create hard link to file (`ln -s` for soft/symbolic link), 

> hard links create an additional pointer to a file’s inode and remains even if the original file from which the link was created is deleted. Similar to copying a file but without taking up extra space on the physical storage medium 

> symbolic links can be made for directories as well as files and work across partitions (unlike hard links), but break if the location they're pointing to is deleted. Similar to Windows shortcuts

---
#### transfer installation to another drive

1. install the `update-grub` package on source drive
2. use gparted to copy source partition to target drive
3. physically disconnect the source drive
4. open terminal while still booted into gparted and generate a new UUID for the new partition on the target drive
5. mount the target drive and bind mount `/dev`, `/run`, `/proc`, and `/sys`
6. chroot into target drive
7. update fstab with new drive UUID
8. run `grub-mkconfig -o /boot/grub/grub.cfg` or `update-grub`
9. reboot. If you're dropped into an emergency shell, try regenerating grub 
