## [Shibboleth Service Provider (SP)](https://shibboleth.atlassian.net/wiki/spaces/SP3/overview?homepageId=2058387896)

- This guide is for configuring Shibboleth as a Service Provider (SP) with Keycloak as an Identity Provider (IdP)

### [Installation](https://www.switch.ch/aai/guides/sp/installation/?os=centos7)

- Notes:
  - [Shibboleth *must* be installed on the *same host* as the app it's protecting](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065334314/ApplicationModel)
    - This means you must have a separate Shibboleth installation for every app that Shibboleth protects
  - The web server Shibboleth is running on *must* be configured for SSL/TLS

> NOTE: [SELinux must be disabled!](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335559/SELinux)

- Go to https://shibboleth.net/downloads/service-provider/RPMS/ and generate the correct .repo file for your
   distribution
- Create `/etc/yum.repos.d/shibboleth.repo` with the content from the previous step
- `yum update -y && yum install -y shibboleth httpd mod_ssl`
- Follow steps recommended [here](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335062/Apache) to
   configure Apache:
  - Set `ServerName` in the `VirtualHost` section of `/etc/httpd/conf.d/ssl.conf`
  - Set `UseCanonicalName On` in the `VirtualHost` section of `/etc/httpd/conf.d/ssl.conf`
  - Unset `LoadModule mpm_prefork_module modules/mod_mpm_prefork.so` and set
     `LoadModule mpm_worker_module modules/mod_mpm_worker.so` in `/etc/httpd/conf.modules.d/00-mpm.conf`. Use `httpd -V`
     to verify MPM mode.
- `apachectl configtest && shibd -t` = Validate configuration
- `systemctl enable httpd --now`
- `systemctl enable shibd --now`
- Test endpoints to ensure a 500 error doesn't occur:
   ```
   curl -vkL https://localhost/Shibboleth.sso/Status
   curl -vkL https://localhost/Shibboleth.sso/Session
   ```
- Add Shibboleth as a client to Keycloak:
  - The Shibboleth client's `client ID` must be equal to the `entityID` set in the `ApplicationDefaults` section of
    `shibboleth2.xml`
  - Example Keycloak configuration (generated via Clients -> Export):
    - Note: When using Shibboleth to protect Digital.ai's Agility, Keycloak doesn't need to have any client mappers. You simply need to configure HTTP_USER in Shibboleth's `attribute-map.xml` file (see below). Agility itself must also be configured for [SSO](https://docs.digital.ai/bundle/agility-onlinehelp/page/Content/Digital.ai_Agility/On-Premise_Single_Sign-On.htm)
    ```json
    {
        "clientId": "shibboleth.example.com",
        "name": "Apache test app",
        "rootUrl": "",
        "adminUrl": "",
        "baseUrl": "",
        "surrogateAuthRequired": false,
        "enabled": true,
        "alwaysDisplayInConsole": false,
        "clientAuthenticatorType": "client-secret",
        "redirectUris": [
            "https://shibboleth.example.com/Shibboleth.sso/SAML2/ECP",
            "https://shibboleth.example.com/Shibboleth.sso/SAML2/POST"
        ],
        "webOrigins": [],
        "notBefore": 0,
        "bearerOnly": false,
        "consentRequired": false,
        "standardFlowEnabled": true,
        "implicitFlowEnabled": false,
        "directAccessGrantsEnabled": false,
        "serviceAccountsEnabled": false,
        "publicClient": false,
        "frontchannelLogout": true,
        "protocol": "saml",
        "attributes": {
            "saml_assertion_consumer_url_redirect": "https://shibboleth.example.com/Shibboleth.sso/SAML2/POST",
            "saml.force.post.binding": "true",
            "saml.multivalued.roles": "false",
            "frontchannel.logout.session.required": "false",
            "oauth2.device.authorization.grant.enabled": "false",
            "backchannel.logout.revoke.offline.tokens": "false",
            "saml.server.signature.keyinfo.ext": "false",
            "use.refresh.tokens": "true",
            "oidc.ciba.grant.enabled": "false",
            "backchannel.logout.session.required": "false",
            "saml.signature.algorithm": "RSA_SHA256",
            "client_credentials.use_refresh_token": "false",
            "saml.client.signature": "false",
            "require.pushed.authorization.requests": "false",
            "saml.allow.ecp.flow": "false",
            "saml.assertion.signature": "false",
            "id.token.as.detached.signature": "false",
            "saml_single_logout_service_url_post": "https://shibboleth.example.com/Shibboleth.sso/SLO/POST",
            "saml.encrypt": "false",
            "saml.server.signature": "true",
            "exclude.session.state.from.auth.response": "false",
            "saml.artifact.binding": "false",
            "saml_single_logout_service_url_redirect": "https://shibboleth.example.com/Shibboleth.sso/SLO/Redirect",
            "saml_force_name_id_format": "false",
            "tls.client.certificate.bound.access.tokens": "false",
            "acr.loa.map": "{}",
            "saml.authnstatement": "true",
            "display.on.consent.screen": "false",
            "saml_name_id_format": "username",
            "token.response.type.bearer.lower-case": "false",
            "saml.onetimeuse.condition": "false"
        },
        "fullScopeAllowed": true,
        "nodeReRegistrationTimeout": -1,
        "protocolMappers": [],
        "defaultClientScopes": [
            "role_list",
            "agility-saml-test"
        ],
        "optionalClientScopes": [],
        "access": {
            "view": true,
            "configure": true,
            "manage": true
        }
    }
    ```
  - Also see [here](https://github.com/andrebiegel/keycloak-examples/blob/master/keycloak-idp/realm-export.json)
    for another example Keycloak client configuration
  - Configure the Shibboleth client's Mappers to allow Shibboleth to receive the intended user attributes from Keycloak
<br><br>
- Configure `/etc/shibboleth/shibboleth2.xml` to add Keycloak as an IdP and metadata provider:
   ```xml
   <SSO entityID="https://keycloak.example.com/realms/devops"
        discoveryProtocol="SAMLDS" discoveryURL="https://keycloak.example.com/realms/devops">
        SAML2 SAML1
   </SSO>
   <MetadataProvider type="XML" validate="false"
        url="https://keycloak.example.com/realms/devops/protocol/saml/descriptor"
        backingFilePath="federation-metadata.xml" maxRefreshDelay="7200">
   </MetadataProvider>
   ```
- Configure `/etc/shibboleth/attribute-map.xml` to map the attributes that Keycloak provides. See
   `/var/log/shibboleth/shibd.log` for attributes that are left out
   - Map keycloak's `HTTP_USER` attribute to the `HTTP_USER` variable:
     ```xml
     <Attribute name="HTTP_USER" nameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic" id="HTTP_USER"/>
     ```
   - Log example:
     ```
     xtractor.XML [3] [default]: skipping SAML 2.0 Attribute with Name: HTTP_USER, Format:urn:oasis:names:tc:SAML:2.0:attrname-format:basic
     ```
   - Shibboleth makes these attributes available to its web server (Apache) as a variable (see next step)
<br><br>
- If your app needs to authenticate users based on the HTTP request headers, the Shibboleth module in Apache makes
   extracted use attributes available as variables
   - Shibboleth 'protects' the URLs defined at the bottom of `/etc/httpd/conf.d/shib.conf`. Shibboleth redirects these
     URLs to the Identity Provider (IdP) for authentication. After the user has been authenticated, the content at the
     protected URL is loaded.
   - Example block in `/etc/httpd/conf.d/shib.conf`:
     ```xml
     <Location />
       AuthType shibboleth
       ShibRequestSetting requireSession 1
       require shib-session
       RequestHeader set HTTP_USER "%{USER}e"
     </Location>
     ```
   - The above block forces the user to authenticate with Shibboleth whenever they navigate to `/` on the server.
     Additionally, Apache will add a header called `HTTP_USER` to the request with the value of the `USER` variable. The
     `USER` variable is set by Shibboleth's `attribute-map.xml` when it receives the `USER` attribute back from Keycloak.
