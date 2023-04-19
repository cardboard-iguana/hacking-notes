# Using OWASP ZAP

ZAP (the "Zed Attack Proxy") is basically an open-source version of Burp Suite. Burp Suite ↔ ZAP equivalencies:

* Site Map ↔ Site Tree
* HTTP History ↔ History
* Scope ↔ Context
* Interceptor (Proxy) ↔ Break
* Repeater ↔ Request Editor
* Intruder ↔ Fuzzer
* Spider ↔ Spider
* Scanner ↔ Active Scan
* BApp Store ↔ Add On Marketplace

While ZAP has a very different interface than Burp Suite, you should basically approach using it in the same fashion.

* [Using Burp Suite](./Using%20Burp%20Suite.md)

## The ZAP Browser

At least on Kali Linux, ZAP can launch a pre-configured Firefox session using web automation; thus, like Burp Suite, there's really no need to configure a local proxy (and probably every reason not to - keep your profiles separate!).

One advantage of the ZAP browser is that it automatically passes session cookies back to ZAP!

One reason *not* to use ZAP's browser, however, is that the user-agent is less generic than Burp Suite's.

## Automated Scans

Automated scans can be fired off using the "Automated Scan" button on the ZAP Quick Start tab.

The "traditional spider" option spiders the website as you would expect, while the "AJAX spider" uses a headless browser to spider AJAX content.

## Directory Enumeration

ZAP has gobuster-like functionality called "Forced Browse". The wordlist can be configured in Tools > Options > Forced Browse; enumeration can be started by right-clicking on the target site and choosing Site > Force Browse Site.

* [Using "gobuster"](./Using%20%22gobuster%22.md)
