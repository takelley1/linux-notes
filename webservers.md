
## REST API

Make POST API request to a Zabbix server:
```bash
curl -v -d \
  '{"jsonrpc": "2.0", "method": "host.get", \
    "params": {"startSearch": {"name": "BlaBlaBla"}}, \
    "id": 1, "auth": "f0fe38b3994cd953403477016e"}' \
    -H "Content-Type: application/json-rpc" \
    http://zabbix-server.example.com/api_jsonrpc.php
```

---
## NGINX

- **See also:**
  - [Nginx.org docs](http://nginx.org/en/docs/)
  - [Nginx.com docs](https://docs.nginx.com/)
  - [Nginx wiki](https://www.nginx.com/resources/wiki/)

Example with HTTP->HTTPS and IP->Domain redirects
```nginx
server {
    # Redirect HTTP IP and HTTPS domain to HTTPS domain.
    listen              80;
    server_name         _;
    return 301          https://domain.example.com$request_uri;
}

server {
    # Redirect HTTPS IP to HTTPS domain.
    listen              443 ssl;
    server_name         10.0.0.5;
    ssl_certificate     /etc/nginx/cert.pem;
    ssl_certificate_key /etc/nginx/certkey.pem;
    return 301          https://domain.example.com$request_uri;
}

server {
    # HTTPS domain.
    listen              443 ssl;
    server_name         domain.example.com;
    ssl_certificate     /etc/nginx/cert.pem;
    ssl_certificate_key /etc/nginx/certkey.pem;
```

Minimal static HTTP webserver
```nginx
user              www-data;
worker_processes      auto;

events {
  worker_connections  1024;
}

http {
  index    index.html;

  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

  server {
    listen       80;
    server_name  10.0.0.15;
    root         /var/www/mywebsite;
    access_log   /var/log/nginx/access.log  main;
    # [ debug | info | notice | warn | error | crit ]
    error_log    /var/log/nginx/error.log   error;

    # Enable indexing for directory paths.
    location / {
      autoindex on;
    }

  }
```

---
## [REVERSE PROXY](https://en.wikipedia.org/wiki/Reverse_proxy)

- **See also:**
  - [Reverse proxy performance](https://www.imperva.com/learn/performance/reverse-proxy/)
<br><br>
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

<img src="images/reverse-proxy.jpg" width="500"/>

### [Apache](https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html)

```apache
# Full Apache reverse proxy config for a handful of apps.
  # Requires creating a separate DNS domain for admin.example.com.
    # 1 DNS A record pointing admin.example.com to the IP of the reverse proxy.
    # 1 DNS CNAME wildcard record pointing *.admin.example.com to the A record.
  # Requires a wildcard certificate for *.admin.example.com.

# Force upgrade from http to https.
<VirtualHost admin.example.com:80>
    ServerName admin.example.com
    Redirect permanent / https://admin.example.com/
</VirtualHost>

<VirtualHost admin.example.com:443>
    ServerName admin.example.com

    LogLevel warn
    ErrorLog /var/log/httpd/admin.example.com.log
    TransferLog /var/log/httpd/admin.example.com.access.log

    SSLProxyCheckPeerName off
    SSLProxyCheckPeerCN off
    SSLProxyEngine on
    SSLEngine on
    SSLCertificateFile /etc/httpd/certs/admin.example.com.crt
    SSLCertificateKeyFile /etc/httpd/certs/admin.example.com.key

    ProxyRequests off
    ProxyPreserveHost on

    # Heimdall
    <Location />
        ProxyPass "https://127.0.0.1:8443/"
        ProxyPassReverse "https://127.0.0.1:8443/"
        Order deny,allow
        Allow from all
    </Location>

    # Rocket.Chat
    <Location /chat>
        Order allow,deny
        Allow from all
        RewriteEngine on
        RewriteCond %{HTTP:Upgrade} =websocket [NC]
        RewriteRule /var/www/(.*)           ws://localhost:3000/$1 [P,L]
        RewriteCond %{HTTP:Upgrade} !=websocket [NC]
        RewriteRule /var/www/(.*)           http://localhost:3000/$1 [P,L]

        ProxyPass http://127.0.0.1:3000/chat
        ProxyPassReverse http://127.0.0.1:3000/chat
    </Location>

</VirtualHost>

<VirtualHost spacewalk.admin.example.com:443>
    ServerName spacewalk.admin.example.com

    LogLevel warn
    ErrorLog /var/log/httpd/admin.example.com.log
    TransferLog /var/log/httpd/admin.example.com.access.log

    SSLProxyEngine on
    SSLEngine on
    SSLCertificateFile /etc/httpd/certs/admin.example.com.crt
    SSLCertificateKeyFile /etc/httpd/certs/admin.example.com.key

    ProxyPass "/" "https://spacewalk-hostname.example.com/"
    ProxyPassReverse "/" "https://spacewalk-hostname.example.com/"
</VirtualHost>

<VirtualHost graylog.admin.example.com:443>
    ServerName graylog.admin.example.com

    LogLevel warn
    ErrorLog /var/log/httpd/admin.example.com.log
    TransferLog /var/log/httpd/admin.example.com.access.log

    ProxyRequests off
    SSLEngine on
    SSLCertificateFile /etc/httpd/certs/admin.example.com.crt
    SSLCertificateKeyFile /etc/httpd/certs/admin.example.com.key
    <Proxy *>
        Order deny,allow
        Allow from all
    </Proxy>

    <Location />
        RequestHeader set X-Graylog-Server-URL "https://graylog.admin.example.com"
        ProxyPass "http://graylog-hostname.example.com:9000/"
        ProxyPassReverse "http://graylog-hostname.example.com:9000/"
    </Location>

</VirtualHost>

<VirtualHost vsphere.admin.example.com:443>
    ServerName vsphere.admin.example.com

    LogLevel warn
    ErrorLog /var/log/httpd/admin.example.com.log
    TransferLog /var/log/httpd/admin.example.com.access.log

    SSLProxyCheckPeerName off
    SSLProxyCheckPeerCN off
    SSLProxyEngine on
    SSLEngine on
    SSLCertificateFile /etc/httpd/certs/admin.example.com.crt
    SSLCertificateKeyFile /etc/httpd/certs/admin.example.com.key

    ProxyRequests off
    ProxyPreserveHost on
    ProxyPass "/" "https://vsphere-hostname.example.com/"
    ProxyPassReverse "/" "https://vsphere-hostname.example.com/"
</VirtualHost>
```

```apache
# Genric reverse proxy config using paths and load balancer.

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

## [FORWARD PROXY](https://www.jscape.com/blog/bid/87783/forward-proxy-vs-reverse-proxy)

<img src="images/forward-proxy.jpg" width="500"/>

