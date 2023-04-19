# Using PowerView

PowerView is a PowerShell reconnaissance tool. Note that AMSI will need to be disabled in the current session before it can be used.

* [PowerShellMafia / PowerSploit / Recon / PowerView.ps1](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1)
* [Using PowerShell](./Using%20PowerShell.md)

## Domain Enumeration

```powershell
# Get domain users and associated groups
#
Get-DomainUsers | select name, memberof

# Get all service accounts in a domain
#
Get-DomainUsers -SPN

# Get all domain group members, including nested domain groups
#
Get-DomainGroupMember -Identity $GROUP_NAME

# Show all users that previously logged on to a machine (defaults to
# local machine; requires admin privileges to be run against remote
# machines)
#
Get-NetLoggedon | select UserName

# Show all users who are logged in to a machine RIGHT NOW (does not
# require admin privileges for remote systems if run from Windows Server)
#
Get-NetSession
```
 
* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)
