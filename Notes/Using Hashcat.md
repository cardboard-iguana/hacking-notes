# Using Hashcat

```bash
hashcat -m $TYPE -O $HASHFILE $WORDLIST
```

Here $TYPE is the hash type (check `man hashcat`), and -O requests that hashcat use an optimized kernel (faster, but limited in the password length that can be cracked).

Some values of -m:

* 0 - md5
* 100 - sha1
* 900 - md4
* 1000 - NTLM (Windows)
* 1400 - sha256
* 1800 - UNIX SHA-512 passwords (`$6$`)
* 3000 - LANMAN (Windows)
* 3200 - bcrypt
* 13100 - Kerberos 5 hashes (TGS-REP)
* 18200 - Kerberos 5 hashes (AS-REP)

There are a large number of "Raw Hash, Salted and/or Iterated" modes That allow raw salted hashes (i.e., those not specific to a particular password type) to be processed; for these, specify the hashes as `$HASH:$SALT`.

Passwords are output as HASH:PLAINTEXT tuples.

Hashcat can accept the output of hashdump from Metasploit (use -m 1000), as well as raw hashes from /etc/shadow (assuming that they're all the same type).

A "token length exception" means that the provided hash format is of the wrong length (probably because an additional character got accidentally added).

* [Kali Hashcat and John the Ripper Crack Windows Password hashdump](https://pentesthacker.com/2020/12/27/kali-hashcat-and-john-the-ripper-crack-windows-password-hashdump/)
* [Cracking Linux Password Hashes with Hashcat](https://samsclass.info/123/proj10/p12-hashcat.htm)
* [hashcat - cracking a salted sha256](https://security.stackexchange.com/a/204978)

## Combinator

The Hashcat `combinator.bin` utility combines two wordlists such that every entry of the first list is concatenated with every entry from the second list.

```bash
/usr/lib/hashcat-utils/combinator.bin \
	$WORDLIST1 $WORDLIST2 > $COMBINED_WORDLIST
```
