## Windows IIS

### Configuring TLS/SSL

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
