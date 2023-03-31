# Enumerate Oracle SQL Server

```bash
# Ping an Oracle server, get version information, etc.
#
tnscmd10g $COMMAND -h $IP_ADDRESS

# Enumerate information about an Oracle server
#
oscanner -s $IP_ADDRESS -P $PORT

# Dictionary enumeration of Oracle server SIDs
#
sidguess -i $IP_ADDRESS -d $WORDLIST_FILE
```

* [slyth11907 / Cheatsheets](https://github.com/slyth11907/Cheatsheets)
* [Tnscmd10g](https://www.kali.org/tools/tnscmd10g/)
* [Oscanner](https://www.kali.org/tools/oscanner/)
* [Sidguesser](https://www.kali.org/tools/sidguesser/)
