## KERBEROS

Used to authenticate users to services over an untrusted network, without sending credentials in plaintext. This is done
by converting user passwords into symmetric secret Keys, which are used to encrypt sensitive traffic.

### Configuration

- **See also:**
  - [Ansible WinRM guide](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#kerberos)
<br><br>
- `kinit <USERNAME>@<REALM>` = Request TGT from KDC.
- `klist` = List all tickets.

#### Example krb5.conf (for Ansible to target Windows hosts):

```
includedir /etc/krb5.conf.d/
includedir /var/lib/sss/pubconf/krb5.include.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = true
 pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt

default_realm = EXAMPLE.COM
[realms]

EXAMPLE.COM = {
  kdc = <YOUR_DOMAIN_CONTROLLER_HOSTNAME>.example.com
  default_domain = EXAMPLE.COM
  admin_server = <YOUR_DOMAIN_CONTROLLER_HOSTNAME>.example.com
 }

[domain_realm]
 example.com = EXAMPLE.COM
 .example.com = EXAMPLE.COM
 example = EXAMPLE.COM
```

### Authentication Process

#### 1: TGT authentication
  1. User requests a *Ticket-Granting Ticket (TGT)* from the *Key Distribution Center (KDC)*. This request is
     encrypted with the user's secret key, which was derived from the user's password.
  2. The KDC decrypts the request using the user's secret key it has stored in its database.
  3. The KDC gives the user two things:
     - A TGT that's been encrypted with the KDC's own secret key.
     - A session key that's been encrypted with the user's secret key.
  4. The user stores the TGT and decrypts the session key.

#### 2: Ticket authentication
  1. When the user needs access to a service, they send the KDC two things:
     1. Their TGT along with a request to access service *XYZ*.
     2. An Authenticator, which has been encrypted with the session key.
  2. The KDC decrypts the requests:
     1. The KDC decrypts the TGT using its own secret key.
     2. The KDC decrypts the Authenticator using the session key and compares the user info in the Authenticator with
        the user info in the TGT.
  3. The KDC responds to the user:
     1. The KDC sends a Ticket and new session key, both encrypted with service *XYZ's* secret key.
     2. The KDC sends another copy of the new session key, encrypted with the old session key.
  4. The user stores the Ticket and decrypts the new session key.

#### 3: Service authentication
  1. User requests access to service *XYZ*:
     1. The user sends the Ticket and new session key, both encrypted with service *XYZ's* secret key, to service *XYZ*.
     2. The user sends a new Authenticator, encrypted with the new session key, to service *XYZ*.
  2. Service *XYZ* decrypts the requests:
     1. Service *XYZ* decrypts the Ticket and new session key using its secret key.
     2. Service *XYZ* decrypts the new Authenticator with the new session key and compares the user info in the new
        Authenticator with the user info in the Ticket.
  3. Service *XYZ* responds to the user with a confirmation message encrypted with the new session key.
  4. User decrypts the confirmation message and compares its timestamp with the timestamp in the new Authenticator.
     If they match, the user can now begin communicating with service *XYZ*.

### Terminology

  - **principal** = A unique identity that uses Kerberos, usually a username formatted as \<USERNAME/PRINCIPAL\>@\<REALM\>.
  - **realm** = The Kerberos-equivalent to a Windows Domain. Realm names are always in all-caps.
  - **SPN (Service Principal Name)** = The formal name of the resource or service a user is requesting access to.
  - **TGS (Ticket-Granting Service)** = The Kerberos service running on the KDC.

<img src="images/kerberos.jpg" width="600"/>

