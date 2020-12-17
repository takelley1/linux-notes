
### Crypto

- `ansible-vault encrypt_string --vault-password-file vaultpw.txt 'CorrectHorseBatteryStaple' --name 'vmware_password' --encrypt-vault-id default` = Encrypt variable.
- `ansible localhost -m debug -a var='userpassword' -e '@inventories/path/to/file/containing/variable.yml'` = View decrypted variable within file.
<br><br>
- `ansible localhost -m debug -a 'msg={{ "mypassword" | password_hash("sha512", "mysecretsalt") }}'` = Hash a user's password for use in the `user` module.

### Variables

- `ansible -i inventories/hostsfile.yml -m debug -a "var=hostvars" all` = View all variables from all hosts in hostsfile.yml.
- `ansible localhost -m setup -kK -u foo` = Print local host's facts by connecting to it with user *foo*.

### Ad-hoc commands

- `ansible webserver01 -m debug -a 'msg={{ hostname | quote }}' -i inventories/my_inv/hosts.yml` = Run ad-hoc debug module on *webserver01* to test variable filter.
- `ansible localhost -m debug -a msg="{{ lookup('env','HOME') }}"` = Run ad-hoc module on localhost to print user's home directory.

Run ad-hoc command as root on target box:
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
Another ad-hoc command example:
```bash
ansible -i inventories/my_inv/hosts.yml -m file -a "path=/etc/yum.repos.d/elasticsearch.repo state=absent" linux_group -kK
```

### Misc

- `ansible-doc -F`                                 = List all available modules.
- `ansible-playbook --syntax-check ./playbook.yml` = Check syntax.
- `ansible-lint ./playbook.yml`                    = Check best-practices.
