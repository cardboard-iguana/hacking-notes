# Enumerate Samba Users and Shares

## NMAP

CIFS users and shares can be enumerated by nmap during scanning:

```bash
nmap -vv -sT \
     --script smb-enum-shares.nse,smb-enum-users.nse \
     -p445 $TARGET_IP
```

NOTE: While smb-enum-shares.nse returns results for UNIX-like systems, I've found smb-enum-users.nse to be kind of hit-or-miss.

* [Nmap SMB Scripts and SMB Enumeration Step-By-Step Pentesting Guide](https://www.infosecademy.com/nmap-smb-scripts-enumeration/)
* [Using "nmap"](./Using%20%22nmap%22.md)

## Metasploit

Metasploit can also enumerate CIFS users using the `auxiliary/smb/smb_lookupsid` module.

Like NMAP, I've found this to be a bit unreliable on UNIX-like systems.

* [Using Metasploit](./Using%20Metasploit.md)

## nbtscan

You can scan a target machine or network using nbtscan to see what hosts are running Samba.

```bash
nbtscan -r $NETWORK_IP/$CIDR_NETMASK
```

This won't give you detailed user and share information, but it will at least let you know what machines to target.

## enum4linux

For UNIX-like systems running Samba, enum4linux works well.

```bash
enum4linux -a $TARGET_IP
```

As of the time of this writing (November 5, 2021) however, it looks like enum4linux's normal user enumeration has been broken for quite some time. However, the "RID cycling" method of discovering users still works - so just call enum4linux with either the -r flag (to specifically use RID cycling to enumerate users) or the -a flag (which does a complete enumeration, including RID cycling) rather than the -U flag.

* [Enumerate SMB with Enum4linux & Smbclient](https://null-byte.wonderhowto.com/how-to/enumerate-smb-with-enum4linux-smbclient-0198049/)
* [Use of uninitialized value $user, what does this mean?](https://github.com/CiscoCXSecurity/enum4linux/issues/4)

## smbclient

Samba services can be enumerated by smbclient using:

```bash
smbclient -L $SERVER_NAME -I $IP_ADDRESS
```

Here `$SERVER_NAME` is the machine's NetBIOS domain name, which can be found with enum4linux (see above).

* [Working With Samba](./Working%20With%20Samba.md)

## smbmap

Get Windows version information:

```bash
smbmap -H $IP_ADDRESS -v
```
