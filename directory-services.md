
## ACTIVE DIRECTORY

### `ldapsearch` command

```bash
ldapsearch \
-LLL -x \
-w <PASSWORD> \
-H ldaps://<SERVERNAME>.<DOMAIN> \
-D "<AUTHENTICATING_USER>.<DOMAIN>" \
"mail=<USER_EMAIL>"
```

### SSH key authentication

- For SSH-key-based LDAP authentication the below scriptlet is to be referenced in "/etc/ssh/sshd_config" at the line `AuthorizedKeysCommand`.
- The scriptlet attempts to authenticate users using a public key stored in the `comment` field of their LDAP user account attributes.

```bash
#!/usr/bin/env bash
USER=$(echo "$1" | cut -f 1 -d "@")
PASS=$(cat </PATH/TO/PASSWORD/FILE>)

ldapsearch -u -LLL -x -w $PASS \
-D "ldapsearch.svc@<DOMAIN>" \ # ldapsearch.svc is a service account.
-H "ldaps://<DOMAIN_CONTROLLER_NAME>.<DOMAIN>" \
'(sAMAccountName='"$USER"')' 'comment' | \
sed -n '/^ /{H;d};/comment:/x;$g;s/\n *//g;s/comment: //gp'
```

---
### Integration

**See also:** [inux integration with windows](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/#sssd-ad-proc)  

```bash
net ads testjoin
net ads info
net ads status
kinit
```

## Integrating Linux with Active Directory using realmd

*Run all commands as root.*

```bash
#!/usr/bin/env bash

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
echo -e "server <NTP_SERVER_IP> iburst maxpoll 10\nserver <NTP_SERVER_IP2> iburst maxpoll 10\n$(cat /etc/chrony.conf)" > /etc/chrony.conf
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
realm join -U <USERNAME.FQDN>

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
id <DOMAIN>\\<DOMAIN_USERNAME>
echo ""
echo ""
id <DOMAIN>\\<DOMAIN_USERNAME2>

echo "giving sudo access to sysadmin users in domain"
echo "%<FQDN_OF_DOMAIN>\\\\<AD_GROUP_NAME> ALL=(ALL) ALL" >> /etc/sudoers

# Get IP of local host and try to SSH in with ad account.
echo "sshing in as domain user"

ssh -l <DOMAIN>\\<DOMAIN_USERNAME> localhost

exit 0
```

