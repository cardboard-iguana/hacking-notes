# Upgrading PostgreSQL

```bash
sudo -u postgres pg_dropcluster --stop $NEW_VER main
sudo -u postgres pg_upgradecluster $OLD_VER main
sudo -u postgres pg_dropcluster --stop $OLD_VER main
```

Where `$OLD_VER` and `$NEW_VER` are the old and new major version numbers (e.g., 13 and 14).

* [How to upgrade PostgreSQL from 13 to 14](https://www.netvizura.com/blog/how-to-upgrade-postgresql-from-13-to-14)
