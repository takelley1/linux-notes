
## ZFS <sup>[1]</sup> 

### Snapshots

- `zfs list -t snapshot tank` = List snapshots for the *tank* dataset.

### Datasets

- `zfs list -r tank` = List all child datasets of the *tank* dataset.

### [Recordsize](https://jrs-s.net/2019/04/03/on-zfs-recordsize/)

- Default is 128k
- Set recordsize to match the typical size of files in the dataset.
  - Dataset with small text files = Small recordsize (128k or less).
  - Dataset with only videos = Large recordsize (1M).
  - Dataset with VMs = Match recordsize to VM disk image's sector size (512B or 4k).*

* Use `fdisk -l` to determine a disk's sector size.


| POOL CREATION                    |                                                      |
|----------------------------------|------------------------------------------------------|
| `zpool create datapool1`         | Create basic pool named datapool                     |
| `zpool create -m /data datapool` | Create pool with different mount point than default  |
| `zpool create datapool raidz`    | Create RAID-Z vdev pool                              |
| `zpool add datapool raidz`       | Add RAID-Z vdev to pool datapool                     |
| `zpool create datapool raidz2`   | Create RAID-Z2 pool                                  |
| `zpool add datapool mirror`      | Add new mirrored vdev to datapool                    |
| `zpool add datapool spare`       | Add spare device to datapool                         |
| `zpool create -n geekpool`       | Do dry run on pool creation                          |
 
| POOL INFO                  |                                              |
|----------------------------|----------------------------------------------|
| `zpool status -x`          | Show pool status                             |
| `zpool status -v datapool` | Show individual pool status in verbose mode  |
| `zpool list` 	             | Show all pools                               |
| `zpool list -o name,size`  | Show particular properties of all pools      |
| `zpool list -Ho name`      | Show all pools without headers and columns   |

[1]: https://www.thegeekdiary.com/solaris-zfs-command-line-reference-cheat-sheet/  

