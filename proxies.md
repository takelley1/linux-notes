## Proxies

### [Reverse Proxy](https://en.wikipedia.org/wiki/Reverse_proxy)

- **See also:**
  - [Reverse proxy performance](https://www.imperva.com/learn/performance/reverse-proxy/)
<br><br>
- Used for security, high-availability, load-balancing, and centralized authentication/authorization.
- Allows many different isolated servers to provide their services behind a single domain.
- As far as the client is concerned, the reverse proxy server is the sole source of all content.

> Httpd itself does not generate or host the data, but rather the content is obtained by one or several
> backend servers,vwhich normally have no direct connection to the external network. As httpd receives a
> request from a client, the request itself is proxied to one of these backend servers, which then handles
> the request, generates the content and then sends this content back to httpd, which then generates the
> actual HTTP response back to the client.

<img src="images/reverse_proxy.jpg" width="500"/>


---
### [Forward Proxy](https://www.jscape.com/blog/bid/87783/forward-proxy-vs-reverse-proxy)

<img src="images/forward_proxy.jpg" width="500"/>
