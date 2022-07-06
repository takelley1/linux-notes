## Splunk

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

### Universal Forwarder setup

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

## Browser Header Manipulation (Firefox only)

1. F12 or right-click -> `Inspect`
2. Open `Network` tab
3. Request the desired URL in your browser
4. Click on the desired resource in browser's inspector
5. Click `Headers` tab in right side-bar
6. Click `Resend` -> `Edit and Resend`

## Fortify SSC

Installation
1. Install Java OpenJDK
2. Extract the Fortify SSC installation archive
3. Extract the `apache-tomcat-*.zip` in the Fortify SSC archive to `/opt`
4. Edit Tomcat's `conf/server.xml` file accordingly (see below)
5. Ensure Tomcat's `bin/*.sh` files are executable
6. Add `@reboot root bash -c /opt/tomcat/bin/startup.sh` to `/etc/crontab`
7. Start Tomcat
8. Copy the `ssc.war` file from the `Fortify_*_Server_WAR_Tomcat.zip` to Tomcat's `webapps/` directory
9. Wait for Tomcat to automatically extract the `ssc.war` file to `ssc/`
10. Ensure Tomcat's root path redirects to `/ssc`:
  - Ensure that `ROOT/index.jsp` has the below content:
  ```jsp
  <% response.sendRedirect("https://fortifydomain.example.com/ssc"); %>
  ```

SSO configuration
- Create local users in the Fortify Web GUI with usernames matching their email address in Keycloak
- Fortify server backend
  1. Create a self-signed cert with password-protected private key
  ```
  openssl req -x509 -sha256 -days 3650 -newkey rsa:4096 -keyout private_key.pem -out certificate.pem
  ```
  1. Export the certs to a pkcs12 bundle
  ```
  openssl pkcs12 -export -in certificate.pem -inkey private_key.pem -name saml > saml.p12
  ```
  1. Create a Java keystore with the cert bundle
  ```
  keytool -importkeystore -srckeystore saml.p12 -destkeystore store.keys -srcstoretype pkcs12 -alias SAML
  ```
- Fortify Web GUI
  ```
  Configuration -> SSO -> SAML:

  # Download the metadata from your IdP manually
  IDP metadata location: file:///opt/fortify_certs/keycloak-metadata.xml
  
  # This can be found in the IdP metadata
  default IDP: https://keycloak.example.com/realms/devops
  
  # The public URL of the Fortify instance
  SP entity ID: https://fortify.example.com/ssc/
  
  SP alias: fortify_ssc
  
  # Location of the Java keystore with the cert bundle. Preceed path with file://
  Keystore location: file:///opt/store.keys
  
  # Password of the Java keystore with the cert bundle
  Keystore password: ****************
  
  # Alias of the cert bundle you imported into the Java keystore
  Signing and encryption key: SAML
  
  # Password of the private key in the cert bundle
  Signing and encryption key password: ****************
  
  SAML name identifier: NameID
  ```
- Keycloak web GUI
  - Go to `https://fortify.example.com/ssc/saml/metadata` to download metadata file
  - Import metadata file into Keycloak as a client configuration

Disabling SSO from the backend
1. Login to Fortify's database
2. `use fortify;`
3. `select * from configproperty where propertyName = 'saml.enabled'`
4. `update configproperty set propertyValue = 'false' where propertyName = 'saml.enabled'`;
5. Restart Fortify's webserver

## Apache Tomcat

- SSL:
  - See also: https://crunchify.com/step-by-step-guide-to-enable-https-or-ssl-correct-way-on-apache-tomcat-server-port-8443/
  - SSL configuration (in `conf/server.xml`):
    ```xml
        <Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
                   maxThreads="150" SSLEnabled="true">
            <SSLHostConfig>
                    <Certificate certificateFile="/opt/tomcat_certs/cert.pem" certificateKeyFile="/opt/tomcat_certs/certkey.pem"
                                 type="RSA" />
            </SSLHostConfig>
        </Connector>
    ```

## VirtualBox

- `VBoxManage list runningvms` = List currently running VMs using headless VirtualBox.

## Zabbix

- `zabbix_proxy -R config_cache_reload` = Reload Zabbix proxy configuration without restarting service.

```bash
curl -L -s -X POST -H 'Content-Type: application/json-rpc' \
    -d '{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password":"zabbix"
    },
    "id":1,
    "auth":null
    }' \
https://zabbix.example.mil/api_jsonrpc.php
```

## vSphere / VMWare

`Actions -> Edit Settings -> VM Options -> VMWare Remote Console Options` = Edit max number of connected console sessions for a guest.

## McAfee

- Logs: `/var/McAfee/agent/logs`

Uninstall McAfee Agent:
```bash
rpm -e MFEdx
rpm -e MFEcma
rpm -e MFErt

# If the above fails:
rpm -e MFEdx --nodeps --noscripts
rpm -e MFEcma --nodeps --noscripts
rpm -e MFErt --nodeps --noscripts
```

## pfSense

- [Place firewall rules on the interface where the traffic originates](https://blog.monstermuffin.org/pfsense-guide-nat-firewall-rules-networking-101/)

- [<INTERFACE> Net vs <INTERFACE> Addres:](https://docs.netgate.com/pfsense/en/latest/firewall/configure.html)
  - Interface Net
    - These macros specify the subnet for that interface exactly, including any IP alias VIP subnets that differ from
      the defined interface subnet.
  - Interface Address
    - These macros specify the IP address configured on that interface.

## Borg Backup

Extract */mnt/tank/share/pictures* in repo *backup-2020-01-19-01-00* to current path:
```bash
borg extract \
--progress \
--list \
--verbose \
/mnt/backup/borgrepo::backup-2020-01-19-01-00 mnt/tank/share/pictures/
```

## Graylog

Change Graylog from RO to RW mode:
```bash
curl \
-XPUT \
-H "Content-Type: application/json" \
https://localhost:9200/_all/_settings \
-d '{"index.blocks.read_only_allow_delete": null}'
```

## OpenSCAP

Run SCAP scan:
```
oscap xccdf eval \
--fetch-remote-resources \                                            # Download any new definition updates.
--profile xccdf_mil.disa.stig_profile_MAC-3_Sensitive \               # Which profile within the STIG checklist to use.
--results /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).xml \    # Filepath to place XML results.
--report /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).html \    # Filepath to place HTML-formatted results.
/shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml # Filepath of the STIG checklist file.
```

Minimum XCCDF file for importing SCAP results to DISA STIG viewer:
```xml
<?xml version="1.0" encoding="UTF-8.  "?>
<TestResult>
  <rule-result idref="SV-86681r2_rule.  ">
    <result>pass</result>
  </rule-result>
  <rule-result idref="SV-86921r3_rule.  ">
    <result>notchecked</result>
  </rule-result>
  <rule-result idref="SV-86473r3_rule.  ">
    <result>notapplicable</result>
  </rule-result>
  <rule-result idref="SV-86853r3_rule.  ">
    <result>fail</result>
  </rule-result>
</TestResult>
```

## Ranger

- `m<KEY>`         = Bookmark path at *\<KEY\>*.
- `` `<KEY> ``     = Jump to bookmark at *\<KEY\>*.
- `cd /path`       = Jump to /path.
- `gh` *(go home)* = Jump to ~ 
<br><br>
- `I` = Rename from beginning of file.
- `A` = Rename from end of file (including extension).
- `a` = Rename from end of file (excluding extension).

## Spacewalk / Red Hat Satellite

- `rhncfg-client get` = Force spacewalk client to pull configuration files.

```bash
#!/usr/bin/env bash
# Spacewalk client setup script for rhel/centos 7

# Whitelist spacewalk server.
firewall-cmd --zone=public --permanent --add-source=XXXXXXX
firewall-cmd --reload
# Add spacewalk repo.
yum install -y yum-plugin-tmprepo
yum install -y spacewalk-client-repo \
--tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.9-client/epel-7-x86_64/repodata/repomd.xml \
--nogpg
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Add epel repo, install necessary packages.
yum install -y epel-release && yum install -y rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin osad
# Add spacewalk ca cert.
rpm -Uvh http://XXXXXXXX/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm
# Register with activation key.
rhnreg_ks --serverUrl=https://XXXXXXX/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-centos7-main-key
# Start rhnsd service.
systemctl enable rhnsd --now
# Install and configure osad.
sed -i "s/osa_ssl_cert =/osa_ssl_cert = \/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT/g" /etc/sysconfig/rhn/osad.conf
systemctl enable osad --now
# Test connectivity.
rhn-channel --list
```

## Tenable Nessus

[Reset user password](https://docs.tenable.com/nessus/commandlinereference/Content/ChangeAUsersPassword.htm)
```bash
/opt/nessus/sbin/nessuscli chpasswd <USERNAME>
```

## Tenable.SC (SecurityCenter)

Get new plugins: https://patches.csd.disa.mil

[Reset admin password to "password"](https://community.tenable.com/s/article/Reset-admin-password-in-Tenable-sc-and-unlock-the-account-if-its-been-locked-Formerly-SecurityCenter)
```
## Versions 5.10 and earlier:
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e' where username='admin';"

## Versions 5.11 and later:
/opt/sc/support/bin/sqlite3 /opt/sc/application.db "update userauth set password = 'bbd29bd33eb161d738536b59e37db31e', salt = '',hashtype = 1 where username='admin';"

# Password hash for easier reading:
bbd2
9bd3
3eb1
61d7
3853
6b59
e37d
b31e
```

List users:
```
# /opt/sc/support/bin/sqlite3 /opt/sc/application.db "select * from UserAuth"
```
