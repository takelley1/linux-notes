## KEYCLOAK / REDHAT IDM

- Configuring keycloak for CAC authentication (also called mTLS or X509 client authentication)
<br><br>
- keycloak frontend configuration:
  - authentication tab
    - flows
      - CAC browser
        - auth type: X509 validate user form (PIV) - alternative
          - user identity source: suject's alternate name otherName (UPN)
          - canonical DN representation enabled - off
          - enable serial number hexadecimal representation - off
          - a regular expression to extract user identity - blank
          - user mapping method - custom attribute mapper
          - a name of user attribute - employeeNumber
          - all other toggles - off
        - auth type: cac browser test CAC browser forms - alternative
        - auth type: username password form - required
  - users
    - ensure user has an attribute called `employeeNumber` with a value of their PIV, e.g. `1234567551117275@mil`
<br><br>
- keycloak backend
  - keycloak must have a root or intermediate CA certificate in its Java keystore that is the *same* certificate that signs the CAC certificates
     - import certs into a keystore:
       ```
       keytool -import -alias ROOT-CA -keystore keystore.jks -file Root-CA.cer
       ```
     - add DoD root certs to keycloak trust store in order to prompt for cert
     - list certs in trust store:
       ```
       keytool -list -keystore keystore.jks
       ```
  - Dod cert bundle can be downloaded here: https://public.cyber.mil/pki-pke/
    - See the `README.txt` file in the downloaded `.zip` archive for instructions on how to extract certs, or see below:
      ```bash
      # Extract certs into PEM format
      openssl pkcs7 -in Certificates_PKCS7_v5.9_DoD.pem.p7b -print_certs -out DoD_CAs.pem
      # Split apart certs into separate files
      csplit -f cert- DoD_CAs.pem '/-----BEGIN CERTIFICATE-----/' '{*}'
      # Import certs into keycloak's Java trust store
      for i in $(seq -w 01 37); do echo TRUSTSTOREPASS|keytool -import -alias "cert-${i}" -keystore certs.jks -file "cert-${i}" -noprompt; done
      ```
  - Edit `/opt/keycloak/*/conf/keycloak.conf` to add configuration settings.
  - `./opt/keycloak/keycloak-18.0.0/bin/kc.sh build --health-enabled=true`
  - `./opt/keycloak/keycloak-18.0.0/bin/kc.sh show-config`
- starting keycloak
  ```
  /opt/keycloak/keycloak-18.0.0/bin/kc.sh --verbose start --https-trust-store-file=./keystore.jks --https-trust-store-password=test123 --https-client-auth=request
  ```
- systemd service
  ```ini
  [Unit]
  Description=Keycloak server
  After=network.target

  [Service]
  User=root
  Group=root
  ExecStart=/opt/keycloak/keycloak-18.0.0/bin/kc.sh --verbose start --https-trust-store-file=/opt/keycloak/keycloak-18.0.0/certs/cac_certs.jks --https-trust-store-password=SuperSecretPassword --https-client-auth=request --https-port=443

  [Install]
  WantedBy=multi-user.target
  ```
<br><br>
- keycloak api
  -  `../bin/kcadm.sh config truststore --trustpass test1234 ./cac_certs.jks`
  -  `../bin/kcadm.sh config credentials --server https://keycloak.gmcsde.com --realm master --user admin`
  - scripting
    - add users to role
      - `../bin/kcadm.sh get users -r devops --limit 1000 | awk -F: '/username/ {gsub(/,|\"/,""); print $2}' > usernames.txt`
      - `for i in $(cat usernames.txt); do ../bin/kcadm.sh add-roles --uusername "${i}" --rolename agility -r devops; echo "${i}"; done`

```
yum update -y
amazon-linux-extras install -y java-openjdk11
mkdir /opt/keycloak
cd /opt/keycloak
wget https://github.com/keycloak/keycloak/releases/download/18.0.0/keycloak-18.0.0.zip
unzip keycloak-18.0.0.zip
```

./opt/keycloak/keycloak-18.0.0/bin/kc.sh build
- connect to db and create db
./opt/keycloak/keycloak-18.0.0/bin/kc.sh show-config

