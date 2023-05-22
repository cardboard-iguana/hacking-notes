# Using Hydra
Hydra can actually brute-force remote services, though I have some skepticism about how useful this is in practice.

```bash
hydra -t 4 -l $USER_NAME -P $WORDLIST \
      -f $TARGET_IP_ADDRESS $SERVICE
```

Here `$SERVICE` is “ssh”, “ftp”, etc. Note that “http” is not used directly; instead use “http-get-form”, “http-post-form”, etc.

## Options
* `-f` - Stop after the first successful match. Useful if you are just trying to brute-force a single username!
* `-l` - Specify the username whose password you want to brute force.
* `-L` - Specify a file listing of usernames (one per line) you want to brute force.
* `-p` - Specify the password you want to attempt. Most useful in conjunction with `-L` for password spraying attacks.
* `-P` - Specify a file listing of passwords (one per line) you want to brute force.
* `-s` - Use a non-default port for `$SERVICE`.
* `-t` - Specifies the number of threads (parallel connection attempts) that Hydra should make at any one time. By default, Hydra uses 16 threads, but many services don’t seem to play well with this; `-t 4` is a much more sane value.
* `-V` - Verbose output. Use `-vV` for even more verbose output, or `-d` for debugging output.

### Additional Resources
* [TryHackMe: Password Attacks](https://tryhackme.com/room/passwordattacks)

## HTTP Logins
When using Hydra to brute force an HTTP login, additional syntax is required after the protocol specifier (`http-get-form` or `http-post-form`). The syntax for each type of request can be looked up using `hydra $SERVICE -U`; use the placeholders `^USER^` and `^PASS^` to substitute in the username and password guesses. Condition strings `S=` and `F=` are simple string matches in the returned data for a successful and failed login, respectively.

See the following section on using Hydra to attack JSON APIs for an example of what this looks like.

### Additional Resources
* [TryHackMe: Password Attacks](https://tryhackme.com/room/passwordattacks)

## Attacking API Endpoints Using JSON
Hydra can be used to attack API endpoints that accept JSON (though apparently there can be some problems with the headers that are passed along):

```bash
hydra -vV -f -l $USERNAME -P $PASSWORDLIST \
	$HOST http-post-form \
	$ENDPOINT:"$TEMPLATE":F="$INVALID":H="Content-Type\: application/json"
```

The `$TEMPLATE` is basically the JSON request body with the special placeholders `^USER^` and `^PASS^` (colons escaped). `$INVALID` is a string that will appear for login *failures* (note that this string *cannot* contain a colon, but fortunately is a substring match). The `H` parameter at the end allows us to override specific headers (necessary because otherwise Hydra sends a `Content-Type` of `application/x-www-form-urlencoded`).

### Additional Resources
* [Hydra bruteforce and JSON](https://security.stackexchange.com/questions/57839/hydra-bruteforce-and-json)
* [Bruteforce - Using Hydra with JSON](https://security.stackexchange.com/questions/203501/bruteforce-using-hydra-with-json)
