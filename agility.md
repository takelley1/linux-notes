# [Digital.ai Agility](https://docs.digital.ai/bundle/agility-onlinehelp/page/Content/Digital.ai_Agility/Digital.ai_Agility.htm)

- [Agility downloads page](https://docs.digital.ai/bundle/agility-onlinehelp/page/Content/Digital.ai_Agility_Release_Notes/Release-Notes-and-Downloads.htm)
- [Agility latest download](https://go.versionone.com/GetLatestUltimate)
<br><br>
- [SSO](https://docs.digital.ai/bundle/agility-onlinehelp/page/Content/Digital.ai_Agility/On-Premise_Single_Sign-On.htm)
  - [SSO for SaaS](https://docs.digital.ai/bundle/agility-onlinehelp/page/Content/Digital.ai_Agility/How_to_start_the_SSO_(Single_Sign-On)_Process_for_Hosted_Customers_(SaaS).htm)
- [SAML](https://docs.digital.ai/bundle/agility-onlinehelp/page/Content/DeveloperLibrary/SAML_SSO_Overview.htm)
<br><br>
- [OIDC for keycloak on digital.ai release](https://docs.digital.ai/bundle/devops-release-version-v.22.0/page/release/concept/release-oidc-with-keycloak.html)

## Logs

- Analytics: `C:\ProgramData\VersionOne\Analytics\setup.log`
- DataMart: `C:\ProgramData\VersionOne\DatamartLoader\setup.log`
- General exceptions: `C:\ProgramData\VersionOne\Exceptions`

## License updates

1. RDP onto Agility server.
2. Go to `C:\inetpub\wwwroot\Agility\bin`.
3. Replace the `.lic` file.
4. Restarting server isn't necessary. New license will be used automatically.

## Upgrades

1. Obtain an updated Agility license file. A new license file must be obtained during any major version bump.
2. Post notification alerting users that service may be down.
3. Snapshot the Agility instance.
4. Snapshot the Agility database (versionone).
5. RDP onto Agility server.
6. [Download the latest Agility release.](https://go.versionone.com/GetLatestUltimate)
7. Disable Shibboleth Service Provider.
   - Edit the file in `C:\opt\shibboleth-sp\etc\shibboleth\shibboleth2.xml` and disable Shibboleth on the RequestMapper paths (around line #70).
   - Set `RequireSession` to `false` and then restart Shibboleth (`shibd_Default` in Windows Services):
     ```xml
     <Path name="Agility" authType="shibboleth" requireSession="false">
     ```
   - This is done to allow a regular login page to be presented at example.domain.com/Agility so the Analytics Service can install correctly. Otherwise Shibboleth will attempt to redirect to the authentication service and prevent Analytics from installing correctly.
   - Also see [Shibboleth RequestMatter docs](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335006/HowToRequestMap)
8. Follow the installation guide PDF in the downloaded release archive.
   - NOTE: Upgrade order is `Agility`, then `DataMart`, then `Analytics`
   - NOTE: The new Agility license goes in `C:\inetpub\wwwroot\Agility\bin\license.lic`
   - Requires:
     - DB password
     - DB username
     - Integration code
9. Re-enable Shibboleth Service Provider.
   - Edit the file in `C:\opt\shibboleth-sp\etc\shibboleth\shibboleth2.xml` and enable Shibboleth on the RequestMapper paths.
   - Set `RequireSession` to `true` and then restart Shibboleth (`shibd_Default` in Windows Services):
     ```xml
     <Path name="Agility" authType="shibboleth" requireSession="true">
     ```
10. Test service connectivity.
<br><br>
TROUBLESHOOTING
- In the IIS manager, ensure Agility is running under `Application Pools` (start it if stopped)
- Restart IIS with cmd.exe: `iisreset /restart`
- Restart Shibboleth daemon shibd.exe from services
