
- `export PAGER="less -XRFS"` = Don't wrap table output in the SQL shell.

## [SQLITE](https://www.sqlite.org/index.html)

- **See also**
  - [SQLite tutorial](https://www.sqlitetutorial.net/)

- `.tables` = Show tables
- `select * from mytable` = Print all rows from table *mytable*

---
## [MARIADB](https://mariadb.com/kb/en/training-tutorials/)

- **See also**
  - [Troubleshooting connection issues](https://mariadb.com/kb/en/troubleshooting-connection-issues/)
  - [MariaDB performance tuning](https://mariadb.com/kb/en/server-system-variables/)
    - [InnoDB Buffer Pool](https://mariadb.com/kb/en/innodb-buffer-pool/)
  - [MySQLTuner script](https://github.com/major/MySQLTuner-perl)

### Shell

- `mysql -u <USERNAME> -p<PASSWORD>` = Connect to a local MariaDB instance.
- `mysql -h <SERVER> -u <USERNAME> -P <PORT> -p<PASSWORD> <DATABASE_NAME>` = [Connect to a remote MariaDB instance.](https://mariadb.com/kb/en/connecting-to-mariadb/)
- `mysqldump -u <USERNAME> -p -x -A >dbs.sql` = [Create database dump.](https://mariadb.com/kb/en/making-backups-with-mysqldump/#backing-up-everything)
- `mysqld_safe --skip-grant tables &` = [Launch MySQL to reset the root password.](https://www.digitalocean.com/community/tutorials/how-to-reset-your-mysql-or-mariadb-root-password)

### Databases

- `show databases;` = Print all databases.
- `use my_database;` = Connect to the database called *my_database*.
- `show tables;` = Print tables of the current database.

### Users

- **See also:**
  - [Account management commands](https://mariadb.com/kb/en/account-management-sql-commands/)
<br><br>
- `use mysql; select user,host from user;` = [Print all users.](https://www.mysqltutorial.org/mysql-show-users/)
- `create user alice@localhost identified by 'password123';` = [Create user *alice* with password *password123*.](https://mariadb.com/kb/en/create-user/)
  - *localhost* is the server *alice* is allowed to connect from.
- `create user 'alice'@'%' identified by 'password123';` = [Create user *alice* that is allowed to connect from any server.](https://mariadb.com/kb/en/configuring-mariadb-for-remote-client-access/#granting-user-connections-from-remote-hosts)
  - *alice@localhost* and *alice@%* are DIFFERENT users.
- `grant all privileges on my_database.* to 'alice'@'localhost';` = [Give *alice* full permissions to *my_database*.](https://chartio.com/resources/tutorials/how-to-grant-all-privileges-on-a-database-in-mysql/)
- `set password for 'alice'@'localhost' = password('CorrectHorseBatteryStaple');` = [Change password for *alice*.](https://mariadb.com/kb/en/set-password/)
- `drop user 'alice'@'localhost';` = [Delete user *alice*.](https://mariadb.com/kb/en/drop-user/)

### Galera cluster

- **See also**:
  - [Understanding Galera](https://mariadb.com/docs/multi-node/galera-cluster/understand-mariadb-galera-cluster)
  - [Galera node monitoring](https://galeracluster.com/library/training/tutorials/galera-monitoring.html)
  - Galera node failure & recovery: [1](https://www.symmcom.com/docs/how-tos/databases/how-to-recover-mariadb-galera-cluster-after-partial-or-full-crash) [2](https://galeracluster.com/library/documentation/recovery.html)

> Quorum requires more than half of all nodes to be running!

- `galera_new_cluster` =  Re-bootstrap a failed cluster. Run from `bash` on most up-to-date node.
  - `show status like 'wsrep_last_committed';` = Show commit number. Compare across nodes to determine most up-to-date node.
- `show status like 'wsrep%';` = Show cluster status.
<br><br>
Change `safe_to_bootstrap` to `1` to [forcibly allow bootstrapping node:](https://www.symmcom.com/docs/how-tos/databases/how-to-recover-mariadb-galera-cluster-after-partial-or-full-crash)
```
root@server# cat /var/lib/mysql/grastate.dat

# GALERA saved state
version: 2.1
uuid:    00dbfde9-51d0-11eb-8b86-02d3d6f3051a
seqno:   -1
safe_to_bootstrap: 0
```
- If `show status like 'wsrep_cluster_size';` shows the incorrect node number, [reboot the node that doesn't agree with the others -- don't just restart the service.](https://www.symmcom.com/docs/how-tos/databases/how-to-recover-mariadb-galera-cluster-after-partial-or-full-crash)

---
## [POSTGRES](https://www.postgresql.org/docs/)

### Shell

- `psql -h <HOSTNAME_OR_IP> -p <PORT> -U <USERNAME> <DATABSE_NAME>` = Remotely connect to database.
- `sudo -u postgres psql -d zabbix` = Launch a SQL shell as user postgres and connect to *zabbix* database.

### psql

- `\l`              = List all databases.
- `\c <DB_NAME>`    = Connect to database.
- `\dt`             = View list of relations/tables.
- `\d <TABLE_NAME>` = Show details of table.
- `\h`              = Print help.
- `\?`              = List all psql "slash" commands.
- `\set`            = System variables.
- `\q`              = Quit.

### pg_hba.conf

<details>
<summary>Manage client authentication to the db host:</summary>

```
# Allow any user on the local system to connect to any database with
# any database user name using Unix-domain sockets (the default for local
# connections).
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust

# The same using local loopback TCP/IP connections.
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             127.0.0.1/32            trust

# The same as the previous line, but using a separate netmask column
#
# TYPE  DATABASE        USER            IP-ADDRESS      IP-MASK             METHOD
host    all             all             127.0.0.1       255.255.255.255     trust

# The same over IPv6.
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             ::1/128                 trust

# The same using a host name (would typically cover both IPv4 and IPv6).
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             localhost               trust

# Allow any user from any host with IP address 192.168.93.x to connect
# to database "postgres" as the same user name that ident reports for
# the connection (typically the operating system user name).
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    postgres        all             192.168.93.0/24         ident

# Allow any user from host 192.168.12.10 to connect to database
# "postgres" if the user's password is correctly supplied.
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    postgres        all             192.168.12.10/32        md5

# Allow any user from hosts in the example.com domain to connect to
# any database if the user's password is correctly supplied.
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             .example.com            md5

# In the absence of preceding "host" lines, these two lines will
# reject all connections from 192.168.54.1 (since that entry will be
# matched first), but allow Kerberos 5 connections from anywhere else
# on the Internet.  The zero mask causes no bits of the host IP
# address to be considered, so it matches any host.
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             192.168.54.1/32         reject
host    all             all             0.0.0.0/0               krb5

# Allow users from 192.168.x.x hosts to connect to any database, if
# they pass the ident check.  If, for example, ident says the user is
# "bryanh" and he requests to connect as PostgreSQL user "guest1", the
# connection is allowed if there is an entry in pg_ident.conf for map
# "omicron" that says "bryanh" is allowed to connect as "guest1".
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             192.168.0.0/16          ident map=omicron.

# If these are the only three lines for local connections, they will
# allow local users to connect only to their own databases (databases
# with the same name as their database user name) except for administrators
# and members of role "support", who can connect to all databases.  The file
# $PGDATA/admins contains a list of names of administrators.  Passwords
# are required in all cases.
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   sameuser        all                                     md5
local   all             @admins                                 md5
local   all             +support                                md5

# The last two lines above can be combined into a single line:
local   all             @admins,+support                        md5

# The database column can also use lists and file names:
local   db1,db2,@demodbs  all                                   md5
```
</details>
