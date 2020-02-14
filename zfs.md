
## ZFS

| POOL CREATION [1]                |                                                     |
|----------------------------------|-----------------------------------------------------|
| `zpool create datapool1`         | create basic pool named datapool                    |
| `zpool create -m /data datapool` | create pool with different mount point than default |
| `zpool create datapool raidz`    | create RAID-Z vdev pool                             |
| `zpool add datapool raidz`       | add RAID-Z vdev to pool datapool                    |
| `zpool create datapool raidz2`   | create RAID-Z2 pool                                 |
| `zpool add datapool mirror`      | add new mirrored vdev to datapool                   |
| `zpool add datapool spare`       | add spare device to datapool                        |
| `zpool create -n geekpool`       | do dry run on pool creation                         |

| POOL INFO                  |                                             |
|----------------------------|---------------------------------------------|
| `zpool status -x`          | show pool status                            |
| `zpool status -v datapool` | show individual pool status in verbose mode |
| `zpool list` 	           | show all pools                              |
| `zpool list -o name,size`  | show particular properties of all pools     |
| `zpool list -Ho name`      | show all pools without headers and columns  |


---
#### sources

[1] https://www.thegeekdiary.com/solaris-zfs-command-line-reference-cheat-sheet/  
