# The Poison Null Byte

Some languages use null bytes (`0x00`) to know when a string terminates, rather than tracking the actual string length (PHP < 5.3.4 is one of these). If a null byte (generally? always? encoded as %00) is included in a string, then everything after that byte is dropped by the interpreter.

Because % characters are themselves special, null bytes need to be encoded in URLs as %2500.

Typically a null byte will either be inserted at the end of a string (to prevent a suffix from being appended or bypass simple path filters) or before a "fake" file extensions (which can cause some file-type checks to pass, again allowing us to download files we'd otherwise be denied access to).

* [TryHackMe: Complete Beginner](https://tryhackme.com/path/outline/beginner)
* [Common PHP attacks: Poison Null Byte](https://defendtheweb.net/article/common-php-attacks-poison-null-byte)
* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
