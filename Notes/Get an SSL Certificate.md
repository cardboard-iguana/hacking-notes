# Get an SSL Certificate

## Self-Signed

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
            -out $SITE.crt -keyout $SITE.key
```

## From a Real Registrar

**Note:** Now that [Let's Encrypt](https://letsencrypt.org/) exists, the below information is a lot less useful…

Generate a unique site key:

```bash
openssl genrsa -out $SITE.key 4096
```

Generate a certificate signing request:

```bash
openssl req -new -config $SITE.cnf \
            -key $SITE.key -out $SITE.csr
```
