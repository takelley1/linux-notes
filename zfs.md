## [ZFS](https://openzfs.github.io/openzfs-docs/index.html)

- **See also:**
  - [TrueNAS ZFS primer](https://www.truenas.com/docs/references/zfsprimer/)
  - [Oracle ZFS docs](https://docs.oracle.com/cd/E23824_01/html/821-1448/zfsover-1.html#scrolltoc)
  - [FreeBSD ZFS administration](https://docs.freebsd.org/en_US.ISO8859-1/books/handbook/zfs-zfs.html)
  - [ZFS properties](https://docs.oracle.com/cd/E23824_01/html/821-1448/gazss.html#scrolltoc)
  - [zfsconcepts(8)](https://openzfs.github.io/openzfs-docs/man/8/zfsconcepts.8.html)
  - [zpoolconcepts(8)](https://openzfs.github.io/openzfs-docs/man/8/zpoolconcepts.8.html)

### Disks

- The output of `zpool list` can make it difficult to identify disks.
- `camcontrol devlist`   = Show disk model numbers mapped to device ports.
- `glabel status`        = Show ZFS GUID numbers mapped to /dev/ block devices.
- `smartctl -a /dev/da1` = Get serial number for disk attached at /dev/sda1.

#### Handling Disk Failure

1. `zpool status -v <POOL_NAME>` = Get detailed info on pool.
2. `glabel status` = Determine /dev/ path from the gptid given in `zpool status` output.
3. `smartctl -a /dev/<DISK>` = Determine disk serial number from the /dev/ path given in the `glabel status` output.
4. Power off server.
5. Physically replace faulted disk with new disk (identify the disk using its serial number).
6. Power on server.
7. `zpool replace <POOL_NAME> <DEVICE_NAME>` = Replace the disk, assuming the new disk's /dev/ path is the same.

#### [Datasets & Properties](https://docs.oracle.com/cd/E23824_01/html/821-1448/gazss.html#scrolltoc)

- `zfs list -r tank` = List all child datasets of the *tank* dataset.
- `zfs list -t filesystem -o space -r tank` = Recursively print filesystem space info for the *tank* dataset.
- `zfs list -o space tank/storage/videos` = Print usage info for the *tank/storage/videos* dataset.
- `zfs get all tank` = Print all properties for the *tank* dataset.
- `zfs set mountpoint=/mount/path mydataset` = Set mountpoint and mount dataset. Mountpoint path is relative to the root
                                               of the ZFS pool, not the root of the filesystem.
<br><br>
- `zpool status -x`         = Show pool status.
- `zpool status -v datapool`= Show individual pool status in verbose mode.
- `zpool list` 	            = Show all pools' usage + dedup info.
- `zpool list -o name,size` = Show particular properties of all pools.
- `zpool list -Ho name`     = Show all pools without headers and columns.

```
root@server$ zfs list -o space tank
NAME  AVAIL   USED  USEDSNAP  USEDDS  USEDREFRESERV  USEDCHILD
tank  1.42T  1.17T      128K    682K             0B      1.17T

root@server$ zfs list -o space tank/storage/videos
NAME                 AVAIL   USED  USEDSNAP  USEDDS  USEDREFRESERV  USEDCHILD
tank/storage/videos  1.42T   583G      247G    337G             0B         0B
-----------------------------------------------------------------------------

AVAIL: Amount of disk space available to dataset and its children.

USED: Space used by the dataset, the dataset's snapshots, and all its
      chilren combined.

USEDSNAP: (usedbysnapshots) Space used by the dataset's snapshots. This
          value IS NOT the sum of the snapshots' USED values because
          space can be shared by multiple snapshots. See the footnote
          at the bottom of this page.

USEDDS: (usedbydataset) Space used by the dataset.

USEDREFRESERV: Space used by refreservation on the dataset.

USEDCHILD: (usedbychildren) Space used by the dataset's children
           combined.

dataset ...................... = USEDDS
children ..................... = USEDCHILD
dataset + snapshots + children = USED
```

### Snapshots

- `zfs list -t snapshot tank`  = List snapshots for the *tank* dataset.
- `zfs list -t snapshot -r tank | sort -h -k2` = Recursively list snapshots for *tank* dataset, sorting by snapshot size.
<br><br>
- `zfs destroy -nv <SNAPSHOT>` = Do a "dry-run" snapshot deletion.

Delete all snapshots taken between those called *2020-07-11__19:00__tank* and *2020-07-16__22:00__tank*, inclusive:
```
zfs destroy tank/storage/videos@2020-07-11__19:00__tank%2020-07-16__22:00__tank
```

```
root@server$ zfs list -t snapshot tank
NAME                                   USED  AVAIL     REFER  MOUNTPOINT
tank@2021-04-09__11:00__tank__daily    220K      -      248G  -
tank@2021-04-12__11:00__tank__daily      0B      -      250G  -
------------------------------------------------------------------------

USED: The amount of data consumed by the snapshot.

REFER: The amount of data accessible by the snapshot. This is the size
       the dataset was when the snapshot was created.
```

### [Restoring Data](https://www.linuxtopia.org/online_books/opensolaris_2008/ZFSADMIN/html/gbchx.html)

- **See also**
  - [Oracle docs: Sending and receiving ZFS data](https://docs.oracle.com/cd/E23824_01/html/821-1448/gbchx.html)

- `zfs send tank/alice@snapshot1 | zfs receive -v newtank/alice` = Create a *newtank/alice* dataset from *snapshot1* in the
                                                                   *tank/alice* dataset.
- `zfs send -R jails@snapshot1 | zfs receive -v tank/jails` = Move *jails* dataset and its descendants to *tank/jails*.
<br><br>
- `zfs send -nv tank/alice@snap1` = Do a "dry-run" ZFS send.
- `zfs send tank/alice@snap1 | zfs receive -nv newtank/alice` = Do a "dry-run" ZFS receive.
<br><br>
- `zfs send tank/test@tuesday | xz > /backup/test-tuesday.img.xz` = Create a compressed image backup of *tank/test@tuesday*.

[Replicate all descendant snapshots and properties:](https://www.truenas.com/community/threads/copy-move-dataset.28876/post-189799)
```bash
# Recursively snapshot all datasets in Data1/Storage.
zfs snapshot -r Data1/Storage@mysnapshot
# Send all snapshots, clones, and datasets from Data1/Storage to Data2/Storage.
zfs send -Rv Data1/Storage@mysnapshot | zfs receive -F Data2/Storage
```

### [Performance](https://klarasystems.com/articles/openzfs-using-zpool-iostat-to-monitor-pool-perfomance-and-health/)

- `zpool iostat -l tank 5` = Print read/write latency statistics for the *tank* pool every 5 seconds.
- `zpool iostat -vl` = List read/write latency statistics for each drive.

#### [Deduplication](https://www.truenas.com/docs/references/zfsdeduplication/)

- `zpool list` = Show dedup ratio of all pools.
<br><br>
- [To determine current RAM usage of dedup table:](https://serverfault.com/a/533880)
  1. Run `zpool status -D tank` to show dedup table for the *tank* pool
  2. See line that says:
  ```
   dedup: DDT entries 23666783, size 648B on disk, 209B in core
  ```
  3. `23666783*209/1024/1024` = Dedup table usage in MB (in this example it's 4717 MB)

### [Zpool Commands](https://www.thegeekdiary.com/solaris-zfs-command-line-reference-cheat-sheet/)

| POOL CREATION                    |                                                     |
|----------------------------------|-----------------------------------------------------|
| `zpool create datapool1`         | Create basic pool named datapool                    |
| `zpool create -m /data datapool` | Create pool with different mount point than default |
| `zpool create datapool raidz`    | Create RAID-Z vdev pool                             |
| `zpool add datapool raidz`       | Add RAID-Z vdev to pool datapool                    |
| `zpool create datapool raidz2`   | Create RAID-Z2 pool                                 |
| `zpool add datapool mirror`      | Add new mirrored vdev to datapool                   |
| `zpool add datapool spare`       | Add spare device to datapool                        |
| `zpool create -n geekpool`       | Do dry run on pool creation                         |

### [Record Size](https://jrs-s.net/2019/04/03/on-zfs-recordsize/)

- Default is 128k.
- Set recordsize to match the typical size of files in the dataset.
  - Dataset with small text files = Small recordsize (128k or less).
  - Dataset with only videos = Large recordsize (1M).
  - Dataset with VMs = Match recordsize to VM disk image's sector size (512B or 4k).
```
General rules of thumb (from https://klarasystems.com/articles/tuning-recordsize-in-openzfs/):
    1MiB for general-purpose file sharing/storage
    64KiB for KVM virtual machines using Qcow2 file-based storage
    16KiB for MySQL InnoDB
    8KiB for PostgreSQL
```
<br><br>
- Determine a disk's sector size
  - `fdisk -l <DISK>` on Linux
  - `diskinfo -v <DISK>` on FreeBSD

### [Storage Hierarchy](https://jrs-s.net/2018/04/11/primer-how-data-is-stored-on-disk-with-zfs/)

1. zpool
   - Stripes data across one or more vdevs.
   - vdevs can easily be added, not not removed.
   - IOPS scales with the number of vdevs.
   - If you lose a vdev, you lose the entire pool.
2. vdev
   - IOPS limited to the IOPS of the slowest disk in the vdev.
   - Option 1: Single-disk vdev
     - Run `zpool attach` with another drive to create a 2-way mirror vdev.
     - Can detect but not repair data corruption.
   - Option 2: N-way mirror vdev
     - Run `zpool attach` with another drive to create an (N+1)-way mirror vdev.
     - Write IOPS limited by slowest drive.
     - Read IOPS are multiplied by N.
     - A zpool with mirror vdevs is equivalent to RAID10
   - Option 3: RAIDZ(1-3) vdev
     - To increase total capacity, each drive must be individually replaced and resilvered with a larger drive.
     - Takes much longer than mirror vdevs to resilver due to recalculating parity.
     - Read IOPS lower than equivalent mirror vdev.
3. metaslab
   - Each vdev organized into 200 metaslabs.
5. record
   - Each write to a pool is broken into records of variable size, depending on size of data.
   - Checksums for data integrity are calculated per-record.
   - Maximum recordsize can be tuned per-dataset (512B-1M, default is 128K).
5. block
   - Multiple blocks create a record, up to the maximum recordsize.
   - Equal to the underlying hardware's physical sector size (usually 512B, 4K, or 8K).
   - Immutable, automatically set per-vdev by the ashift property.

### [ZFS Benchmarks](https://calomel.org/zfs_raid_speed_capacity.html)
```
         ZFS Raid Speed Capacity and Performance Benchmarks
=============================================================================
                             SATA HARD DRIVES

 1x 4TB, single drive,          3.7 TB,  w=108MB/s , rw=50MB/s  , r=204MB/s
 2x 4TB, mirror (raid1),        3.7 TB,  w=106MB/s , rw=50MB/s  , r=488MB/s
 2x 4TB, stripe (raid0),        7.5 TB,  w=237MB/s , rw=73MB/s  , r=434MB/s
 3x 4TB, mirror (raid1),        3.7 TB,  w=106MB/s , rw=49MB/s  , r=589MB/s
 3x 4TB, stripe (raid0),       11.3 TB,  w=392MB/s , rw=86MB/s  , r=474MB/s
 3x 4TB, raidz1 (raid5),        7.5 TB,  w=225MB/s , rw=56MB/s  , r=619MB/s
 4x 4TB, 2 striped mirrors,     7.5 TB,  w=226MB/s , rw=53MB/s  , r=644MB/s
 4x 4TB, raidz2 (raid6),        7.5 TB,  w=204MB/s , rw=54MB/s  , r=183MB/s
 5x 4TB, raidz1 (raid5),       15.0 TB,  w=469MB/s , rw=79MB/s  , r=598MB/s
 5x 4TB, raidz3 (raid7),        7.5 TB,  w=116MB/s , rw=45MB/s  , r=493MB/s
 6x 4TB, 3 striped mirrors,    11.3 TB,  w=389MB/s , rw=60MB/s  , r=655MB/s
 6x 4TB, raidz2 (raid6),       15.0 TB,  w=429MB/s , rw=71MB/s  , r=488MB/s
10x 4TB, 2 striped 5x raidz,   30.1 TB,  w=675MB/s , rw=109MB/s , r=1012MB/s
11x 4TB, raidz3 (raid7),       30.2 TB,  w=552MB/s , rw=103MB/s , r=963MB/s
12x 4TB, 6 striped mirrors,    22.6 TB,  w=643MB/s , rw=83MB/s  , r=962MB/s
12x 4TB, 2 striped 6x raidz2,  30.1 TB,  w=638MB/s , rw=105MB/s , r=990MB/s
12x 4TB, raidz (raid5),        41.3 TB,  w=689MB/s , rw=118MB/s , r=993MB/s
12x 4TB, raidz2 (raid6),       37.4 TB,  w=317MB/s , rw=98MB/s  , r=1065MB/s
12x 4TB, raidz3 (raid7),       33.6 TB,  w=452MB/s , rw=105MB/s , r=840MB/s
22x 4TB, 2 striped 11x raidz3, 60.4 TB,  w=567MB/s , rw=162MB/s , r=1139MB/s
23x 4TB, raidz3 (raid7),       74.9 TB,  w=440MB/s , rw=157MB/s , r=1146MB/s
24x 4TB, 12 striped mirrors,   45.2 TB,  w=696MB/s , rw=144MB/s , r=898MB/s
24x 4TB, raidz (raid5),        86.4 TB,  w=567MB/s , rw=198MB/s , r=1304MB/s
24x 4TB, raidz2 (raid6),       82.0 TB,  w=434MB/s , rw=189MB/s , r=1063MB/s
24x 4TB, raidz3 (raid7),       78.1 TB,  w=405MB/s , rw=180MB/s , r=1117MB/s
24x 4TB, striped raid0,        90.4 TB,  w=692MB/s , rw=260MB/s , r=1377MB/s

================================================================================
                           SATA SOLID STATE DRIVES

1x 256GB  a single drive  232 gigabytes ( w= 441MB/s , rw=224MB/s , r= 506MB/s )

2x 256GB  raid0 striped   464 gigabytes ( w= 933MB/s , rw=457MB/s , r=1020MB/s )
2x 256GB  raid1 mirror    232 gigabytes ( w= 430MB/s , rw=300MB/s , r= 990MB/s )

3x 256GB  raid5, raidz1   466 gigabytes ( w= 751MB/s , rw=485MB/s , r=1427MB/s )

4x 256GB  raid6, raidz2   462 gigabytes ( w= 565MB/s , rw=442MB/s , r=1925MB/s )

5x 256GB  raid5, raidz1   931 gigabytes ( w= 817MB/s , rw=610MB/s , r=1881MB/s )
5x 256GB  raid7, raidz3   464 gigabytes ( w= 424MB/s , rw=316MB/s , r=1209MB/s )

6x 256GB  raid6, raidz2   933 gigabytes ( w= 721MB/s , rw=530MB/s , r=1754MB/s )

7x 256GB  raid7, raidz3   934 gigabytes ( w= 591MB/s , rw=436MB/s , r=1713MB/s )

9x 256GB  raid5, raidz1   1.8 terabytes ( w= 868MB/s , rw=618MB/s , r=1978MB/s )
10x 256GB raid6, raidz2   1.8 terabytes ( w= 806MB/s , rw=511MB/s , r=1730MB/s )
11x 256GB raid7, raidz3   1.8 terabytes ( w= 659MB/s , rw=448MB/s , r=1681MB/s )

17x 256GB raid5, raidz1   3.7 terabytes ( w= 874MB/s , rw=574MB/s , r=1816MB/s )
18x 256GB raid6, raidz2   3.7 terabytes ( w= 788MB/s , rw=532MB/s , r=1589MB/s )
19x 256GB raid7, raidz3   3.7 terabytes ( w= 699MB/s , rw=400MB/s , r=1183MB/s )

24x 256GB raid0 striped   5.5 terabytes ( w=1620MB/s , rw=796MB/s , r=2043MB/s )
```

[Footnote on shared snapshot space:](https://docs.oracle.com/cd/E78901_01/html/E78912/gprhr.html#scrolltoc)
> Note that the amount of space consumed by all snapshots is not equivalent to the
> sum of unique space across all snapshots. With a share and a single snapshot,
> all blocks must be referenced by one or both of the snapshot or the share. With
> multiple snapshots, however, it's possible for a block to be referenced by some
> subset of snapshots, and not any particular snapshot. For example, if a file is
> created, two snapshots X and Y are taken, the file is deleted, and another
> snapshot Z is taken, the blocks within the file are held by X and Y, but not by
> Z. In this case, destroying Z will not free up the space, but destroying both X
> and Y will. Because of this, destroying any snapshot can affect the unique space
> referenced by neighboring snapshots, though the total amount of space consumed
> by snapshots will always decrease.
>
> Also see:
> - [1] https://github.com/mafm/zfs-snapshot-disk-usage-matrix
> - [2] https://www.delphix.com/blog/delphix-engineering/what-shared-snapshot-space
