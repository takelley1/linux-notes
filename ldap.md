## LDAP

### `ldapsearch` command

`ldapsearch -LLL -x "(uid=john.doe)" '*' '+'` = Print all info for a specific UID.

```bash
ldapsearch \
      -LLL \
      -x \
      -w <PASSWORD> \
      -H ldaps://<SERVERNAME>.<DOMAIN> \
      -D "<AUTHENTICATING_USER>@<DOMAIN>" \
      "mail=<USER_EMAIL>"

ldapsearch -LLL -x -w CorrectHorseBatteryStaple -H ldaps://dc01.domain.example.com -D "jane.doe.sa@domain.example.com" "mail=jdoe@example.com"
```

### SSH Key Authentication

- For SSH-key-based LDAP authentication the below scriptlet is to be referenced in "/etc/ssh/sshd_config" at the line
  `AuthorizedKeysCommand`.
- The scriptlet attempts to authenticate users using a public key stored in the `comment` field of their LDAP user
  account attributes.

```bash
#!/usr/bin/env bash
USER="$(echo "$1" | cut -f 1 -d "@")"
PASS="$(cat </PATH/TO/PASSWORD/FILE>)"

ldapsearch -u \
           -LLL \
           -x \
           -w $PASS \
           -D "<SERVICE_ACCOUNT_NAME>@<DOMAIN>" \
           -H "ldaps://<DOMAIN_CONTROLLER_NAME>.<DOMAIN>" \
           '(sAMAccountName='"$USER"')' 'comment' | \
           sed -n '/^ /{H;d};/comment:/x;$g;s/\n *//g;s/comment: //gp'
```
