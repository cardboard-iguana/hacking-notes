# Find and Replace a Single Line in a Large Text File

To display a single line from a large text file:

```bash
sed -n "${LINE_NUMBER}{p;q}" $FILE
```

The `p` command prints matching lines, and the `q` command causes sed to quit after the first match.

You can't use `q` if you want to print a block of lines, so you'll just need to `^C` after the output is printed so that sed doesn't keep needlessly reading the file.

```bash
sed -n "${START_LINE},${END_LINE}p" $FILE
```

If you want to replace a single line, you can use a similar trick (once you've identified the line number):

```bash
sed -i "${LINE_NUMBER}s/.*/${REPLACEMENT_TEXT}/" $FILE
```

It may be advisable to use single quote here, rather than double quotes + variable substitution, to prevent shell weirdness. Unfortunately, there's really no way to tell when this command has finished (except to let it work through the whole file).

* [Getting one line in a huge file with bash](http://stackoverflow.com/a/2796347)
* [How to replace an entire line in a text file by line number](http://stackoverflow.com/a/11145362)
