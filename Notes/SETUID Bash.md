# SETUID Bash

Let's say you manage to get a copy of bash on a system that's (1) owned by root and (2) has the SUID bit set. If you just try to execute it, bash will still drop privileges, and you'll be running as the same user you were before!

To prevent this, run bash with the `-p` flag (`./bash -p`), which helpfully instructs bash to *not* drop privs.
