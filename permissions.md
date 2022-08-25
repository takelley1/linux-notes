## ACLs

- `setfacl –R –m u:alice:rw /photos` = Grant user *alice* read and write access to all files in */photos*, regardless of
                                       her POSIX permissions on those files.
  - `-R` = Recursive.
  - `-m` = Modify file or directory permissions.
<br><br>
- `getfacl /path/to/file.txt` = View ACL for given file.


---
## UMASK

> NOTE: Umask modifies the default permissions of created files and
>       directories to make them more restrictive.

- Directories example:
  - Default permissions for directories:    `777`
  - Umask of user that created directory:   `002`
  - New default permissions of directories: `775`
- Files example:
  - Default permissions for files:     `666`
  - Umask of user that created file:   `022`
  - New default permissions for files: `644`

> NOTE: Umask is permanently set in `/etc/profile` or `/etc/login.defs`.


---
## Users

- `usermod -U alice`              = Unlock user account *alice* (due to kernel locking user).
- `faillock --user alice --reset` = Unlock user account *alice* (due to *pam_faillock.so* locking user).
<br><br>
- `w`                 = Print recently logged-on user data.
- `last` or `lastlog` = View all users' last logins.
- `passwd -e alice`   = Expire password for user alice, prompting her for a password reset upon next login.
<br><br>
- `/etc/passwd` syntax = `uname:'x':uid:gid:comments:homedir:shell`
- `/etc/group` syntax  = `groupname:'x':groupid:userlist(user1,user2)`


---
## Groups

- `usermod -a -G wheel,group1 alice` = Add *alice* to *wheel* and *group1* groups.
- `usermod -G group1 alice`          = Remove *alice* from all groups except *group1*.
- `gpasswd -d alice wheel`           = Remove *alice* from group *wheel*.
<br><br>
- `id alice`    = Show what groups user *alice* is in, also show user ID and group IDs.
- `id -G wheel` = Show group ID of *wheel* group.


---
## Permissions

- `chown -R alice:admins /documents` = Change ownership of */documents* directory recursively to *alice* and the *admins* group.
- `chgrp wheel /home/alice` = Change group owner of the */home/alice* directory to *wheel*.

### Octal Permissions

- chmod octal permissions order --> | special | user (`u`) | group (`g`) | everyone else / other (`o`) |
<br><br>
- Regular permissions (user, group, other)
  - `4` = Read (`r`)
  - `2` = Write (`w`)
  - `1` = Execute (`x`)
  - `0` = None (`-`)
- Special permissions
  - `4` = Setuid - Appears as an `s` instead of `x` on the file owner bit (ex. `rwsr-xr-x`).
  - `2` = Setgid - Appears as an `s` instead of `x` on the group owner bit (ex. `rwxr-sr-x`).
  - `1` = Sticky bit - Appears as a `t` instead of `x` on the other bit (ex. `rwxr-xr-t`).
  - `0` = None (`-`)
- Examples:
  - `0755` = `rwxr-xr-x`
  - `400`  = `r--------`
  - `1777` = `rwxrwxrwt`
  - `4655` = `rwsr-xr-x`

> If 3 digits are given, 1st is owner, 2nd is group, 3rd is other (ex. `chmod 755`)
> If 4 digits are given, 1st is the special bit, 2nd is owner, 3rd is group, 4th is other (ex. chmod `0755`)

| Permission | Effect when applied to a binary file                                      | Effect when applied to a directory                              |
|------------|---------------------------------------------------------------------------|-----------------------------------------------------------------|
|setuid      | The user running the file temporarily becomes the file's owner            | N/A                                                             |
|setgid      | The user running the file temporarily becomes part of file's owning group | All new files beneath the directory inherit its group ownership |
|sticky bit\*| N/A                                                                       | User cannot delete a file in a directory unless they own the file or directory |
|read \(r\)  | The user can read the file's contents and metadata                        | The user can list the files within the directory, but cannot not read the files' metadata |
|write (w)   | The user can write to, rename, or delete the file (deletion requires write permission on parent dir) | The user can create, rename, or delete files within the directory or the directory itself |
|execute (e) | The user can run the file                                                 | The user can enter the directory, read file metadata, and access files and directories nested inside |

*\*The sticky bit is useful for negating deletion abilities in a directory. Normally a user who has execute and write
  permissions to a directory can also delete files in that directory, even if the user doesn't own any files in the
  directory.*

- Example: `chmod -R 6754 /var/log`
  - *Special*: (4+2=6) Run executables with permissions of the owning user and group.
  - *Owner*: Give read, write, and execute (`rwx`) (4+2+1=7) permission.
  - *Group*: Give read and write (`rx`) (4+1=5) permission.
  - *Other*: Give read (`r`) (4) permission.
  - Apply these permissions recursively (`-R`).
  - **Resulting permissions will display as `rwsr-srw-`**.

---
### Standard (non-octal) Permissions

- `chmod u+r file.txt`  = Add read permissions to user on file.txt
- `chmod a-rw file.txt` = Remove read/write permissions for all on file.txt
<br><br>
- `u` (*user*)  = Owning user.
- `g` (*group*) = Owning group.
- `o` (*other*) = Users not in the file's owning group.
- `a` (*all*)   = Everyone (user, group, and other).
