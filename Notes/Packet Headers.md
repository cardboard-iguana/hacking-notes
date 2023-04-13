# Packet Headers

## Important/Common TCP Packet Headers

* Time to Live (TTL) - How long a packet should live on the network before being discarded.
* Source port - A random (unused) port chosen by the sender.
* Destination port - The port on the receiving end, which normally is determined by the application being used.
* Source address - "From" IP address.
* Destination address - "To" IP address.
* Sequence number - A random number that identifies a given connection.
* Acknowledgement number - Starts at the sequence number and then increases by the number of bytes received in the previous packet (or 1 is the previous packet did not include a data segment). Used to ensure that no data is lost, and that packets are reassembled in the right order.
* Checksum - Integrity check.
* Data - The, well, data.
* Flag(s) - How the packet should be handled (SYN, ACK, FIN, RST, etc.).

There's potentially *a lot* more detail then this in a TCP packet header, however.

* [DEF CON 30](https://defcon.org/html/defcon-30/dc-30-index.html)

## Important/Common UDP Packet Headers

* Time to Live (TTL) - How long a packet should live on the network before being discarded.
* Source port - A random (unused) port chosen by the sender.
* Destination port - The port on the receiving end, which normally is determined by the application being used.
* Source address - "From" IP address.
* Destination address - "To" IP address.
* Data - The, well, data.
