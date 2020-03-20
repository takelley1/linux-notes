
**A proxy acts on behalf of the client(s), while a reverse proxy acts on behalf of the server(s).** <sup>[1]</sup> 

## REVERSE PROXY <sup>[4]</sup> 

Also known as a *gateway server*.

- Used for security, high-availability, load-balancing, and centralized authentication/authorization.
- Allows many different isolated servers to provide their services behind a single domain.
- As far as the client is concerned, the reverse proxy server is the sole source of all content.

```
Httpd itself does not generate or host the data, but rather the content is obtained by one or several
backend servers,vwhich normally have no direct connection to the external network. As httpd receives a
request from a client, the request itself is proxied to one of these backend servers, which then handles
the request, generates the content and then sends this content back to httpd, which then generates the
actual HTTP response back to the client.
```

<img src="/images/reverse-proxy.jpg" width="500"/> <sup>[2]</sup>

### Configuration examples

```xml
# Reverse proxy config for the localhost using subdomains.

<Proxy *>
Require all granted
</Proxy>

<VirtualHost first.example.com:80>
    ServerName first.example.com
    ProxyPass / http://localhost:1234
</VirtualHost>

<VirtualHost second.example.com:80>
    ServerName second.example.com
    ProxyPass / http://localhost:5678
</VirtualHost>
```

```xml
# Reverse proxy config using paths and forced HTTPS redirection.

<VirtualHost server.example.com:80>
    ServerName server.example.com
    Redirect permanent / https://server.example.com/
</VirtualHost>

<VirtualHost server.example.com:443>
    ServerAdmin example@example.com
    ServerName server.example.com

    LogLevel info
    ErrorLog /var/log/httpd/proxy.log
    TransferLog /var/log/httpd/proxy.log

    SSLEngine On
    SSLCertificateFile /etc/httpd/certificate.crt
    SSLCertificateKeyFile /etc/httpd/certificate.key

    <Location /chat>
        Order allow,deny
        Allow from all
        ProxyPass http://localhost:3000/chat
        ProxyPassReverse http://127.0.0.1:3000/chat
    </Location>

</VirtualHost>
```

```xml
# Reverse proxy config using paths and load balancer.

# Requests to the /bitbucket directory are proxied to a different server.
<Location /bitbucket>
    ProxyPass https://10.0.0.50:443
    ProxyPassReverse https://10.0.0.50:443
</Location>

# Requests to the /jenkins directory are proxied to a cluster for load balancing.
<Location /jenkins>
    ProxyPass balancer://jenkins-cluster
    ProxyPassReverse balancer://jenkins-cluster
</Location>

# Add servers to the jenkins cluster.
<Proxy balancer://jenkins-cluster>
    BalancerMember https://jenkins-cluster-server1.example.com
    BalancerMember https://jenkins-cluster-server2.example.com
</Proxy>
```  
<sup>[4]</sup> 


## FORWARD PROXY

<img src="/images/forward-proxy.jpg" width="500"/> <sup>[2]</sup>

[1]: https://en.wikipedia.org/wiki/Reverse_proxy  
[2]: https://www.imperva.com/learn/performance/reverse-proxy/  
[3]: https://www.jscape.com/blog/bid/87783/forward-proxy-vs-reverse-proxy  
[4]: https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html  
