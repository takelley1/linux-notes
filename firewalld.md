## [Firewalld](https://firewalld.org/documentation/)

- **See also:**
  - [Using Firewalld on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7)

Allow HTTPS traffic in the public zone:
```bash
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
```

Disallow port 123 TCP traffic in the block zone.
```bash
firewall-cmd --zone=block --permanent --remove-port 123/tcp
firewall-cmd --reload
```

### firewall-cmd options

- `--list-ports` or `--list-services` = Show allowed ports/services.
- `--list-all-zones` = Show firewalld rules for both public and private zones.
<br><br>
- `--state` = Check if firewalld is running.
- `--zone=private --add-interface=ens32` = Attach zone to network interface.
