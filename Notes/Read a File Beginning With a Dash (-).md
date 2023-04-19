# Read a File Beginning With a Dash (-)

The easiest way to read a file beginning with a dash (-) is generally just to prefix it with a path; so, `cat ./-` reads a file called `-` in the current directory (as opposed to `cat -`, which tries to read from STDIN).
