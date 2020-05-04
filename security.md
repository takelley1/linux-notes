# SECURITY

## CERTIFICATES

Generate generic CSR:
```bash
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
```

Generate self-signed cert:
```bash
certtool --generate-privkey --outfile key.pem
certtool --generate-self-signed --load-privkey key.pem --outfile cert.pem
```

Add private key to certificate. This allows the cert and private key to be imported into Windows: <sup>[5]</sup> 
```bash
openssl pkcs12 -export -out cert.pfx -inkey private.key -in cert.crt -certfile CACert.crt
```


Convert *.pem* to *.crt*:
```bash
openssl x509 -outform der -in cert.pem -out cert.crt
```

Generate CSR with Subject Alternate Names: (See ./certgen.sh for script)

```bash
bash ./certgen.sh domain.example.com 'DNS:*.domain.example.com,IP:10.0.0.10'
```


---
## FIPS

`cat /proc/sys/crypto/fips_enabled` = check if fips is enabled.   

---
## GPG

**see also**: [The GNU Privacy Handbook](https://www.gnupg.org/gph/en/manual/book1.html), [Backing up private keys on paper 1](https://wiki.archlinux.org/index.php/Paperkey), [2](https://www.jabberwocky.com/software/paperkey/), [3](https://www.saminiir.com/paper-storage-and-recovery-of-gpg-keys/)  

### digitally sign and verify a file

(assumes recipient does not yet have sender's public key)  
on sender:  
1. `gpg --gen-key`                                  = create public and private key pair.  
1. `gpg --output file.sig --detatch-sign file.txt`  = sign file.txt with private key, producing the signature file file.sig.  
1. `gpg --export --armor "pubkey.gpg" > public.asc` = export binary public key to ASCII-encoded string.  
1. transfer `file.sig`, `file.txt`, and `public.asc` to recipient

on recipient:  
1. `gpg --import public.asc`                        = import sender's public key.  
1. `gpg --verify file.sig file.txt`                 = verify the file.sig signature of file.txt using sender's public key.  

### asymetrically encrypt/decrypt and sign a file

#### on sender:  

1. encrpyt file.txt using receiver's public key (assuming it's in the gpg keychain), then sign file.txt using your private key
   ```bash
   gpg --encrypt --sign --armor --recipient receiver@gmail.com file.txt
   ```
1. this produces the encrypted and signed file `file.txt.asc`

#### on receiver: <sup>[3], [4]</sup> 

1. decrypt file.txt using receiver's private key and verify sender's signature
   ```bash
   gpg --decrypt file.txt.asc > file.txt
   ```


### symmetrically encrypt/decrypt a file <sup>[2]</sup> 

1. encrypt file.txt into file.gpg using a password that must be provided  
   ```bash
   gpg --output file.gpg --symmetric file.txt
   ```
1. decrypt file.gpg into file.txt using the same password used to encrypt file.txt
   ```bash
   gpg --decrypt file.gpg
   ```


---
## PAM

`authconfig --disablesssdauth --update` = remove pam sssd module.  

#### /etc/pam.d/ syntax

TODO: fill out this section


---
## SELINUX

`semanage port –a –t ssh_port_t tcp 9999` = set ssh context to allow use of port 9999.  

selinux context syntax: `user:role:type:level`  
`ls -Z` = view selinux contexts.  

`chcon -R [context] file.txt` = change selinux context.    
                         `-R` = recursive.  

`sestatus -v` = display general selinux config.    
         `-v` = verbose.  

`setenforce 1` = enable selinux enforcement (`1` for on, `0` for off.  )  
`fixfiles`     = check security context database.  

`restorecon -F ./file.txt` = restore selinux context to specified file or directory.    
                      `-F` = force.  

`getsebool`                              = get selinux boolean values.    
`setsebool`                              = toggle selinux boolean values.    
`setsebool httpd_can_network_connect on` = allow outside directory access to httpd.    

`aureport -a` = summarize audit logs and show failures.  

---
#### `audit2allow` command <sup>[1]</sup>  

`audit2allow -w -a` or `audit2why -a` = generate a list of policies triggering selinux denials.    
`audit2allow -a -M [policy]` = create an selinux module that would fix the current policy denial (see below.  )

`semodule -l` = list all current selinux modules.  

```
~]# audit2allow -w -a

type=AVC msg=audit(1226270358.848:238): avc:  denied  { write.   }
for pid=13349 comm="certwatch" name="cache" dev=dm-0 ino=218171.  
scontext=system_u:system_r:certwatch_t:s0.  
tcontext=system_u:object_r:var_t:s0 tclass=dir.  
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

selinux denial log example in `/var/log/messages`: <sup>[1]</sup>  
```
Dec 16 16:28:22 [hostname] kernel: type=1400 audit(1576531702.010:97659712): avc:  denied  { getattr.   }
for pid=28583 comm="pidof" path="/usr/bin/su" dev="dm-0" ino=50444389.  
scontext=system_u:system_r:keepalived_t:s0 tcontext=system_u:object_r:su_exec_t:s0 tclass=file permissive=0.  
```

[1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-fixing_problems-allowing_access_audit2allow  
[2]: https://stackoverflow.com/questions/36393922/how-to-decrypt-a-symmetrically-encrypted-openpgp-message-using-php  
[3]: https://www.networkworld.com/article/3293052/encypting-your-files-with-gpg.html  
[4]: https://www.howtogeek.com/427982/how-to-encrypt-and-decrypt-files-with-gpg-on-linux/  
[5]: https://security.stackexchange.com/questions/25996/how-to-import-a-private-key-in-windows

