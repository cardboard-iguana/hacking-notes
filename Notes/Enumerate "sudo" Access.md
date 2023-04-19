# Enumerate "sudo" Access

The `sudo -l` command will helpfully tell us what we can run as the superuser without a password (`NOPASSWD`), as well as what environment variables may be preserved (useful if you're going to try to exploit `LD_PRELOAD` or `LD_LIBRARY_PATH`).

**Note:** The use of `sudo -l` requires that the user have *some* level of sudo access to begin with, and *will* be logged!

* [TryHackMe: Complete Beginner](https://tryhackme.com/path/outline/beginner)
* [TryHackMe: Basic Pentesting](https://tryhackme.com/room/basicpentestingjt)
* [Shell Escapes](./Shell%20Escapes.md)
* [Exploiting LD_PRELOAD](./Exploiting%20LD_PRELOAD.md)
* [Exploiting LD_LIBRARY_PATH](./Exploiting%20LD_LIBRARY_PATH.md)
