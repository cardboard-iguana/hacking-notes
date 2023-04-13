# Hypertext Transfer Protocol (HTTP)

## A Minimal HTTP Request

```http
GET / HTTP/1.1
host: something

```

(Note the blank line at the end.)

## Useful HTTP Headers

* Server - Web server information (Apache, NGINX, etc.); useful for recon.
* True-Client-IP - Override the client IP address (direct connections to servers).
* X-Forwarded-For - Override the client IP address (connections forwarded through proxies).
* X-Powered-By - Added by some application engines to advertise themselves; useful for recon.
* Content-Type - Specifies the body content; normally only set by the client for POST/PATCH requests (for example, form data uses application/x-www-form-urlencoded.
* Content-Length - The length of the body in bytes (which is just characters for ASCII) for POST requests.

There are other headers (for example, Cookie), and arbitrary additional X-prefixed (non-standard) headers can also be added.

* [Content-Length (MDN)](https://developer.mozilla.org/docs/Web/HTTP/Headers/Content-Length)
