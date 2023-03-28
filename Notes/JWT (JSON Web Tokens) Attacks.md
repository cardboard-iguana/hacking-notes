# JWT (JSON Web Tokens) Attacks

JSON web token format: `$HEADER.$PAYLOAD.$SIGNATURE`, where each substring is (URL-safe) base64 encoded. These can be passed around as a user cookie, HTTP header, or queried from local storage.

`$HEADER` and `$PAYLOAD` are both JSON blobs, but `$SIGNATURE` is binary data.

* `$HEADER` takes the form `{ "alg": "RS256", "typ": "JWT" }`, where `alg` is a signing algorithm supported by the server.
* `$PAYLOAD` is a JSON blob containing various pieces of user information, which can include permissioning data. See jwt.io for a detailed breakdown.
* `$SIGNATURE` is the signature (using `alg` from the `$HEADER`) of `$HEADER.$PAYLOAD` (both parts base64 encoded) using a server-side secret (often an SSL key… but sometimes just a string!).

Use `basenc --base64url` and `basenc -d --base64url` to encode/decode URL-safe base64, rather than the `base64` binary. Be sure to strip the trailing `=` signs!

* [JSON Web Tokens](https://jwt.io)
* [Using "basenc"](Using%20%22basenc%22.md)

## Attacks

### "None" Attacks

Sometimes servers will also support the `NONE` signature type, which indicates that no signing is used (so the JWT is then just `$HEADER.$PAYLOAD.` - note the trailing dot!). If the server allows the `none` signing method, then it's often possible to just arbitrarily edit the `$PAYLOAD` to gain access to other users.

The base64-encoded version of `{"typ":"JWT","alg":"none"}` is `eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0`.

### Public Key Attacks

JWT algorithms can use a server's *public* key if `alg` is `HS256`. If the public half of the keypair used to sign the JWT is available somehow (for example, if it's been re-used as the server's HTTPS certificate), then we can harvest it and use it to forge new JWTs.

The base64-encoded version of `{"typ":"JWT","alg":"HS256"}` is `eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9Cg`. 

Use the following to generate a signature with the above `$HEADER` and the PEM-formatted `$PUBLIC_KEY_FILE` half of the public/private key to validate the JWTs (when `alg` is `RS256`):

```bash
echo -n "$HEADER.$PAYLOAD" | \
openssl dgst -sha256 -mac HMAC -macopt hexkey:$(cat $PUBLIC_KEY_FILE | xxd -p | tr -d '
') | \
sed -e 's/.*= //' | \
tr -d '
' | \
xxd -p -r | \
basenc --base64url | \
sed -e 's/=*$//'
```

### Brute-Forcing Weak Secrets

*If* a weak secret (a simple string) is used to sign the JWT token, then it is sometimes possible to brute-force it using JWT-Cracker.

* [lmammino / jwt-cracker](https://github.com/lmammino/jwt-cracker)
