## [PostgreSQL](https://www.postgresql.org/docs/)

- **See also:**
  - [Postgres pager](https://github.com/okbob/pspg)
<br><br>
- `export PAGER="less -XRFS"` = Don't wrap table output in the SQL shell.

### Shell

- `psql -h <HOSTNAME_OR_IP> -p <PORT> -U <USERNAME> <DATABSE_NAME>` = Remotely connect to database.
- `sudo -u postgres psql -d zabbix` = Launch a SQL shell as user postgres and connect to *zabbix* database.

- Create user with database:
```
# Pop shell
sudo -u postgres psql
# Create user
CREATE USER username WITH PASSWORD 'password';
# Create DB
CREATE DATABASE dbname OWNER username;
# Give privileges
GRANT ALL PRIVILEGES ON DATABASE dbname TO username;
# Quit
\q
# Test connection
psql -U username -d dbname -h localhost
```

### psql

- `\l`              = List all databases.
- `\c <DB_NAME>`    = Connect to database.
- `\dt`             = View list of relations/tables.
- `\d <TABLE_NAME>` = Show details of table.
- `\h`              = Print help.
- `\?`              = List all psql "slash" commands.
- `\set`            = System variables.
- `\q`              = Quit.

### Server

- See [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-8) for basic
  server setup and how Postgres manages roles and authentication.

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
