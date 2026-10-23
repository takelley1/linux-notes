## HTTP

### Methods

- `GET` = Request the resource at the URL.
- `PUT` = Replace a resource at the URL with what's in the request. Always idempotent.
- `PATCH` = Modify a resource at the URL with what's in the request.
- `POST` = Submit data to the URL. More flexible than `PATCH`.

### Response codes

- Client errors
  - `400` = You messed up.
  - `401 Unauthorized` = ("Who are you?") Authentication required, possibly due to missing token.
  - `403 Forbidden` = ("You can't do that") The server understood the request but refused to process it.
  - `405 Method Not Allowed` = You `POST`ed a `GET` endpoint, for example.
  - `429 Too Many Requests` = You hit that API too many times.
- Server errors
  - `500 Internal Server Error` = The server messed up.
  - `502 Bad Gateway` = The reverse proxy didn't get a valid response from the upstream server.
  - `503 Service Unavailable` = The server is under maintenance or not yet ready.
  - `504 Gateway Timeout` = The reverse proxy didn't receive an upstream response in time.
- Misc
  - `301 Moved Permanently` = Permanent redirect to another URL. Doesn't preserve HTTP method (`308` preserves method)
  - `302 Found` = Temporary redirect. Doesn't preserve HTTP method (`307` preserves method)

### Headers

- Authentication
  - `Authorization` = Sends credentials to the server, like `Bearer auHAkCiA...`. When you login to a server, it issues a token. The client sends the token in subsequent requests.
  - `Set-Cookie` = Sent by the server to create a cookie, like `Set-Cookie: session=abc123; HttpOnly; Secure; SameSite=Lax`.
  - `Cookie` = Arbitrary info stored by the browser and sent by the client, like `Cookie: session=abc123`. Can also be used by clients to authenticate requests.
- Proxying
  - `Host` = Set by client to identify the target hostname of the server, like `api.example.com`. Used by reverse proxies to route requests to the correct backend.
  - `X-Forwarded-Host` = Set by reverse proxies to preserve the original `Host` requested by a client.
  ```
  Client
    | Host: api.example.com
    v
  NGINX
    | Host: backend.internal
    | X-Forwarded-Host: api.example.com
    v
  Backend
  ```
  - `X-Forwarded-For` = Set to the original client IP by the reverse proxy, like `203.0.113.10`. Allows the backend to tie requests back to individual clients.
  - `X-Forwarded-Proto` = Set to the original client protocol by the reverse proxy, like `http` or `https`. Useful if the client is talking HTTPS to the proxy, and the proxy is talking HTTP to the backend. Can help the backend know to generate `https://` URLs when redirecting clients.
- CORS headers (see below)
  - `Origin` = Which site initiated the request
  - `Access-Control-Allow-Origin` = Sent by sites to allow other sites to read its responses.
 
### CORS (Cross-Origin Resource Sharing)

- Browsers enforce a Same-Origin Policy to prevent JavaScript from reading HTTP responses from other sites (prevent `evil.com` from reading authenticated responses from `bank.com`). CORS relaxes this rule.
- If `frontend.com` wants to talk to `backend.com`, then `backend.com` must respond with a CORS header for the browser to permit `frontend.com` to read the response
  ```
  # Frontend Javascript wants to run:
  fetch("https://backend.com/users")
  ```
  ```
  # The browser issues a request to the backend:
  GET /users
  Origin: https://frontend.com
  ```
  ```
  # The backend responds with a CORS header allowing the frontend:
  HTTP/1.1 200 OK
  Access-Control-Allow-Origin: https://frontend.com

  # The browser then allows the JS to read the response from backend.com
  ```
