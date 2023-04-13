# Pull SSL Certificates from an External Server

```bash
# Pull a server's certificate:
#
openssl s_client -connect ${SERVER}:${PORT}

# When dealing with a mail server using STARTTLS, we need
# to modify this a bit:
#
openssl s_client -connect ${SERVER}:${PORT} \
                 -starttls smtp

# Pull the entire certificate chain:
#
openssl s_client -connect ${SERVER}:${PORT} -showcerts

# Get certificate information:
#
openssl x509 -in $CERT -text -noout

# Calculate a SHA1 fingerprint:
#
openssl x509 -noout -in $CERT -fingerprint

# Calculate a MD5 fingerprint:
#
openssl x509 -noout -in $CERT -fingerprint -md5
```

* [How to inspect remote SMTP server's TLS certificate?](https://serverfault.com/a/131628)
* [SSL Shopper Certificate Decoder](https://www.sslshopper.com/certificate-decoder.html)
