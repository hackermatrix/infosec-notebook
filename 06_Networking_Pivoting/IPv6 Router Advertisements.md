Pv6 works very differently from IPv4.

### In IPv4:

- DNS = manually set OR DHCP
- Static, explicit
### In IPv6:

- **Auto-configuration is the default**
- Hosts _listen_ for announcements

These announcements are called:
> **Router Advertisements (RA)**

---

## 📡 What Is a Router Advertisement?

It’s a message that says:

> “Hey everyone, I’m a router  
> Here’s:  
> • a gateway  
> • a DNS server  
> • how to reach the network”

And the scary part?

🔴 **RAs are unauthenticated by default**