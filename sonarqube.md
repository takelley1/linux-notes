## SonarQube

### SSO w/ Keycloak

See here: https://docs.sonarqube.org/latest/instance-administration/delegated-auth/
- Issue: Keycloak returning 'invalid redirect uri' error
  - Solution: In SonarQube GUI -> Administration -> Configuration -> General -> Server base URL, ensure value is set.
