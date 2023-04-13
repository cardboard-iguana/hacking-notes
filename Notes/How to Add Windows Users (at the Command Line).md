# How to Add Windows Users (at the Command Line)

```powershell
net user $USERNAME $PASSWORD /add
net localgroup Administrators $USER /add
net localgroup "Remote Desktop Users" $USER /add
reg add `
	"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" `
	/v fDenyTSConnections /t REG_DWORD /d 0 /f
```

This requires SYSTEM privileges or a (local) administrator account.

It's worth noting that users added via `net user` seem to bypass Windows' password policies…

## References

* [TryHackMe: Complete Beginner](https://tryhackme.com/path/outline/beginner)
* [Alice with Siddicky (Student Mentor) (YouTube)](https://www.youtube.com/watch?v=Zma6Mk5bEI8)
