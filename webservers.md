## Apache Tomcat

- SSL:
  - See also: https://crunchify.com/step-by-step-guide-to-enable-https-or-ssl-correct-way-on-apache-tomcat-server-port-8443/
  - SSL configuration (in `conf/server.xml`):
    ```xml
        <Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
                   maxThreads="150" SSLEnabled="true">
            <SSLHostConfig>
                    <Certificate certificateFile="/opt/tomcat_certs/cert.pem" certificateKeyFile="/opt/tomcat_certs/certkey.pem"
                                 type="RSA" />
            </SSLHostConfig>
        </Connector>
    ```
## NGINX

- **See also:**
  - [Nginx.org docs](http://nginx.org/en/docs/)
  - [Nginx.com docs](https://docs.nginx.com/)
  - [Nginx wiki](https://www.nginx.com/resources/wiki/)
  - [Nginx file structure](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)
  - [Nginx performance tuning](https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration)
  - [Nginx security tuning](https://www.upguard.com/blog/how-to-build-a-tough-nginx-server-in-15-steps)
<br><br>
- `nginx -t` = Test server configuration.
<br><br>
- Minimal static HTTP webserver
  - Configration directives used:
    - [user](http://nginx.org/en/docs/ngx_core_module.html#user)
    - [worker_processes](http://nginx.org/en/docs/ngx_core_module.html#worker_processes)
    - [access_log](http://nginx.org/en/docs/http/ngx_http_log_module.html#access_log)
    - [error_log](http://nginx.org/en/docs/ngx_core_module.html#error_log)
    - [autoindex](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html)
    - [log_format](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format)
    - [server_name](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_name)
    - [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root)
```nginx
user              www-data;
worker_processes      auto;

events {}

http {
  log_format     main '$remote_addr - $remote_user [$time_local]  $status '
                      '"$request" $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

  access_log          /var/log/nginx/access.log  main;
  error_log           /var/log/nginx/error.log   error;
  autoindex           on;
  autoindex_localtime on;

  server {
    server_name  10.0.0.15;
    root         /var/www/mywebsite;
  }
}
```

- Server with *HTTP->HTTPS* and *IP->Domain* redirects
  - Configration directives used:
    - [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen)
    - [return](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)
    - [ssl_certificate](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate)
```nginx
server { # Redirect HTTP IP/domain to HTTPS domain.
    listen               80;
    server_name          _; # Matches everything (both IPs and domains).
    return 301           https://domain.example.com$request_uri;
}

server { # Redirect HTTPS IP to HTTPS domain.
    listen               443 ssl;
    server_name          10.0.0.5;
    ssl_certificate      /etc/nginx/cert.pem;
    ssl_certificate_key  /etc/nginx/certkey.pem;
    return 301           https://domain.example.com$request_uri;
}

server { # HTTPS domain.
    listen               443 ssl;
    server_name          domain.example.com;
    ssl_certificate      /etc/nginx/cert.pem;
    ssl_certificate_key  /etc/nginx/certkey.pem;
}
```

- [Server with HTTP authentication](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/)
  - [Using basic auth over HTTPS](https://security.stackexchange.com/a/17216)
  - Configration directives used:
    - [satisfy](https://nginx.org/en/docs/http/ngx_http_core_module.html#satisfy)
    - [deny](https://nginx.org/en/docs/http/ngx_http_access_module.html#deny)
    - [allow](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow)
    - [auth_basic](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic)
    - [auth_basic_user_file](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic_user_file)
```nginx
http {
    server {
        listen 192.168.1.23:8080;
        root   /usr/share/nginx/html;
        satisfy all;

        deny  192.168.1.2;
        allow 192.168.1.1/24;
        allow 127.0.0.1;
        deny  all;

        auth_basic           "Administrator’s Area";
        auth_basic_user_file /etc/apache2/.htpasswd;
    }
}
```

- [Context path-based reverse proxy server](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
  - Configration directives used:
    - [proxy_buffers](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffers)
    - [proxy_buffers_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffer_size)
    - [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)
```nginx
http {
    server {
        listen 80;
        root   /usr/share/nginx/html;
        proxy_buffers     16 4k;
        proxy_buffer_size    2k;

        location /some/path/ {
            proxy_pass https://10.0.0.10:8000;

            # Require authentication for this path.
            auth_basic           "Administrator’s Area";
            auth_basic_user_file /etc/apache2/.htpasswd;
        }
        location /some/other/path/ {
            proxy_pass http://10.0.0.15:80;
        }
    }
}
```

---
## [HAPROXY](http://www.haproxy.org/#docs)

- **See also**
  - [HAProxy concepts](https://www.digitalocean.com/community/tutorials/an-introduction-to-haproxy-and-load-balancing-concepts)
  - [HAProxy config file format](https://www.haproxy.com/blog/the-four-essential-sections-of-an-haproxy-configuration/)
  - [HAProxy logging](https://www.haproxy.com/blog/introduction-to-haproxy-logging/)
<br><br>
- Context path-based reverse proxy server example
  - Configration directives used:
    - global
      - [log](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#log)
      - [pidfile](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#pidfile)
      - [maxconn](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#maxconn)
      - [user](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#user)
      - [group](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#group)
    - defaults
      - [mode](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#mode)
      - [log global](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#3.10-log%20global)
      - [log-format](https://www.haproxy.com/de/blog/haproxy-log-customization/)
      - [balance](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#balance)
      - option
        - [httpchk](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#option%20httpchk)
        - [dontlognull](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#option%20dontlognull)
        - [http-server-close](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#option%20http-server-close)
        - [forwardfor](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4-option%20forwardfor)
        - [redispatch](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#option%20redispatch)
      - [retries](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#retries)
      - timeout
        - [queue](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4.2-timeout%20queue)
        - [client](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#timeout%20client)
        - [server](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#timeout%20server)
        - [http-request](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#timeout%20http-request)
        - [http-keep-alive](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4-timeout%20http-keep-alive)
        - [connect](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4.2-timeout%20connect)
        - [check](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#timeout%20check)
    - frontend
      - [bind](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#bind)
      - stats
        - [enable](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#stats%20enable)
        - [uri](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#stats%20uri)
        - [refresh](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4-stats%20refresh)
      - [http-request](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#http-request)
        - [redirect](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4.2-http-request%20redirect)
        - [replace-path](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4.2-http-request%20replace-path)
      - [acl](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4.2-acl)
        - [path_beg](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#7.3.6-path)
      - [use_backend](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4-use_backend)
      - [default_backend](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#default_backend)
    - backend
      - [server](http://cbonte.github.io/haproxy-dconv/2.4/configuration.html#4.2-server)
```haproxy
global
    log       local0 info
    pidfile   /var/run/haproxy.pid
    maxconn   1000
    user      root
    group     root

defaults
    mode         http
    log          global
    log-format   "[%Tl] client=%ci, frontend=%fi:%fp, backend=%b, path=%HU, method=%HM, status=%ST"
    balance      roundrobin
    option       httpchk GET /
    option       dontlognull
    option       http-server-close
    option       forwardfor except 127.0.0.0/8
    option       redispatch
    retries      3
    timeout      queue             1m
    timeout      client            1m
    timeout      server            1m
    timeout      http-request      5s
    timeout      http-keep-alive   5s
    timeout      connect           5s
    timeout      check             5s

frontend stats # Enable the HAProxy stats page.
    bind *:9000
    stats enable
    stats uri /
    stats refresh 5s

frontend http # Redirect HTTP to HTTPS.
    bind *:80
    http-request redirect scheme https code 301 if !{ ssl_fc }

frontend https
    bind *:443 ssl crt /usr/local/etc/haproxy/cert.pem

    # Determine which backend to use based on path.
    acl acl_pihole path_beg /admin /pihole
    acl acl_heimdall path_beg /css /js /img /favicon /items /users /apple-icon /ms-icon /tags /settings

    use_backend pihole if acl_pihole
    use_backend heimdall if acl_heimdall
    default_backend heimdall

# --------------------------------------------------------

backend pihole
    server s_pihole 10.0.0.15:80 check

backend heimdall
    http-request replace-path /heimdall/?(.*) /\1
    server s_heimdall 10.0.0.10:443 check ssl verify none
```

- Subdomain-based reverse proxy server example
```haproxy
    acl acl_home_assistant hdr_dom(host) -i homeassistant.domain.example.com
    acl acl_pihole hdr_dom(host) -i pihole.domain.exmaple.com

    use_backend home_assistant if acl_home_assistant
    use_backend pihole if acl_pihole
```

---
## [APACHE](https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html)

- SSL configuration:
  - Install the `mod_ssl` package. A file in `/etc/httpd/conf.d/ssl.conf` will be automatically added along with self-signed certs.
<br><br>
- Subdomain-based reverse proxy config.
  - Requires creating a separate DNS domain for admin.example.com.
    - 1 DNS A record pointing admin.example.com to the IP of the reverse proxy.
    - 1 DNS CNAME wildcard record pointing *.admin.example.com to the A record.
  - Requires a wildcard certificate for *.admin.example.com.
```apache
<VirtualHost admin.example.com:80> # Force upgrade from http to https.
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

    <Location /> # Heimdall
        ProxyPass "https://127.0.0.1:8443/"
        ProxyPassReverse "https://127.0.0.1:8443/"
        Order deny,allow
        Allow from all
    </Location>

    <Location /chat> # Rocket.Chat
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

- Genric reverse proxy config using context paths and load balancer.
```apache
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

---
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
## [REVERSE PROXY](https://en.wikipedia.org/wiki/Reverse_proxy)

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

<img src="images/reverse-proxy.jpg" width="500"/>


## [FORWARD PROXY](https://www.jscape.com/blog/bid/87783/forward-proxy-vs-reverse-proxy)

<img src="images/forward-proxy.jpg" width="500"/>
