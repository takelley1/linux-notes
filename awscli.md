# AWS CLI

## [Installation on Windows (no Admin rights)](https://github.com/aws/aws-cli/issues/4633)

1. Open the Windows CLI and run:
```
msiexec /a https://awscli.amazonaws.com/AWSCLIV2.msi /qb TARGETDIR=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps
```
2. Open `%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\Amazon\AWSCLIV2` in the explorer
3. Copy the contents of `%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\Amazon\AWSCLIV2\*` to `%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\`
4. Test out AWS CLI:
```
aws --version
```
