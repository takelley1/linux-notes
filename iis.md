## [Windows IIS](https://www.iis.net/)

### Configuring Self-signed TLS/SSL

- Open IIS manager
- Generate a cert for the web server:
  - Select the host at the top of the tree on the left
  - `Server Certificates`
  - `Create Self-Signed Certificate` -> `OK`
- Listen on a new port with the cert:
  - Right click desired site -> `Edit Bindings`
  - `Add..`
    - Type: `https`
    - IP address: `All Unassigned`
    - Port: `443`
    - Host name: blank
- Restart IIS
  - Right click desired site -> `Manage Website` -> `Restart`

### Certificate Updates

- Create the cert and CSR.
- Have the CSR signed.
- Combine into a chain.crt:
  ```bash
  cat ServerCertificate.crt Intermediate.crt Root.crt > chain.crt
  ```
- Convert to a PFX file:
  ```bash
  openssl pkcs12 -export -out server.pfx -inkey certkey.pem -in chain.crt
  ```
- Transfer the PFX to the Windows server and install it as a system-wide certificate.
- In IIS under the Orchestrator site edit the bindings and select the new certificate.
- Restart IIS
  - Right click desired site -> `Manage Website` -> `Restart`
