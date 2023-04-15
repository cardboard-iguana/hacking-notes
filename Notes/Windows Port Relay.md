# Windows Port Relay

```powershell
netsh interface portproxy add v4tov4 `
      listenport=$LOCAL_PORT listenaddress=0.0.0.0 `
      connectport=$REMOTE_PORT connectaddress=$REMOTE_IP
```

This works on Windows 7 and later.

* [slyth11907 / Cheatsheets](https://github.com/slyth11907/Cheatsheets)
