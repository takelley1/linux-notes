
## Contexts

Context syntax: `user:role:type:level`
- `ls -Z` = View contexts of files in directory.
<br><br>
- `chcon -R <CONTEXT> file.txt` = Change context of file.txt.
  - `-R` = Recursive.
<br><br>
- `restorecon -F file.txt` = Restore context to specified file or directory.
  - `-F` = Force.

## Ports

- `semanage port –a –t ssh_port_t tcp 9999` = Set ssh context to allow use of port 9999.

## Config

- `sestatus -v` = Display general config.
  - `-v` = Verbose.
<br><br>
- `setenforce 1` = Enable SELinux enforcement, *1* for on, *0* for off.
- `fixfiles`     = Check security context database.
<br><br>
- `getsebool`                              = Get boolean values.
- `setsebool`                              = Toggle boolean values.
- `setsebool httpd_can_network_connect on` = Allow outside directory access to httpd.
<br><br>
- `aureport -a` = Summarize audit logs and show failures.

## Troubleshooting <sup>[1]</sup>

- `audit2allow -w -a` or `audit2why -a` = Generate a list of policies triggering SELinux denials.
- `audit2allow -a -M <POLICY>` = Create an SELinux module that would fix the current policy denial (see below).
<br><br>
- `semodule -l` = List all current SELinux modules.

```
# audit2allow -w -a

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
# audit2allow -a -M mycertwatch

******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i mycertwatch.pp
```

SELinux denial log example in */var/log/messages*: <sup>[1]</sup>
```
Dec 16 16:28:22 [hostname] kernel: type=1400 audit(1576531702.010:97659712): avc:
denied  { getattr } for pid=28583 comm="pidof" path="/usr/bin/su" dev="dm-0" ino=50444389.
scontext=system_u:system_r:keepalived_t:s0 tcontext=system_u:object_r:su_exec_t:s0
tclass=file permissive=0
```

[1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-fixing_problems-allowing_access_audit2allow
