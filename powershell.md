## PowerShell


### Robocopy

- **See Also**:
  - [Robocopy over network](https://klyavlin.wordpress.com/2012/09/19/robocopy-network-usernamepassword/)

`NET USE \\<SHARE IP>\<SHARE PATH> /u:server\<USERNAME> <PASSWORD>` = Mount network drive for Robocopy to use.


---

---
### MISC

#### Extra features (Windows 10)

[Install or remove RSAT tools:](https://www.petri.com/how-to-install-the-remote-server-administration-tools-in-windows-10)
```powershell
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
Add-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 -Online
Remove-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 -Online
```

- `netstat -np` = View open ports.
- `repadmin /syncall /AdeP` = Force domain controllers to sync.
