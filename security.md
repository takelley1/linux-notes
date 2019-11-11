## FIPS

`cat /proc/sys/crypto/fips_enabled` = check if FIPS is enabled 


## GPG

#### key pair signing
1. Create key pair on server `gpg -gen-key`
2. Export public key `gpg -export -a "pubkey.pub" > public.key` = export the binary key `pubkey.pub` to the ascii string called `public.key`
3. Import public key on client `gpg -import public.key`
4. sign file with private key on server `gpg -detatch-sign file.txt`
5. verify file on client with public key `gpg -verify signed-file.txt file.txt`


## PAM

`authconfig --disablesssdauth --update` = remove pam sssd module


## SELINUX 

`semanage port –a –t ssh_port_t tcp 9999` = set ssh context to allow use of port 9999 \
`ls -Z` = view selinux contexts

`chcon -R [context] file.txt` = change selinux context 

selinux contexts syntax: SELinux `user:role:type:level`

`sestatus -v` = display general selinux config, verbose (`-v`) \
`setenforce 1` = enable selinux enforcement (`1` for on, `0` for off)

`restorecon -F /file.txt` = forcibly (`-F`) restore selinux content to specified file or directory \
`fixfiles` = check security context database

`getsebool` = get selinux boolean values \
`setsebool` = toggle selinux boolean values

`setsebool httpd_can_network_connect on` = allow outside directory access to httpd 
