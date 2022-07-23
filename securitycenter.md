## TENABLE.SC (SecurityCenter)

Get new plugins: https://patches.csd.disa.mil

[Reset admin password to "password"](https://community.tenable.com/s/article/Reset-admin-password-in-Tenable-sc-and-unlock-the-account-if-its-been-locked-Formerly-SecurityCenter)
```
## Versions 5.10 and earlier:
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e' where username='admin';"

## Versions 5.11 and later:
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e', salt = '',hashtype = 1 where username='admin';"

# Password hash for easier reading:
bbd2
9bd3
3eb1
61d7
3853
6b59
e37d
b31e
```

List users:
```
# /opt/sc/support/bin/sqlite3 /opt/sc/application.db "select * from UserAuth"
```
