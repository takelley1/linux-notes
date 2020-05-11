
**`faillock --user alice --reset` = Unlock user**

## ACLs 

grant user alice read and write access to all files in `/photos`, regardless of alice's POSIX permissions on those files
```bash
setfacl –R –m u:alice:rw /photos
```
`-R` = Recursive.  
`-m` = Modify file or directory permissions.  

`getfacl /file.txt` = View ACL for given file.  


---
## UMASK 

> NOTE: umask modifies the default permissions of created files and directories to make them more restrictive 

### directories 

example:
default permissions for directories:    `777`  
umask of user that created directory:   `002` (example)  
new default permissions of directories: `775`

### files 

default permissions for files:     `666`  
umask of user that created file:   `022` (example)  
new default permissions for files: `644`

> NOTE: umask is permanently set in `/etc/profile` or `/etc/login.defs`


---
## USERS 

`usermod -U alice`              = Unlock user account alice (due to kernel locking user)  
`faillock --user alice --reset` = Unlock user account alice (due to pam_faillock.so locking user)

`w`               = Print recently logged-on user data  
`last`            = View all users' last logins  
`passwd -e alice` = Expire password for user alice, prompting her for a password reset upon next login 

`/etc/passwd` syntax = `uname:'x':uid:gid:comments:homedir:shell`  
`/etc/group` syntax  = `groupname:'x':groupid:userlist(user1,user2)`


---
## GROUPS

`usermod -a -G wheel,group1 alice` = Add alice to wheel and group1 groups   
`usermod -G group1 alice`          = Remove alice from all groups except group 1  
`gpasswd -d alice wheel`           = Delete alice from group wheel

`id alice`    = Show what groups user alice is in, and show uid and gids  
`id -G wheel` = Show gid of wheel group


---
## PERMISSIONS

`chown -R alice:admins /home/Documents` = Change ownership of Documents directory recursively (`-R`) to alice and the admins group  
`chgrp wheel /home/alice` = Change group owner of the /home/alice directory to wheel 

### octal 

chmod octal permissions order --> | special | user (`u`) | group (`g`) | everyone else (`o`) |

regular permissions:  
`4` = Read (`r`)  
`2` = Write (`w`)  
`1` = Execute (`x`)  
`0` = None (`-`)

special permissions only:  
`4` = Setuid - appears as an `s` instead of `x` for the file owner (ex. `rwsrwxrwx`)  
`2` = Setgid - appears as an `s` instead of `x` for the group owner (ex. `rwxrwsrwx`)  
`1` = Sticky bit - appears as a `t` instead of `x` for 'other' (ex. `rwxrwxrwt`)  
`0` = None (`-`)

examples:  
`0755` = `rwxr-xr-x`  
`400`  = `r--------`  
`1777` = `rwxrwxrwt`  
`4655` = `rwsr-xr-x`

> If 3 digits are given, 1st is owner, 2nd is group, 3rd is other (ex. `chmod 755`)  
> If 4 digits are given, 1st is the special bit, 2nd is owner, 3rd is group, 4th is other (ex. chmod `0755`)


| permission | Effect when applied to a binary file                           | Effect when applied to a directory |
|------------|----------------------------------------------------------------|------------------------------------|
|setuid      | the user running the file temporarily becomes the file's owner | N/A                                |
|setgid      | the user running the file temporarily becomes a member of file's owning group | causes all new files beneath that directory to inherit its group ownership |
|sticky bit\* | N/A | prevents a user from deleting a file in a directory unless they own the file or directory |

*\*The sticky bit is useful for negating deletion abilities in a directory, as normally a user who has execute and write permissions to a directory can also delete files within that directory, even if the user doesn't own the files.*


example:  
`chmod -R 6754 /var/log` = 
-(4+2=6, special bit) run executables with permissions of the owning user and group 
-give read, write, and execute (`rwx`) (4+2+1=7) permissions to owner
-give read and write (`rx`) (4+1=5) to members of the owning group
-give read (`r`) (4) permissions to everyone else (aka “all”)
-apply these permissions recursively (`-R`)
- **permissions of `/var/log` will display as: `rwsr-srw-`**

---
### standard (non-octal) 

`chmod u+r file.txt`  = Add read permissions to user on file.txt
`chmod a-rw file.txt` = Remove read/write permissions for all on file.txt 

`u` (*user*)  = Owning user  
`g` (*group*) = Owning group  
`o` (*other*) = Users not in the file's owning group  
`a` (*all*)   = Everyone, including the owning user and group

