# Kerberos

Kerberos: The default authentication method for Windows domains. Intended to be the successor to NTLM.

The built-in Windows command `klist` will show you the current Kerberos tickets in memory.

## Definitions

* TICKET GRANTING TICKET (TGT): An authentication ticket that can be used to request service tickets for specific domain services from the ticket granting service.
* KEY DISTRIBUTION CENTER (KDC): A domain service that issues tickets; typically composed of the ticket granting service and the authentication service.
* AUTHENTICATION SERVICE (AS): Issues ticket granting tickets. (Presumably in charge of *authenticating* users and automations.)
* TICKET GRANTING SERVICE (TGS): Issues tickets for domain services (and machines?) when presented with a ticket granting ticket. (Presumably in charge of *authorizing* users and automations.)
* SERVICE PRINCIPAL NAME (SPN): A service identifier. On Windows, SPNs associates a particular service instance with a domain account. All services must have a domain service account. (But it sounds like services might be associated with *multiple* accounts via multiple principal names assigned to multiple running instances?)
* KDC LONG TERM SECRET KEY (KDC LT KEY): A secret key used to encrypt ticket granting tickets and sign privilege attribute certificates. This is the NT hash of the KRBTGT service account.
* SERVICE LONG TERM SECRET KEY (SERVICE LT KEY): A secret key associated with a particular service. Used to encrypt the service portion of a service ticket and sign privilege attribute certificates. Held by individual domain service accounts.
* SESSION KEY: Issued with a ticket to identify a particular user session. Services expects *both* a ticket and a session key to be present before acting on a user's behalf.
* PRIVILEGE ATTRIBUTE CERTIFICATE (PAC): A bundle of the user's identifying information, which is provided along with the tickets. Importantly, this contains the user's username and (on Windows) SID.

Note that Active Directory bundles the authentication service, ticket granting service, and KDC into a single "domain controller" role. Non-Windows Kerberos implementations are more likely to separate these roles between different servers.

## Authentication Process

The below steps are cut-and-pasted from Wikipedia's walk-through, but with language adapted to match the Windows-specific environment Kerberos is most commonly deployed in. (A close reading of these steps will also explain why it's sometimes said that "a hash is as good as a password" for a Window's domain.)

* [Wikipedia: Kerberos (protocol)](https://en.wikipedia.org/wiki/Kerberos_%28protocol%29)

### Client Authentication to the KDC (a.k.a. "Pre-Authentication")

(1) AS-REQ: The client sends the client/user ID + the current timestamp (the timestamp is used to prevent replay attacks) encrypted with the NT hash of the user's password + a cleartext message of the user ID to the authentication server to request services on behalf of the user.

(2) AS-REP: The authentication server checks to see if the client/user ID is in its database and if it can decrypt the timestamp using the NT hash of the password stored there. If it can, then the authentication server sends back the following two messages to the client:

* Message A: *Client/TGS Session Key* encrypted using the NT hash of the client/user.
* Message B: *Ticket Granting Ticket* (including the privilege attribute certificate, client network address, ticket validity period, and the *Client/TGS Session Key*) encrypted using the KDC long term secret key.

(3) Once the client receives messages A and B, it attempts to decrypt message A with the NT hash generated from the password entered by the user. If the user entered password does not match the password in the authentication service database then decryption of message A will fail. Once message A is decrypted, the client obtains the *Client/TGS Session Key*. This session key is used for further communications with the ticket granting service. (Note: The client cannot decrypt Message B, as it is encrypted using the KDC long term secret key.)

### Client Service Authorization

(1) TGS-REQ: When requesting services, the client sends the following messages to the ticket granting service:

* Message C: Composed of the ticket granting ticket and the service principal name of the requested service.
* Message D: Authenticator (which is composed of the client ID and the timestamp), encrypted using the *Client/TGS Session Key*.

(2) TGS-REP: Upon receiving messages C and D, the ticket granting service retrieves the ticket granting ticket out of message C and decrypts it using the KDC long term secret key. This gives it the *Client/TGS Session Key* and the client ID (the client ID is part of the privilege attribute certificate). Using the *Client/TGS Session Key*, the ticket granting service decrypts message D (Authenticator) and compares the client IDs from the ticket granting ticket and message D; if they match, the server sends the following two messages to the client:

* Message E: *Service ticket* (which includes the privilege attribute certificate, client network address, validity period, and *Client/Server Session Key*) encrypted using the service's long term secret key.
* Message F: *Client/Server Session Key* encrypted with the *Client/TGS Session Key*.

### Client Service Access

(1) AP-REQ: Upon receiving messages E and F from ticket granting service, the client has enough information to authenticate itself to the service server. The client connects to the service server and sends the following two messages:

* Message E: The *service ticket* (as provided by the ticket granting service; see above).
* Message G: A new Authenticator, which includes the client ID, timestamp and is encrypted using *Client/Server Session Key*.

(2) AP-REP: The service server decrypts the service ticket (message E) using its long term secret key to retrieve the *Client/Server Session Key*. Using the sessions key, it then decrypts the Authenticator and compares client ID from the service ticket and message G. If they match the server sends the following message to the client to confirm its true identity and willingness to serve the client:

* Message H: The timestamp found in client's Authenticator (sometimes modified, depending upon the version of Kerberos being used), encrypted using the *Client/Server Session Key*.

(3)  The client decrypts the confirmation (message H) using the *Client/Server Session Key* and checks whether the timestamp is correct. If so, then the client can trust the server and can start issuing service requests to the server.

(4) The server provides the requested services to the client.

## .kirbi Files

There's a bit of terminology creep when discussing Kerberos tickets. Mimikatz and Rubeus are actually dumping Kerberos data structures (as .kirbi files), which contain *both* a ticket *and* the corresponding session key. People tend to call these .kirbi files "tickets", but it's worth keeping in mind that they contain *both* pieces of data (as a "ticket" in the Kerberos sense, not the hacker's sense, isn't useful without the corresponding session key).

* [Rubeus - Now With More Kekeo](http://www.harmj0y.net/blog/redteaming/rubeus-now-with-more-kekeo/)
* [Using Mimikatz](./Using%20Mimikatz.md)
* [Using Rubeus](./Using%20Rubeus.md)

## Atacking Kerberos

### Kerberoasting

Kerberoasting is where a service ticket is used to brute force a service password. This password can then be used to either move laterally or (if the service runs with elevated privileges) to elevate your privileges.

Note that not every account is kerberoastable, though it's not 100% obvious from this walk-through why that is. The Kali Linux tool `bloodhound` can be used to identify potentially kerberoastable accounts.

The `Invoke-Kerberoast` PowerShell module can be used to create a dump of service tickets that can then be attacked offline using Hashcat of John the Ripper. (Note that calling `Out-File` with the `-Width 8000` option is important in the below example, as otherwise the ticket can be truncated!)

```powershell
Invoke-Kerberoast -OutputFormat Hashcat |
	Select-Object Hash |
	Out-File -filepath "$FILE_PATH" -Width 8000
```

The main defenses against kerberoasting are (1) strong passwords and (2) making sure you're not running any services as domain admin (which you shouldn't need to do in this day and age anyway).

* [EmpireProject / Empire / module_source / credentials / Invoke-Kerberoast.ps1](https://github.com/EmpireProject/Empire/blob/master/data/module_source/credentials/Invoke-Kerberoast.ps1)
* [Using Hashcat](./Using%20Hashcat.md)
* [Using John the Ripper](./Using%20John%20the%20Ripper.md)

### AS-REP Roasting

AES-REP roasting is basically kerberoasting for regular user accounts. The only requirement to roast a user account is that Kerberos pre-authentication is disable.

(When pre-authentication is disabled, the authentication server will supply a ticket granting ticket and a session key automatically when requested, *without first verifying the user*. This data is then stored offline by the Windows machine for later decryption when the user with pre-authentication disabled logs in. But this means that all we need to do is to break the user's NT hash!)

Basically the only mitigation for this attack is to keep pre-authentication enabled, though strong password policies can help.

* [Windows Password Hashes](./Windows%20Password%20Hashes.md)

### Pass the Ticket Attacks

The only real way to defend against this attack is to *only* allow domain admins to log into domain controllers, *not* lower privileged machines!

## Golden/Silver Ticket Attacks

The idea with gold and silver tickets is that, since the KDC and service long term secret keys are just the NT hashes of the corresponding service account's passwords, then if you can dump the password (or even its hash), you can *forge* a kerberos ticket without ever needing to contact the KDC.

Silver tickets are forged using a service account's NT hash, and can be used to grant any user access to that service. This works because Kerberos implicitly assumes that *only* the KDC and the service account know the service account's long term secret key.

Golden tickets take things a step further - if you can get the `krbtgt` *user*'s NT hash, then you can forge a ticket granting ticket for any user, and then use that to get the KDC to provide a valid service ticket for any service that user has access to. This works because Kerberos trusts the encrypted ticket granting ticket blob and *doesn't reauthenticate the user before granting further access*.

Golden tickets are powerful (since you can be anyone, it's trivial to gain control of the domain), but also noisier - because you're running through the KDC infrastructure, golden ticket still generate (almost) all of the normal logging, while silver tickets allow you to bypass the KDC completely and only generate logs on the service server (if that).

* [Golden ticket attacks: How they work - and how to defend against them](https://blog.quest.com/golden-ticket-attacks-how-they-work-and-how-to-defend-against-them/)
* [Silver & Golden Tickets](https://en.hackndo.com/kerberos-silver-golden-tickets/)
