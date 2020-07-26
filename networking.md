
## SSH

*OpenSSH only*

**See also:** [ssh essentials](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys), [authorized_keys vs known_hosts](https://security.stackexchange.com/questions/20706/what-is-the-difference-between-authorized-keys-and-known-hosts-file-for-ssh), [sshd_config man page](https://www.freebsd.org/cgi/man.cgi?sshd_config(5))

### files <sup>[6]</sup>

`~/.ssh/known_hosts`
  - Kept on the client.
  - Contains the public keys of servers (host keys) this user trusts.
  - Servers maintain their own host keypairs (in /etc/ssh) to prove their identity to connecting clients.
    - Via a key-exchange, clients can know they're connecting to the same host and not an impersonator or man-in-the-middle (because the server can prove it has posession of the matching private key).

`~/.ssh/authorized_keys`
  - Kept on the server.
  - Contains the public keys of users (user keys) allowed to login to this account.


---
## FIREWALLD

**See also:** [using firewalld on centos7](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7)

Allow https traffic in the public zone:
```bash
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
```

Disallow port 123 tdp traffic in the block zone.
```bash
firewall-cmd --zone=block --permanent --remove-port 123/tcp
firewall-cmd --reload
```

### `firewall-cmd` command

`--list-ports` or `--list-services` = Show allowed ports/services.<br>
`--list-all-zones` = Show firewalld rules for both public and private zones.<br>

`--state` = Check if firewalld is running.<br>
`--zone=private --add-interface=ens32` = Attach zone to network interface.<br>


---
## IPTABLES

> NOTE: `iptables` has been deprecated in favor of `nftables` <sup>[4]</sup>

`iptables -L` = Show firewall ruleset.

Add new rule to allow port 80 traffic both to and from host:
```bash
iptables -A INPUT -i eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
iptables –A OUTPUT -o eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT

iptables –A INPUT -i eth0 –p tcp --sport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
iptables –A OUTPUT -o eth0 –p tcp --sport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
```


---
## `ip` COMMAND

### interfaces

`ip a add 192.168.1.200/24 dev eth0`   = Add ip to device.
`ip a del 10.0.0.10/24 dev enp12s0`    = Remove ip from device.
`ip route add DEFAULT via 10.0.0.1 dev eth0` = Add default gateway to device.

`ip link set dev eth1 up` = Enable/disable interface.

### config

`ip n show` = Show neighbor/arp cache.
`ip r`      = Show routing table.
`ip a`      = Show network interfaces and IP addresses.

`/etc/sysconfig/network` = See default gateway.<br>
`/etc/sysconfig/network-scripts/ifcfg-[interface]` = Networking device interface options (Fedora-based systems).<br>


---
## PORTS

### remote ports

`nmap -p [port#] [ip]` or `telnet [ip] [port#]` = Ping specific tcp port on host.

`nc -zvu [ip] [port#]` = Ping specific udp port on host.<br>
                  `-z` = Zero IO mode, show only if connection is up/down.<br>
                  `-v` = Verbose.<br>
                  `-u` = Query udp instead of tcp.<br>

### local ports

> NOTE: `netstat` has been deprecated in favor of `ss` <sup>[5]</sup>

`less /etc/services` = Show ports being used by specific services.

`netstat -plaunt` or `ss -plunt` = View all open ports.<br>
                            `-p` = Associated process PIDs.<br>
                            `-l` = Only listening ports.<br>
                            `-n` = Numerical ip addresses.<br>
                            `-t` = Tcp ports.<br>
                            `-u` = Udp ports.<br>

### scanning <sup>[3]</sup>

`nmap -p 22 192.168.1.0/24`      = Scan for every host on subnet with port 22 open.<br>
`nmap -p 1-1000 192.168.1.20-40` = Scan tcp ports 1-1000 on hosts within range.<br>
`nmap -sU localhost`             = Scan localhost for open udp ports.<br>

`nmap -sP 10.0.0.0/8` = Attempt to ping all hosts on the 10.0.0.0/8 subnet and list responses.<br>


### VLANS

[how do VLANs work?](https://serverfault.com/questions/188350/how-do-vlans-work?rq=1)
[access ports vs trunk ports](https://www.solarwindsmsp.com/blog/vlan-trunking)

---
## ROUTES

`ip route` or `routel` = View routing table.<br>
`route add default gw 192.168.1.1 eth0` = Manually add default gateway.<br>

`traceroute domain.com` = Print the route that packets take to a given destination.<br>


---
## MONITORING & TROUBLESHOOTING

`iperf` and `iperf3`
`iftop`
`ifstat`

`dig domain.com` or `nslookup domain.com` or `host domain.com` = Perform dns lookup on domain.

### tcpdump <sup>[2]</sup>

`tcpdump -tvv` = Dump all packets on all interfaces.<br>
 `-v` or `-vv` = Extra packet information.<br>
          `-t` = Human-readable timestamps.<br>

`tcpdump -i ens32` = Packets on interface ens32.<br>

`tcpdump host 1.1.1.1`     = Packets going to or from 1.1.1.1.<br>
`tcpdump src 10.0.0.5`     = Packets coming from 10.0.0.5.<br>
`tcpdump dst 192.168.1.10` = Packets going to 192.168.1.10.<br>

`tcpdump -v port 3389`  = Packets on port 3389.<br>
`tcpdump src port 1025` = Packets coming from port 1025.<br>

`tcpdump -vvt src 10.0.0.5 and dst port 22` = Packets coming from 10.0.0.5 to port 22.<br>


---
## NTP

> NOTE: `ntpd` has been deprecated in favor of `chrony` <sup>[1]</sup>

`date +%T –s "16:45:00"` = Manually set time in HH:mm:ss format.<br>
`date`                   = View current time.<br>

### chrony <sup>[1]</sup>

Show timekeeping stats:
```
[root@host]#: chronyc tracking.

Reference ID    : 9B1D9843 (hostname.domain)           # source ntp server.
Stratum         : 4                                    # number of ntp server hops to a root ntp server.
Ref time (UTC)  : Wed Dec 11 20:42:51 2019             # utc time of ntp server.
System time     : 0.000126482 seconds slow of NTP time # difference between host time and ntp server time.
Last offset     : -0.000039551 seconds                 # changes made during chrony's last modification.
RMS offset      : 0.001020088 seconds                  # long-term average offset.
Frequency       : 2.941 ppm fast                       # how much faster/slower the default system clock is from ntp server.
Residual freq   : -0.001 ppm                           # difference between reference frequency and current frequency.
Skew            : 0.135 ppm                            # margin of error on frequency.
Root delay      : 0.014488510 seconds                  # network delay for packets to reach ntp server.
Root dispersion : 0.079814211 seconds
Update interval : 64.3 seconds                         # how frequently chrony modifies the system clock.
Leap status     : Normal                               # whether a leap second is pending to be added/removed.
                                                       # 1 ppm = 1.000001 seconds.
```

other useful commands <sup>[7]</sup>
```bash
chronyc sources -v
chronyc sourcestats
chronyc activity
timedatectl
```


---
## EMAIL

`mail -s "Test Subject" example@mail.com < /dev/null` = Send test email (using the current host has the smtp relay).<br>

Send email using a specific smtp relay:
```bash
echo "This is the message body and contains the message" | \
mail -v                                   \
-r "sender@example.com"                   \  # This is the 'from' field of the email.
-s "This is the subject"                  \
-S smtp="mail.example.com:25"             \  # This is the smtp relay.
-S smtp-use-starttls                      \
-S smtp-auth=login                        \
-S smtp-auth-user="authuser@example.com"  \
-S smtp-auth-password="abc123"            \
-S ssl-verify=ignore                      \
recipient@example.com                        # This is the 'to' field of the email.
```

### filtering

`grep -o -E 'from=<.*>' /var/log/maillog | sort -u` = Filter sending addresses from maillog.<br>

### postfix whitelists

1. add line to `/etc/postfix/main.cf`<br>
   ```bash
   mynetworks = /postfix-whitelist

   ```
1. populate `/postfix-whitelist` with IPs<br>
1. run `postmap /postfix-whitelist && systemctl restart postfix`<br>
1. now only the IPs in `/postfix-whitelist` will be permitted to use the postfix server as an smtp relay<br>


---
## `wget` COMMAND

```bash
wget                            \
  --recursive                   \ # Descend into all subdirectories.
  --no-clobber                  \ # Don't overwrite existing files.
  --page-requisites             \ # Download all files required to display each page properly.
  --html-extension              \ # Explicitly add .html extensions to relevant files.
  --convert-links               \ # Convert http:// to file:// links for offline browsing.
  --restrict-file-names=windows \ # Escape control characters in filenames.  .<br>
  --no-parent                   \ # Don't include directories above the path provided.
  www.website.org/

wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --no-parent www.website.org
```

[1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#migrating-to-chrony_using-chrony-to-configure-ntp.
[2]: https://danielmiessler.com/study/tcpdump/
[3]: https://danielmiessler.com/study/nmap/
[4]: https://wiki.debian.org/nftables
[5]: https://dougvitale.wordpress.com/2011/12/21/deprecated-linux-networking-commands-and-their-replacements/#netstat.
[6]: https://www.techrepublic.com/article/the-4-most-important-files-for-ssh-connections/
[7]: https://www.thegeekdiary.com/centos-rhel-7-tips-on-troubleshooting-ntp-chrony-issues/
