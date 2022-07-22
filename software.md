## vSphere / VMWare

`Actions -> Edit Settings -> VM Options -> VMWare Remote Console Options` = Edit max number of connected console sessions for a guest.

## Borg Backup

Extract */mnt/tank/share/pictures* in repo *backup-2020-01-19-01-00* to current path:
```bash
borg extract \
--progress \
--list \
--verbose \
/mnt/backup/borgrepo::backup-2020-01-19-01-00 mnt/tank/share/pictures/
```

