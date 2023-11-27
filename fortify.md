## [Fortify SSC](https://www.microfocus.com/documentation/fortify-software-security-center/)

Downloading Fortify SSC release
  1. `sld.microfocus.com`
  2. After logging in, select account.
  3. Security Fortify Runtime -> Security Fortify Scanning User Subscription SW E-LTU -> {version} -> Fortify_SSC_Server_{version}.zip

Downloading Fortify rulepacks
  1. `https://support.fortify.com/admin/rulepacks.jsp`
  2. Download Rulepacks -> Rulepacks release -> {latest} -> SCA

Installation
1. Install Java OpenJDK
2. Extract the Fortify SSC installation archive
3. Extract the `apache-tomcat-*.zip` in the Fortify SSC archive to `/opt`
4. Edit Tomcat's `conf/server.xml` file accordingly (see the `tomcat.md` file)
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

Database
```
MySQL [(none)]> CREATE DATABASE fortify CHARACTER SET latin1 COLLATE latin1_general_cs;
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
