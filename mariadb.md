## [MariaDB](https://mariadb.com/kb/en/training-tutorials/)

- **See also**
  - [MySQL cheat sheet](https://devhints.io/mysql)
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

### MariaDB Galera cluster

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
