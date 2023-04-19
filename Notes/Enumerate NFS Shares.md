# Enumerate NFS Shares

NFS shares can be enumerated by nmap during scanning:

```bash
nmap -v -sT --script nfs-ls,nfs-statfs,nfs-showmount \
     -p$PORT $IP
```

Normally `$PORT` is 111.

* [TryHackMe: Complete Beginner](https://tryhackme.com/path/outline/beginner)
* [Using "nmap"](./Using%20%22nmap%22.md)
