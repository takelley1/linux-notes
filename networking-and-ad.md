## FIREWALLD

- allow https traffic
  ```
  firewall-cmd --zone=public –-permanent --add-service=https
  firewall-cmd --reload
  ```

- disallow port 123 tdp traffic
  ```
  firewall-cmd --zone=public –-permanent --remove-port 123/tcp
  firewall-cmd --reload
  ```

#### `firewall-cmd` command
`--list-ports` or `--list-services` = show allowed ports/services \
`--list-all-zones` = show firewalld rules for both public and private zones

`--state` = check if firewalld is running \
`--zone=private --add-interface=ens32` = attach zone to network interface


## IPTABLES

`iptables -L` = show firewall ruleset

add new rule to allow port 80 traffic both to and from host
  ```
  iptables -A INPUT -i eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
  iptables –A OUTPUT -o eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT

  iptables –A INPUT -i eth0 –p tcp --sport 80 –m state --state NEW,ESTABLISHED –j ACCEPT 
  iptables –A OUTPUT -o eth0 –p tcp --sport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
  ```


## `ip` command  

#### interfaces
- `ip a add 192.168.1.200/255.255.255.0 dev eth0` or `ip a add 192.168.1.200/24 dev eth0` = change ip
- `ip link set dev eth1 up` = enable/disable interface

#### config
- `ip n show` = show neighbor/arp cache
- `ip r` = show routing table
- `ip a` = show network interfaces and IP addresses
- `/etc/sysconfig/network` = see default gateway
- `/etc/sysconfig/network-scripts/ifcfg-[interface]` = networking device interface options (Fedora-based systems)


## PORTS 

#### remote ports
- `nmap -p [port#] [ip]` or `telnet [ip] [port#]` = ping specific port on remote host
- `nc -zvu [ip] [port#]` = ping specific remote udp port
  - `z` zero IO mode, show only if connection is up/down
  - `v` verbose
  - `u` query udp instead of tcp

#### local ports
- `less /etc/services` = show ports being used by specific services
- `nmap localhost` or `ss -tulpn` or `netstat -plant` = view all open ports
  - `p` associated process PIDs
  - `l` only listening ports
  - `n` numerical ip addresses
  - `t` tcp ports
  - `u` udp ports

#### network scanning
- `nmap -p 22 192.168.1.1-254` = scan ip range for every box with port 22 open
- `nmap 192.168.1.20-40` = scan all ports on hosts within range


## ROUTES

- `route add default gw 192.168.1.1 eth0` = add default gateway
- `ip r` or `routel` = view routing table
- `dig domain.com` or `nslookup domain.com` = perform dns lookup on domain
- `traceroute domain.com` = print the route packets take to a given destination 


## NTP

- `ntpq -p` and `ntpstat` = show NTP status
- `date +%T –s "16:45:00"` = manually set time in HH:mm:ss format
- `ntpdate [fqdn or ip]` = force ntp to sync with specified server
- `timedatectl` = edit time
- `date` = view current time
- `date +%T –s "16:45:00"` = manually set time in HH:mm:ss format 

#### chrony
- `chronyc tracking`
- `chronyc sources -v` 
- `chronyc sourcestats` 
- `systemctl status chronyd` 
- `chronyc activity` 


## EMAIL 

- `mail -s "Test Subject" example@mail.com < /dev/null` = send test email (using the current host has the smtp relay)

- send email using a specific smtp relay
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
- `grep -h -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /var/log/maillog* | sort -u` = filter IPs from maillog
- `grep -o -E 'from=<.*>' /var/log/maillog | sort -u` = filter sending addresses from maillog

#### postfix whitelists
1. Add line to `/etc/postfix/main.cf` \
   `mynetworks = /postfix-whitelist`
2. Populate `/postfix-whitelist` with IPs
3. Run `postmap /postfix-whitelist && systemctl restart postfix`
4. Now only the IPs in `/postfix-whitelist` will be permitted to use the postfix server as an smtp relay


## spacewalk / red hat satellite

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

## active directory

### `ldapsearch` command

`ldapsearch -LLL -x -w [password] -H ldaps://[servername].[domain] -D "[authenticating-user].[domain]" "mail=[user-email]"`

#### ssh keys in Active Directory 

run script in /etc/ssh/sshd_config under line "AuthorizedKeysCommand" to authenticate users using their domain
account's public key, stored in the 'comment' field within their domain account's account properties.
```
#!/bin/bash
#echo "$1"
USER=$(echo "$1" | cut -f 1 -d "@")
PASS=$(cat /passwordfile)

ldapsearch -u -LLL -x -w $PASS -D "ldapsearch.svc@[DOMAIN]" -H "ldaps://[DOMAIN-CONTROLLER-NAME].[DOMAIN]" '(sAMAccountName='"$USER"')' 'comment' | sed -n '/^ /{H;d};/comment:/x;$g;s/\n *//g;s/comment: //gp'
```

### basic Active Directory tools

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/#sssd-ad-proc 


`net ads testjoin` 
`net ads info`
`net ads status`

`kinit`

integrate Linux with Active Directory using sssd 
run all commands as root 

```
#!/bin/bash

# make sure server isn't joined already
realm leave

# remove packages in order to start fresh
yum remove chrony ntp ntpdate krb5-workstation realmd oddjob oddjob-mkhomedir sssd samba-common-tools libsss_simpleifp sssd-tools dconf adcli -y

# install packages
yum install chrony ntp ntpdate krb5-workstation realmd oddjob oddjob-mkhomedir sssd samba-common-tools libsss_simpleifp sssd-tools dconf adcli -y

# sync ntp for kerberos
echo "syncing ntp with chrony"
systemctl enable chronyd
systemctl stop chronyd
# remove lines containing original server IPs
sed -i '/^server/d' /etc/chrony.conf
# add new server IPs to chrony config file
echo -e "server [NTP-SERVER-IP] iburst maxpoll 10\nserver [NTP-SERVER-IP2] iburst maxpoll 10\n$(cat /etc/chrony.conf)" > /etc/chrony.conf
systemctl start chronyd

echo "disabling selinux"
setenforce 0

echo "whitelisting firewall ports"
systemctl start firewalld
#ntp
firewall-cmd --zone=public --permanent --add-port 123/udp

#dns
firewall-cmd --zone=public --permanent --add-port 53/tcp
firewall-cmd --zone=public --permanent --add-port 53/udp

#ldap
firewall-cmd --zone=public --permanent --add-port 389/tcp
firewall-cmd --zone=public --permanent --add-port 389/udp

#kerberos
firewall-cmd --zone=public --permanent --add-port 88/udp
firewall-cmd --zone=public --permanent --add-port 88/tcp

#kerberos
firewall-cmd --zone=public --permanent --add-port 464/udp
firewall-cmd --zone=public --permanent --add-port 464/tcp

#ldap global catalog
firewall-cmd --zone=public --permanent --add-port 3268/tcp

# stop firewall
echo "stopping firewall"
systemctl stop firewalld

# allow sssd to authenticate
echo "editing pam"
authconfig --update --enablesssd --enablesssdauth --disableldap --disableldapauth --disablekrb5

# join domain
echo "joining domain"
realm join -U [USERNAME.FQDN]

# edit sssd file to remove requirement for fully qualified names
sed -i '/^use_fully_qualified/d' /etc/sssd/sssd.conf
echo -e "use_fully_qualified_names = False" >> /etc/sssd/sssd.conf

# permit user login
echo "permitting user login"
realm permit --all

# verify
echo "verifying domain"
realm list
echo ""
echo ""
id [DOMAIN]\\[DOMAIN-USERNAME]
echo ""
echo ""
id [DOMAIN]\\[DOMAIN-USERNAME2]

echo "giving sudo access to sysadmin users in domain"
echo "%[FQDN-OF-DOMAIN]\\\\[AD-GROUP-NAME] ALL=(ALL) ALL" >> /etc/sudoers

# get ip of local host and try to ssh in with ad account
echo "sshing in as domain user"

ssh -l [DOMAIN]\\[DOMAIN-USERNAME] localhost

exit 0
```    
