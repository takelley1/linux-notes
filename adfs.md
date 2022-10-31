### [AD FS](https://learn.microsoft.com/en-us/windows-server/identity/active-directory-federation-services)

- Add server to AD FS farm:
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
