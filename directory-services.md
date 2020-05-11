
## ACTIVE DIRECTORY

### `ldapsearch` command

```bash
ldapsearch \
-LLL -x \
-w [password] \
-H ldaps://[servername].[domain] \
-D "[authenticating-user].[domain]" \
"mail=[user-email]"
```

### SSH key authentication

The below script is referenced in `/etc/ssh/sshd_config` at the line `AuthorizedKeysCommand`.  
It attempts to authenticate users using a public key stored in the `comment` field of their ldap user account attributes.  

```bash
#!/bin/bash
USER=$(echo "$1" | cut -f 1 -d "@")
PASS=$(cat ./passwordfile)

ldapsearch -u -LLL -x -w $PASS \
-D "ldapsearch.svc@[DOMAIN]" \
-H "ldaps://[DOMAIN-CONTROLLER-NAME].[DOMAIN]" \
'(sAMAccountName='"$USER"')' 'comment' | \
sed -n '/^ /{H;d};/comment:/x;$g;s/\n *//g;s/comment: //gp'
```

---
### Integration

**see also:** [inux integration with windows](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/#sssd-ad-proc)  

```bash
net ads testjoin
net ads info
net ads status
kinit`
```

## Integrate Linux with Active Directory using `realmd`

*Run all commands as root.*

```bash
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

# Stop firewalld.
echo "stopping firewall"
systemctl stop firewalld

# Allow sssd to authenticate.
echo "editing pam"
authconfig --update --enablesssd --enablesssdauth --disableldap --disableldapauth --disablekrb5

# Join domain.
echo "joining domain"
realm join -U [USERNAME.FQDN]

# Edit sssd file to remove requirement for fully qualified names.
sed -i '/^use_fully_qualified/d' /etc/sssd/sssd.conf
echo -e "use_fully_qualified_names = false" >> /etc/sssd/sssd.conf

# Permit user login.
echo "permitting user login"
realm permit --all

# Verify
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

# Get IP of local host and try to SSH in with ad account.
echo "sshing in as domain user"

ssh -l [DOMAIN]\\[DOMAIN-USERNAME] localhost

exit 0
```

