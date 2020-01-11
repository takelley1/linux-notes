
## FIREWALLD

allow https traffic
```
firewall-cmd --zone=public –-permanent --add-service=https
firewall-cmd --reload
```

disallow port 123 tdp traffic
```
firewall-cmd --zone=public –-permanent --remove-port 123/tcp
firewall-cmd --reload
```

#### `firewall-cmd` command

`--list-ports` or `--list-services` = show allowed ports/services  
`--list-all-zones` = show firewalld rules for both public and private zones

`--state` = check if firewalld is running  
`--zone=private --add-interface=ens32` = attach zone to network interface


---
## IPTABLES

`iptables -L` = show firewall ruleset

add new rule to allow port 80 traffic both to and from host

```bash
iptables -A INPUT -i eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
iptables –A OUTPUT -o eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT

iptables –A INPUT -i eth0 –p tcp --sport 80 –m state --state NEW,ESTABLISHED –j ACCEPT 
iptables –A OUTPUT -o eth0 –p tcp --sport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
```


---
## `ip` COMMAND  

#### interfaces

`ip a add 192.168.1.200/24 dev eth0` = add ip to device  
`ip a del 10.0.0.10/24 dev enp12s0`  = remove ip from device

`ip link set dev eth1 up` = enable/disable interface  

#### config

`ip n show` = show neighbor/arp cache  
`ip r`      = show routing table  
`ip a`      = show network interfaces and IP addresses

`/etc/sysconfig/network` = see default gateway  
`/etc/sysconfig/network-scripts/ifcfg-[interface]` = networking device interface options (Fedora-based systems)


---
## PORTS 

#### remote ports

`nmap -p [port#] [ip]` or `telnet [ip] [port#]` = ping specific tcp port on host

`nc -zvu [ip] [port#]` = ping specific udp port on host  
                  `-z` = zero IO mode, show only if connection is up/down  
                  `-v` = verbose  
                  `-u` = query udp instead of tcp

#### local ports

`less /etc/services` = show ports being used by specific services

`netstat -plant` or `ss -plunt` = view all open ports  
                           `-p` = associated process PIDs  
                           `-l` = only listening ports  
                           `-n` = numerical ip addresses  
                           `-t` = tcp ports  
                           `-u` = udp ports

#### scanning [3]

`nmap -p 22 192.168.1.0/24`      = scan for every host on subnet with port 22 open  
`nmap -p 1-1000 192.168.1.20-40` = scan tcp ports 1-1000 on hosts within range 
`nmap -sU localhost`             = scan localhost for open udp ports

`nmap -sP 10.0.0.0/8 = attempt to ping all hosts on the 10.0.0.0/8 subnet and list responses


---
## ROUTES

`ip r` or `routel` = view routing table  
`route add default gw 192.168.1.1 eth0` = manually add default gateway

`traceroute domain.com` = print the route that packets take to a given destination


---
## MONITORING & TROUBLESHOOTING

`iperf` and `iperf3`
`iftop`
`ifstat`

`dig domain.com` or `nslookup domain.com` or `host domain.com` = perform dns lookup on domain  

#### tcpdump [2]

`tcpdump -tvv` = dump all packets on all interfaces
 `-v` or `-vv` = extra packet information
	  `-t` = human-readable timestamps

`tcpdump host 1.1.1.1'     = packets going to or from 1.1.1.1
`tcpdump src 10.0.0.5'     = packets coming from 10.0.0.5
`tcpdump dst 192.168.1.10' = packets going to 192.168.1.10

`tcpdump -v port 3389'  = packets on port 3389
`tcpdump src port 1025' = packets coming from port 1025'

`tcpdump -vvt src 10.0.0.5 and dst port 22` = packets coming from 10.0.0.5 to port 22


---
## NTP

*`ntpd` has been deprecated in favor of `chrony`* [1]

`date +%T –s "16:45:00"` = manually set time in HH:mm:ss format  
`timedatectl`            = edit time  
`date`                   = view current time

#### chrony

show timekeeping stats [1]
```
[root@host]#: chronyc tracking

Reference ID    : 9B1D9843 (hostname.domain)           # source ntp server
Stratum         : 4                                    # number of ntp server hops to a root ntp server
Ref time (UTC)  : Wed Dec 11 20:42:51 2019             # utc time of ntp server
System time     : 0.000126482 seconds slow of NTP time # difference between host time and ntp server time
Last offset     : -0.000039551 seconds                 # changes made during chrony's last modification
RMS offset      : 0.001020088 seconds                  # long-term average offset
Frequency       : 2.941 ppm fast                       # how much faster/slower the default system clock is from ntp server
Residual freq   : -0.001 ppm                           # difference between reference frequency and current frequency
Skew            : 0.135 ppm                            # margin of error on frequency
Root delay      : 0.014488510 seconds                  # network delay for packets to reach ntp server
Root dispersion : 0.079814211 seconds
Update interval : 64.3 seconds                         # how frequently chrony modifies the system clock
Leap status     : Normal                               # whether a leap second is pending to be added/removed
                                                       # 1 ppm = 1.000001
```
other commands
`chronyc sources -v`   
`chronyc sourcestats`   
`systemctl status chronyd`   
`chronyc activity`   


---
## EMAIL

`mail -s "Test Subject" example@mail.com < /dev/null` = send test email (using the current host has the smtp relay)

send email using a specific smtp relay
```
echo "This is the message body and contains the message" | \
mailx -v \
-r "me@gmail.com" \               # this is the 'from' field of the email
-s "This is the subject" \
-S smtp="mail.example.com:25" \   # this is the smtp relay
-S smtp-use-starttls \
-S smtp-auth=login \
-S smtp-auth-user="someone@example.com" \
-S smtp-auth-password="abc123" \
-S ssl-verify=ignore \
yourfriend@gmail.com              # this is the 'to' field of the email
```

#### filtering

`grep -h -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /var/log/maillog* | sort -u` = filter IPs from maillog  
`grep -o -E 'from=<.*>' /var/log/maillog | sort -u` = filter sending addresses from maillog

#### postfix whitelists

1. Add line to `/etc/postfix/main.cf`    
   `mynetworks = /postfix-whitelist`
2. Populate `/postfix-whitelist` with IPs
3. Run `postmap /postfix-whitelist && systemctl restart postfix`
4. Now only the IPs in `/postfix-whitelist` will be permitted to use the postfix server as an smtp relay


---
## SPACEWALK / RED HAT SATELLITE

```
#!/bin/bash

# spacewalk client setup script

# for rhel/centos 7

# whitelist spacewalk server
firewall-cmd --zone=public --permanent --add-source=XXXXXXX
firewall-cmd --reload

# add spacewalk repo
yum install -y yum-plugin-tmprepo
yum install -y spacewalk-client-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.9-client/epel-7-x86_64/repodata/repomd.xml --nogpg
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# add epel repo
yum install epel-release

# install necessary packages
yum -y install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin osad

# add spacewalk ca cert
rpm -Uvh http://XXXXXXXX/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm

# register with activation key
rhnreg_ks --serverUrl=https://XXXXXXX/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-centos7-main-key

# start rhnsd service
systemctl enable rhnsd && systemctl start rhnsd

# install and configure osad
sed -i "s/osa_ssl_cert =/osa_ssl_cert = \/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT/g" /etc/sysconfig/rhn/osad.conf
systemctl enable osad && systemctl start osad

# test connectivity
rhn-channel --list
```

---
#### sources

[1] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#migrating-to-chrony_using-chrony-to-configure-ntp  
[2] https://danielmiessler.com/study/tcpdump/  
[3] https://danielmiessler.com/study/nmap/

