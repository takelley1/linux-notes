
## ANSIBLE 

`ansible-playbook /path/to/playbook -kK –f 100` = run playbook

run ad-hoc command as root on target box  
`ansible 192.168.1.1 -a "yum update" -u akelley -k –b –-become-user root –K –-become-method su -f 10`  
  `-a`                 = run ad-hoc command  
  `-u`                 = use this user to access the machine  
  `-k`                 = ask for user's password instead of using ssh key  
  `-b`                 = use become to elevate privileges  
  `--become-user root` = become the user root when elevating  
  `-K`                 = ask for escalation password   
  `--become-method su` = use su instead of sudo when elevating 
  `-f 100`             = run 100 separate worker threads  

`ansible-playbook --syntax-check ./playbook.yml` = check syntax  
`ansible-lint ./playbook.yml`                    = check best-practices  


---
## BORG BACKUP

`borg extract --progress --list --verbose /mnt/backup/borgrepo::backup-2020-01-19-01-00 mnt/tank/share/pictures/` = extract /mnt/tank/share/pictures in repo backup-2020-01-19-01-00 to current path


---
## GRAYLOG

`curl -XPUT -H "Content-Type: application/json"  https://localhost:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": null}'` = change Graylog to RW mode from RO mode


---
## OPENSCAP  

run scap scan
  ```
  oscap xccdf eval \
  --fetch-remote-resources \                                            # download any new definition updates
  --profile xccdf_mil.disa.stig_profile_MAC-3_Sensitive \               # which profile within the STIG checklist to use
  --results /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).xml \    # filepath to place XML results
  --report /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).html \    # filepath to place HTML-formatted results
  /shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml # filepath of the STIG checklist file
  ```
  
  minimum XCCDF file for importing SCAP results to DISA STIG viewer:
  ```
  <?xml version="1.0" encoding="UTF-8"?>
<TestResult>
  <rule-result idref="SV-86681r2_rule">
    <result>pass</result>
  </rule-result>
  <rule-result idref="SV-86921r3_rule">
    <result>notchecked</result>
  </rule-result>
  <rule-result idref="SV-86473r3_rule">
    <result>notapplicable</result>
  </rule-result>
  <rule-result idref="SV-86853r3_rule">
    <result>fail</result>
  </rule-result>
</TestResult>
```


---
## Tenable.SC (SecurityCenter)

reset admin password to "password" [1]
```
## Versions 5.10 and earlier
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e' where username='admin';"

## Versions 5.11 and later
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e', salt = '', hashtype = 1 where username='admin';"
```

list users [1]
```
# /opt/sc/support/bin/sqlite3 /opt/sc/application.db "select * from UserAuth" 
```


---
#### sources

[1] https://community.tenable.com/s/article/Reset-admin-password-in-Tenable-sc-and-unlock-the-account-if-its-been-locked-Formerly-SecurityCenter  
