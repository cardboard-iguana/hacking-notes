# Enumerate Linux Environments

## Useful Commands

* `cat /etc/issue`
* `cat /etc/passwd`
* `cat /proc/version`
* `env`
* `find`
* `getcap` - find and list executable *capabilities*
* `history`
* `hostname`
* `id`
* `ifconfig`
* `ip route`
* `ls`
* `netstat -ano` - list all listening parts and established connections, no domain resolution
* `netstat -i` - list per interface statistics
* `netstat -l` - list *only* listening ports
* `netstat -p` - list protocol and service information (requires root to see everything)
* `netstat -s` - list protocol statistics
* `ps auxfww` - show process tree
* `ps auxww` - show lots and lots of process info
* `sudo -l`
* `uname -a`

## Useful Scripts

* [LinPeas](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS)
* [LinEnum](https://github.com/rebootuser/LinEnum)
* [LES (Linux Exploit Suggester)](https://github.com/mzet-/linux-exploit-suggester)
* [Linux Smart Enumeration](https://github.com/diego-treitos/linux-smart-enumeration)
* [Linux Priv Checker](https://github.com/linted/linuxprivchecker)

## References

* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
* [How to Find Executables with SUID Capabilities](./How%20to%20Find%20Executables%20with%20SUID%20Capabilities.md)
* [How to Use "find" with File Metadata](./How%20to%20Use%20%22find%22%20With%20File%20Metadata.md)
* [Using "netstat"](./Using%20%22netstat%22.md)
* [Using "ps"](./Using%20%22ps%22.md)
* [Enumerate "sudo" Access](./Enumerate%20%22sudo%22%20Access.md)
