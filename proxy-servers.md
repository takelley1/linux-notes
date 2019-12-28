
**A proxy acts on behalf of the client(s), while a reverse proxy acts on behalf of the server(s)** [1]**.**

## REVERSE PROXY
also known as a *gateway server*

- Used for security, high-availability, load-balancing, and centralized authentication/authorization. [4]
- Allows many different isolated servers to provide their services behind a single domain
- As far as the client is concerned, the reverse proxy server is the sole source of all content. [4]

```
httpd itself does not generate or host the data, but rather the content is obtained by one or several
backend servers,which normally have no direct connection to the external network. As httpd receives a
request from a client, the request itself is proxied to one of these backend servers, which then handles
the request, generates the content and then sends this content back to httpd, which then generates the
actual HTTP response back to the client. [4]
```

![reverse-proxy](/images/reverse-proxy.jpg) [2]

```xml
apache config (httpd.conf) [4]

    # Requests to the /bitbucket directory are proxied to a different server
    <Location /bitbucket>
        ProxyPass https://bitbucket-server.domain
        ProxyPassReverse https://bitbucket-server.domain
    </Location>

    # Requests to the /jenkins directory are proxied to a cluster for load balancing
    <Location /jenkins>
        ProxyPass balancer://jenkins-cluster
        ProxyPassReverse balancer://jenkins-cluster
    </Location>

    # Add servers to the jenkins cluster
    <Proxy balancer://jenkins-cluster>
        BalancerMember https://jenkins-cluster-server1.domain
        BalancerMember https://jenkins-cluster-server2.domain
    </Proxy>
```  


## FORWARD PROXY

![forward-proxy](/images/forward-proxy.jpg) [2]

[1] https://en.wikipedia.org/wiki/Reverse_proxy  
[2] https://www.imperva.com/learn/performance/reverse-proxy/  
[3] https://www.jscape.com/blog/bid/87783/forward-proxy-vs-reverse-proxy  
[4] https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html

