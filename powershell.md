
## WinRM

- **See Also**:
  - [Windows setup for Ansible](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)
  - [WinRM HTTP config](https://docs.vmware.com/en/vRealize-Automation/7.5/com.vmware.vrealize.orchestrator-use-plugins.doc/GUID-D4ACA4EF-D018-448A-866A-DECDDA5CC3C1.html)
  - [WinRM listener config](https://stackoverflow.com/questions/17281224/configure-and-listen-successfully-using-winrm-in-powershell)
  - [Allow WinRM with GPOs](https://www.pcwdld.com/winrm-quickconfig-remotely-configure-and-enable)
  - [WinRM authentication](https://docs.microsoft.com/en-us/windows/win32/winrm/authentication-for-remote-connections)

### Server

- The default ports are 5985 for HTTP, and 5986 for HTTPS.

GPO and Regkey locations:
```
Computer Configuration > Policies > Administrative Templates: Policy definitions > Windows Components > Windows Remote Management (WinRM) > WinRM Service
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy
```
- `winrm set winrm/config/client ‘@{TrustedHosts="10.0.0.15"}’` = Set trusted hosts.
- `winrm e winrm/config/listener` = Check if running, get ports.
<br><br>
- `winrm set winrm/config/service/auth @{Basic="true"}` =  Enable basic authentication on the WinRM service.
- `winrm set winrm/config/service @{AllowUnencrypted="true"}` = Allow transfer of unencrypted data on the WinRM service.
- `winrm set winrm/config/service/auth @{CbtHardeningLevel="relaxed"}` = Change challenge binding.

### Client

Test the connection to the WinRM service:
```
winrm identify -r:http://winrm_server:5985 -auth:basic -u:user_name -p:password -encoding:utf-8
```
- `winrm set winrm/config/client/auth @{Basic="true"}` = Enable basic authentication.
- `winrm set winrm/config/client @{AllowUnencrypted="true"}` = Enable basic authentication.


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


## Networking

`netstat -np` = View open ports.


## Certificates

`certreq -submit -attrib "CertificateTemplate:WebServer" request.csr` = Import and sign *request.csr* using the 
                                                                        *WebServer* template.

`certlm.msc`  = Local computer certificates.
`certmgr.msc` = Current user certificates.


## Extra features (Windows 10)

Install or remove RSAT tools: <sup>1</sup>
```powershell
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
Add-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
Remove-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
```

[1]: https://www.petri.com/how-to-install-the-remote-server-administration-tools-in-windows-10
