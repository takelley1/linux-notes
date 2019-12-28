
## CERTIFICATES

generate self-signed cert
```
certtool --generate-privkey --outfile key.pem
certtool --generate-self-signed --load-privkey key.pem --outfile cert.pem
```

---
## FIPS

`cat /proc/sys/crypto/fips_enabled` = check if fips is enabled 

---
## GPG

#### key pair signing
1. Create key pair on server  
`gpg -gen-key`
2. Export binary public key to ascii scring  
`gpg -export -a "pubkey.pub" > public.key`
3. Import public key on client  
`gpg -import public.key`
4. sign file with private key on server  
`gpg -detatch-sign file.txt`
5. verify file on client with public key  
`gpg -verify signed-file.txt file.txt`

---
## PAM

`authconfig --disablesssdauth --update` = remove pam sssd module

#### /etc/pam.d/ syntax

---
## SELINUX

`semanage port –a –t ssh_port_t tcp 9999` = set ssh context to allow use of port 9999

selinux context syntax: `user:role:type:level`  
`ls -Z` = view selinux contexts

`chcon -R [context] file.txt` = change selinux context  
`-R`                          = recursive

`sestatus -v` = display general selinux config  
`-v`          = verbose

`setenforce 1` = enable selinux enforcement (`1` for on, `0` for off)  
`fixfiles`     = check security context database

`restorecon -F ./file.txt` = restore selinux context to specified file or directory  
`-F`                       = force

`getsebool`                              = get selinux boolean values  
`setsebool`                              = toggle selinux boolean values  
`setsebool httpd_can_network_connect on` = allow outside directory access to httpd

---
#### `audit2allow` command [1]

`audit2allow -w -a` or `audit2why -a` = generate a list of policies triggering selinux denials  
`audit2allow -a -M [policy]` = create an selinux module that would fix the current policy denial (see below)

`semodule -l` = list all current selinux modules

``` [1]
~]# audit2allow -w -a

type=AVC msg=audit(1226270358.848:238): avc:  denied  { write }
for pid=13349 comm="certwatch" name="cache" dev=dm-0 ino=218171
scontext=system_u:system_r:certwatch_t:s0
tcontext=system_u:object_r:var_t:s0 tclass=dir
	Was caused by:
		Missing type enforcement (TE) allow rule.

	You can use audit2allow to generate a loadable module to
  allow this access.
```  
```
~]# audit2allow -a -M mycertwatch

******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i mycertwatch.pp
```

selinux denial log example in `/var/log/messages`:
```
Dec 16 16:28:22 [hostname] kernel: type=1400 audit(1576531702.010:97659712): avc:  denied  { getattr }
for pid=28583 comm="pidof" path="/usr/bin/su" dev="dm-0" ino=50444389
scontext=system_u:system_r:keepalived_t:s0 tcontext=system_u:object_r:su_exec_t:s0 tclass=file permissive=0
```

[1] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-fixing_problems-allowing_access_audit2allow

