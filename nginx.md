## [Nginx](http://nginx.org/en/docs/)

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

        auth_basic           "Administrator's Area";
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
            auth_basic           "Administrator's Area";
            auth_basic_user_file /etc/apache2/.htpasswd;
        }
        location /some/other/path/ {
            proxy_pass http://10.0.0.15:80;
        }
    }
}
```
