# Windows Password Hashes

The Windows NT family uses NTLM for (network) logins, and stores hashes in the NT hash format, which is really just the md4 hash of the UTF-16-LE encoding of the user password (UTF-16-LE is the little endian version of UTF-16). While NTLM is the login protocol, people commonly call NT hashes "NTLM" hashes.

The "LM" in "NTLM" references the pre-NT password hashing mechanism, LM. LM hashes are constructed in an absolutely batshit crazy fashion, and are *much* weaker than (the already weak) NT hashes.

Windows passwords are stored in the SAM, but NT and LM hashes (which can coexist on the same system) are stored in different data structures.

* [TryHackMe: Complete Beginner](https://tryhackme.com/path/outline/beginner)
* [LM, NTLM, Net-NTLMv2, oh my!](https://medium.com/@petergombos/lm-ntlm-net-ntlmv2-oh-my-a9b235c58ed4)
