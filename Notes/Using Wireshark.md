# Using Wireshark

## User Interface

TCP "conversations" (related packets) can be automatically filtered by right-clicking on a packet and selecting "Conversation Filter > TCP" (this matches all packets with the same source/destination IP/port). This really just automatically applies a filter.

Use "Statistics > Conversations" to get a quick overview of the conversations in a packet capture. You can limit conversation statistics to the current filter view using the "Limit to display filter" checkbox.

Use "Statistics > Capture File Properties" to see information about capture files (you can also include/save comments here!).

### Packet List

By default, the "Time" column is in seconds and starts at zero (0) for the first packet captured. PCAP files actually include the full packet timestamp, so the format of the "Time" column can be changed using "View > Time Display Format".

Wireshark adds some additional packet information, designated as `[Wireshark Data]`. Some examples:

* Stream Index - The index of the streams/conversations displayed in the current filter, starting from 0.
* TCP Segment Length - The packet data length (this is useful for figuring out weird things, like SYN packets with data).
* Conversation Completeness - A measure of how much of the current conversation/stream is present in the packet capture (for TCP conversations, Wireshark expects a handshake, some data, and then a FIN or RST).

Wireshark will also use these fields to note unusual TCP packet behaviors (such as the lack of an MSS option).

When you select an ACK packet in Wireshark, a checkmark will be displayed next to the packet that is being acknowledged.

If you can find an encryption key in a packet dump, you can try applying them to encrypted packets in Wireshark using "Preferences > RSA Keys".

Wireshark can easily extract files from HTTP conversations. To extract them from raw TCP streams, (1) locate the beginning of the stream, (2) right-click on the packet and select "Follow > TCP Stream, (3) change "Show data as" to "Raw", and (4) save it off using "Save As".

## Filtering

* Filter on a negation using `!` (for example, `!arp` filters out ARP packets).
* To see SYN/ACK packets, filter with `tcp.flags.syn == 1 && tcp.flags.ack == 1`.
* To search within packets use the filter `frame contains "$TEXT_TO_SEARCH"`.

If you click on a field for a packet, the filter name is displayed in the lower left. (For example, TCP SYN packets are tcp.flags.syn.) You can automatically apply a filter (or "prepare" a filter, which lets you see the filter before it's applied) by right-clicking on it and choosing "Apply as Filter" (or "Prepare as Filter").

To see (suspected) retransmissions in Wireshark, filter for the `tcp.analysis.retransmission` flag. Some retransmissions may be "fast", in that the packet is transmitted before the TCP timer would have expired. This happens when SACK is used, typically after a packet isn't acknowledged in after three consecutive SACK blocks.

## Customization

Wireshark supports "profiles" (accessible in the lower right in the status bar) that are just collections of settings, filters, layouts, etc.

Wireshark allows filters to be saved for quick access; use the "+" button to the right of the filter bar. Drop-down menus can be created by separating menu components with `//` (for example, `Menu//Submenu//Filter Name`).

Protocol names can be resolved in the Wireshark preferences by checking the "Name Resolution > Resolve transport names" option. IP address resolution is controlled using "Name Resolution > Resolve network (IP) addresses". Wireshark can pull from either DNS querier in the packet capture itself, or from the resolver itself. Using an external resolver can get pretty noisy though.

### Color Rules

Color rules are just filters; they're matched in order (from top down), with the first matched coloring rule applying. Note that Wireshark is not really consistent about applying new coloring rules - it's best to reload the file after creating/modifying rules.
