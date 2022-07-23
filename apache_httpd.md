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
