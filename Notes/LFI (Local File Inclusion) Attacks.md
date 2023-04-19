# LFI (Local File Inclusion) Attacks

LFI vulnerabilities are *most* common in PHP, but are sometimes found in other languages/frameworks.

Since web servers are typically serving content from `/var/www`, `/var/www/srv`, or an immediate subdirectory for virtual hosts, you generally need to use `../../`, `../../../`, or `../../../../` to reach `/`.

## PHP Tricks

For PHP < 5.3.4, you can use the poison null byte to defeat simple path filters or situations where the developer is appending some suffix to user input.

If the poison null byte doesn't work, another trick relies on the fact that for some bizarre reason PHP allows files to be referenced with `.` notation just like directories. In other words, `/etc/passwd/.` will return the contents of `/etc/passwd`!

Representing `../` as `....//` can bypass filters that replace `../`, as PHP search-and-replace only does a single pass through a string (it should be obvious how to extend this if a developer tries  to just run a search and replace *twice*).

* [The Poison Null Byte](./The%20Poison%20Null%20Byte.md)
