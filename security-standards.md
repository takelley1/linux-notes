## SSL SIGNATURES

  - 2 keys are used, Private Key is used for signing, Public Key is used for verifying signatures. 
  1. Sender hashes document, encrypts hash with Sender's Private Key, then attaches encrypted hash to document. This encrypted hash is 
     the Digital Signature. 
  2. Receiver hashes document and decrypts the Sender's signature containing the Sender's hash using the Sender's Public Key. 
  3. If the Receiver's own hash and the Receiver's decrypted hash from the Sender match, the signature is valid. 
  - Provides Integrity, Non-Repudiation, and Authentication. 

![digital-signatures](/images/digital-signatures.png)


## SYMMETRIC ENCRYPTION

> AES, Blowfish, Twofish, RC4, 3DES, One Time Pad, TLS/SSL/HTTPS (data transfer only) 
  - A single Secret Key (called a Private Key, Shared Secret, or Session Key in HTTPS) is used for both encryption and decryption of 
    messages after it has been exchanged using Public Key encryption. 
  - Much faster than Asymmetric Encryption since it uses less overhead and its key sizes are smaller.
    - AES (symmetric) keys are 256-bits, RSA (asymmetric) keys are usually 2048-bits.
    
### Kerberos

  - Used to authenticate users to services over an untrusted network, without sending credentials in plaintext. This is done by 
    converting user passwords into symmetric Secret Keys, which are used to encrypt sensitive traffic.
    
#### Part 1: TGT Authentication
  1. User requests a **Ticket-Granting Ticket (TGT)** from the **Key Distribution Center (KDC)**. This request is encrypted with the 
     user's Secret Key, which was derived from the user's password.
  2. The KDC decrypts the request using the user's Secret Key it has stored in its database.
  3. The KDC gives the user two things:
     1. A TGT that's been encrypted with the KDC's own Secret Key.
     2. A Session Key that's been encrypted with the user's Secret Key.
  4. The user stores the TGT and decrypts the Session Key.
  
#### Part 2: Ticket Authentication
  1. When the user needs access to a service, they send the KDC two things:
     1. Their TGT along with a request to access service X.
     2. An Authenticator, which has been encrypted with the Session Key.
  2. The KDC decrypts the requests:
     1. The KDC decrypts the TGT using its own Secret Key.
     2. The KDC decrypts the Authenticator using the Session Key and compares the user info in the Authenticator with the user info
        in the TGT.
  3. The KDC responds to the user:
     1. The KDC sends a Ticket and new Session Key, both encrypted with service X's Secret Key.
     2. The KDC sends another copy of the new Session Key, encrypted with the old Session Key.
  4. The user stores the Ticket and decrypts the new Session Key.
     
#### Part 3: Service Authentication
  1. User requests access to service X:
     1. The user sends the Ticket and new Session Key, both encrypted with service X's Secret Key, to service X.
     2. The user sends a new Authenticator, encrypted with the new Session Key, to service X.
  2. Service X decrypts the requests:
     1. Service X decrypts the Ticket and new Session Key using its Secret Key.
     2. Service X decrypts the new Authenticator with the new Session Key and compares the user info in the new Authenticator with the 
        user info in the Ticket.
  3. Service X responds to the user with a confirmation message encrypted with the new Session Key.
  4. User decrypts the confirmation message and compares its timestamp with the timestamp in the new Authenticator. If they match, the 
     user can now begin communicating with service X.
  
#### Terminology
  - **principal** = A unique identity that uses Kerberos, usually a username formatted as `username@REALM.NAME`.
  - **realm** = The Kerberos-equivalent to a Windows Domain. Realm names are always in all-caps.
  - **SPN (Service Principal Name)** = The formal name of the resource or service a user is requesting access to.
  - **TGS (Ticket-Granting Service)** = The Kerberos service running on the KDC
  
  `kinit username@REALM` = request TGT from KDC \
  `klist` = list all tickets

![kerberos](/images/kerberos.jpg)    
    
    
## KDF (Key Derivation functions)

> PBKDF2, scrypt
  - Used to derive a cryptographically-secure symmetric Secret Key from a less secure password or other input (like a Shared Secret 
    created via a Diffie-Hellman exchange).
  - Very similar to hash functions, but more secure. This is because KDFs produce higher-entropy and more uniformly random outputs.
    - Used both to create encryption keys from passwords and to create cryptographically-secure hashes from passwords
  - Keyed-hash MACs (HMACs) are frequently used as part of KDFs. The input for the KDF may be hashed thousands of times to increase
    the difficulty of Brute Force Attacks. This is called a Work Factor.


## MAC (Message Authentication Code)

> HMAC, PMAC, OMAC 
  - Used to ensure data integrity in messages. Similar to Digital Signatures, except much smaller (only a few bytes) and faster. 
  1. The Sender uses a MAC algorithm with a Shared Secret on a message's hash to create a cryptographic checksum, called a MAC.
  2. The MAC is attached to the message and sent to the Receiver.
  3. The Receiver uses the same Shared Secret with the same MAC algorithm on the message's hash.
  4. The Receiver compares his MAC with the Sender's MAC. If they match, the message is good and has not been altered en route. The
     Receiver also knows that the message definitely came from the Sender (and not a Man-in-the-Middle) because only the Receiver and
     Sender posess the Shared Secret.
  - Faster than Digital Signatures, but doesn't provide Non-Repudiation because the Symmetric Key used to sign the hash is not unique to 
    the Sender.
  ### HMAC (Keyed-Hash Message Authentication Code)
  > HMAC-SHA256, HMAC-MD5, HMAC-SHA1
  - HMACs are a type of Keyed Cryptographic hash functions, which are used to dervice MACs.
  - Example: HMAC-MD5(key = "key", message = "The quick brown fox jumps over the lazy dog") = `80070713463e7749b90c2dc24911e275`
  
| Data integrity method  | Hash | HMAC      | Digital Signature|
|------------------------|:----:|:---------:|:----------------:|
| Integrity              | Yes  | Yes       | Yes              |
| Authentication         | No   | Yes       | Yes              |
| Non-repudiation        | No   | No        | Yes              |
| Relative Speed         | Fast | Fast      | Slow             |
| Kind of keys           | None | Symmetric | Asymmetric       |
| Able to be truncated   | Yes  | Yes       | No               |

- **Integrity**: Has the message been altered?
- **Authentication**: Is this entity who they say they are?
- **Non-Repudiation**: Has this entity provided proof that this message actually came from them?
  - Non-Repudiation also provides Authentication as a byproduct.
  
<img src="/images/hmac.png" width="600"/>
  
  
## HASHING

> - *Unkeyed Cryptographic*: MD5 (deprecated), SHA1 (deprecated), SHA2 (SHA256 & SHA512), SHA3, bcrypt
> - *Keyed Cryptographic*: HMACs, KMACs, MD6, UMACs, VMACs, BLAKE2
> - *Non-Cryptographic*: Buzhash, xxHash, Pearson hashing, MurmurHash 
> - *Checksums*: sum8, sum32, fletcher-4, fletcher-32, xor8, Adler-32 
>   - *Cyclic Redundancy Checks (CRCs)*: cksum, CRC-16, CRC-32, CRC-64
  - Hashes are one-way functions to ensure data integrity and to obscure/obfuscate passwords.
    - **CRCs** (a common type of checksum) are short and used to detect and/or correct changes in data.
    - **Unkeyed hashes** depend only on input data, intentioanlly designed to be computationally intensive, and are cryptographically 
      secure against brute-force attacks
    - **Keyed hashes** depend on input data and a Symmetric Key. Much faster than salted hashes. An HMAC is a type of keyed hash.
  - **Salting:** When hashing passwords, it is recommended to salt them by hashing the user's password concatenated with a random unique 
    string tied to that user's account. This eliminates the effectiveness of Rainbow Tables because common passwords that have been 
    salted now create hashes different from what would appear on Rainbow Tables.
      
| Salted vs Keyed hashes             | Salted hash              | Keyed hash           |
|------------------------------------|:------------------------:|:--------------------:|
| Primary function                   | Deter brute-force attacks| Ensure data integrity|
| Salt/Key is known to attacker      | Yes                      | No                   |
| Reused between messages            | No                       | Yes                  |
| Relative speed                     | Slow                     | Fast                 |

<img src="/images/salted-hash.png" width="600"/>


## MFA (Multi-Factor Authentication)

### TOTP (Time-based One-Time Password)
- Used with an Authenticator app that combines a shared symmetric Secret Key with the current timestamp (on a 30s interval) to create
  a single-use one-time password.
  - An HMAC is used to create the TOTP, which is encoded and truncated down to 6-digits.
  - Only the Authenticator app and the authenticating server know the Secret Key.
  - Based on HMAC-based One-Time Passwords (HOTP)

### FIDO U2F

## SSL CERTIFICATES (1-way SSL Authentication) 

  Before Bob sends Alice data that's been encrypted with ker Public Key, it is important for Bob to verify Alice's Public Key belongs to 
her and not a malicious third party impersonating Alice by giving Bob the wrong Public Key. 
  
  To verify Alice's Public Key belongs to her, Bob checks the Alice's Certificate, which contains her Public Key. The Certificate 
also has the Digital Signature of a Certificate Authority (CA) verifying its authenticity, since the CA is a trusted third-party.

  The CA that signed Alice's Certificate is an Intermediate CA, which Bob doesn't trust. However, the Intermediate CA's Certificate was
signed by a Root CA, which Bob trusts. Through the Chain of Trust, since Bob trusts the Root CA, and the Root CA trusts the Intermediate
CA, Bob can trust the Intermediate CA.
    
  Bob can verify the Root CA's signature on the Intermediate CA's Certificate using the Root CA's Public Key, which came built-in on 
Bob's web browser when he downloaded it, along with the Public Key of every other common Root CA.

  Bob trusts the Root CA because it has established its reputation through the Web of Trust, along with the fact that the Root CA's
Public Key came with his browser [1].
 
<img src="/images/session-keys.jpg" width="400"/> 


## MUTUAL SSL AUTHENTICATION (2-way SSL Authentication)

  In Mutual Authentication, the Client must trust the Server, but the Server must also trust the Client.
  1. The Client requests access to a protected resource. 
  2. The Server presents its Certificate to the Client. 
  3. The Client verifies the server’s Certificate using the Server's Certificate issuer's Public Key. 
  4. If successful, the Client then sends its Certificate to the Server. 
  5. The Server verifies the Client’s credentials using the Client's Certificate issuer's Public Key. 
  6. If successful, the Server grants access to the protected resource requested by the Client [2]. 

![mutual-ssl-authentication](/images/mutual-ssl-auth.png)


## KEY EXCHANGE

  - #### Diffie-Hellman 
    - Used to securely create a Shared Secret for a symmetrically-encrypted interaction. A Key-Derivation Function (KDF) can then be 
      used with the Shared Secret in order to create a cryptographically-secure Secret Key for use with AES.
    - Vulnerable to Man in the Middle attacks if the exchange is not encrypted with RSA. 
  - #### Diffie-Hellman-RSA (DH_RSA) 
    - DH with RSA  
    - Bob uses signs his DH Public Key with his RSA Private Key before sending it to Alice. 
    - Alice verifies Bob's signature using his RSA Public Key to ensure the DH Public Key is actually from Bob and there is no Man in 
      the Middle. 

<img src="/images/dh-exchange.png" width="600"/> 


## ATTACKS

- **Side-channel attack** = Attack based on a weakness in the implementation of a security system, rather than a weakness in the
                            system itself.
                            
  - **Cold-boot attack** = Attacker with physical access reboots into a temporary OS and performs a memory dump to retrieve encryption 
                           keys stored in RAM from the previous boot. Exploits the fact that RAM is unencrypted and remains readable 
                           seconds to minutes after losing power. Used to circumvent full-disk encryption.
                           
  - **Cache side-channel attack** = (*ex. Meltdown & Spectre*) Attacker takes advantage of the way speculative execution is performed on
                                    certain CPUs to gain access to protected areas of memory.

- **Man-in-the-middle attack (MITM)** = Attacker relays or alters messages between two parties who believe they're communicating with 
                                        each other.
                                        
  - **ARP spoofing / ARP poisoning** = Attacker replies to ARP messages that are requesting the MAC of a specific IP. This allows the 
                                       attacker to get their MAC associated with the IP of another host, usually the default gateway.
                                       The attacker can then perform a DoS or MITM attack by intercepting and relaying traffic.
  
  - **Replay attack** = Attacker repeats or delays a valid message, fooling a party into believing the attacker is legitimate.

<img src="/images/replay-attack.png" width="300"/>


### Breaking encryption 
  "Big O" time complexity 
  
![time-complexity](/images/time-complexity.jpg)
 
  - classical brute-force time complexity of breaking a cryptographic hash = **O(2<sup>N</sup>)**
    - A SHA256 hash has a search space of **2<sup>256</sup>** [3]
  
  - quantum brute-force time complexity of factoring an RSA key using Shor's algorithm = **O(72(logN)<sup>3</sup>)** [4]
  
![shors-algorithm](/images/time-complexity-shors-algorithm.jpg)

- [1] https://strongarm.io/blog/how-https-works/
- [2] https://www.codeproject.com/Articles/326574/An-Introduction-to-Mutual-SSL-Authentication
- [3] https://www.youtube.com/watch?v=S9JGmA5_unY&t=1s
- [4] https://cs.stackexchange.com/questions/16684/shors-algorithm-speed
