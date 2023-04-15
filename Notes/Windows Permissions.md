# Windows Permissions

Windows access is default-deny.

Windows folder permissions:

* Read - Permits viewing and listing of files and subfolders
* Write - Permits adding of files and subfolders
* Read & Execute - Permits viewing and listing of files and subfolders as well as executing of files; inherited by files and folders
* List Folder Contents - Permits viewing and listing of files and subfolders as well as executing of files; inherited by folders only
* Modify - Permits reading and writing of files and subfolders as well as executing of files; allows deletion of the folder
* Full Control - Permits reading, writing, changing, and deleting of files and subfolders

Windows file permissions:

* Read - Permits viewing or accessing of the file's contents
* Write - Permits writing to a file
* Read & Execute - Permits viewing and accessing of the file's contents as well as executing of the file
* List Folder Contents - N/A
* Modify - Permits reading and writing of the file as well as executing of the file; allows deletion of the file
* Full Control - Permits reading, writing, changing and deleting of the file

The biggest differences between Windows and UNIX permissions:

* Windows doesn't have as fine-grained of control *for a given user or group*.
* Windows has *much more* fine-grained control across users and groups (there's no limit of three permission sets).
* The ability to delete a folder or file, and to change its permissions, are essentially considered to be distinct "sub-permissions".

As much as it pains me to say it, in many ways the Windows permission mode is much better than the (pre-ACL) Linux model.

* [File and Folder Permissions](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/bb727008)

## Checking Permissions

Use `icacls` or `Get-Acl $PATH | Format-List` in PowerShell to check permissions at the command line. The `icacls` tool can also be used to update Windows ACLs.

Both of these tools produce output that is somewhat different than that of the "Security" tab in the file or folder properties:

* `(I)` - permission inherited from the parent container
* `(F)` - full access (full control)
* `(M)` - modify right/access
* `(OI)` - object inherit
* `(IO)` - inherit only
* `(CI)` - container inherit
* `(RX)` - read and execute
* `(AD)` - append data (add subdirectories)
* `(WD)` - write data and add files

Note that the Windows File Explorer only displays the *first* ACL for a particular user or group, but that Windows allows *multiple* ACLs to be applied! This means that the File Explorer does not always show you the *actual* permissions a user/group will have - you really do need to use `icacls` or `Get-Acl`.

In the case of multiple ACLs, or when a user is part of two groups with different groups, keep in mind that allow permissions only override *inherited* deny permissions. Explicitly set deny permissions *cannot* be overridden.

## Common User Types

* Local Admin
* Local User
* Guest User
* Domain User
* Domain Admin

Note that non-admin domain users may still be local admins.
