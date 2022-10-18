## [Samba](https://wiki.samba.org/index.php/Main_Page)

- Enable debug logging:
```
/etc/samba/smb.conf.client-debug

[global]
max log size = 0                  # No log file size limitation.
log file = /var/log/samba/log.%I  # Specific log file name.
log level = 3                     # Set the debug level.
debug pid = yes                   # Add the pid to the log.
debug uid = yes                   # Add the uid to the log.
debug class = yes                 # Add the debug class to the log.
debug hires timestamp = yes       # Add microsecond resolution to timestamp.
```
