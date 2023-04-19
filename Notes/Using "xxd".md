# Using "xxd"

The xxd command is actually pretty standard on Linux systems.

```bash
# Create a hex dump of binary file $BINARY.
#
xxd $BINARY $HEXDUMP

# Reconstitute a binary file from a hex dump! Wow!
#
xxd -r $HEXDUMP $BINARY 
```
