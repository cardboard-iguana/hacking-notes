# Using PowerShell

## Access the Registry Through PowerShell

You can actually access the registry from PowerShell using the `cd` command: `cd HKLM:\` will take you to the `HKEY_LOCAL_MACHINE` hive, for instance.

Major hives:

* `HKEY_CLASSES_ROOT`
* `HKEY_CURRENT_USER`
* `HKEY_LOCAL_MACHINE`
* `HKEY_USERS`
* `HKEY_CURRENT_CONFIG`

## Commands

### Accessing Windows Logs

Use the `Get-WinEvent` cmdlet.

* [Get-WinEvent](./Get-WinEvent.md)

### Download a File

```powershell
# Download to disk
#
Invoke-WebRequest -Uri $URL_OF_FILE -OutFile $FILE_ON_DISK

# Download into a variable (useful for scripts!)
#
$SCRIPT_DATA = `
	(New-Object System.Net.Webclient).DownloadString("$SCRIPT_URL")

# Download and invoke from memory
#
IEX (New-Object System.Net.Webclient).DownloadString("$SCRIPT_URL")
```

### Using Base64 Encoding

Encode a command to base64 in PowerShell:

```powershell
$Text = "$ONE_LINE_POWERSHELL_COMMAND"
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$EncodedText = [Convert]::ToBase64String($Bytes)
```

Run this using:

```powershell
powershell.exe -enc $EncodedText
```

### Manipulating Services

* `Get-Service` - list all services, or drill down on a particular service.
* `Start-Service -Name $SERVICE`/`sc.exe start $SERVICE` - start $SERVICE.
* `Stop-Service -Name $SERVICE`/`sc.exe stop $SERVICE` - stop $SERVICE.

### Calculating File Hashes

```powershell
Get-FileHash -Algorithm $ALGORITHM $FILE_PATH
```

The algorithm can be excluded (in which case SHA-256 is used). *Lots* of different hashing algorithms are supported - run `help Get-FileHash` to see a list.

### PowerShell Remoting

Many large companies will enable PowerShell Remoting on all machines in order to ease IT support burdens (by default, remoting is only enabled on domain controllers).

```powershell
Invoke-Command -ComputerName $MACHINE `
	-ScriptBlock {$COMMANDS_TO_RUN}
```

Remoting can be used to create a reverse shell.

```powershell
$SESSION_NAME = New-PSSession -ComputerName "$MACHINE"
Enter-PSSession -Session $SESSION_NAME
```

* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)

## Run PowerShell from cmd.exe

```powershell
powershell -c "$COMMAND"
```
