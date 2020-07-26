
## ZFS <sup>[1]</sup> 

| POOL CREATION                    |                                                      |
|----------------------------------|------------------------------------------------------|
| `zpool create datapool1`         | Create basic pool named datapool.                    |<br>
| `zpool create -m /data datapool` | Create pool with different mount point than default. |<br>
| `zpool create datapool raidz`    | Create RAID-Z vdev pool.                             |<br>
| `zpool add datapool raidz`       | Add RAID-Z vdev to pool datapool.                    |<br>
| `zpool create datapool raidz2`   | Create RAID-Z2 pool.                                 |<br>
| `zpool add datapool mirror`      | Add new mirrored vdev to datapool.                   |<br>
| `zpool add datapool spare`       | Add spare device to datapool.                        |<br>
| `zpool create -n geekpool`       | Do dry run on pool creation.                         |<br>
 
| POOL INFO                  |                                              |
|----------------------------|----------------------------------------------|
| `zpool status -x`          | Show pool status.                            |<br>
| `zpool status -v datapool` | Show individual pool status in verbose mode. |<br>
| `zpool list` 	             | Show all pools.                              |<br>
| `zpool list -o name,size`  | Show particular properties of all pools.     |<br>
| `zpool list -Ho name`      | Show all pools without headers and columns.  |<br>

[1]: https://www.thegeekdiary.com/solaris-zfs-command-line-reference-cheat-sheet/  

