# Using "unbuffer"

Normally application output is printed to STDOUT whenever a newline is encountered ("line buffering"). However, line buffering is disabled when piping to another application. This is particularly annoying, for example, when piping the output of an application to `tee` in order to both observe *and* save it to a log.

The `unbuffer` command restores line buffering in pipes. Use like so:

```bash
unbuffer $APPLICATION | tee $LOG
```

* [Force line-buffering of stdout in a pipeline](https://stackoverflow.com/questions/11337041/force-line-buffering-of-stdout-in-a-pipeline#comment111940075_11337310)
