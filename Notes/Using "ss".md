# Using "ss"

"Socket statistics" (`ss`) is a `netstat`-like tool with slightly nicer formatting. Options:

* `-t` - Display TCP sockets
* `-u` - Display UDP sockets
* `-l` - Display listening sockets (not just established connections)
* `-p` - Show the process using the socket (broken?)
* `-n` - Show raw port numbers (not named services)

 For example, `ss -tulpn` will produce a nice list of open ports.

* [TryHackMe: Game Zone](https://tryhackme.com/room/gamezone)
* [Using "netstat"](./Using%20%22netstat%22.md)
