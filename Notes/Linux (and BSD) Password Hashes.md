# Linux (and BSD) Password Hashes

UNIX-style passwords are of the form `$format$rounds$salt$hash`. Common `format` parameters:

* 1 - md5crypt (mostly older)
* 2, 2a, 2b, 2x, 2y - bcrypt (generally web apps)
* 6 - sha512crypt (most modern systems)

Both $rounds and $salt are optional (salts are never purely numeric, so it's easy to tell these apart).

Bcrypt is designed to take approximately the same amount of time when hashed on a CPU vs. a GPU, which is one reason it's considered more resistant to cracking.

NOTE: 1 hex digit = 4 bits (2 hex digits per byte), which is why a 128-bit md5 hash is 32 characters long.

* [TryHackMe: Complete Beginner](https://tryhackme.com/path/outline/beginner)
