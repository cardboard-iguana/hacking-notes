# Using SSH
## Port Forwarding
The most important thing to remember about SSH port forwarding is that specifications are read as `$FROM_SPEC:$TO_SPEC`. So a local port forward creates a port that the *local* system uses to communicate with the *remote* host/port specified by `$TO_SPEC`, while a remote port forward creates a port that the *remote* system uses to communicate with the *local* host/port specified by `$TO_SPEC`. (It’s actually a *little* more complicated than this, as the `$FROM_SPEC` might be something like `*:8888`, which opens up port 8888 to *all* systems on the local subnet, not just localhost.

*Port forwarding is always one-way, from the created port to the destination port.*

### Local Port Forwarding
Create a tunnel on the local machine (`-L`) using port `$LOCAL_PORT`, to `$REMOTE_HOST:$REMOTE_PORT` *relative to the remote machine*:

```bash
ssh -L $LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT \
       $TARGET_USER@$TARGET_HOST
```

### Remote Tunneling
Create a tunnel on the remote machine (`-R`) using port `$REMOTE_PORT`, to `$LOCAL_HOST:$LOCAL_PORT` *relative to the local machine*:

```bash
ssh -R $REMOTE_PORT:$LOCAL_HOST:$LOCAL_PORT \
       $TARGET_USER@$TARGET_HOST
```

### Additional Resources
* [TryHackMe: Lateral Movement and Pivoting](https://tryhackme.com/room/lateralmovementandpivoting)

## Dynamic Port Forwarding (a.k.a. SSH as a Proxy)
It’s also possible to use SSH as a SOCKS5 proxy (with a tool like `proxychains`). As of OpenSSH 7.6, proxy ports can be opened up for both local *and* remote systems.

You need to already have access to a $TARGET machine. SSH from the $TARGET back to the $ATTACKER box:

```bash
# Open up $LOCAL_PROXY_PORT on $REMOTE_HOST, allowing users
# on the local side to access services on the remote network.
#
ssh -D $LOCAL_PROXY_PORT $USER@$REMOTE_HOST

# Open up $REMOTE_PROXY_PORT on $REMOTE_HOST, allowing users
# on the remote side to access services on the local network.
#
ssh -R $REMOTE_PROXY_PORT $USER@$REMOTE_HOST
```

### Additional Resources
* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)
* [TryHackMe: Lateral Movement and Pivoting](https://tryhackme.com/room/lateralmovementandpivoting)
* [SSH Reverse socks tunnel](https://superuser.com/questions/370930/ssh-reverse-socks-tunnel/1538581)
