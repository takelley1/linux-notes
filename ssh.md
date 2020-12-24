
## SSH

- **See also:**
  - [SSH essentials](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys)
  - [authorized_keys vs known_hosts](https://security.stackexchange.com/questions/20706/what-is-the-difference-between-authorized-keys-and-known-hosts-file-for-ssh)
  - [sshd_config man page](https://www.freebsd.org/cgi/man.cgi?sshd_config(5)
  - [ssh-keygen best practices](https://security.stackexchange.com/questions/143442/what-are-ssh-keygen-best-practices)

### Connection process <sup>[8]</sup>

1. Server authentication
   1. Client initiates TCP connection to server.
   1. Server provides client its public host key. This proves server is the same server that's been connected to before.
   1. Diffie-Hellman used to create session key.
   1. Server signs challenge number with its own private host key, sends it to client.
   1. Client verifies challenge number signature to confirm server is in posession of its public host key.
2. User authentication (using key pairs)
   1. Server checks requested server user's `authorized_keys` file for client user's public key.
   1. Server sends client challenge number encrypted with client user's public key.
   1. Client decrypts challenge number using client user's private key.
   1. Client MD5 hashes (decrypted challenge number + session key) string.
   1. Client sends MD5 digest to server.
   1. Server MD5 hashes (original challenge number + session key) string.
   1. Server compares its MD5 digest to client's MD5 digest. If they match, the requested user is authenticated.

### Files <sup>[6]</sup>

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
