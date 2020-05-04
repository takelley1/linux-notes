# POWERSHELL

`netstat -np` = View open ports.

`certreq -submit -attrib "CertificateTemplate:WebServer" request.csr` = Import and sign *request.csr* using the *WebServer* template.

## Windows 10

Install or remove RSAT tools. <sup>1</sup>
```powershell
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
Add-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
Remove-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
```

[1]: https://www.petri.com/how-to-install-the-remote-server-administration-tools-in-windows-10
