# Using Nikto

Nikto is a web application vulnerability scanner.

```bash
nikto -Format txt -host $URL \
      -output $OUTPUT_FILE_WITH_EXTENSION
```

It can be used for basic web enumeration as well.

Getting help

```bash
nikto -h            # Short help
nikto -H            # Long help (all commands)
nikto -list-plugins # List plugins
```

* [TryHackMe: CC: Pen Testing](https://tryhackme.com/room/ccpentesting)
* [TryHackMe: Tools'R'us](https://tryhackme.com/room/toolsrus)
* [web enumeration](https://pentesting.one2bla.me/enumeration/web-enumeration)
