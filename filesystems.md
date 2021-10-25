
## FILESYSTEMS

### [Btrfs](https://btrfs.wiki.kernel.org/index.php/Main_Page)

- `btrfs -v filesystem defrag -r -czstd /` = Recursively compress filesystem with zstd.

### [Ext4](https://ext4.wiki.kernel.org/index.php/Main_Page)

- `mkfs.ext4 /dev/mapper/LV1` or `mkfs -t ext4 /dev/mapper/LV1` = Create ext4 filesystem on logical volume *LV1*.
<br><br>
- `e2fsck -f /dev/mapper/LV1 && resize2fs /dev/mapper/LV1` = Expand filesystem to fit size of *LV1* (must be unmounted).
- `e4degrag /`     = Defragment all partitions.
- `fsck /dev/sda2` = Check *sda2* for errors.

### [XFS](https://wiki.archlinux.org/index.php/XFS)

- `xfs_growfs /dev/centos/var` = Expand mounted XFS filesystem (must be mounted).

> NOTE: XFS filesystems cannot be shrunk.

#### [Ext4 vs XFS](https://unix.stackexchange.com/questions/467385/should-i-use-xfs-or-ext4)

- ext4 is faster on single-threaded IO and when working with many small files.
- XFS is faster on multi-threaded IO, performs better with large files (>100MB).


| Filesystem features <sup>[1]</sup> | ext4  | XFS  | Btrfs | ZFS  | UFS2   | F2FS  | NTFS   | bcachefs | FAT32 | exFAT |
|------------------------------------|-------|------|-------|------|--------|-------|------  |----------|-------|-------|
| Online/offline growing             | yes   |online| yes   |online| yes    |offline| yes    | ?        | no    | no    |
| Online/offline shrinking           |offline| no   | yes   | no   | no     | no    | yes    | ?        | no    | no    |
| Transparent compression            | no    | no   | yes   | yes  | ?      | yes   | yes    | yes      | no    | no    |
| Encryption                         | LUKS  | LUKS | yes   | yes  | ?      | yes   | yes    | yes      | no    | no    |
| Data deduplication                 | no    | no   | yes   | yes  | no     | no    | yes    | yes      | no    | no    |
| Snapshots                          | LVM   | LVM  | yes   | yes  | ?      | no    | no     | yes      | no    | no    |
| Block + metadata checksums         | no    | no   | yes   | yes  | no     | no    | no     | yes      | no    | no    |
| Block + metadata journaling        | yes   | yes  | CoW   | CoW  |metadata| CoW   |metadata| CoW      | no    | no    |
| Built-in RAID support              | LVM   | LVM  | yes   | yes  | no     | ?     | yes    | yes      | no    | no    |
| File change log                    | no    | yes  | no    | no   | no     | no    | yes    | no       | no    | no    |
| Maximum file size                  | -     | -    | -     | -    | -      | -     | -      | -        | 4GB   | -     |

- LUKS = Encrypting these filesystems is usually handled through LUKS and/or dm-crypt.
- LVM  = This feature is traditionally provided through LVM.
- CoW  = Journaling is superceded by copy-on-write mechanisms.
- \-   = Maximum theoretical size is large enough to be irrelevant.
- ?    = Currently unknown and/or no reliable data available.

[1]: https://www.tldp.org/LDP/sag/html/filesystems.html
