# Simple Mail Transfer Protocol (SMTP)

A set of commands to send an email:

```smtp
HELO somehostname
MAIL FROM:fromaddress@host1.tld
RCPT TO:toaddress@host2.tld
DATA
To: "To Address" <toaddress@host2.tld>
From: "From Address" <fromaddress@host1.tld>
Subject: An Email
This is content.

Here is another line.
.
QUIT
```

Note that `MAIL FROM` / `From` and `RCPT TO` / `To` are not actually required to match, though failure to fill in the `MAIL FROM` / `RCPT TO` commands *may* result in the message being rejected. The commands above are *not* case-sensitive, and the message ends with a `.` on a single line.

* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
* [In SMTP, must the RCPT TO: and TO: match?](https://stackoverflow.com/questions/10822190/in-smtp-must-the-rcpt-to-and-to-match)
