# Send a Command Using OpenSSL

```bash
echo "$TEXT" | openssl s_client $HOST:$PORT -ign_eof
```

The `-ign_eof` keeps the s_client open on EOF, which can (does?) get sent after each command. This is necessary if you, say, want to read the connected server's respond to sending it $TEXT.
