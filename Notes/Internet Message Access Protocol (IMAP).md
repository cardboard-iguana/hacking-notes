# Internet Message Access Protocol (IMAP)

IMAP commands are much more complicated than POP3. Some examples:

* Login User - prefix LOGIN user pass
* Lost Folders - prefix LIST "" "\*"
* List Emails in INBOX - prefix EXAMINE INBOX
* Close Connection - prefix LOGOUT

Here `prefix` is a random prefix we provide to track server replies to various commands. IMAP accepts a lot of different user authentication methods; LOGIN is just the simplest (and least secure).

* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
