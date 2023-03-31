# Create a GPG Key (With SSH Support!)

## Create the Initial Key

```bash
gpg --expert --full-generate-key
```

* Choose “ECC (set your own capabilities)”
* Toggle the “Sign” capability *off* (`S`).
* Finish choosing capabilities (`Q`).
* Choose “Curve 25519”.
* Expire in 2 years (`2y`).
* Enter your name.
* Enter the primary email address for the key.
* *Do not enter a comment.*

## Edit the Key

```bash
gpg --expert --edit-key $KEYID
```

### Add UIDs

* Use `adduid`.
* Enter your name.
* Enter the primary email address for the key.
* *Do not enter a comment.*

### Add a Signing Subkey

* Use `addkey`.
* Choose “ECC (sign only)”
* Choose “Curve 25519”.
* Expire in 2 years (`2y`).

### Add an Authentication Subkey

* Use `addkey`.
* Choose “ECC (set your own capabilities)”
* Toggle the “Sign” capability *off* (`S`).
* Toggle the “Authenticate” capability on (`A`).
* Finish choosing capabilities (`Q`).
* Choose “Curve 25519”.
* Expire in 2 years (`2y`).

### Add an Encryption Subkey

* Use `addkey`.
* Choose “ECC (encrypt only)”
* Choose “Curve 25519”.
* Expire in 2 years (`2y`).

### Finish Up

Be sure to save the key before exiting.

## Remove the Primary Key for Safe Keeping

```bash
# Export keys
#
gpg --armor --export-secret-key $KEYID > $KEYID.asc
gpg --export-secret-subkeys $KEYID > subkeys.gpg
#
# Delete secret keys (BOTH primary and subkeys)
#
gpg --delete-secret-keys $KEYID
#
# Re-import secret subkeys
#
gpg --import subkeys.gpg
#
# Optionally verify that eveything worked...
#
gpg --list-keys
gpg --list-secret-keys
#
# Cleanup
#
rm subkeys.gpg
```

Once this is done, `$KEYID.asc` can be stored “offline” on a secure (encrypted!) drive, etc. Note that this key will need to be re-imported to generate new subkeys, add UIDs, extend expiration dates, or create updated revocation certificates.

## Export the Authentication Subkey to SSH

* Run `gpg --list-secret-keys --with-keygrip`.
* Copy keygrips of the authentication subkeys (`[A]`) you want to use in SSH to `~/.gnupg/sshcontrol`.
* Generate the SSH public key using `gpg --export-ssh-key $KEYID > ~/.ssh/id_${KEYID}.pub`. This key can then be referenced using the `IdentityFile` directive in `~/.ssh/config` or inserted into a host’s `~/.ssh/authorized_keys` file.

## References

* [Creating newer ECC keys for GnuPG](https://www.gniibe.org/memo/software/gpg/keygen-25519.html)
* [OpenPGP Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices)
* [How to enable SSH access using a GPG key for authentication](https://opensource.com/article/19/4/gpg-subkeys-ssh)
* [Force the use of a gpg-key as an ssh-key for a given server](https://serverfault.com/a/964317)
