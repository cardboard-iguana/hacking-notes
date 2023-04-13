# Removing Duplicate Lines in Bash

## Quick-and-Dirty

```bash
cat $FILE | sort -u
```

This works in a pinch, but as a side effect will sort the lines lexicographicly.

## Remove All But the First Occurrence of a Line

```bash
cat $FILE | cat -n | sort -uk2 | sort -nk1 | cut -f2-
```

## Remove All But the Last Occurrence of a Line

```bash
cat $FILE | cat -n | sort -rk2 | sort -uk2 | sort -nk1 | cut -f2-
```

## References

* [Remove duplicate lines without sorting](https://stackoverflow.com/a/20639730)
