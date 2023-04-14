# SIP Protocol

SIP usually uses ports 5060 TCP or UDP for unencrypted signaling or 5061 for encrypted transportation using TLS.

SIP is an ASCII based protocol which has some similar elements like in the HTTP protocol by using a request/response model. Much like an HTTP request from a browser a SIP client request is made using a SIP URI a user agent and a method/request. SIP uses e-mail like addresses format:

* sip:205@192.168.1.100
* sip:username@pbx.com
* sip:205@192.168.1.100:5060
* etc.

## SIP Requests/Methods

* INVITE - Used to invite and account to participate in a call session.
* ACK - Acknowledge an INVITE request.
* CANCEL - Cancel a pending request.
* REGISTER - Register user with a SIP server.
* OPTIONS - Lists information about the capabilities of a caller.
* BYE - Terminates a session between two users in a call.
* REFER - Indicates that the recipient(identified by the Request URI) should contact a third party using the contact information provided in the request.
* SUBSCRIBE - The SUBSCRIBE method is used to request current state and state updates from a remote node.
* NOTIFY - The NOTIFY method is used to notify a SIP node that an event which has been requested by an earlier SUBSCRIBE method has occurred.

### Example SIP INVITE Request

```sip
INVITE sip:201@192.168.1.104 SIP/2.0
Via: SIP/2.0/UDP 192.168.1.102;rport;branch=z9hG4bKvbxaoqar
Max-Forwards: 70 

To: 
From: "NightRanger" ;tag=eihgg
Call-ID: hfxsabthoymshub@backtrack
CSeq: 649 INVITE
Contact: 
Content-Type: application/sdp 

Allow: INVITE,ACK,BYE,CANCEL,OPTIONS,PRACK,REFER,NOTIFY,SUBSCRIBE,INFO,MESSAGE
Supported: replaces,norefersub,100rel
User-Agent: Twinkle/1.2 

Content-Length: 310
```

## SIP Responses

* 1xx - Informational responses.
* 2xx - Successful responses: The action was successfully received, understood, and accepted.
* 3xx - Redirection responses.
* 4xx - Request failure responses: The request contains bad syntax or cannot be fulfilled at the server.
* 5xx - Server failure responses: The server failed to fulfill an apparently valid request.
* 6xx - Global failure responses: The request cannot be fulfilled at any server.

## Example SIP Call

* The calling phone sends an invite.
* The called phone sends back a response of 100 (Trying).
* The called phone then starts to ring and sends a response of 180 (Ringing).
* When the caller picks up the phone the called phone sends a response of 200 (OK).
* The calling phone sends an ACK response.
* Conversation begins via RTP.
* When the caller hangs up the phone a BYE request is sent.
* The calling phone responds with 200 (OK).

## References

* [slyth11907 / Cheatsheets](https://github.com/slyth11907/Cheatsheets)
