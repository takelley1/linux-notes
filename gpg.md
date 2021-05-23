
## [GPG](https://www.gnupg.org/gph/en/manual/book1.html)

- **See also**:
  - Backing up private keys on paper:
  [(1)](https://wiki.archlinux.org/index.php/Paperkey),
  [(2)](https://www.jabberwocky.com/software/paperkey/),
  [(3)](https://www.saminiir.com/paper-storage-and-recovery-of-gpg-keys/)

### Digitally sign and verify a file

*Assumes recipient does not yet have sender's public key.*

#### Sender:
1. `gpg --gen-key`                                  = Create public and private key pair.
2. `gpg --output file.sig --detatch-sign file.txt`  = Sign *file.txt* with private key, producing the signature file
                                                      *file.sig*.
3. `gpg --export --armor "pubkey.gpg" > public.asc` = Export binary public key to ASCII-encoded string.
4. Transfer *file.sig*, *file.txt*, and *public.asc* to recipient.

#### Recipient:
5. `gpg --import public.asc`                        = Import sender's public key.
6. `gpg --verify file.sig file.txt`                 = Verify the *file.sig* signature of *file.txt* using sender's public
                                                      key.

### Asymetrically encrypt/decrypt and sign a file

#### Sender:
1. Encrpyt *file.txt* using recipient's public key (assuming it's in the gpg keychain), then sign *file.txt* using
   sender's private key:
  ```bash
  gpg --encrypt --sign --armor --recipient recipient@example.com file.txt
  ```
2. This produces the encrypted and signed file `file.txt.asc`.

#### Recipient: [[1]](https://www.networkworld.com/article/3293052/encypting-your-files-with-gpg.html), [[2]](https://www.howtogeek.com/427982/how-to-encrypt-and-decrypt-files-with-gpg-on-linux/)
3. Decrypt *file.txt* using recipient's private key and verify sender's signature:
   ```bash
   gpg --decrypt file.txt.asc > file.txt
   ```

### [Symmetrically encrypt/decrypt a file](https://stackoverflow.com/questions/36393922/how-to-decrypt-a-symmetrically-encrypted-openpgp-message-using-php)

1. Encrypt *file.txt* into *file.gpg* using a password that must be provided:
   ```bash
   gpg --output file.gpg --symmetric file.txt
   ```
2. Decrypt *file.gpg* into *file.txt* using the same password used to encrypt file.txt:
   ```bash
   gpg --decrypt file.gpg
   ```
