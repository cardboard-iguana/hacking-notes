# TCP Model

## TCP Model Layers

* Layer 4: Application (highest)
* Layer 3: Transport
* Layer 2: Internet
* Layer 1: Network interface (lowest)

## OSI vs. TCP Models

*Roughly*, the TCP Model encapsulates the OSI Model.

```
+--------------+-------------------+
| OSI LAYER    | TCP/IP LAYER      |
+--------------+-------------------+
| Application  |                   |
+--------------+                   |
| Presentation | Application       |
+--------------+                   |
| Session      |                   |
+--------------+-------------------+
| Transport    | Transport         |
+--------------+-------------------+
| Network      | Internet          |
+--------------+-------------------+
| Data Link    |                   |
+--------------+ Network Interface |
| Physical     |                   |
+--------------+-------------------+
```

## References

* [TryHackMe: Pre Security](https://tryhackme.com/path/outline/presecurity)
* [OSI Model](./OSI%20Model.md)
