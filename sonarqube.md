## [SonarQube](https://docs.sonarqube.org/latest/)

### SSO w/ Keycloak

See here: https://docs.sonarsource.com/sonarqube/latest/instance-administration/authentication/saml/how-to-set-up-keycloak/
- Issue: Keycloak returning 'invalid redirect uri' error
  - Solution: In SonarQube GUI -> Administration -> Configuration -> General -> Server base URL, ensure value is set.
- Issue: SonarQube returning a signature not found or not available error
  - Solution: In KeyCloak GUI -> Clients -> Select SonarQube Client -> Settings -> Signature and Encrypion -> Enable both Sign documents and Sign assertions.
