
## [SSH](https://www.openssh.com/manual.html)

- **See also:**
  - [SSH essentials](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys)
  - [sshd_config man page](https://www.freebsd.org/cgi/man.cgi?sshd_config(5))
  - [SSH jump hosts](https://wiki.gentoo.org/wiki/SSH_jump_host)

### Examples

- `ssh ansible@10.0.0.5 'bash -s' < myscript.sh` = [Run a local script remotely](https://stackoverflow.com/questions/305035/how-to-use-ssh-to-run-a-local-shell-script-on-a-remote-machine)

### [Key generation best-practices](https://security.stackexchange.com/questions/143442/what-are-ssh-keygen-best-practices)

```
ssh-keygen -t ed25519 -o -a 100
ssh-keygen -t rsa -b 4096 -o -a 100
```

### [Connection process](https://www.digitalocean.com/community/tutorials/understanding-the-ssh-encryption-and-connection-process)

1. Server authentication
   1. Client initiates TCP connection to server.
   2. Server provides client its public host key. This proves server is the same server that's been connected to before.
   3. Diffie-Hellman is used to create a session key.
   4. Server creates and signs challenge number with its own private host key, then sends it to client.
   5. Client verifies challenge number signature to confirm server is in posession of its public host key.
2. User authentication (using key pairs)
   1. Server checks requested server user's *authorized_keys* file for client user's public key.
   2. Server sends client a challenge number encrypted with the client user's public key.
   3. Client decrypts challenge number using the client user's private key.
   4. Client MD5 hashes the *decrypted challenge number + session key* string.
   5. Server MD5 also hashes the *original challenge number + session key* string.
   6. Client sends the MD5 digest to server.
   7. Server compares its MD5 digest to client's MD5 digest. If they match, the requested user is authenticated.

### [Files](https://www.techrepublic.com/article/the-4-most-important-files-for-ssh-connections/)

- **See also:**
  - [authorized_keys vs known_hosts](https://security.stackexchange.com/questions/20706/what-is-the-difference-between-authorized-keys-and-known-hosts-file-for-ssh)
<br><br>
- `~/.ssh/id_rsa`
  - Kept on the client.
  - This is the private key of the client. It is *always* kept on the client and is used to decrypt authentication
    challenges sent by the server.
- `~/.ssh/id_rsa.pub`
  - Kept on the client.
  - This is the public key of the client. It is added to servers' *authorized_keys* file to enable login.
<br><br>
- `~/.ssh/known_hosts`
  - Kept on the client.
  - Contains the public keys of servers (host keys) this user trusts.
  - Servers maintain their own host keypairs (in /etc/ssh) to prove their identity to connecting clients.
    - Via a key-exchange, clients can know they're connecting to the same host and not an impersonator or man-in-the-middle
      (because the server can prove it has posession of the matching private key).
<br><br>
- `~/.ssh/authorized_keys`
  - Kept on the server.
  - Contains the public keys of users (user keys) allowed to login to the requested account.

- `~/.ssh/config`
  - Kept on the client.
  - Contains personal configuration settings for SSH, such as host aliases.

```
# Sample ~/.ssh/config

Host mywebserver
  Hostname 10.1.0.1
  Proxyjump 10.0.0.15

Host another_server
  Hostname 10.0.0.20
```
