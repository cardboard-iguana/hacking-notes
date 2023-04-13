# Post Office Protocol 3 (POP3)

POP3 commands:

* USER - Username to use for authentication
* PASS - Password to use for authentication
* STAT - Mailbox statistics (+OK $TOTAL_MSGS $MBOX_SIZE_BYTES)
* LIST - List messages ($MSG_NUMBER $MSG_SIZE_BYTES)
* RETR - Retrieve message $MESSAGE_NUMBER
* QUIT - Close connection

There are other commands, but the above are enough to pull messages.

* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
