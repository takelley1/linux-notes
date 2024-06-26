## [Ansible](https://docs.ansible.com/)

- **See also**
  - [Jinja2 reference](https://jinja2docs.readthedocs.io/en/stable/)
  - [Jinja2 filters](https://jinja.palletsprojects.com/en/3.0.x/templates/#builtin-filters)
  - [Jinja2 tests](https://jinja.palletsprojects.com/en/3.0.x/templates/#builtin-tests)

### Crypto

- `ansible-vault encrypt_string --vault-password-file vaultpw.txt 'CorrectHorseBatteryStaple' --name 'vmware_password' --encrypt-vault-id default` = Encrypt variable.
- `ansible localhost -m debug -a var='userpassword' -e '@inventories/path/to/file/containing/variable.yml'` = View decrypted variable within file.
<br><br>
- `ansible localhost -m debug -a 'msg={{ "mypassword" | password_hash("sha512", "mysecretsalt") }}'` = Hash a user's password for use in the *ansible.builtin.user* module.

### Modules

- `ansible -v localhost -m aws_s3 -a "bucket=my-bucket object=/repos/fortify/fortify.license dest=/home/akelley/fortify.license mode=get overwrite=different"` = Run local module with multiple arguments.
- `ansible -v ipa.example.com -b -u ansible -m package -a "name=coreutils"` = Install coreutils using package module with ansible user on ipa.exmaple.com host.

### Variables

- `when: result.stdout is search("already installed")` = [Test string for substring](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tests.html#testing-strings)
- `ansible -i inventories/hostsfile.yml -m debug -a "var=hostvars" all` = View all variables from all hosts in *hostsfile.yml*.
- `ansible webserver01 -m debug -a 'msg={{ hostname | quote }}' -i inventories/my_inv/hosts.yml` = Run ad-hoc debug module on *webserver01* to test variable filter.
- `ansible localhost -m debug -a msg="{{ '/opt/apache-tomcat-9.0.zip' | basename | splitext | first }}"` = Extract *apache-tomcat-9.0* with filters.
- `ansible localhost -m debug -a msg="{{ lookup('env','HOME') }}"` = Run ad-hoc module on *localhost* to print user's home directory.
- `ansible localhost -m setup -kK -u foo` = Print local host's facts by connecting to it with user *foo*.
- `ansible myserver.example.com -m setup -u ansible` = Print facts from myserver.example.com using user *ansible*.
<br><br>
- `packages_list_new: "{{ packages_list | reject('eq', 'p7zip') | list }}"` = [Remove p7zip from packages_list.](https://docs.ansible.com/ansible/latest/user_guide/complex_data_manipulation.html#omit-elements-from-a-list)
- `packages_list_new: "{{ packages_list + ['p7zip', 'htop'] }}"` = Add *p7zip* and *htop* to *packages_list*.
<br><br>
- [Wrap long Jinja2 lines:](https://ansibledaily.com/add-beauty-to-long-jinja2-chains/)
```yaml
# Make sure to remove the surrounding double-quotes!
foo: >-
  {{ foo_bar |
  reject('eq', 'green') |
  reject('eq', 'eggs') |
  reject('eq', 'and') |
  reject('eq', 'ham') |
  list }}
```

```bash
ansible 192.168.1.1       \
  -a "yum update"         \ # Run ad-hoc.
  -u austin               \ # User to use when connecting to target.
  -k                      \ # Ask for user's SSH password to authenticate.
  -b                      \ # Use become to elevate privileges
  -K                      \ # Ask for the user's escalation password.
  --become-method sudo    \ # Use sudo to escalate.
  -f 10                     # Run 10 separate threads.

ansible 192.168.1.1 -a "yum update" -u austin -kK -b --become-user root --become-method sudo -f 10
```

Run Ad-hoc Ansible module from an interactive shell:
```bash
# On remote host using inventory file
ansible -i inventories/my_inv/hosts.yml -m file -a "path=/etc/yum.repos.d/elasticsearch.repo state=absent" linux_group -kK
# On the local host
ansible localhost -m uri -a "http://localhost:80 status_code=200"
```

### Misc

Use *192.168.1.20* as proxyjump/bastion host for *my_host*:
```
my_host:
  ansible_ssh_common_args: -o ProxyCommand="ssh -W %h:%p -q 192.168.1.20"

# NOTE: Don't use a username in your SSH command! (e.g. -o ProxyCommand="ssh -W %h:%p -q ansible@192.168.1.20")
```

> Tags attached to `import_tasks` statements will run every task inside the taskfile being imported, but tags attached
>   to `include_task` statements WILL NOT run every task. You must tag every individual task within the taskfile being
>   imported by the `include_task` statement to run them. This is called tag inheritance. In other words, tag inheritance
>   works on static `import` statements, but NOT on dynamic `include` statements. See
>   [this](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html#adding-tags-to-imports) link for
>   more info.

- `ansible-doc -F`                                 = List all available modules.
- `ansible-doc -l -t become/cache/callback/cliconf/connection/httpapi/inventory/lookup/netconf/shell/vars/strategy` = List available plugins of a given type.
<br><br>
- `ansible-playbook --syntax-check ./playbook.yml` = Check syntax.
- `ansible-lint ./playbook.yml`                    = Check best-practices.

---
## Ansible with Windows Targets

### [Windows OpenSSH](https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#windows-ssh-setup)

- [Install OpenSSH on Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell#install-openssh-for-windows)
  ```powershell
  Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
  Start-Service sshd
  Set-Service -Name sshd -StartupType 'Automatic'
  netstat -a
  ```

### Kerberos

#### HTTPS transport encryption
- Run [this script](https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1) on the
  WinRM server to attach a self-signed certificate to the HTTPS WinRM listener.
- Set `ansible_winrm_server_cert_validation: ignore` on the Ansible controller.

#### Troubleshooting
```
fatal: [apgrw4fhaat1t01]: UNREACHABLE! => changed=false
msg: 'kerberos: Bad HTTP response returned from server. Code 500'
unreachable: true
```
- This means Kerberos is not allowed to connect over HTTP.
  - Either set `AllowUnencrypted` to *True* on the WinRM server,
  - Or `ansible_winrm_port: 5986` on the Ansible controller to connect over HTTPS.

---
## [Molecule](https://molecule.readthedocs.io/en/latest/)

- `molecule converge -- -v --diff` = Run Molecule, pass *-v* and *--diff* to Ansible.
- `molecule login -h ubuntu-host -s main` = Login to *ubuntu-host* using the *main* scenario.

Example *molecule.yml* (create a new scenario with *molecule init*):
```yaml
dependency:
  name: galaxy
driver:
  name: vagrant
  provider:
    name: virtualbox
platforms:
  # - name: freebsd-host
  #   box: generic/freebsd12
  #   memory: 2048
  #   cpus: 2
  - name: ubuntu-host
    box: ubuntu/groovy64
    memory: 2048
    cpus: 2
provisioner:
  name: ansible
  connection_options:
    ansible_ssh_user: vagrant
    ansible_ssh_common_args: -o StrictHostKeyChecking=no
  inventory:
    host_vars:
      ubuntu-host:
        hostname: ubuntu-host
        common_include_debian_tasks: true
        disable_suspend: true
      freebsd-host:
        hostname: freebsd-host
    group_vars:
      all:
        use_proxy: true
        proxy_url: http://10.0.0.15:8080
        interactive_account:
          username: alice
          comment: Alice
          home_dir: /home/alice
          pubkeys:
            - "{{ lookup('file', '../../keys/id_rsa.pub') }}"
        service_account:
          username: ansible
          comment: Service account
          home_dir: /var/lib/ansible
          pubkeys:
            - "{{ lookup('file', '../../keys/id_rsa.pub') }}"
verifier:
  name: ansible
```
