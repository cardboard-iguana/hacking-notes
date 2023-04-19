# Using Burp Suite

## Keyboard Shortcuts

* `Ctrl + Shift + D` - Switch to Dashboard
* `Ctrl + Shift + T` - Switch to Target
* `Ctrl + Shift + P` - Switch to Proxy
* `Ctrl + Shift + I` - Switch to Intruder
* `Ctrl + Shift + R` - Switch to Repeater
* `Ctrl + F` - Forward intercepted request
* `Ctrl + U` - URL encode selected text in Proxy > Intercept
* `Ctrl + R` - Send request from Proxy to Repeater
* `Ctrl + R` - Send request from Proxy to Intruder

## The Burp Suite Browser

I *strongly* recommend using the Burp Suite Browser, since it already has proxy and SSL interception set up. Also, it's always best to keep your "hacker" and "normie" tools/identities as separate as possible!

### Using Firefox with Burp Suite

The Burp Suite browser is compiled as an x86_64 binary, and thus *doesn't* work on a Raspberry Pi. As a work-around, Firefox can be used to interact with Burp Suite.

First, make the following changes to Firefox's settings:

* Settings > General > Network Settings > Settings… > Manual proxy configuration > [set the "HTTP Proxy" to 127.0.0.1:8080 and check "Also use this proxy for HTTPS"]
* Settings > Privacy & Security > Browser Privacy > Logins and Passwords > Ask to save logins and passwords for websites > Off
* Settings > Privacy & Security > Browser Privacy > History > Use custom settings for history > Always use private browsing mode > On

Then install the Burp Suite CA certificate:

* Start Burp Suite.
* Go to http://127.0.0.1:8080.
* Click on the "CA Certificate" link in the upper right to download Burp Suite's certificate.
* Go to Settings > Privacy & Security > Security > Certificates > View Certificates…
* Import the Burp Suite CA certificate and check "Trust this CA to identify websites."

It's also possible to use FoxyProxy - set up Burp Suite as a togglable proxy and then import the Burp Suite CA certificate as above. I don't like this option because I think that hacking and normal browsing activities should be kept as separate as possible.

Using Chromium on the Raspberry Pi as the Burp Suite browser might be the best option, as it aligns more with Burp Suite's built-in (x86_64) browser. Unfortunately, Chromium's certificate import functionality appears to be broken on Kali Linux ARM right now.

* [Use a Raspberry Pi 4B as an iPad Pro Hacking Accessory](./Use%20a%20Raspberry%20Pi%204B%20as%20an%20iPad%20Pro%20Hacking%20Accessory.md)
* [FoxyProxy Basic](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-basic/)

### Mobile App Testing

You can proxy mobile API requests through Burp Suite too.

* Configure Burp Suite to listen on all interfaces.
* Add your computer as an HTTP proxy to the network interface on the mobile device.
* Add the Burp Suite CA using more-or-ess the same process as would be used for Firefox (above).

Be aware that this proxies *all* device traffic through Burp Suite.

* [Configuring an iOS Device to Work With Burp](https://portswigger.net/support/configuring-an-ios-device-to-work-with-burp)
* [Installing Burp's CA Certificate in an iOS Device](https://portswigger.net/support/installing-burp-suites-ca-certificate-in-an-ios-device)

## Scoping

Sites can be added to the project scope under Target > Scope.

You can also add them by right-clicking on a site in Target > Site map. When you do this, you'll be prompted to turn off logging outside of the scope. If you want to change this (or forget to set it), then you can still do so in Logger by clicking on the "Capture filter" bar and then checking the "Capture only in-scope items (Suite scope)"

You can further restrict the Proxy to only intercept in-scope requests under Proxy > Options > Intercept Client Requests by turning on "And URL Is in target scope".

## Issue Definitions

Target > Issue definitions provides a list of the issues used by the vulnerability scanner built into the paid version of Burp Suite. For the Community Edition (i.e., what comes with Kali Linux), it's basically just a massive (and very useful!) reference.

## Intruder Attacks

Note that Burp Suite seems to have trouble running attacks with a large list. For example, trying to use the `rockyou.txt` data set on my machine silently fails.

### Sniper

Sniper takes a *single* word list and inserts each element into each defined position, one element and one position at a time.

For example, assume a three-element word list containing `one`, `two`, and `three`, and the body date `foo=position1&bar=position2`. Then if `position1` and `position2` are both defined as positions, Sniper will produce the following sequence of attempts:

* `foo=one&bar=position2`
* `foo=two&bar=position2`
* `foo=three&bar=position2`
* `foo=position1&bar=one`
* `foo=position1&bar=two`
* `foo=position1&bar=three`

Sniper is most useful when attacking a *single* position, however.

### Battering Ram

Battering Ram again takes a *single* word list, but then inserts the *same* payload into *every* position on each run.

For example, assume a three-element word list containing `one`, `two`, and `three`, and the body date `foo=position1&bar=position2`. Then if `position1` and `position2` are both defined as positions, Battering Ram will produce the following sequence of attempts:

* `foo=one&bar=one`
* `foo=two&bar=two`
* `foo=three&bar=three`

It's a little mysterious to me why this attack is useful.

### Pitchfork

Pitchfork takes *one word list per position*, and then iterates through them in sequence (thus all word lists need to be the same length; if the lists are of different lengths, then Pitchfork will stop upon reaching the end of the *shortest* list).

For example, assume one three-element word list containing `one`, `two`, and `three`, a second three-element word list containing `alpha`, `beta`, and `gamma`, and the body date `foo=position1&bar=position2`. Then if `position1` and `position2` are both defined as positions, Pitchfork will produce the following sequence of attempts:

* `foo=one&bar=alpha`
* `foo=two&bar=beta`
* `foo=three&bar=gamma`

This is generally the approach that would be used in order to test against a potential list of username/password tuples.

### Cluster Bomb

Cluster Bomb takes *one word list per position*, and then tests every possible combination in sequence.

For example, assume one three-element word list containing `one`, `two`, and `three`, a second three-element word list containing `alpha`, `beta`, and `gamma`, and the body date `foo=position1&bar=position2`. Then if `position1` and `position2` are both defined as positions, Cluster Bomb will produce the following sequence of attempts:

* `foo=one&bar=alpha`
* `foo=one&bar=beta`
* `foo=one&bar=gamma`
* `foo=two&bar=alpha`
* `foo=two&bar=beta`
* `foo=two&bar=gamma`
* `foo=three&bar=alpha`
* `foo=three&bar=beta`
* `foo=three&bar=gamma`

This is a good approach for attacking login forms if you *don't* already know the actual credentials, but want to fuzz using some set of likely values (like `rockyou.txt`).

Obviously this is the most expensive attack in terms of connections/time, and thus also the one most likely to get you noticed!

## Macros

When dealing with forms that include session cookies or anti-CSRF tokens, we can either grab these tokens directly in Intruder using the Recursive Grep function (within the Intruder module), or construct a macro in Project options > Sessions > Macros (necessary if there's, for example, a random redirect to make our life harder).

Basically, macros just define repeated requests that we can make. Once a request is defined here, we can add an entry in Session Handling Rules and define the Scope of the macro (the tools it's active in and the URL  it applies to). Then in details we can trigger the macro. Generally you'll want to restrict the URLs the macro applies to and what parameters/cookies get updated by the macro as much as possible.

## Hashing in Decoder

Burp Suite displays hashes in the "Hex" view by default; to convert them into the (hex) ASCII string you're used to, encode this output as "ASCII Hex".
