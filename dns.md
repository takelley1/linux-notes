# DNS

## Recursive resolution

For test.dev.example.com:
- Your client asks a Root server `.` where `test.dev.example.com` is. The Root server's IP is hardcoded. 
- Root (`.`): "I don't have that A record, but here are the nameservers responsible for `.com`."
- `.com` nameserver: "Here are the nameservers responsible for `example.com`."
- `example.com` nameserver: "I have the A record for `test.dev.example.com`. Its IP is `192.0.2.30`."
```
Client
  | Query: test.dev.example.com?
  v
Recursive DNS Resolver
  |
  v
Root DNS Server (.)
  | "Ask the .com nameservers" (returns an NS record for the .com server)
  v
.com Nameserver
  | "Ask the example.com nameservers" (returns an NS record for the example.com server)
  v
example.com Nameserver
  | "test.dev.example.com = 192.0.2.30"
  v
Recursive DNS Resolver
  | Returns A record: 192.0.2.30
  v
Client
```
