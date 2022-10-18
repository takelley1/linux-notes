## Logical Volume Management (LVM)

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

### Physical Volumes (PV)

- `pvdisplay` or `pvscan`        = Show physical volumes.
- `pvcreate /dev/sdb`            = Create a physical volume.
- `pvremove /dev/sdb1 /dev/sdc1` = Remove physical volumes on partitions *sdb1* and *sdc1*.
- `pvmove /dev/sdb1 /dev/sdb2`   = Copy all data from *sdb1* to *sdb2*.

### Logical Volumes (LV)

- `lvdisplay` or `lvscan`            = Show logical volumes.
- `lvcreate -l 2500 centos -n vol_1` = Create a new volume called *vol_1* with *2500* extents in vgroup *centos*.
- `lvextend -L 1.5G /dev/mapper/LV1` = Extend volume *LV1* to *1.5 GB*.
- `lvreduce -l -200 /dev/mapper/LV1` = Reduce volume *LV1* by *200* extents.

### Volume Groups (VG)

- `vgdisplay` or `vgscan`            = Show volume groups.
- `vgcreate VG1 /dev/sdb1 /dev/sdc1` = Create a volume group called *VG1*, containing physical volumes *sdb1* and
                                       *sdc1*.
- `vgextend VG1 /dev/sdb1`           = Add physical volume sdb1 to volume group VG1.
