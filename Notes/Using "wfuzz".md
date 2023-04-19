# Using "wfuzz"

wfuzz is a URL fuzzer — basically the command-line version of the Burp Suite Intruder (but it's *much* faster, which is what one would generally expect from a command-line tool).

* `-c` - Use color
* `-z` - Specify the wordlist that will replace FUZZ in the request

Basically, the word "FUZZ" in the URL will be replaced by elements of the wordlist specified by `-z`. Multiple slots can be specified using "FUZ2Z", "FUZ3Z", etc.

```bash
wfuzz -z file,rockyou.txt \
         https://example.com/FUZZ/img/secret.webp
```

Use `wfuzz --help` for a full list of options. The `--hc 404` option is particularly useful for hiding pages that return a 404.

* [TryHackMe: Web Fundamentals](https://tryhackme.com/path/outline/web)
* [Using Burp Suite](./Using%20Burp%20Suite.md)
