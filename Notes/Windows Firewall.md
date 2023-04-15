# Windows Firewall

Check Windows Firewall state:

```powershell
netsh advfirewall show currentprofile
```

See all Windows Firewall rules for inbound connections:

```powershell
netsh advfirewall firewall show rule dir=in name=all
```

Be aware that most built-in rules on Windows are bound to particular applications. But admins are lazy, and seldom bind custom rules to explicit applications. There's no 100% reliable way to identify custom rules from the command line, but they'll often have obvious naming conventions.

See all Windows Firewall rules for outbound connections:

```powershell
netsh advfirewall firewall show rule dir=out name=all
```

Punch a hole in the Windows Firewall for ports 80, 443, and 4444:

```powershell
netsh advfirewall firewall add action=allow name=tunnel_in `
	dir=in protocol=tcp localport="80,443,4444"
netsh advfirewall firewall add action=allow name=tunnel_out `
	dir=out protocol=tcp localport="80,443,4444"
```

In general you don't want to turn off the Windows Firewall, as doing so will generate a popup for any users currently logged into the machine.

* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)
