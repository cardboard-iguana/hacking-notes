# Compact VirtualBox Disk Images

1. Zero out free disk space *on the guest*:

	**Windows:** Disable the paging file (Settings > System > About > Advanced system settings > Advanced > Performance > Settings… > Advanced > Virtual memory > Change…), clean all temporary files (C: > Properties > Disk Cleanup), defrag (`defrag C: /FreespaceConsolidate /Verbose`), and then zero out free space with SDelete (`sdelete -z C:`).

	**Linux:**

	```bash
	sudo dd if=/dev/zero of=/temp.zeros bs=4096k
	sudo rm -f /temp.zeros
	```

2. Compact the disk image *on the host*:

	```bash
	vboxmanage modifymedium /path/to/image.vdi --compact
	```

Remember to turn the paging file back on after compacting the drive (for Windows guests)!

Note that this only works on a disk image *without any snapshots*.

* [How to compact VirtualBox’s VDI file size?](https://superuser.com/questions/529149/how-to-compact-virtualboxs-vdi-file-size/529183#529183)
* [SDelete](https://docs.microsoft.com/en-us/sysinternals/downloads/sdelete)
