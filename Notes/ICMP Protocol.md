# ICMP Protocol

ICMP headers are 8 bytes; the first 4 bytes have a fixed meaning, while the meaning of the last 4 bytes varies depending on the type of request specified in the first 4 bytes.

ICMP traffic "types" correspond to the kind of packet being sent (though different ICMP services can have multiple types):

* 0 — Ping reply
* 8 — Ping request

Ping packets typically just include either random data or all zeros.

* [TryHackMe: Wireshark 101](https://tryhackme.com/room/wireshark)
* [RFC 792](https://datatracker.ietf.org/doc/html/rfc792)
* [Internet Control Message Protocol (Wikipedia)](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)
* [TryHackMe: Jr. Penetration Tester](https://tryhackme.com/path/outline/jrpenetrationtester)
