# File Transfer Protocol (FTP)

## Commands

* LIST - List contents of the supplied directory (or user's FTP root)
* PASS - Specify the password for the account logging on
* PASV - Switch to passive mode
* QUIT - End the current session/connection
* RETR - Retrieve the provided file
* STAT - Provide connection/server information
* SYST - Provide system "type" information
* TYPE - Switch between ASCII (A) and binary (I) transfer modes
* USER - Specify the username for the account logging on

There are a lot more obscure commands as well, though the above is sufficient for basic operations.

* [FTP Commands: QUIT, USER, ABOR, ACCT, SYST, XDEL](https://www.serv-u.com/resource/tutorial/quit-user-abor-acct-syst-xdel-ftp-command)
* [FTP Commands: APPE, MLSD, MLST, LIST, RETR, STOR, STOU](https://www.serv-u.com/resource/tutorial/appe-stor-stou-retr-list-mlsd-mlst-ftp-command)

## File Retrieval

Note that you cannot receive files using FTP with a *single* telnet/netcat session, as file transfers are conducted over a separate channel (either a channel originating from port 20 on the server for "active" mode or a random port above 1023 on the client for "passive" mode).

However, you *can* retrieve files using *two* sessions.

* Switch to passive mode (PASV).
* The FTP server will reply with a string of the form (o1,o2,o3,o4,p1,p2), where o1 - o4 are the four octets of the server's IP address and p1 - p2 are the high + low bytes of the port number to connect to.
* Use (256 × p1) + p2 to determine the decimal port number. For example, if p1 = 117 and p2 = 85, then then port number you need to connect to is 30037.
* Connect a *second* telnet/netcat client to the IP + port provided by the server.
* Issue the appropriate file retrieval (RETR) command in the original telnet/netcat client. The file will be sent to the second client.

Which is a lot of work, but sometimes you just don't have an FTP client.

* [How to list FTP directories using telnet?](https://stackoverflow.com/questions/50324402/how-to-list-ftp-directories-using-telnet#comment126707507_50324402)

## FTPS

FTPS (FTP over SSL) uses port 990 by default. Mostly supplanted by SFTP.

* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
