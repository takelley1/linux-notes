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
