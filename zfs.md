
## ZFS <sup>[1]</sup> 

### Snapshots

- `zfs list -t snapshot tank`  = List snapshots for the *tank* dataset.
<br><br>
- `zfs destroy -nv <SNAPSHOT>`       = Do a "dry-run" snapshot deletion.
- `zfs destroy tank/snap@1-15%12-20` = Delete all snapshots taken between those called *1-15* and *1-20*, inclusive.

### Datasets

- `zfs list -r tank` = List all child datasets of the *tank* dataset.

### [Recordsize](https://jrs-s.net/2019/04/03/on-zfs-recordsize/)

- Default is 128k
- Set recordsize to match the typical size of files in the dataset.
  - Dataset with small text files = Small recordsize (128k or less).
  - Dataset with only videos = Large recordsize (1M).
  - Dataset with VMs = Match recordsize to VM disk image's sector size (512B or 4k).*

* Use `fdisk -l` to determine a disk's sector size.

### [Storage hierarchy](https://jrs-s.net/2018/04/11/primer-how-data-is-stored-on-disk-with-zfs/)

- zpool
  - Stripes data across one or more vdevs.
  - vdevs can easily be added, not not removed.
  - IOPS scales with the number of vdevs.
  - If you lose a vdev, you lose the entire pool.
- vdev
  - IOPS limited to the IOPS of the slowest disk in the vdev.
  - Single-disk vdev
    - Run `zpool attach` with another drive to create a 2-way mirror vdev.
    - Can detect but not repair data corruption.
  - N-way mirror vdev
    - Run `zpool attach` with another drive to create an (N+1)-way mirror vdev.
    - Write IOPS limited by slowest drive.
    - Read IOPS are multiplied by N.
    - A zpool with mirror vdevs is equivalent to RAID10
  - RAIDZ(1-3) vdev
    - To increase total capacity, each drive must be individually replaced and resilvered with a larger drive.
    - Takes much longer than mirror vdevs to resilver due to recalculating parity.
    - Read IOPS lower than equivalent mirror vdev.
- metaslab
  - Each vdev organized into 200 metaslabs.
- record
  - Each write to a pool is broken into records of variable size, depending on size of data.
  - Checksums for data integrity are calculated per-record.
  - Maximum recordsize can be tuned per-dataset (512B-1M, default is 128K).
- block
  - Multiple blocks create a record, up to the maximum recordsize.
  - Equal to the underlying hardware's physical sector size (usually 512B, 4K, or 8K).
  - Immutable, automatically set per-vdev by the ashift property.


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
 
| POOL INFO                  |                                             |
|----------------------------|---------------------------------------------|
| `zpool status -x`          | Show pool status                            |
| `zpool status -v datapool` | Show individual pool status in verbose mode |
| `zpool list` 	             | Show all pools                              |
| `zpool list -o name,size`  | Show particular properties of all pools     |
| `zpool list -Ho name`      | Show all pools without headers and columns  |


### [ZFS benchmarks](https://calomel.org/zfs_raid_speed_capacity.html)

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

[1]: https://www.thegeekdiary.com/solaris-zfs-command-line-reference-cheat-sheet/  
