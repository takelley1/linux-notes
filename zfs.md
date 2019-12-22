## ZFS
[1]


| POOL CREATION |                                                         |
|---------------|---------------------------------------------------------|
'zpool create datapool1'       | create a basic pool named datapool       |
zpool create -m /data datapool | Create a pool with a different mount point than the default.
zpool create datapool raidz       Create RAID-Z vdev pool
zpool add datapool raidz  	      Add RAID-Z vdev to pool datapool
zpool create datapool raidz2      Create RAID-Z2 pool
zpool add datapool mirror 	      Add new mirrored vdev to datapool
zpool add datapool spare          Add spare device to the datapool
zpool create -n geekpool          Do a dry run on pool creation


| POOL INFO |              |
|-----------|--------------|
| zpool status -x |         Show pool status
| zpool status -v datapool 	Show individual pool status in verbose mode
zpool list 	                Show all the pools
zpool list -o name,size 	Show particular properties of all the pools (here, name and size)
zpool list -Ho name 	    Show all pools without headers and columns


[1] https://www.thegeekdiary.com/solaris-zfs-command-line-reference-cheat-sheet/