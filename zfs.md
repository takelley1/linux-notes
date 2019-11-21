## ZFS
[1]


| POOL CREATION |                                                         |
|---------------|---------------------------------------------------------|
# zpool create datapool c0t0d0 	Create a basic pool named datapool
# zpool create -f datapool c0t0d0 	Force the creation of a pool
# zpool create -m /data datapool c0t0d0 	Create a pool with a different mount point than the default.
# zpool create datapool raidz c3t0d0 c3t1d0 c3t2d0 	Create RAID-Z vdev pool
# zpool add datapool raidz c4t0d0 c4t1d0 c4t2d0 	Add RAID-Z vdev to pool datapool
# zpool create datapool raidz1 c0t0d0 c0t1d0 c0t2d0 c0t3d0 c0t4d0 c0t5d0 	Create RAID-Z1 pool
# zpool create datapool raidz2 c0t0d0 c0t1d0 c0t2d0 c0t3d0 c0t4d0 c0t5d0 	Create RAID-Z2 pool
# zpool create datapool mirror c0t0d0 c0t5d0 	Mirror c0t0d0 to c0t5d0
# zpool create datapool mirror c0t0d0 c0t5d0 mirror c0t2d0 c0t4d0 	disk c0t0d0 is mirrored with c0t5d0 and disk c0t2d0 is mirrored withc0t4d0
# zpool add datapool mirror c3t0d0 c3t1d0 	Add new mirrored vdev to datapool
# zpool add datapool spare c1t3d0 	Add spare device c1t3d0 to the datapool
## zpool create -n geekpool c1t3d0 	Do a dry run on pool creation


| POOL INFO |              |
|-----------|--------------|
| zpool status -x | Show pool status
| zpool status -v datapool 	Show individual pool status in verbose mode
# zpool list 	Show all the pools
# zpool list -o name,size 	Show particular properties of all the pools (here, name and size)
# zpool list -Ho name 	Show all pools without headers and columns



[1] https://www.thegeekdiary.com/solaris-zfs-command-line-reference-cheat-sheet/
