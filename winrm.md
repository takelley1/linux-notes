## [WinRM](https://learn.microsoft.com/en-us/windows/win32/winrm/portal)

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

### Troubleshooting

1. Is user part of the local `Remote Management Users` group? Run `lustmgr.msc` to check.
2. Is remote logon for this user allowed? Check the below GPO settings with `rsop.exe`:
```
Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment >
> Allow log on through Remote Desktop Services
> Deny log on through Remote Desktop Services
> Deny access to this computer from the network
```
3. Is the remote host trusted? `winrm set winrm/config/client '@{TrustedHosts="10.0.0.15"}'`
4. Is Basic Authentication allowed? `winrm set winrm/config/service/auth '@{Basic="true"}'`
5. Is encryption disabled? `winrm set winrm/config/service '@{AllowUnencrypted="true"}'`
6. Is the Windows Defender firewall disabled? Does it allow WinRM?
7. Does the HTTPS listener's certificate match the server's hostname?

### Query

- `winrm e winrm/config/listener` = Check if running, get ports.
- `winrm get winrm/config/service` = Show authentication settings.

### Configure

- `winrm set winrm/config/client '@{TrustedHosts="10.0.0.15"}'` = Allow *10.0.0.15* to connect to this host over WinRM.
- `winrm set winrm/config/client '@{TrustedHosts="*"}'` = Allow any host to connect to this host over WinRM.
<br><br>
- `winrm set winrm/config/service/auth '@{Basic="true"}'` =  Enable basic authentication on the WinRM service.
- `winrm set winrm/config/service '@{AllowUnencrypted="true"}'` = Allow transfer of unencrypted data on the WinRM service.
- `winrm set winrm/config/service/auth '@{CbtHardeningLevel="relaxed"}'` = Change challenge binding.
<br><br>
- `winrm delete winrm/config/listener?address=*+transport=https` = [Delete HTTPS listener.](https://www.nicovs.be/?p=399)

### WinRM Client

Test the connection to the WinRM service:
```bat
winrm identify -r:http://<IP_OR_HOSTNAME>:5985 -auth:basic -u:<USERNAME> -p:<PASSWORD> -encoding:utf-8
```
- `winrm set winrm/config/client/auth '@{Basic="true"}'` = Enable basic authentication.
- `winrm set winrm/config/client '@{AllowUnencrypted="true"}'` = Enable basic authentication.
