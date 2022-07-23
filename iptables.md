## IPTABLES

- **See also:**
  - [iptables guide](https://phoenixnap.com/kb/iptables-tutorial-linux-firewall)

> [NOTE: `iptables` has been deprecated in favor of `nftables`](https://wiki.debian.org/nftables)

```
Tables: Tables are files that join similar actions. A table consists of several chains.
Chains: A chain is a string of rules. When a packet is received, iptables finds the appropriate table, then runs it through
        the chain of rules until it finds a match.
Rules: A rule is a statement that tells the system what to do with a packet. Rules can block one type of packet, or forward
       another type of packet. The outcome, where a packet is sent, is called a target.
Targets: A target is a decision of what to do with a packet. Typically, this is to accept it, drop it, or reject it (which
         sends an error back to the sender).
```

`iptables -A <CHAIN> -i <INTERFACE> -p <TCP/UDP> -s <SOURCE> --dport <DEST_PORT> -j <TARGET>`

- `iptables -L -v` = Show firewall ruleset (-L) with traffic on each chain (-v).
- `iptables-save` = Save current ruleset (unsaved changes are flushed upon reboot).
- `iptables -D INPUT 3` = Delete rule *3* from the *INPUT* chain (use `iptables -L --line-numbers` to get rule numbers).
- `iptables -F` = Delete all rules (*flush*).
<br><br>
- `iptables -A INPUT -p tcp --dport 22 -j ACCEPT` = Accept packets to port *22*.
- `iptables -A INPUT -s 192.168.1.3 -j ACCEPT` = Accept packets from *192.168.1.3*.
- `iptables -A INPUT -m iprange --src-range 192.168.1.100-192.168.1.200 -j DROP` = Drop all packets from *192.168.1.100-200*.
- `iptables -A INPUT -j DROP` = Drop all other traffic.

Add new rule to allow port 80 traffic on interface eth0 both to and from host:
```bash
iptables -A INPUT -i eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
iptables –A OUTPUT -o eth0 –p tcp --dport 80 –m state --state NEW,ESTABLISHED –j ACCEPT
```
