# Enumerate Windows Environments
## Important Commands
* `arp -a` — display the ARP cache (find other machines on the network!)
* `cmdkey /list` — show saved credentials
* `driverquery` — list installed drivers
* `hostname` — return system hostname
* `net accounts` — local machine policies
* `net accounts /domain` — domain policies
* `net group` — list domain groups
* `net group “Domain Admins” /domain` — list domain admins
* `net localgroup` — list all (local) groups
* `net localgroup administrators` — list local admins
* `net share` — list all shares (made available by the current machine)
* `net start` — list all running services (lots!)
* `net user` — list all (local) users
* `net user $USERNAME` — get details for user `$USERNAME`
* `netstat` — query open/listening ports
* `query session` — list other users who are currently logged in
* `reg` — query (and manipulate) registry enteries
* `sc` — query (and manipulate) services (conflicts with a PowerShell built-in!)
* `schtasks` — list scheduled tasks
* `systeminfo` — return system info
* `whoami /groups` — list current user’s groups
* `whoami /priv` — current user + privileges

### Additional Resources
* [TryHackMe: Enumeration](https://tryhackme.com/room/enumerationpe)

## Potentially Interesting Files
### PowerShell History
View PowerShell’s history.

```powershell
type $Env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt
```

Use `%USERPROFILE%` instead of `$Env:USERPROFILE` if running from `cmd.exe`.

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

### Unattended Windows Installation Data
Unattended Windows installations still need an administrative account; credentials can be left in one of the following files (if not cleaned up):

* `C:\Unattend.xml`
* `C:\Windows\Panther\Unattend.xml`
* `C:\Windows\Panther\Unattend\Unattend.xml`
* `C:\Windows\sSystem32\sysprep.inf`
* `C:\Windows\system32\sysprep\sysprep.xml`

Look for the `<Credentials/>` block.

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

### IIS Configuration Data
Placed where IIS stores passwords:

* `C:\inetpub\wwwroot\web.config`
* `C:\Windows\Microsoft.NET\Framework64\$SOME_VERSION_STRING\Config\web.config`

Look for the `connectionString` directive.

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

## netstat
The `netstat` command on Windows *almost* works exactly like its Linux equivalent. The difference is that `-ob` displays the PID and binary of the process using the connection on Windows.

If you know the PID of a process, you can use `netstat` + `findstr` to quickly find out what ports its listening on:

```powershell
netstat -noa | findstr “LISTENING” | findstr “$PID”
```

### Additional Resources
* [Using “netstat”](./Using%20%22netstat%22.md)
* [TryHackMe: The Lay of the Land](https://tryhackme.com/room/thelayoftheland)
* [TryHackMe: Enumeration](https://tryhackme.com/room/enumerationpe)

## Querying the Registry
```powershell
reg query $REGISTRY_PATH
```

Registry paths will typically start with `HKLM` (HKey Local Machine), `HKCU` (HKey Current User), etc. 

### Additional Resources
* [TryHackMe: The Lay of the Land](https://tryhackme.com/room/thelayoftheland)

## systeminfo
Use `findstr` to filter the output of `systeminfo`:

```powershell
systeminfo | findstr /B /C:”OS Name” `
                        /C:”OS Version” `
                        /C:”System Type”
```

This can be used to semi-reliably determine if a machine is part of a domain.

```powershell
systeminfo | findstr Domain
```

(Non-AD joined machines will almost always use WORKGROUP for the `Domain`, while AD-joined machines will often use a fully qualified DNS domain here.)

### Additional Resources
* [TryHackMe: The Lay of the Land](https://tryhackme.com/room/thelayoftheland)

## wmic
The `wmic` command is extremely useful, but is also deprecated (*because* of its usefulness to attackers!). It can be used on Windows 10 21H1 and earlier. For later systems, PowerShell command-lets will need to be used instead (which increases the risk that activity will be logged).

* `wmic product get name,version,vendor` — list all installed software (but misses 32-bit applications installed on a 64-bit OS)
* `wmic service get name,displayname,pathname,startmode` — list all services
* `wmic qfe get caption,description,hotfixid,installedon` — list installed updates
* `wimc service list brief` — another way of listing services
* `wmic service where “name like ‘$SERVICE_NAME’” get name,pathname` — get information about a particular service
* `wmic /namespace:\root\securitycenter2 path antivirusproduct` — enumerate antivirus
* `wmic useraccount get name,sid` — Display SIDs for all (local) users

### Additional Resources
* [TryHackMe: The Lay of the Land](https://tryhackme.com/room/thelayoftheland)
* [TryHackMe: Enumeration](https://tryhackme.com/room/enumerationpe)
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

## PowerShell
```powershell
# List all AD users (IFF the machine is joined to a domain!)
#
Get-ADUser -Filter *

# List AD users within a particular LDAP subtree
#
Get-ADUser -Filter * -SearchBase “CN=Users,DC=example,DC=com”

# Enumerate antivirus
#
Get-CimInstance -Namespace root/SecurityCenter2 `
                -ClassName AntivirusProduct

# Check if the Windows Defender service is running
#
Get-Service WinDefend

# Check if real-time protection is enabled for Windows
# Defender
#
Get-MpComputerStatus | select RealTimeProtectionEnabled

# Get information about potential threats recently detected by
# Windows Defender
#
Get-MpThreat

# Check the status of the Windows Firewall
#
Get-NetFirewallProfile | Format-Table Name,Enabled

# Disable all WIndows Firewall profiles
#
Set-NetFirewallProfile -Profile Domain,Public,Private `
                       -Enabled False

# List Windows Firewall rules
#
Get-NetFirewallRule | select DisplayName,Enabled,Description

# Two ways to check if a port can be connected to (the first
# provides more output, while the second is more suitable for
# scripting)
#
Test-NetConnection -ComputerName $IP_OR_HOSTNAME -Port $PORT

(New-Object System.Net.Sockets.TcpClient(“$IP_OR_HOSTNAME”, “$PORT”)).Connected

# List all current Windows logs
#
Get-EventLog -List

# Sysmon is dangerous for an attacker! Three ways to check if
# it’s running...
#
Get-Process | Where-Object { $_.ProcessName -eq “Sysmon” }

Get-CimInstance win32_service `
	-Filter “Description = ‘System Monitor service’”

Get-Service | where-object {$_.DisplayName -like “sysm”}

# List hidden directories
#
Get-ChildItem -Hidden -Path $SOME_PATH

# Get a process with a particular “image name” (generally example.exe has an image name of “example”)
#
Get-Process -Name $IMAGE_NAME
```

When checking to see if Sysmon is running, you can also examine the `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational` Registry entry.

### Additional Resources
* [TryHackMe: The Lay of the Land](https://tryhackme.com/room/thelayoftheland)
* [Using PowerShell](./Using%20PowerShell.md)
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

## Useful Scripts
* [WinPEAS](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS)
* [PowerUp](https://github.com/PowerShellMafia/PowerSploit/tree/master/Privesc)
* [Windows Exploit Suggester](https://github.com/AonCyberLabs/Windows-Exploit-Suggester)
* Metasploit → [Using Metasploit](./Using%20Metasploit.md)

### Notes
* WinPEAS is detected and quarantined by Microsoft Defender (service `windefend`) by default.
* PowerUp may require an unrestricted PowerShell session (`powershell -nop -exec bypass`), which can raise alerts.
* Windows Exploit Suggester analyzes the output of `systeminfo`, and can be run on the attacker’s machine.
* The `multi/recon/local_exploit_suggester` module works through Meterpreter to analyze a Windows system for potential vulnerabilities.
