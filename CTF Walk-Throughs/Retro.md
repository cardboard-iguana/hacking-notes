# Retro

## Initial Reconnaissance 

This CTF is an earlier version of Blaster without the step-by-step nature of that room. Not 100% sure what the differences are.

The target IP is 10.10.20.185.

As with Blaster, we'll start out As usual, we'll start out by running an nmap scan:

```bash
sudo nmap -v -oA retro -Pn -A -T4 -sS -script vuln \
          -p- 10.10.20.185
```

This gives us:

```
# Nmap 7.92 scan initiated Sun Jan  2 19:34:48 2022 as: nmap -v -oA retro -Pn -A -T4 -sS -script vuln -p- 10.10.20.185
Pre-scan script results:
|_broadcast-avahi-dos: ERROR: Script execution failed (use -d to debug)
Nmap scan report for 10.10.20.185
Host is up (0.18s latency).
Not shown: 65533 filtered tcp ports (no-response)
PORT     STATE SERVICE       VERSION
80/tcp   open  http          Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
3389/tcp open  ms-wbt-server Microsoft Terminal Services
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows 2012|2016 (90%), FreeBSD 6.X (85%)
OS CPE: cpe:/o:microsoft:windows_server_2012:r2 cpe:/o:microsoft:windows_server_2016 cpe:/o:freebsd:freebsd:6.2
Aggressive OS guesses: Microsoft Windows Server 2012 R2 (90%), Microsoft Windows Server 2016 (89%), FreeBSD 6.2-RELEASE (85%)
No exact OS matches for host (test conditions non-ideal).
Uptime guess: 0.013 days (since Sun Jan  2 19:29:09 2022)
Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=261 (Good luck!)
IP ID Sequence Generation: Incremental
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

TRACEROUTE (using port 80/tcp)
HOP RTT       ADDRESS
1   37.05 ms  10.13.0.1
2   ... 3
4   180.52 ms 10.10.20.185

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Jan  2 19:47:21 2022 -- 1 IP address (1 host up) scanned in 753.31 seconds
```

So we've got IIS and RDP running. Let's start by taking a look around IIS.

* [Blaster](./Blaster.md)
* [Using "nmap"](../Notes/Using%20%22nmap%22.md)

## Flag 1: The Hidden Directory

As with Blaster, we just have the default IIS welcome page. So let's follow up with gobuster since we know from the flag list that there's a hidden directory

```bash
gobuster \
	-t 10 dir \
	-w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt \
	-u http://10.10.20.185/
```

Still paralleling Blaster, the hidden directory is `/retro`.

* [Using "gobuster"](../Notes/Using%20%22gobuster%22.md)

## Flag 2: `user.txt`

Visiting http://10.10.20.185/retro/ reveals the same retro arcade website as Blaster. (I'm noticing a parallel here… I suspect that the rest of the CTF will also be the same, though I'm going to see if I can do this one with less guessing.)

All of the posts are by "Wade". I hadn't noticed it the first time, but the "Ready Player One" post is actually suggestive that either Wade's username or password is "Parzival".

> I can't believe the movie based on my favorite book of all time is going to come out in a few days! Maybe it's because my name is so similar to the main character, but I honestly feel a deep connection to the main character Wade. I keep mistyping the name of his avatar whenever I log in but I think I'll eventually get it down. Either way, I'm really excited to see this movie!

The comment immediately afterward seems to confirm this.

> Leaving myself a note here just in case I forget how to spell it: parzival

Theoretically I should use this information to generate a wordlist (who knows what permutations Wade is applying to "Parzival", and whether this is Wade's username or password). There's a few Kali Linux tools that could be used to harvest words from http://10.10.20.185/retro/ and generate various common permutations, but all of these will result in quite a long list.

In the real world, this is what I'd probably have to do. But since I kinda already know how this is going to shake out, let's just skip ahead to logging in with XFreeRDP.

```bash
xfreerdp /dynamic-resolution +clipboard /cert:ignore \
         /v:10.10.20.185 /u:Wade /p:parzival
```

Unsurprisingly, this works. The `user.txt` file on the desktop contains the second flag (which is different than in Blaster!).

* [Ready Player One (Wikipedia)](https://en.wikipedia.org/wiki/Ready_Player_One)
* [Using XFreeRDP](../Notes/Using%20XFreeRDP.md)

## Flag 3: `root.txt`

This flag is probably in `C:\Users\Administrator\Desktop\root.txt`. But now things are diverging a bit…

Wade has Google Chrome installed in this version of the CTF, and no other files are on the desktop.

But poking around a bit reveals that things aren't too far off Blaster.

* There's an `hhupd.exe` executable in the Recycle Bin.
* Chrome has a single bookmark for "NVD - CVE-2019-1388".

Of course, the TryHackMe machine doesn't have internet access, but we can follow this link locally. Moreover, searching for `hhupd` reveals that this is a program that can be used to perform the attack; that page helpfully links to a YouTube video demonstrating how to leverage `hhupd.exe` in exactly this way.

The attack works somewhat differently on this system than in Blaster (or the demonstration video), however. Instead of opening up an Internet Explorer window outside of the secure desktop, IE is opened up *on* the UAC desktop itself, and all interaction needs to take place there (we also get a choice of using IE or Chrome…). Still, overall things work more-or-less as we'd expect, and we can use the resulting elevated command prompt to read `C:\Users\Administrator\Desktop\root.txt.txt` (note the extra `.txt`) to obtain the final flag.

(I kinda feel like I cheated now, since I did Blaster first without realizing that this room was almost *exactly* the same.)
 
* [CVE-2019-1388 Detail (National Vulnerability Database)](https://nvd.nist.gov/vuln/detail/CVE-2019-1388)
* [CVE-2019-1388 (nagenrauft-consulting.com)](https://www.nagenrauft-consulting.com/2019/11/21/cve-2019-1388-hhupd-exe/)

### Related Video

[CVE-2019-1388: Windows Privilege Escalation Through UAC (YouTube)](https://www.youtube.com/watch?v=3BQKpPNlTSo)

ELAPSED TIME: 1 h 16 min

## References

* [TryHackMe: Retro](https://tryhackme.com/room/retro)
