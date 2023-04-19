# Using "nmap"

Note that nmap accepts ranges in any octet of an IP address; for example, 10.10.0-255.1-255 will scan 10.10.0.1 – 10.10.255.255.

When dealing with firewalls, be aware that the default nmap SYN scan packet is 44 bytes = 20 bytes IP header + 24 bytes TCP header + 0 bytes data. Note that packet fragmentation only effects the TCP header + data - the 20 byte IP header will always be sent!

Most nmap scans will generate ~2x the number of packets as scanned ports, as unresponsive ports are sent a second packet to verify that they're actually closed (and, in general, most ports will be closed).

* [TCP Protocol](./TCP%20Protocol.md)

## Useful Flags

* `-A` - "Aggressive" scan; alias for `-O -sC -sV --traceroute`.
* `-D` - Send multiple scan requests using decoys; specified using a list of arbitrary IP addresses. The special "addresses" `ME` and `RND` represent the attacker (you!) and a random IP address, respectively. If `ME` isn't included in the list, it will be inserted into a random position. Trades stealth for "chaff". Maybe only useful as a diversion?
* `-e` - Specify the network interface to use during scanning.
* `-f` - Fragment (TCP) packets into chunks of 8 bytes or less. Can help evade some next-gen firewall / IDS alarms.
* `-ff` - Fragment (TCP) packets into chunks of 16 bytes or less. Can help evade some next-gen firewall / IDS alarms.
* `-F` - "Fast" scan. Alias for `--top-ports 100`.
* `-g` - Use the specified source port number, rather than a random source port. Useful for bypassing some stateless firewalls.
* `-iL` - Use a file for nmap's scan targets.
* `-n` - Don't resolve host names using DNS (or do reverse DNS resolution).
* `-O` - OS detection. Generally requires at least one open and one closed port to be detected, and results will be distorted if the target is virtualized. The OS type is much more reliably detected than the OS version.
* `-p-` - Scan all ports. (The end/beginning of port ranges can be excluded to represent 1/65535, so `-p-` is equivalent to `-p1-65535`.) If omitted, the 1000 most common ports are scanned by default.
* `-Pn` - Scan the host even if it doesn't respond to an initial ping. *Necessary for scanning/discovering modern Windows systems, since the Windows Firewall blocks ICMP by default.*
* `-r` - Scan ports in sequential order (rather than randomly). Can make for more accurate scans for targets that have only recently been brought online.
* `-R` - Perform reverse DNS resolution even for offline hosts.
* `-sC` - Scan with "default" script set; equivalent to `--script default`. Mostly provides basic intelligence.
* `-sV` - Service detection. The same as `-sT` (because a full TCP connection is required to gather the necessary information), but probes listening services for additional information.
* `-S` - Use a spoofed IP address for the scan. Only useful if you can actually capture incoming packets at that IP address! Generally must be combined with the `-e` and `-Pn` flags.
* `-T` - Specify timing from 0 – 5. `-T0` will wait *5 minutes* between ports. `-T1` is typical on engagements. `-T3` is the default. `-T4` is typical on CTFs. `-T5` is not recommended, as it is so fast that it may lead to packet loss.
* `-v` - Increase nmap's verbosity. There are four verbosity levels for nmap: `-v` < `-vv` < `-d` < `-dd`. In practice, I've found anything above `-v` too noisy for general use.

There's more, but these are the big ones.

* [Port Scanning Basics (Official Nmap Project Guide)](https://nmap.org/book/man-port-scanning-basics.html)

### Long Flags

* `--badsum` - Produce packets with an invalid checksum. These should be dropped by normal hosts, but many IDS solutions *respond* to these. This can be useful for reconnaissance.
* `--data-length` - Append random data to nmap TCP packets to ensure that all packets are the same length. By default, nmap appends no data after the TCP header; padding this out *can* make scans look more innocuous. Values < 24 only effect fragmented packets (since the TCP header is already 24 bytes). Disables protocol-specific payloads, which can decrease scan accuracy, particularly for UDP scans.
* `--dns-servers` - Specify DNS server(s) to use for hostname resolution and reverse lookups.
* `--ip-options` - Specify the IP "Options" field as either a string of hex-encoded bytes (`\x00`, etc.) or *one* of the shortcut options `R` (record-route), `T` (record-timestamp), `U` (`R` *and* `T`), `L` (loose source routing), and `S` (strict source routing). Both `L` and `S` must be followed by a space-separated list of IP addresses to route the packet through (the entire sting must be quoted), and are used to route around security appliances.
* `--max-parallelism` - The maximum number of probes to run in parallel. Overrides `-T`.
* `--max-rate` - The maximum number of packets/second to send. Overrides `-T`.
* `--min-parallelism` - The minimum number of probes to run in parallel. Overrides `-T`.
* `--min-rate` - The minimum number of packets/second to send. Overrides `-T`.
* `--mtu` - Fragment packets into a chosen multiple of 8. Setting `--mtu 8` is equivalent to `-f`, and `--mtu 16` is the same as `-ff`.
* `--open` - Only report back machines with open ports (most useful when used in conjunction with `-p`).
* `--proxies` - Use an HTTP or SOCKS4 proxy. Specify a comma-separated list to chain proxies together.
* `--reason` - Show the reason that nmap made a particular identification. Kinda fun.
* `--scan-delay` - Add a delay (in milliseconds) between ports/hosts. Helpful for IDS evasion, but makes things *slow*.
* `--scanflags` - Specify the TCP flags used to probe ports during a scan using URG, PSH, RST, SYN, ACK, FIN (e.g., `--scanflags URGPSHFIN` is the same as `-sX`). Overrides the explicit scanning options in the following sections.
* `--script` - Run specified scripts, or all scripts in a specified category (as applicable). Also accepts wildcard matches (e.g., `ftp*`). See next section for script category breakdown.
* `--script-help` - Return the "help" comment block at the top of a script file.
* `--source-port` - Specify the source port for a scan. possibly useful to evade some firewall rules?
* `--spoof-mac` - Use a spoofed MAC address for the scan. Obviously only matters when you're on the same subnet as the target; otherwise has the same caveats as IP spoofing.
* `--top-ports` - Scan only the X most common ports. Nmap's default is `--top-ports 1000`. Can be useful for detecting locked-down hosts (use `--top-ports 10 -Pn`). Overridden when using `-p`.
* `--traceroute` - Perform a traceroute between the attacker and target systems. Note that nmap's traceroute works in the opposite fashion (high TTL to low TTL) than traceroute/tracert. Note that most routers will not send ICMP TTL exceeded packets, and will thus show up as `*`.
* `--ttl` - Set a custom TTL. Does not always work as you'd expect in my experience!
* `--version-intensity` - Determine how much service information to collect (and thus how noisy the associated probes will be) with `-sV`. Ranges from 0 – 9; `--version-light` is equivalent to 2, `--version-all` is equivalent to 9.

Nmap has a ton of flags. Be sure to check the man page and official documentation!

* [Firewall/IDS Evasion and Spoofing (Official Nmap Project Guide)](https://nmap.org/book/man-bypass-firewalls-ids.html)

### Scripting Engine

Script categories:

* auth - Probes for information about service authentication and bypasses. Does not conduct brute-force attacks.
* broadcast - Host/network probes using broadcast packets.
* brute - Attempt to brute-force service credentials.
* default - A curated list of fast, reliable scripts. Can also be called using -sC.
* discovery - Gather additional information about scanned machines/ports.
* dos - Scripts that may crash machines/services.
* exploit - Attempt to actually exploit identified services.
* external - Scripts that send data to third-party services.
* fuzzer - Fuzz identified services.
* intrusive - Scripts that may crash a service, generate lots of log messages, or are otherwise noise / may be considered malicious.
* malware - Test for the possible presence of malware on the target.
* safe - The opposite of "intrusive" - scripts that are unlikely to be noisy or perceived as malicious (no guarantees though).
* version - Scripts called by -sV. Unlike "default", this category cannot be called directly.
* vuln - Check for potential vulnerabilities. I've found that scripts in this category generate a lot of false positives.

You can also run your own scripts.

* [Nmap Scripting Engine Usage and Examples (Official Nmap Project Guide)](https://nmap.org/book/nse-usage.html)

### Host Discovery Options

When called as the superuser, Nmap uses ARP for local host discovery and a combination of ICMP Echo, TCP SYN to 443, TCP ACK to 80, and ICMP Timestamp requests for remote host discovery.

When called as a normal user, Nmap has more limited options and uses TCP SYN packets sent for ports 80 and 443 for both local and remote host discovery.

Discovery methods:

* `-PA` - Use TCP ACK packets for host discovery; otherwise the same as `-PS`.
* `-PE` - Use ICMP Echo for host discovery. (Note that Nmap will still not send the echo request if host existence can be verified using the initial ARP request.)
* `-PM` - Use ICMP Address Mask for host discovery. (More-or-less the same as `-PP`, just a different ICMP request type.)
* `-PP` - Use ICMP Timestamp for host discovery. (Less likely to be blocked by firewalls than `-PE`, but also a more unusual request that may stand out. Like `-PE`, Nmap will still not send the timestamp request if host existence can be verified using the initial ARP request.)
* `-PR` - Use ARP packets only for host discovery.
* `-PS` - Use TCP SYN packets for host discovery. Uses port 80 by default, or you can specify a port list (e.g., `-PS80,8080,8888`) or range (e.g. `-PS20-30`). (Note that unprivileged users *must* complete a full TCP handshake.)
* `-PU` - Use UDP packets for host discovery. Unlike other types of host discovery scans, UDP scans only generate a reply (ICMP Port Unreachable) if the target port is *closed*.

Most of the time the default discovery options (or -Pn) is fine. The above options are mostly useful for unusual networks or if there's a need to be extra-stealthy.

* [Host Discovery (Official Nmap Project Guide)](https://nmap.org/book/man-host-discovery.html)

### Scan Types

* `-sA` - ACK scan. All ports *should* respond with a RST, but firewalls will generally block these requests except for open/forwarded ports. Thus, an ACK scan is useful for probing the configuration of intermediate firewalls (but says nothing about whether services are actually *listening* on the identified ports).
* `-sF` - FIN scan. Use and output is similar to a null scan, but is slightly more likely to be blocked.
* `-sI` - Idle/Zombie scan. The idea here is to choose a machine with *no* traffic on it and then spoof it's IP address. Scans then consist of a SYN/ACK to the zombie to get the current IP ID value for the current port, then a SYN to the target (which should either reply with a RST to the zombie, which doesn't trigger a response and thus doesn't increment the IP ID, or a SYN/ACK to the zombie, which will respond with a RST which *will* increment the IP ID), then a second SYN/ACK to the zombie to see if the IP ID has been incremented by 1 (port closed or filtered on the target) or 2 (port open on the target). Note that zombies need to be systems that increment the IP ID sequentially *and* globally, and open/closed ports will be from the *zombie's* perspective, not the attacker's. These scans are also slooooow (though not as slow as `-T0`).
* `-sL` - Dummy scan. Show the hosts that would be scanned, but don't actually do anything (except perhaps DNS resolution).
* `-sM` - Maimon scan (named after Uriel Maimon); the FIN and ACK TCP flags are set. Should always receive a RST, but some older BSD systems drop the packet on open ports. Of limited modern utility.
* `-sn` - Host discovery only (see the previous section for details). Note that the Windows Firewall blocks ICMP by default.
* `-sN` - Null scan; no TCP flags are set. Used to circumvent *stateless* firewalls. Can distinguish between `closed` and `open|filtered`.
* `-sS` - SYN scan. Most common scan, and nmap's default. Starts a TCP handshake but then sends a RST after receiving the SYN/ACK packet. Requires root, should not be used on OT. Also called a "stealth scan", but most IDS solutions detect it these days.
* `-sT`- TCP connect scan. This makes a full TCP handshake when connecting to each port, then sends a RST/ACK after the handshake is finished. Slow but accurate. This is the only scan available for unprivileged users.
* `-sU` - UDP scan. Sends empty UDP packets (or more realistic packets for known ports) and listens for a response back ("open") or a ICMP "port unreachable" packet ("closed"). Since UDP doesn't require a response, most ports will get marked `open|filtered`. Can be specified with one of the TCP scans to scan TCP and UDP ports simultaneously. *Very* slow, so you probably want to use with `-sU --top-ports 20`.
* `-sW` - TCP windows scan; the same as an ACK scan except that it examines the TCP window field of returned RST packets and uses it to discern if a port responded *differently*. Note that ports may be reported as closed (and open!) erroneously (as not all systems respond in the same way), but unfiltered ports will be identified. Look for patterns of open/closed ports to try to discern how the target system is responding.
* `-sX` - Xmas scan; the FIN, URG, and PSH TCP flags are set. Use and output is similar to a null scan.

Note that nmap by default uses a TCP window of 1024 bytes and an MSS of 1460. This is actually an unusual combination, and makes most nmap TCP scans stick out in packet captures. The exception to this is a full TCP connect scan, which uses the system TCP stack and thus tends to have more sensible options.

* [UDP Scan (-sU) (Official Nmap Project Guide)](https://nmap.org/book/scan-methods-udp-scan.html)
* [TCP Window Scan (-sW) (Official Nmap Project Guide)](https://nmap.org/book/scan-methods-window-scan.html)
* [TCP Idle Scan (-sI) (Official Nmap Project Guide)](https://nmap.org/book/idlescan.html)

### Port States

* `Open` - The port is reachable and there is a service listening on it.
* `Closed` - The port is reachable and there is no service listening on it.
* `Filtered` - Nmap cannot determine the port state because the port is not accessible (probably because of a firewall).
* `Unfiltered` - Nmap cannot determine the port state, but the port *is* accessible (only encountered in ACK scans).
* `Open|Filtered` - Nmap can only determine that the port is not closed (only encountered in UDP scans and more exotic scans like Xmas).
* `Closed|Filtered` - Nmap can only determine that the port is not open (only encountered in IP ID idle scans).

## Output

* `-oA` - Save the results in "normal", "grepable", and XML formats simultaneously. This option will automatically append meaningful extensions (the other options do not do this).
* `-oG` - Save the results as "grepable" output. This is a compact format meant to automatically provide context when searched with grep.
* `-oN` - Save results as "normal" output. This is more-or-less what nmap will print to STDOUT.
* `-oX` - Save the results as XML, designed to be importable by other applications.
