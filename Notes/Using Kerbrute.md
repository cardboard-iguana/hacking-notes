# Using Kerbrute

Kerbrute works by sending a single UDP packet to the authentication service to begin the authentication process, but then doesn't complete the transaction as to avoid an actual login failure (and the associated logging). While this doesn't grant access to anything, it does allow domain users to be enumerated using a wordlist.

To use kerbrute you need to meet one of the following requirements:

1. Already be on the domain you are attacking, *or*
2. Know the IP address of the domain controller (which normally hosts the KDC). This can be manually mapped in /etc/hosts or just specified as a raw IP using the `--dc` flag.

* [TryHackMe: Attacking Kerberos](https://tryhackme.com/room/attackingkerberos)
* [Attacktive Directory](https://tryhackme.com/room/attacktivedirectory)
