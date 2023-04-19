# Jump to an Editor in "more"

An editor can be invoked from `more` using `v`; by default this tries to invoke $VISUAL, and then $EDITOR, and then just vi before giving up.

Note that using `!` to invoke a command (!/bin/bash, etc.) won't work, as by default `more` is executing `$SHELL -c $COMMAND`, which can fail if $SHELL is set to something exotic in /etc/passwd.

(Exotic shells in /etc/passwd can also cause commands executed via ssh to fail for the same reason.)

* [ssh works with my custom shell but can't execute commands directly using ssh](https://stackoverflow.com/a/52673010)
