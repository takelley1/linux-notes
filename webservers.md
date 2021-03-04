
## NGINX

SSL configuration example with HTTP redirect:
```nginx
server {
    listen 80;
    server_name 10.0.0.5;
    return 301 https://10.0.0.5$request_uri;
}

server {
  listen 443;
  server_name 10.0.0.5;
  ssl on;
  ssl_certificate /etc/opt/rh/rh-nginx116/nginx/cert.pem;
  ssl_certificate_key /etc/opt/rh/rh-nginx116/nginx/certkey.pem;
}
```
