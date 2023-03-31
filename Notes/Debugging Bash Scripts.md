# Debugging Bash Scripts

Using the -x flag will force bash to output each line of the shell script you’re running before that line is executed. This can be useful for debugging.

```bash
bash -x ./script.sh
```

The -x flag can also be incorporated into the interpreter line.

```bash
#!/usr/bin/env bash -x

# Script content...
```

Finally, this mode can be toggled on and off with the `set` command within the script itself.

```bash
#!/usr/bin/env bash

# Some script content...

set -x

# These lines will be echoed before execution.

set +x

# These lines will not be echoed...
```

Frequently `set -x` is used at the start of a script without a closing `set +x`, which will just cause all lines of the script to be echoed back before execution.

* [TryHackMe: Bash Scripting](https://tryhackme.com/room/bashscripting)
