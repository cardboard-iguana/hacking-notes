# Using “gdb”

## Startup

```bash
gdb                   # Run; use file command to load $OBJECT
gdb $OBJECT           # Debug $OBJECT
gdb $OBJECT $COREDUMP # Analyze $COREDUMP
gdb $OBJECT $PID      # Attach to running process $PID
```

## General Commands

```gdb
set args                     # Set program arguments
show args                    # Show program arguments
run                          # Run the program
run < file                   # Run with input from file
set follow-exec-mode new/sam # Set debugger response to exec
set write                    # Set write into executables
set write off                # Unset write int oexecutables 
continue                     # Continue running until break
finish                       # Exec until current frame ends
source FILE                  # Read commands from script file
shell [cmd]                  # Run cmd in a shell
display /5i $eip             # Display $eip at execution end
undisplay <expr #>           # Undisplay expression number
info functions               # List all the functions
info variables               # List all the variables
info registers               # List most common registers
info all-registers           # List all registers
info display                 # List of displayed expressions
backtrace                    # Backtrace of all stack frames
where                        # Same as backtrace
set disassembly-flavor intel # Disassembly style to intel/att
define hook-[cmd]            # Action before command
define hooopost-[cmd]        # Action after command
define hook-stop             # Action when execution stops
```

## Breakpoints

```gdb
info breakpoints              # List all breakpoints
break [func]                  # Break function name
break *[addr]                 # Break at address
delete [bnum]                 # Delete breakpoint bnum
break if [cond]               # Break if condition
ignore [bnum] [count]         # Ignore breakpoint count times
condition [bnum] $eax == 0x22 # Add condition for breakpoint
condition [bnum]              # Del condition for breakpoint
```

## Watchpoints

```gdb
info watchpoints         # List all the watchpoint
watch variable==value    # Break when variable equals ...
watch $eax == 0x0000ffaa # Break when register equals ...
rwatch *[addr]           # Break on read memory location
awatch *[addr]           # Break on read/write memory location
```

## References

* [slyth11907 / Cheatsheets](https://github.com/slyth11907/Cheatsheets)
