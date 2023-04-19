# Ice

## Recon

The machine we'll be attacking is at 10.10.55.173. Since it's a Windows box, we know that it won't respond to `ping` by default.

As usual, we'll start out with an nmap scan:

```bash
sudo nmap -v -oA ice -Pn -A -T4 -sS -script vuln \
          -p- 10.10.55.173
```

Which gives us:

```
# Nmap 7.92 scan initiated Tue Dec  7 20:55:44 2021 as: nmap -v -oA ice -Pn -A -T4 -sS -script vuln -p- 10.10.55.173
Pre-scan script results:
| broadcast-avahi-dos: 
|   Discovered hosts:
|     224.0.0.251
|   After NULL UDP avahi packet DoS (CVE-2011-1002).
|_  Hosts are all up (not vulnerable).
Increasing send delay for 10.10.55.173 from 0 to 5 due to 387 out of 967 dropped probes since last increase.
Increasing send delay for 10.10.55.173 from 5 to 10 due to 48 out of 119 dropped probes since last increase.
Nmap scan report for 10.10.55.173
Host is up (0.18s latency).
Not shown: 65523 closed tcp ports (reset)
PORT      STATE SERVICE            VERSION
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  ssl/ms-wbt-server?
|_ssl-ccs-injection: No reply from server (TIMEOUT)
| rdp-vuln-ms12-020: 
|   VULNERABLE:
|   MS12-020 Remote Desktop Protocol Denial Of Service Vulnerability
|     State: VULNERABLE
|     IDs:  CVE:CVE-2012-0152
|     Risk factor: Medium  CVSSv2: 4.3 (MEDIUM) (AV:N/AC:M/Au:N/C:N/I:N/A:P)
|           Remote Desktop Protocol vulnerability that could allow remote attackers to cause a denial of service.
|           
|     Disclosure date: 2012-03-13
|     References:
|       http://technet.microsoft.com/en-us/security/bulletin/ms12-020
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2012-0152
|   
|   MS12-020 Remote Desktop Protocol Remote Code Execution Vulnerability
|     State: VULNERABLE
|     IDs:  CVE:CVE-2012-0002
|     Risk factor: High  CVSSv2: 9.3 (HIGH) (AV:N/AC:M/Au:N/C:C/I:C/A:C)
|           Remote Desktop Protocol vulnerability that could allow remote attackers to execute arbitrary code on the targeted system.
|           
|     Disclosure date: 2012-03-13
|     References:
|       http://technet.microsoft.com/en-us/security/bulletin/ms12-020
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2012-0002
5357/tcp  open  http               Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
8000/tcp  open  http               Icecast streaming media server
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-iis-webdav-vuln: Could not determine vulnerability, since root folder is password protected
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-vuln-cve2014-3704: ERROR: Script execution failed (use -d to debug)
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49158/tcp open  msrpc              Microsoft Windows RPC
49159/tcp open  msrpc              Microsoft Windows RPC
49160/tcp open  msrpc              Microsoft Windows RPC
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.92%E=4%D=12/7%OT=135%CT=1%CU=42453%PV=Y%DS=4%DC=T%G=Y%TM=61B035
OS:3F%P=x86_64-pc-linux-gnu)SEQ(SP=100%GCD=1%ISR=10D%TI=I%CI=I%II=I%SS=S%TS
OS:=7)OPS(O1=M506NW8ST11%O2=M506NW8ST11%O3=M506NW8NNT11%O4=M506NW8ST11%O5=M
OS:506NW8ST11%O6=M506ST11)WIN(W1=2000%W2=2000%W3=2000%W4=2000%W5=2000%W6=20
OS:00)ECN(R=Y%DF=Y%T=80%W=2000%O=M506NW8NNS%CC=N%Q=)T1(R=Y%DF=Y%T=80%S=O%A=
OS:S+%F=AS%RD=0%Q=)T2(R=Y%DF=Y%T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)T3(R=Y%DF=Y
OS:%T=80%W=0%S=Z%A=O%F=AR%O=%RD=0%Q=)T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD
OS:=0%Q=)T5(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=80%W=0
OS:%S=A%A=O%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1
OS:(R=Y%DF=N%T=80%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI
OS:=N%T=80%CD=Z)

Uptime guess: 0.035 days (since Tue Dec  7 20:41:59 2021)
Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=255 (Good luck!)
IP ID Sequence Generation: Incremental
Service Info: Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_samba-vuln-cve-2012-1182: NT_STATUS_ACCESS_DENIED
| smb-vuln-ms17-010: 
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|           
|     Disclosure date: 2017-03-14
|     References:
|       https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
|       https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143
|_smb-vuln-ms10-054: false
|_smb-vuln-ms10-061: NT_STATUS_ACCESS_DENIED

TRACEROUTE (using port 1723/tcp)
HOP RTT       ADDRESS
1   34.62 ms  10.13.0.1
2   ... 3
4   179.31 ms 10.10.55.173

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Tue Dec  7 21:31:59 2021 -- 1 IP address (1 host up) scanned in 2174.84 seconds
```

(An interesting effect of the -T4 flag, which uses a slightly more aggressive timing timing profile, is that port discovery seems to happen out-of-order…)

FLAG 1: What port is MSRDP open on? - 3389

FLAG 2: What service is running on port 8000? - Icecast streaming media server

FLAG 3: What is the hostname of the machine? - DARK-PC

* [Using "nmap"](../Notes/Using%20%22nmap%22.md)

## Gain Access

The next few flags are about finding a particular vulnerability for Icecast on https://cvedetails.com. There's actually a couple of different vulnerabilities that match the flag descriptions, but after a little trial-and-error we can find the right ones.

FLAG 4: What is a vulnerability impacting Icecast with a CVSS score of 7.5? - Execute Code Overflow

FLAG 5: What is the CVE number for the vulnerability in Flag 4? - CVE-2004-1561

FLAG 6: What is the Metasploit module for exploiting this vulnerability? - exploit/windows/http/icecast_header

FLAG 7: What option must be set to use this module? - RHOSTS

There's not too much to this module - set RHOSTS and LHOST, run, get shell.

* [CVE-2004-1561](https://www.cvedetails.com/cve/CVE-2004-1561/)
* [Using Metasploit](../Notes/Using%20Metasploit.md)

## Escalate

FLAG 8: What shell does Metasploit provide us with? - meterpreter

We can find the current user using the `getuid` command.

FLAG 9: What user is running the Icecast process? - Dark-PC/Dark

The `sysinfo` command will give us the OS version and architecture.

FLAG 10: What is the build of this Windows system? - Windows 7 (6.1 Build 7601, Service Pack 1)

FLAG 11: What is the system architecture? - x64

We'll now use `run post/multi/recon/local_exploit_suggester` to find potential paths to elevating privileges.

Unfortunately, for me this only returns one result - `exploit/windows/local/ms10_092_schelevator` - which is not accepted as the 12th flag. The flag hint states that the exploit will contain `eventvwr`. A quick search through Metasploit shows that the only exploit including this string is `exploit/windows/local/bypassuac_eventvwr`, which *is* accepted.

FLAG 12: What is the potential exploit `run post/multi/recon/local_exploit_suggester` returns? - `exploit/windows/local/bypassuac_eventvwr`

We can background meterpreter with Ctrl+Z and then switch to this exploit using `use exploit/windows/local/bypassuac_eventvwr`. This exploit runs through an existing session, so we need to set this using `set SESSION 2`. (I'm on session 2 because I previously backed out an unsuccessfully tried to pop a 64-bit meterpreter shell - I guess Icecast is running as a 32-bit process.)

FLAG 13: What option needs to be set to ensure that our listener IP address is correct? - LHOST

I also tweaked LPORT, as I'm nervous about killing the existing session (which is running on the default port, 4444).

Using `run` quickly pops a new shell.

FLAG 14: What permission allows taking ownership of files? - SeTakeOwnershipPrivilege

## Looting

In order to harvest credentials from LSASS we'll need to migrate meterpreter to a process with the same permissions (NT AUTHORITY/SYSTEM) and architecture as LSASS. The print spooler service is a good choice, as it runs with elevated permissions, has the same architecture as the system itself, and will restart itself automatically.

FLAG 15: What is the name of the print spooler service? - `spoolsv.exe`

```meterpreter
migrate -N spoolsv.exe
```

FLAG 16: What user is the migrated meterpreter process running as after migration? - NT AUTHORITY/SYSTEM

We're going to loot LSASS now using Mimikatz.

```meterpreter
load kiwi
```

FLAG 17: What command retrieves all credentials from LSASS? - `creds_all`

It turns out that Windows loads *unhashed* passwords into LSASS for any users with scheduled jobs!

FLAG 18: What is Dark's password? - `Password01!`

* [Using Mimikatz](../Notes/Using%20Mimikatz.md)
* [Using Hydra](../Notes/Using%20Hydra.md)
* [Using John the Ripper](../Notes/Using%20John%20the%20Ripper.md)

## Past-Exploitation

FLAG 19: What meterpreter command allows us to dump all of the password hashes stored on the system? - `hashdump`

Hashes dumped using `hashdump` can be cracked offline using Hydra or John the Ripper.

FLAG 20: What meterpreter command allows us to watch the remote user's desktop in real time? - `screenshare`

FLAG 21: What meterpreter command allows us to record using the system's microphone? - `record_mic`

FLAG 22: What meterpreter command can modify timestamps of files on the system? - `timestomp`

FLAG 23: What meterpreter/kiwi command allows for the creation of a golden ticket? - `golden_ticket_create`

* [Kerberos](../Notes/Kerberos.md)

ELAPSED TIME: 2 h 39 min

## References

* [TryHackMe: Ice](https://tryhackme.com/room/ice)
