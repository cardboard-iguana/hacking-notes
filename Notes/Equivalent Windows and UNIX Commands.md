# Equivalent Windows and *NIX Commands
*NIX ↔ Windows command equivalencies (more-or-less):

* cat ↔ type
* dig ↔ nslookup
* grep ↔ findstr / select
* ifconfig ↔ ipconfig
* ls ↔ dir
* more ↔ more
* netstat ↔ netstat
* ping ↔ ping
* shutdown ↔ shutdown
* sleep ↔ timeout
* sudo ↔ runas
* tcpdump ↔ windump
* traceroute ↔ tracert
* wget ↔ wget
* hostname ↔ hostname
* whoami ↔ whoami

## cat
```bash
# Use cat to add line numbers to a file!
#
cat -n < $FILE

# Only number non-blank lines
#
cat -b < $FILE
```

* [What is the Windows equivalent of the Unix command cat?](https://superuser.com/questions/434870/what-is-the-windows-equivalent-of-the-unix-command-cat#434876)

## dig
```bash
# dig command syntax; only $DOMAIN is required
#
dig @$NAME_SERVER $DOMAIN $QUERY_TYPE

# Examples
#
dig @8.8.8.8 microsoft.com A
dig @1.1.1.1 tryhackme.com
dig          google.com    MX
```

## grep
```bash
# Case-insensitive grep
#
grep -i $STRING $FILE

# Recursive grep of all files in a folder (and its subfolders)
#
grep $STRING -r $DIRECTORY
```

## findstr
```powershell
# Use findstr to filter the output of systeminfo (or another
# command):
#
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
```

## dir
The `dir` command accepts wildcard listings (`*.txt`, etc.), and will perform a subdirectory search if given the `/S` flag. For example:

```powershell
dir /S /P example.txt
```

## ipconfig
### Display Current DNS Settings
```powershell
ipconfig /displaydns | more
```

### Flush Local DNS Cache
```powershell
ipconfig /flushdns
```

## nslookup
```powershell
# nslookup command syntax; only $DOMAIN is required
#
nslookup -type=$QUERY_TYPE $DOMAIN $NAME_SERVER

# Examples
#
nslookup -type=A  microsoft.com 8.8.8.8
nslookup          tryhackme.com 1.1.1.1
nslookup -type=MX google.com
```

The `nslookup.exe` binary also provides a nice shell if run without any arguments. From here, a server to query can be specified (`server $IP_ADDRESS`), and then `ls -d $DOMAIN` will provide *all* records related to the specified `$DOMAIN` (including, it would seem, subdomain information!).

### Additional Resources
* [TryHackMe: The Lay of the Land](https://tryhackme.com/room/thelayoftheland)

## ping
Windows `ping` uses the `-n` flag to specify the number of packets sent (in contrast to Linux’s `-c`).

## runas
```powershell
runas /user:$USERNAME $EXECUTABLE
```

`$USERNAME` may also be specified as `$DOMAIN\$USERNAME` for domain-joined machines.

`$EXECUTABLE` is treated normally (as if not prefixed by the `runas` command), so a full or relative path is only necessary when it’s not already in the Windows path.

If credentials are saved for a particular user (use `cmdkey /list` to check), then the `/savecred` flag will apply them automatically!

* [Windows: Run as Different User](https://www.shellhacks.com/windows-run-as-different-user/)
* [Windows runas command syntax and examples](https://www.windows-commandline.com/windows-runas-command-prompt/)

## whoami
Windows’ `whoami` supports a couple of useful flags:

* `/all` - return detailed user information.
* `/privs` - return information about current user privileges.
