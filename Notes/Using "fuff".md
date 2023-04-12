# Using "fuff"

A general web fuzzing tool. Use `FUZZ` as your placeholder.

## Directory/File Enumeration

```bash
ffuf -w /usr/share/wordlists/dirb/common.txt \
     -u https://$DOMAIN/FUZZ
```

## Brute Force Virtual Hosts

Ffuf can fuzz HTTP headers, which can be used to try to brute force virtual host entries.

```bash
ffuf -w /usr/share/wordlists/metasploit/namelist.txt \
     -H "Host: FUZZ.$DOMAIN" \
     -u https://$IP
```

Use `-fs $SIZE` to remove results of a particular size from the list (which you'll probably need to do when trying to brute force virtual hosted subdomains).

## Username Enumeration

Assuming that our login or password reset form isn't AJAX-y:

```bash
ffuf -w /usr/share/wordlists/wfuzz/others/names.txt \
     -X POST -d "$POST_VARS" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -u $FORM_URL -mr "$ERROR_MEESAGE_SUBSTRING" -s
```

Here `$POST_VARS` should look something like `username=FUZZ&email=FUZZ@example.com&password=1234&cpassword=1234`. The `-mr` flag instructs ffuf to filter on page text for a "successful hit"; `-s` supresses all output except successful fuzzes (as defined by `-mr`).

## Brute Force Login Credentials

```bash
ffuf -w /usr/share/wordlists/wfuzz/others/names.txt:W1,$HOME/.local/share/red-team/wordlists/rockyou.txt:W2 \
     -X POST -d "$POST_VARS" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -u $LOGIN_URL -fc 200 -s
```

Here we assign W1 and W2 to take terms from the two supplied wordlists; `$POST_VARS` then looks something like `username=W1&password=W2`. This example assumes that a successful login will return an HTTP status code *other* than 200 (probably a 301 or 302);  `-s` supresses all output except successful fuzzes (the inverse of `-fc`).

Note that ffuf will try every possible combination of elements between the two wordlists, which means that the number of combinations tried grows geometrically. So you probably *don't* want to try the above example directly, but rather generate a shorter user list first via enumeration (see the previous section).
