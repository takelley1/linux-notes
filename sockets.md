## Unix Domain Sockets

- Kernel-mediated communication between processes on the same machine.
- One process creates and binds to a socket as a file descriptor, then another can listen to it.
- Arbitrary bytes can be exchanged from one process to another, or vice versa. Communication is bidirectional.
- Faster and lower overhead than using TCP over `localhost` since it bypasses the network stack.
<br><br>
- Using `curl` to talk to the Docker socket:
```
curl --unix-socket /var/run/docker.sock
http://localhost/containers/json
```
- Docker daemon sees:
```
GET /containers/json HTTP/1.1
Host: localhost
```
- This is HTTP over a domain socket rather than HTTP over TCP/IP
