# POWERSHELL


## AD FS

Add server to AD FS farm:
```powershell
Import-Module ADFS

# Get the credential used for performaing installation/configuration of ADFS
$installationCredential = Get-Credential -Message "Enter the credential for the account used to perform the configuration."

# Get the credential used for the federation service account
$serviceAccountCredential = Get-Credential -Message "Enter the credential for the Federation Service Account."

Add-AdfsFarmNode -CertificateThumbprint:"<CERTIFICATE THUMBPRINT>" -Credential:$installationCredential -OverwriteConfiguration:$true -PrimaryComputerName:"<SERVER HOSTNAME>" -ServiceAccountCredential:$serviceAccountCredential
```


## Networking

`netstat -np` = View open ports.


## Certificates

`certreq -submit -attrib "CertificateTemplate:WebServer" request.csr` = Import and sign *request.csr* using the *WebServer* template.

`certlm.msc`  = Local computer certificates.
`certmgr.msc` = Current user certificates.


## Extra features (Windows 10)

Install or remove RSAT tools. <sup>1</sup>
```powershell
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
Add-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
Remove-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
```

[1]: https://www.petri.com/how-to-install-the-remote-server-administration-tools-in-windows-10
