## [NFS](https://wiki.archlinux.org/title/NFS)

- **See also:**
  - [Troubleshooting NFS performance](https://www.redhat.com/sysadmin/using-nfsstat-nfsiostat)
  - [NFS performance benchmarks](https://blog.ja-ke.tech/2019/08/27/nas-performance-sshfs-nfs-smb.html)
  - [NFS performance tuning](https://docstore.mik.ua/orelly/networking_2ndEd/nfs/ch18_01.htm)

`nfsstat`
`nfsiostat`
`mountstats`

### Server

1. `yum install nfs-utils`
2. `systemctl enable nfs`
3. `systemctl start nfs`
4. create entry in `/etc/exports` (see examples at bottom of man page for `exports`)
`/[mountpoint being shared] [authorized ips or fqdns]([mount options])`
ex: `/mirror 192.168.1.1/24(rw)`
5. `exportfs -a`
6. `sync`

### Client

7. `mount -t nfs [server ip or fqdn]:/[directory being shared] /[local mount location]`
8. `showmount`
9. create entry in `/etc/fstab`
`[server ip or fqdn]:/[directory being shared] /[local mount location] nfs defaults 0 0`
ex: `10.0.0.10:/data  /mnt/data  nfs  defaults  0 0`
