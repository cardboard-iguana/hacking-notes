# Cisco IOS Cheatsheet

**source:** [slyth11907 / Cheatsheets](https://github.com/slyth11907/Cheatsheets)

## System Information

```bash
show version                 # Software & hardware information
show running-config          # Current configuration
show startup-config          # Boot configuration
show history                 # Command history buffer
show ip interface brief      # Interface overview
show interface $TYPE $NUM    # Detailed interface information
show interfaces description  # Interface descriptions
show interfaces status       # Status of all interfaces
show crypto key mypubkey rsa # Current SSH public key
show dhcp lease              # Current DHCP status/information
```

## Configuration Modes

```bash
config           # General configuration mode
config interface # Interface configuration mode
config line      # Serial console configuration mode
```

### General Configuration

```bash
hostname $HOSTNAME                 # Set switch hostname
enable secret $MD5_PASS            # Set password using MD5 hash 
enable password $PASSWORD          # Set password using clear text
banner motd $BANNER                # Set login banner
                                   # (use "$" like "EOF")
ip default-gateway $IP_ADDRESS     # Set default gateway
copy running-config startup-config # Persiste current config
```

### Interface Configuration

```bash
# Configure console port
#
config
line con 0
password $PASSWORD
login

# Configure terminal connections
#
config
line vty 0 $VTTY_NUM
password $PASSWORD
login
```

### Line Configuration

```bash
# Configure network interface
#
config
interface $IFACE_TYPE $IFACE_NUM
ip address $IP_ADDRESS $NETMASK
```
