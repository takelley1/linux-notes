
## NGINX

- **See also:**
  - [Nginx.org docs](http://nginx.org/en/docs/)
  - [Nginx.com docs](https://docs.nginx.com/)

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
