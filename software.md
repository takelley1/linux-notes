## ZABBIX

- `zabbix_proxy -R config_cache_reload` = Reload Zabbix proxy configuration without restarting service.

## VSPHERE / VMWARE

`Actions -> Edit Settings -> VM Options -> VMWare Remote Console Options` = Edit max number of connected console sessions for a guest.


---
## MCAFEE

Uninstall McAfee Agent:
```bash
rpm -e MFEdx
rpm -e MFEcma
rpm -e MFErt

# If the above fails:
rpm -e MFEdx --nodeps --noscripts
rpm -e MFEcma --nodeps --noscripts
rpm -e MFErt --nodeps --noscripts
```


---
## PFSENSE

- [Place firewall rules on the interface where the traffic originates](https://blog.monstermuffin.org/pfsense-guide-nat-firewall-rules-networking-101/)

- [<INTERFACE> Net vs <INTERFACE> Addres:](https://docs.netgate.com/pfsense/en/latest/firewall/configure.html)
  - Interface Net
    - These macros specify the subnet for that interface exactly, including any IP alias VIP subnets that differ from
      the defined interface subnet.
  - Interface Address
    - These macros specify the IP address configured on that interface.

---
## BORG BACKUP

Extract */mnt/tank/share/pictures* in repo *backup-2020-01-19-01-00* to current path:
```bash
borg extract \
--progress \
--list \
--verbose \
/mnt/backup/borgrepo::backup-2020-01-19-01-00 mnt/tank/share/pictures/
```


---
## GRAYLOG

Change Graylog from RO to RW mode:
```bash
curl \
-XPUT \
-H "Content-Type: application/json" \
https://localhost:9200/_all/_settings \
-d '{"index.blocks.read_only_allow_delete": null}'
```


---
## OPENSCAP

Run SCAP scan:
```
oscap xccdf eval \
--fetch-remote-resources \                                            # Download any new definition updates.
--profile xccdf_mil.disa.stig_profile_MAC-3_Sensitive \               # Which profile within the STIG checklist to use.
--results /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).xml \    # Filepath to place XML results.
--report /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).html \    # Filepath to place HTML-formatted results.
/shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml # Filepath of the STIG checklist file.
```

Minimum XCCDF file for importing SCAP results to DISA STIG viewer:
```xml
<?xml version="1.0" encoding="UTF-8.  "?>
<TestResult>
  <rule-result idref="SV-86681r2_rule.  ">
    <result>pass</result>
  </rule-result>
  <rule-result idref="SV-86921r3_rule.  ">
    <result>notchecked</result>
  </rule-result>
  <rule-result idref="SV-86473r3_rule.  ">
    <result>notapplicable</result>
  </rule-result>
  <rule-result idref="SV-86853r3_rule.  ">
    <result>fail</result>
  </rule-result>
</TestResult>
```


---
## RANGER

- `m<KEY>`   = Bookmark path at <KEY>
- \`<KEY>    = Jump to bookmark at <KEY>
- `cd /path` = Jump to /path.
- `gh`       = Jump to ~ (*go home.  *)
<br><br>
- `I` = Rename from beginning of file.
- `A` = Rename from end of file (including extension).
- `a` = Rename from end of file (excluding extension).


---
## SPACEWALK / RED HAT SATELLITE

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

---
## TENABLE NESSUS

[Reset user password](https://docs.tenable.com/nessus/commandlinereference/Content/ChangeAUsersPassword.htm)
```bash
/opt/nessus/sbin/nessuscli chpasswd <USERNAME>
```

---
## TENABLE.SC (SECURITY CENTER)

Get new plugins: https://patches.csd.disa.mil

[Reset admin password to "password"](https://community.tenable.com/s/article/Reset-admin-password-in-Tenable-sc-and-unlock-the-account-if-its-been-locked-Formerly-SecurityCenter)
```
## Versions 5.10 and earlier:
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e' where username='admin';"

## Versions 5.11 and later:
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e', salt = '',hashtype = 1 where username='admin';"

# Password hash for easier reading:
bbd2
9bd3
3eb1
61d7
3853
6b59
e37d
b31e
```

List users:
```
# /opt/sc/support/bin/sqlite3 /opt/sc/application.db "select * from UserAuth"
```
