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
