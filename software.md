## SonarQube

### SSO w/ Keycloak

See here: https://docs.sonarqube.org/latest/instance-administration/delegated-auth/
- Issue: Keycloak returning 'invalid redirect uri' error
  - Solution: In SonarQube GUI -> Administration -> Configuration -> General -> Server base URL, ensure value is set.

## VirtualBox

- `VBoxManage list runningvms` = List currently running VMs using headless VirtualBox.
- Fix freezing Ubuntu system:
  - VM Settings -> System -> Acceleration -> Paravirtualization Interface -> Change from 'Default' to 'Minimal'

## Zabbix

- `zabbix_proxy -R config_cache_reload` = Reload Zabbix proxy configuration without restarting service.

```bash
curl -L -s -X POST -H 'Content-Type: application/json-rpc' \
    -d '{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password":"zabbix"
    },
    "id":1,
    "auth":null
    }' \
https://zabbix.example.mil/api_jsonrpc.php
```

## vSphere / VMWare

`Actions -> Edit Settings -> VM Options -> VMWare Remote Console Options` = Edit max number of connected console sessions for a guest.

## Borg Backup

Extract */mnt/tank/share/pictures* in repo *backup-2020-01-19-01-00* to current path:
```bash
borg extract \
--progress \
--list \
--verbose \
/mnt/backup/borgrepo::backup-2020-01-19-01-00 mnt/tank/share/pictures/
```

## Graylog

Change Graylog from RO to RW mode:
```bash
curl \
-XPUT \
-H "Content-Type: application/json" \
https://localhost:9200/_all/_settings \
-d '{"index.blocks.read_only_allow_delete": null}'
```

## Ranger

- `m<KEY>`         = Bookmark path at *\<KEY\>*.
- `` `<KEY> ``     = Jump to bookmark at *\<KEY\>*.
- `cd /path`       = Jump to /path.
- `gh` *(go home)* = Jump to ~
<br><br>
- `I` = Rename from beginning of file.
- `A` = Rename from end of file (including extension).
- `a` = Rename from end of file (excluding extension).

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

