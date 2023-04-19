# AIX

## System Information

```bash
oslevel     # Report system version
oslevel -rq # Report "technology level" (major release?)
            # information
oslevel -sq # Report service pack information
```

Different system components ("filesets") can be at different technology levels / service packs. You can list which software that is more (`-g`) or less (`-l`) recent than a given technology level (`-r`) or service pack (`-s`); for example:

```bash
oslevel -s -l $SERVICE_PACK # List filesets below the specified
                            # service pack
```

* [slyth11907 / Cheatsheets](https://github.com/slyth11907/Cheatsheets)
* [oslevel Command](https://www.ibm.com/docs/en/aix/7.2?topic=o-oslevel-command)

## Fileset Information

```bash
lslpp -l               # List all filesets
lslpp -h $FILESET_NAME # Detailed fileset information
```

Some versions of AIX can also apparently use the RPM package manager.

* [lslpp Command](https://www.ibm.com/docs/en/aix/7.2?topic=l-lslpp-command)
* [How to Match Files to Packages](./How%20to%20Match%20Files%20to%20Packages.md)
