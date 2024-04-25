## [SonarQube](https://docs.sonarqube.org/latest/)

### SSO w/ Keycloak

See here: https://docs.sonarsource.com/sonarqube/latest/instance-administration/authentication/saml/how-to-set-up-keycloak/
- Issue: Keycloak returning 'invalid redirect uri' error
  - Solution: In SonarQube GUI -> Administration -> Configuration -> General -> Server base URL, ensure value is set.
- Issue: SonarQube returning a signature not found or not available error
  - Solution: In KeyCloak GUI -> Clients -> Select SonarQube Client -> Settings -> Signature and Encrypion -> Enable both Sign documents and Sign assertions.
- Issue: KeyCloak returning 'invalid requester' error. Also, the KeyCloak journal log shows
  ```
   ERROR [org.keycloak.protocol.saml.SamlService] (executor-thread-606) request validation failed: org.keycloak.common.VerificationException: org.keycloak.common.VerificationException: Invalid query param signature
  ```
  - Solution: In KeyCloak GUI -> Clients -> Select SonarQube Client -> Keys -> Signing keys config -> Disable Client signature required.
