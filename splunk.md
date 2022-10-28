## [Splunk](https://docs.splunk.com/Documentation)

### SSO w/ Keycloak

- See also: https://keycloak.discourse.group/t/using-keycloak-as-the-idp-for-spunk-via-saml/1583/3
- Issue: Keycloak returning 'invalid requester' error
  - Solution: Disable 'client signature required' field in the Splunk client configuration within Keycloak
- Issue: Keycloak authentication works successfully and redirects to Splunk, but Splunk returns a 'SAML response does
  not contain group information'
  - Solution: In Keycloak GUI -> Client Scopes -> role_list -> Mappers -> role list -> Change 'role attribute name' from
    'Role' to 'role'
- Issue: Keycloak returning 'invalid redirect uri' error
  - Solution: In Splunk GUI -> Settings -> Authentication Methods -> SAML Settings -> SAML Configuration -> Redirect to
    URL after logout, ensure value is "443" instead of "8000" if Splunk is behind a loadbalancer that redirects from
    443.

### Universal Forwarder Setup

```
export SPLUNK_HOME="/opt/splunkforwarder"
mkdir $SPLUNK_HOME
cd $SPLUNK_HOME
```
- Download and install
```
wget -O splunkforwarder-9.0.0-6818ac46f2ec-linux-2.6-x86_64.rpm "https://download.splunk.com/products/universalforwarder/releases/9.0.0/linux/splunkforwarder-9.0.0-6818ac46f2ec-linux-2.6-x86_64.rpm"
rpm -i ./splunkforwarder-9.0.0-6818ac46f2ec-linux-2.6-x86_64.rpm
```
- Run initial setup (test:password)
```
/opt/splunkforwarder/bin/splunk start --accept-license
```
- Stop daemon, then enable at boot
```
/opt/splunkforwarder/bin/splunk stop
/opt/splunkforwarder/bin/splunk enable boot-start
/opt/splunkforwarder/bin/splunk start
```
- Add a forwarder
```
/opt/splunkforwarder/bin/splunk add forward-server <IP>:<PORT>
```
- Begin monitoring a log file
```
/opt/splunkforwarder/bin/splunk add monitor /var/log/messages
```

Files for universal forwarder:
  - Target server: `/opt/splunkforwarder/etc/system/local/outputs.conf`
  - Files to monitor: `/opt/splunkforwarder/etc/apps/search/local/inputs.conf`

