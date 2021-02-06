
## CERTIFICATE MANAGEMENT

### OpenSSL

- **See also**
  - [OpenSSL certificate generation and signing](https://stackoverflow.com/questions/21297139/how-do-you-sign-a-certificate-signing-request-with-your-certification-authority)

#### Viewing

- `openssl x509 -text -noout -in servercert.pem` = View cert.
- `openssl req -text -noout -in servercsr.pem` = View CSR.
  - `-text` = Output in text form.
  - `-noout` = Don't output encoded.
- `openssl x509 -purpose -in servercert.pem` = View certificate uses.

#### Generation

- `openssl req -new -newkey rsa:2048 -nodes -keyout csrkey.pem -out csr.pem` = Generate CSR (Certificate Signing Request).
  - `-new` = Create a CSR.
  - `-newkey rsa:2048` = Create a 2048-bit RSA private key.
  - `-nodes` (*No DES*) = Don't encrypt the private key (DANGEROUS!).
  - `-keyout certkey.pem` = Write the private key to *csrkey.pem*.
  - `-out cert.pem` = Write the CSR to *csr.pem*.
<br><br>
- `openssl req -x509 -newkey rsa:2048 -nodes -keyout certkey.pem -out cert.pem -subj "/C=US/ST=/L=/O=/CN=example.com"` = Generate self-signed cert.
  - `-x509` = Create a self-signed cert instead of a CSR.
  - `-subj "..."` = Add information to cert without OpenSSL prompting for it.
<br><br>
- `sh ./certgen.sh domain.example.com 'DNS:*.domain.example.com,IP:10.0.0.10'` = Generate CSR with Subject Alternate Names
                                                                               (See [certgen.sh](certgen.sh) for script).
<br><br>
- Add private key to certificate. This allows the cert and private key to be imported into Windows: <sup>[3]</sup>
```
openssl pkcs12 -export -out cert.pfx -inkey private.key -in cert.crt -certfile CACert.crt
```

#### Conversion

- `openssl x509 -outform der -in cert.pem -out cert.crt` = Convert *.pem* to *.crt* format.
- `openssl x509 -outform pem -in cert.crt -out cert.pem` = Convert *.crt* to *.pem* format.


#### Files

Example OpenSSL CA config file:
```
HOME            = .
RANDFILE        = $ENV::HOME/.rnd

[ ca ]
default_ca       = CA_default   # The default ca section

[ CA_default ]
default_days     = 365           # How long to certify for
default_md       = sha256        # Use public key default MD
preserve         = no            # Keep passed DN ordering
x509_extensions  = ca_extensions # The extensions to add to the cert
email_in_dn      = no            # Don't concat the email in the DN
copy_extensions  = copy          # Required to copy SANs from CSR to cert

[ req ]
default_bits       = 4096
default_keyfile    = cakey.pem
distinguished_name = ca_distinguished_name
x509_extensions    = ca_extensions
string_mask        = utf8only

[ ca_distinguished_name ]
countryName             = Country Name (2 letter code)
stateOrProvinceName     = State or Province Name (full name)
localityName            = Locality Name (eg, city)
organizationName        = Organization Name (eg, company)
organizationalUnitName  = Organizational Unit (eg, division)
commonName              = Common Name (e.g. server FQDN or YOUR name)
emailAddress            = Email Address

[ ca_extensions ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always, issuer
basicConstraints       = critical, CA:true
keyUsage               = keyCertSign, cRLSign
```

`openssl req -x509 -config openssl-ca.cnf -newkey rsa -nodes -out cacert.pem -outform PEM` = Generate CA cert using above file.

### GNU CertTool

- Generate self-signed certificate:
```bash
certtool --generate-privkey --outfile key.pem
certtool --generate-self-signed --load-privkey key.pem --outfile cert.pem
```

### Add certificate to trust store

#### FreeBSD
`cat mycert.pem >> /etc/ssl/cert.pem`

#### Debian-based Linux
1. Add certificate name to `/etc/ca-certificates.conf`
2. Place certificate in `/usr/share/ca-certificates/`
3. Run `update-ca-certificates`

#### Arch, RHEL-based Linux
`trust anchor mycert.pem`

### Windows

- **See also**
  - [How to sign a CSR on Windows](https://docs.aws.amazon.com/cloudhsm/latest/userguide/win-ca-sign-csr.html)
<br><br>
- `certreq -submit -attrib "CertificateTemplate:WebServer" request.csr` = Import and sign *request.csr* using the *WebServer* template (cmd.exe).
<br><br>
- Run window (WIN-r)
  - `certlm.msc` = Local computer certificates.
  - `certmgr.msc` = Current user certificates.


---
## PUBLIC KEY CERTIFICATES (1-way SSL Authentication)

Before Bob sends Alice data that's been encrypted with ker Public Key, it is important for Bob to verify Alice's
Public Key belongs to her and not a malicious third party impersonating Alice by giving Bob the wrong Public Key.

To verify Alice's Public Key belongs to her, Bob checks the Alice's Certificate, which contains her Public Key.
The Certificate also has the Digital Signature of a Certificate Authority (CA) verifying its authenticity, since
the CA is a trusted third-party.

The CA that signed Alice's Certificate is an Intermediate CA, which Bob doesn't trust. However, the Intermediate
CA's Certificate was signed by a Root CA, which Bob trusts. Through the Chain of Trust, since Bob trusts the Root
CA, and the Root CA trusts the Intermediate CA, Bob can trust the Intermediate CA.

Bob can verify the Root CA's signature on the Intermediate CA's Certificate using the Root CA's Public Key, which
came built-in on Bob's web browser when he downloaded it, along with the Public Key of every other common Root CA.

Bob trusts the Root CA because it has established its reputation through the Web of Trust, along with the fact that
the Root CA's Public Key came with his browser. <sup>[1]</sup>

<img src="images/session-keys.jpg" width="400"/>


---
## MUTUAL PUBLIC KEY AUTHENTICATION (2-way SSL Authentication)

- In Mutual Authentication, the Client must trust the Server, but the Server must also trust the Client.
  1. The Client requests access to a protected resource.
  1. The Server presents its Certificate to the Client.
  1. The Client verifies the server’s Certificate using the Server's Certificate issuer's Public Key.
  1. If successful, the Client then sends its Certificate to the Server.
  1. The Server verifies the Client’s credentials using the Client's Certificate issuer's Public Key.
  1. If successful, the Server grants access to the protected resource requested by the Client. <sup>[2]</sup>

![mutual-ssl-authentication](images/mutual-ssl-auth.png)


[1]: https://strongarm.io/blog/how-https-works/
[2]: https://www.codeproject.com/Articles/326574/An-Introduction-to-Mutual-SSL-Authentication
[3]: https://security.stackexchange.com/questions/25996/how-to-import-a-private-key-in-windows
