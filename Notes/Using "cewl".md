# Using “cewl”
The cewl utility (`sudo apt install cewl` on Kali Linux) can be used to crawl a website and extract strings that can be used as a word list.

```bash
cewl -w $OUTPUT_FILE \
     -d $DEPTH_TO_SPIDER \
     -m $MINIMUM_STRING_LENGTH \
        $URL 
```

It’s generally worth pulling strings out of a company’s website to seed a word list before attempting password spraying or brute-force login attacks.

## Additional Resources
* [TryHackMe: Password Attacks](https://tryhackme.com/room/passwordattacks)
