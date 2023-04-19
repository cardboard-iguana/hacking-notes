# TCP Protocol

The "Transmission Control Protocol". TCP was formalized in September 1981 in RFC793.

* [Transmission Control Protocol (RFC 793)](https://datatracker.ietf.org/doc/html/rfc793.html)
* [TCP Model](./TCP%20Model.md)

## Flags

* URG - Process the current TCP packet immediately. Directs the receiving system to examine the "urgent pointer" field.
* ACK - Acknowledgement. Directs the receiving system to examine the "acknowledgement number" field.
* PSH - Push. Elevate the priority of the packet's data, but does not otherwise change rules around packet processing.
* RST - Reset. Terminates the connection forcefully.
* SYN - Synchronize. Used during the initial three-way handshake to set a shared (starting) sequence number.
* FIN - Finish. Indicates that the connection may be dropped gracefully.

## Acknowledgement Number

The TCP "acknowledgment number" contains the *next* sequence number that the sender is expecting to receive (so basically senders determine the next sequence number). This is the current sequence number (for the other host) + the number of bytes in the data segment of the packet being sent to that host.

Packets with a zero-length data segment that start or continue a conversation (for example, SYN packets) get their sequence/acknowledgement number incremented by 1. This is called a "ghost byte".

The acknowledgement number for RST packets is always 0.

The initial SYN packet that starts the three-way handshake should *not* have an acknowledgement number

## Window Size

The TCP "Window" is the maximum number of bits that the sending system expects to receive from a request (it represents the current buffer size for that connection on that system). This is a 2-byte number, such that the maximum (unscaled) window size if 65535 bytes.

## TCP Options

TCP "options" are set in the initial handshake (the initiating host will propose in the SYN packet, and the receiving host will reply with what it supports in the SYN/ACK packet). Note that each system sets its own window scale and MSS values (but these value must be set by both hosts in order to be used in a connection).

* Window Scale - Set the *multiplier* for the window size (see above) as as a power of two - such that a "Window scale" of 7 is a multiplier of 2⁷ = 128. Window scales can be up to 14, which allows (once multiplied with the maximum window size) *up to* 1 GB of data to be transmitted before an ACK is *required*. Typically set to 2 for webservers, or to 0 for systems that wish to allow the use of this option in a conversation but don't support large buffers themselves.
* Maximum Segment Size (MSS) - The maximum data segment size that a system can receive. This is different than the window size, which is the amount of data that a system expects before it gets an ACK (it's basically that system's buffer for this connection).
* Selective Acknowledgement (SACK) - Allows for packets to be acknowledged as they are received, rather than at the end of a window. Using SACK allows for dropped packets to be retransmitted sooner, and prevents the retransmission of packets that were properly received *after* a dropped packet. However, using SACK requires that the transmitting host keep track of what packets were sent in memory, which means that it's typically not set on resource-constrained systems (IoT, etc.).
* No-Op (NOP) - A "blank" value (`01`) used to pad out the options field, since header size must be a power of two *bytes* but (1) each option need to fall on a byte boundary and (2) we may not have enough options to fill out the space requested. How NOPs are used is highly implementation-dependent. NOPs can also be used by middle-boxes (firewalls, routers, etc.) to *strip* options.

If SACK is used, then acknowledge packet numbers are also placed in the options block.

Differences in how TCP options are responded to for incoming SYN packets or ordered for outgoing SYN/ACK packets are important for fingerprinting operating systems and TCP stacks.

## Initial Round Trip Time

The "initial round trip time" (IRTT) is the time taken for the initial SYN packet in the TCP handshake to the final ACK packet in the initial three-way handshake. Most TCP implementations will *initially* wait for up to 0.5 seconds until retransmitting a packet, but will dynamically adjust this to 3x - 4x the IRTT after the initial handshake. Wireshark will report the IRTT value in the final ACK packet of the three-way handshake.

* [Using Wireshark](./Using%20Wireshark.md)
