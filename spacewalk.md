## Spacewalk / Red Hat Satellite

- `rhncfg-client get` = Force spacewalk client to pull configuration files.

```bash
#!/usr/bin/env bash
# Spacewalk client setup script for rhel/centos 7

# Whitelist spacewalk server.
firewall-cmd --zone=public --permanent --add-source=XXXXXXX
firewall-cmd --reload
# Add spacewalk repo.
yum install -y yum-plugin-tmprepo
yum install -y spacewalk-client-repo \
--tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.9-client/epel-7-x86_64/repodata/repomd.xml \
--nogpg
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Add epel repo, install necessary packages.
yum install -y epel-release && yum install -y rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin osad
# Add spacewalk ca cert.
rpm -Uvh http://XXXXXXXX/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm
# Register with activation key.
rhnreg_ks --serverUrl=https://XXXXXXX/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-centos7-main-key
# Start rhnsd service.
systemctl enable rhnsd --now
# Install and configure osad.
sed -i "s/osa_ssl_cert =/osa_ssl_cert = \/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT/g" /etc/sysconfig/rhn/osad.conf
systemctl enable osad --now
# Test connectivity.
rhn-channel --list
```
