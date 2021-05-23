
## ACTIVE DIRECTORY

### `ldapsearch` command

```bash
ldapsearch \
      -LLL \
      -x \
      -w <PASSWORD> \
      -H ldaps://<SERVERNAME>.<DOMAIN> \
      -D "<AUTHENTICATING_USER>@<DOMAIN>" \
      "mail=<USER_EMAIL>"

ldapsearch -LLL -x -w CorrectHorseBatteryStaple -H ldaps://dc01.domain.example.com -D "jane.doe.sa@domain.example.com" "mail=jdoe@example.com"
```

### SSH key authentication

- For SSH-key-based LDAP authentication the below scriptlet is to be referenced in "/etc/ssh/sshd_config" at the line
  `AuthorizedKeysCommand`.
- The scriptlet attempts to authenticate users using a public key stored in the `comment` field of their LDAP user
  account attributes.

```bash
#!/usr/bin/env bash
USER="$(echo "$1" | cut -f 1 -d "@")"
PASS="$(cat </PATH/TO/PASSWORD/FILE>)"

ldapsearch -u \
           -LLL \
           -x \
           -w $PASS \
           -D "<SERVICE_ACCOUNT_NAME>@<DOMAIN>" \
           -H "ldaps://<DOMAIN_CONTROLLER_NAME>.<DOMAIN>" \
           '(sAMAccountName='"$USER"')' 'comment' | \
           sed -n '/^ /{H;d};/comment:/x;$g;s/\n *//g;s/comment: //gp'
```

---
### Integration

- **See also:**
  - [Linux integration with windows](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/#sssd-ad-proc)

```bash
net ads testjoin
net ads info
net ads status
kinit
```

## Integrating Linux with Active Directory using realmd

```bash
#!/usr/bin/env bash

#######################
# This script is old! #
#######################

# Make sure server isn't joined already.
realm leave
# Install packages.
yum install chrony \
            ntp \
            ntpdate \
            krb5-workstation \
            realmd \
            oddjob \
            oddjob-mkhomedir \
            sssd \
            samba-common-tools \
            libsss_simpleifp \
            sssd-tools \
            dconf \
            adcli -y
# Sync NTP for kerberos.
systemctl enable chronyd --now

# Disable SELinux.
setenforce 0

systemctl enable firewalld --now

for i in ntp dns ldap kerberos ldaps; do
  firewall-cmd --zone=public --permanent --service="${i}"
done

systemctl stop firewalld

# Allow sssd to authenticate.
authconfig --update \
           --enablesssd \
           --enablesssdauth \
           --disableldap \
           --disableldapauth \
           --disablekrb5

# Join domain.
realm join -U <USERNAME.FQDN>
# Permit user login.
realm permit --all

# Verify.
realm list
id <DOMAIN>\\<DOMAIN_USERNAME>

# Get IP of local host and try to SSH in with ad account.
ssh -l <DOMAIN>\\<DOMAIN_USERNAME> localhost
```
