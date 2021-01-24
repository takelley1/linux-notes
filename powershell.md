
## WSUS

### [Troubleshooting](https://community.spiceworks.com/topic/2194028-windows-update-error-0x80244022)
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
## Robocopy

- **See Also**:
  - [Robocopy over network](https://klyavlin.wordpress.com/2012/09/19/robocopy-network-usernamepassword/)

`NET USE \\<SHARE IP>\<SHARE PATH> /u:server\<USERNAME> <PASSWORD>` = Mount network drive for Robocopy to use.


---
## WinRM

- **See Also**:
  - [Windows setup for Ansible](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)
  - [WinRM HTTP config](https://docs.vmware.com/en/vRealize-Automation/7.5/com.vmware.vrealize.orchestrator-use-plugins.doc/GUID-D4ACA4EF-D018-448A-866A-DECDDA5CC3C1.html)
  - [WinRM listener config](https://stackoverflow.com/questions/17281224/configure-and-listen-successfully-using-winrm-in-powershell)
  - [Allow WinRM with GPOs](https://www.pcwdld.com/winrm-quickconfig-remotely-configure-and-enable)
  - [WinRM authentication](https://docs.microsoft.com/en-us/windows/win32/winrm/authentication-for-remote-connections)

### WinRM Server

- The default ports are 5985 for HTTP, and 5986 for HTTPS.

GPO and Regkey locations:
```
Computer Configuration > Administrative Templates > Windows Components > Windows Remote Management (WinRM)

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy
```

#### Troubleshooting
1. Is user part of the local `Remote Management Users` group? Run `lustmgr.msc` to check.
2. Is remote logon for this user allowed? Check GPO with `rsop.exe`:
```
Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment >
> Allow log on through Remote Desktop Services
> Deny log on through Remote Desktop Services
```
3. Is the remote host trusted? `winrm set winrm/config/client '@{TrustedHosts="10.0.0.15"}'`
4. Is Basic Authentication allowed? `winrm set winrm/config/service/auth '@{Basic="true"}'`
5. Is encryption disabled? `winrm set winrm/config/service '@{AllowUnencrypted="true"}'`
6. Is the Windows Defender firewall disabled? Does it allow WinRM?

#### Query
- `winrm e winrm/config/listener` = Check if running, get ports.
- `winrm get winrm/config/service` = Show authentication settings.

#### Configure
- `winrm set winrm/config/client '@{TrustedHosts="10.0.0.15"}'` = Allow *10.0.0.15* to connect to this host over WinRM.
- `winrm set winrm/config/client '@{TrustedHosts="*"}'` = Allow any host to connect to this host over WinRM.
<br><br>
- `winrm set winrm/config/service/auth '@{Basic="true"}'` =  Enable basic authentication on the WinRM service.
- `winrm set winrm/config/service '@{AllowUnencrypted="true"}'` = Allow transfer of unencrypted data on the WinRM service.
- `winrm set winrm/config/service/auth '@{CbtHardeningLevel="relaxed"}'` = Change challenge binding.

### WinRM Client

Test the connection to the WinRM service:
```bat
winrm identify -r:http://<IP_OR_HOSTNAME>:5985 -auth:basic -u:<USERNAME> -p:<PASSWORD> -encoding:utf-8
```
- `winrm set winrm/config/client/auth '@{Basic="true"}'` = Enable basic authentication.
- `winrm set winrm/config/client '@{AllowUnencrypted="true"}'` = Enable basic authentication.


---
## AD FS

Add server to AD FS farm:
```powershell
Import-Module ADFS

# Get the credential used for performaing installation/configuration of ADFS.
$installationCredential = Get-Credential -Message "Enter the credential for the account used to perform the configuration."

# Get the credential used for the federation service account.
$serviceAccountCredential = Get-Credential -Message "Enter the credential for the Federation Service Account."

Add-AdfsFarmNode \
      -CertificateThumbprint:"<CERTIFICATE THUMBPRINT>" \
      -Credential:$installationCredential \
      -OverwriteConfiguration:$true \
      -PrimaryComputerName:"<SERVER HOSTNAME>" \
      -ServiceAccountCredential:$serviceAccountCredential
```


---
## MISC

### Extra features (Windows 10)

[Install or remove RSAT tools:](https://www.petri.com/how-to-install-the-remote-server-administration-tools-in-windows-10)
```powershell
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
Add-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
Remove-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
```

- `netstat -np` = View open ports.
