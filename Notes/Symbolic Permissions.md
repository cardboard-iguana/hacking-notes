# Symbolic Permissions

Numeric permissions are sometimes called *absolute* permissions, because they exactly specify an object's permissions. Symbolic permissions are a bit more flexible.

Like absolute permissions, symbolic permissions are divided into user (u), group (g), and others (o). *Unlike* absolute permissions, not all of these permission sets need to be specified. Sets are separated by commas, and identical sets can be combined (e.g., ug).

This specifier is then followed by an *operator* that specifies whether the following permissions should be granted (+), removed (-), or set exactly (=). (Note that when using "find" only "=" makes sense.)

Permissions themselves are given as one or more of the following:

* Read - r (4)
* Write - w (2)
* Execute - x (1)
* SUID - s/S (4)
* SGID - s/S (2)
* Sticky Bit - t (1)

The SUID/SGID bits are applied to the user or group (respectively) when set symbolically; the sticky bit is applied to the "other" permission set. When set numerically, all three of these values are applied to the "prefix" digit.

Symbolically, the SUID/SGID bits can be represented as either "s" or "S". The different is whether the user/group *also* has execute permissions ("s"), or lacks these permissions themself ("S").

* [How to manage Linux permissions for users, groups, and others](https://www.redhat.com/sysadmin/manage-permissions)
* [Linux permissions: SUID, SGID, and sticky bit](https://www.redhat.com/sysadmin/suid-sgid-sticky-bit)
* [How to Use "find" With File Metadata](./How%20to%20Use%20%22find%22%20With%20File%20Metadata.md)

## SUID

Execute as the file owner, rather than the user passing the command.

## SGID

If set on a file, this operates similarly to SUID: The file is executed as if the user passing the command was in the *group* with the SGID bit set. (I honestly have rarely seen this used.)

If set on a directory, files created in the directory will have their group ownership set to the same group as the directory itself. (In my experience this is the more common use case.)

## Sticky Bit

*Only* applied to directories. A file in a directory with the sticky bit set can only be deleted by its owner (and root). For example, /tmp always has the sticky bit set.

## Write Permissions and Directories

If a user has *write* access to a directory, then they can write to any file they have at least *read* access to (!!!).
