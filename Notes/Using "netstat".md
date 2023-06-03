# Using “netstat”
The `netstat` command is found on both Linux and Windows, though it has slightly different options.

| Linux |  Windows | Description                                       |
| -----:| --------:|:------------------------------------------------- |
|  `-a` |     `-a` | Shows all sockets (listening and established)     |
|  `-i` |          | Shows per interface statistics                    |
|  `-l` |          | Show *only* listening ports                       |
|  `-n` |     `-n` | Do *not* resolve IP addresses or port numbers     |
|  `-p` |    `-ob` | Show PID and binary using the socket (needs root) |
|  `-s` |          | Show protocol statistics                          |
|  `-t` | `-p TCP` | Show TCP sockets only                             |
|  `-u` | `-p UDP` | Show UDP sockets only                             |
|  `-x` |          | Show UNIX sockets (kernel-only "network") only    |

## Additional Resources
* [TryHackMe: Enumeration](https://tryhackme.com/room/enumerationpe)
