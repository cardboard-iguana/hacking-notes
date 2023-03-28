# Bash Scripting Tricks

```bash
# Brace expansion
#
{X,Y}      # X Y
{X,Y}.txt  # X.txt Y.txt
{1..10}    # 1 2 3 4 5 6 7 8 9 10
{1..10..2} # 1 3 5 7 9

# Special variables
#
$#   # Number of arguments to script/function
$1   # First argument
$9   # Ninth argument (NOTE: there is no $10 and higher)
"$@" # All arguments as a separate quoted strings
"$*" # All arguments as a single string separated by
     # first IFS character

# IFS is the string of characters that act as delimeters
# (for example, in loops). If unset, it's equal to the
# sequence <space><tab><newline>.

# Length of a variable
#
MYVAR=/path/to/file/file.tar.gz
${#MYVAR} # 25

# Variable manipulation
#
${MYVAR%.*}            # /path/to/file/file.tar
${MYVAR%%.*}           # /path/to/file/file
${MYVAR#*/}            # path/to/file/file.tar.gz
${MYVAR##*/}           # file.tar.gz
${MYVAR/file/newfile}  # /path/to/newfile/file.tar.gz
${MYVAR//file/newfile} # /path/to/newfile/newfile.tar.gz
${MYVAR:1:4}           # path
${MYVAR:(-6):3}        # tar

# Setting defaults
#
${MYVAR:-default} # Return $MYVAR, or "default" if unset
${MYVAR:=default} # Set $MYVAR to "default" if unset
${MYVAR:+default} # Return "default" if $MYVAR set
${MYVAR:?error}   # Exit with "error" if $MYVAR unset

# Variable variables
#
VAR1="Hello world"
VAR2="VAR1"
${!VAR2} # Hello world

# Arrays
#
MYARRAY=("element0" "element1" "element2")
MYARRAY[3]="element3"
${MYARRAY[0]}     # element0
${MYARRAY[-1]}    # element3
${MYARRAY[@]}     # element0 element1 element2 element3
${MYARRAY[@]:1:2} # element1 element2
${!MYARRAY[@]}    # 0 1 2 3

# Size of an array
#
${#MYARRAY[@]} # 4

# Remove an element from an array
#
unset MYARRAY[3]

# Arrays are actually a special case of dictionaries,
# which hold key/value pairs. In an array, keys are just
# 0-indexed numbers. Dictionaries work exactly the same
# as arrays, except rather than referencing/setting
# elements by number, you reference and set them by key.

# Create a dictionary
#
declare -A MYDICT

# Math
#
$(( 1 + 2 )) # 3
$RANDOM      # Random-ish number

# Loop over lines in a file
#
cat $FILE | while read LINE; do
	# Do stuff with $LINE
done

# Loop over filenames with spaces
#
while IFS= read -d '' -r FILE; do
	# Do stuff with $FILE
done < <(find $DIR -type f -print0)

# The advantage this has over other approaches is that it
# doesn't create a subshell, so you can use variables set
# within the loop elsewhere. We need to temporarily
# override IFS because our list is null-separated; the
# space between the -d and the '' (an empty string, which
# Bash interprets as the null character) is *required*.
```

* [Bash scripting cheatsheet](https://devhints.io/bash)
* [$IFS](https://bash.cyberciti.biz/guide/$IFS)
* [Bash - variable variables](https://stackoverflow.com/a/10757531)
* [Looping through find output in Bash where file name contains white spaces](https://stackoverflow.com/a/23748641)
