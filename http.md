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
