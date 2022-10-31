## [WSUS](https://learn.microsoft.com/en-us/windows-server/administration/windows-server-update-services/get-started/windows-server-update-services-wsus)

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
