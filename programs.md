## ANSIBLE 

- `ansible-playbook /path/to/playbook -kK –f 100` = run playbook

run ad-hoc command as root on target box
- `ansible 192.168.1.1 -a "yum update" -u akelley -k –b –-become-user root –K –-become-method su -f 10`
  - `-a` run ad-hoc command
  - `-u` use this user to access the machine
  - `-k` ask for user's password instead of using ssh key
  - `-b` use become to elevate privileges
  - `--become-user root` become the user root when elevating
  - `-K` ask for escalation password
  - `--become-method su` use su instead of sudo when elevating
  - `-f 100` = run 100 separate worker threads

`ansible-playbook --syntax-check ./playbook.yml` = check syntax  
`ansible-link ./playbook.yml` = check best-practices


## OPENSCAP  

- run scap scan
  ```
  oscap xccdf eval \
  --fetch-remote-resources \
  --profile xccdf_mil.disa.stig_profile_MAC-3_Sensitive \
  --results /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).xml \
  --report /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).html \
  /shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml
  ```
  - `--fetch-remote-resources` = download any new definition updates
  - `--profile` = which profile within the STIG checklist to use
  - `--results` = filepath to place XML results
  - `--report` = filepath to place HTML-formatted results
  - `/shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml` = filepath of the STIG checklist file


## LESS 

`SPACE` next page  
`b` previous page  
`>` last line  
`<` first line  
`/` forward search  
`?` backward search  
`n` next search match  
`N` previous search match  
`q` quit
