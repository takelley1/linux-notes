## PowerShell

### WSUS

#### [Troubleshooting](https://community.spiceworks.com/topic/2194028-windows-update-error-0x80244022)
```
And for testing,

Try to download the WSUS iuident CAB file from the client machine.

http://server.domain.local:8530/selfupdate/iuident.cab
https://server.domain.local:8531/selfupdate/iuident.cab

and then try to browse to:

http://server.domain.local:8530/ClientWebService/client.asmx
https://server.domain.local:8531/ClientWebService/client.asmx

If you can download it and browse to it, that's the port/url to use in your GPO.
If you can't, check firewall settings and port settings.
```


---
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
