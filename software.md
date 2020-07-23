
## ANSIBLE

`ansible -i inventories/hostsfile.yml -m debug -a "var=hostvars" all` = View all variables from all hosts in hostsfile.yml.  

`ansible-vault encrypt_string --vault-password-file vaultpw.txt "ThisIsAGoodPassword" --name 'userpassword' --encrypt-vault-id default` = Encrypt variable.  
`ansible localhost -m debug -a var='userpassword' -e '@group_vars/all/path/to/file.yml` = View decrypted variable within file.  

Run ad-hoc command as root on target box
```bash
ansible 192.168.1.1       \
  -a "yum update"         \ # Run ad-hoc.
  -u austin               \ # User to use when connecting to target.
  -k                      \ # Ask for user's SSH password to authenticate.
  –b                      \ # Use become to elevate privileges
  –K                      \ # Ask for the user's escalation password.
  –-become-method sudo    \ # Use sudo to escalate.
  -f 10                     # Run 10 separate threads.
  
ansible 192.168.1.1 -a "yum update" -u austin -kK –b –-become-user root –-become-method sudo -f 10
```

`ansible-playbook --syntax-check ./playbook.yml` = Check syntax.    
`ansible-lint ./playbook.yml`                    = Check best-practices.    


---
## BORG BACKUP

Extract /mnt/tank/share/pictures in repo backup-2020-01-19-01-00 to current path:
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

`cd /path` = Jump to /path.    
`gh`       = Jump to ~ (*go home.  *)  


---
## SPACEWALK / RED HAT SATELLITE

`rhncfg-client get` = Force spacewalk client to pull configuration files.  

```bash
#!/bin/bash

# spacewalk client setup script

# for rhel/centos 7

# whitelist spacewalk server
firewall-cmd --zone=public --permanent --add-source.  =XXXXXXX
firewall-cmd --reload

# add spacewalk repo
yum install -y yum-plugin-tmprepo
yum install -y spacewalk-client-repo \
--tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.9-client/epel-7-x86_64/repodata/repomd.xml.   \
--nogpg
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# add epel repo
yum install epel-release

# install necessary packages
yum -y install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin osad

# add spacewalk ca cert
rpm -Uvh http://XXXXXXXX/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm

# register with activation key
rhnreg_ks --serverUrl=https://XXXXXXX/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-centos7-main-key.  

# start rhnsd service
systemctl enable rhnsd && systemctl start rhnsd

# install and configure osad
sed -i "s/osa_ssl_cert =/osa_ssl_cert = \/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT/g" /etc/sysconfig/rhn/osad.conf.  
systemctl enable osad && systemctl start osad

# test connectivity
rhn-channel --list
```


---
## TENABLE.SC (SECURITYCENTER) <sup>[1]</sup> 

Get new plugins: https://patches.csd.disa.mil

Reset admin password to "password":
```
## Versions 5.10 and earlier
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e' where username='admin.  ';"

## Versions 5.11 and later
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e', salt.   = '',
hashtype = 1 where username='admin.  ';"

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

[1]: https://community.tenable.com/s/article/Reset-admin-password-in-Tenable-sc-and-unlock-the-account-if-its-been-locked-Formerly-SecurityCenter  
