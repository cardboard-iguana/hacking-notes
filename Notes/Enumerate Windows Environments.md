# Enumerate Windows Environments

## Important Commands

* `cmdkey /list` - show saved credentials
* `driverquery` - list installed drivers
* `hostname` - return system hostname
* `net group "Domain Admins" /domain` - list domain admins
* `net localgroup` - list all (local) groups
* `net localgroup $GROUP` - list user in group `$GROUP`
* `net user` - list all (local) users
* `net user $USERNAME` - get details for user `$USERNAME`
* `netstat` - query open/listening ports
* `query session` - list other users who are currently logged in
* `reg` - query (and manipulate) registry enteries
* `sc` - query (and manipulate) services (conflicts with a PowerShell built-in!)
* `schtasks` - list scheduled tasks
* `systeminfo` - return system info
* `whoami /priv` - current user + privileges

## net

Windows' `net` command is can also be used to *manipulate* user and group information (*if* you already have admin/SYSTEM permission)! For example:

```powershell
# Change a user's password
#
net user $USERNAME $PASSWORD

# Add a user to a domain
#
net user $USERNAME /add /domain

# Make a user a domain admin
#
net group "Domain Admins" $USERNAME /add /domain
```

## netstat

The `netstat` command on Windows *almost* works exactly like its Linux equivalent. The difference is that `-o` displays the PID of the process using the connection on Windows (which, IMHO, is more useful than `-o` on Linux).

* [Using "netstat"](./Using%20%22netstat%22.md)

## systeminfo

Use `findstr` to filter the output of `systeminfo`:

```powershell
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
```

## wmic

The `wmic` command is extremely useful, but is also deprecated (*because* of its usefulness to attackers!). It can be used on Windows 10 21H1 and earlier. For later systems, PowerShell command-lets will need to be used instead (which increases the risk that activity will be logged).

* `wmic product` - list all installed software (but misses 32-bit applications installed on a 64-bit OS)
* `wmic service get name,displayname,pathname,startmode` - list all services
* `wmic qfe get Caption,Description,HotFixID,InstalledOn` - list installed updates
* `wimc service list brief` - another way of listing services

## Useful Scripts

* [WinPEAS](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS)
* [PowerUp](https://github.com/PowerShellMafia/PowerSploit/tree/master/Privesc)
* [Windows Exploit Suggester](https://github.com/AonCyberLabs/Windows-Exploit-Suggester)
* [Metasploit](./Using%20Metasploit.md)

Notes:

* WinPEAS is detected and quarantined by Microsoft Defender (service `windefend`) by default.
* PowerUp may require an unrestricted PowerShell session (`powershell -nop -exec bypass`), which can raise alerts.
* Windows Exploit Suggester analyzes the output of `systeminfo`, and can be run on the attacker's machine.
* The `multi/recon/local_exploit_suggester` module works through Meterpreter to analyze a Windows system for potential vulnerabilities.
