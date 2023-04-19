# Using "sqlmap"

Used to automate SQLi attacks (and apparently banned on the OSCP because it makes things too easy).

Useful flags:

* `-u URL`/`--url=URL` - process URL (this *must* include the query parameters *or* you must specify POST parameters using `--data`)
* `-p`/ - which URL parameter(s) (variables) to test
* `--dbms=DB_TYPE` - only use injections for a given type of backend database (MySQL, PostgreSQL, etc.)
* `--dbs` - enumerate DBs
* `-D`/`-T`/`-C` - dump a specific database/table/column
* `--dump`/`--dump-all`/`--all` - dump data
* `--os-shell` - attempt to spawn an interactive shell
* `--os-pwn` - attempt to spawn a Meterpreter shell or VNC session
* `--forms` - parse target URL for forms, and use these
* `--batch` - don't prompt for user input, just use the defaults
* `--risk` - set the maximum risk level of tests (1 – 3, lowest to highest risk)

For example:

```bash
sqlmap -u http://example.com/test.php?input=foo \
       --dump-all
```

Or:

```bash
sqlmap -u http://example.com/test.php \
       --data input=foo --dump-all
```

One handy way to seed a URL is using requests harvested with Burp Suite.

* [TryHackMe: CC: Pen Testing](https://tryhackme.com/room/ccpentesting)
* [How to use SQLMAP to test a website for SQL Injection vulnerability](https://www.geeksforgeeks.org/use-sqlmap-test-website-sql-injection-vulnerability/)
* [TryHackMe: SQL Injection](https://tryhackme.com/room/sqlibasics)
* [SQL Injection](./SQL%20Injection.md)
* [Using Metasploit](./Using%20Metasploit.md)
* [Using Burp Suite](./Using%20Burp%20Suite.md)
