# Quickly Find the Canonical Path of a File

On Debian-based systems and derivatives, use `readlink`.

Some useful options from the man page:

> `-f`, `--canonicalize`
> canonicalize by following every symlink in every component of the given name recursively; all but the last component must exist
> 
> `-e`, `--canonicalize-existing`
> canonicalize by following every symlink in every component of the given name recursively, all components must exist
> 
> `-m`, `--canonicalize-missing`
> canonicalize by following every symlink in every component of the given name recursively, without requirements on components existence

Note that this follows symlinks, so it's not suitable for every use.
