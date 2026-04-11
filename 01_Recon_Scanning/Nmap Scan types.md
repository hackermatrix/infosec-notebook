- **TCP Connect Scans (`-sT`)**
- **SYN "Half-open" Scans (`-sS`)**
- **UDP Scans (`-sU`**

**TCP Connect scans (`-sT`)**

The flag bits of TCP header

![[Pasted image 20260403143359.png]]

As a brief recap, the three-way handshake consists of three stages. First the connecting terminal (our attacking machine, in this instance) sends a TCP request to the target server with the SYN flag set. The server then acknowledges this packet with a TCP response containing the SYN flag, as well as the ACK flag. Finally, our terminal completes the handshake by sending a TCP request with the ACK flag set. 

![](https://muirlandoracle.co.uk/wp-content/uploads/2020/03/image-2.png)  
![](https://assets.tryhackme.com/additional/imgur/ngzBWID.png)

This is one of the fundamental principles of TCP/IP networking, but how does it relate to Nmap?

Well, as the name suggests, a TCP Connect scan works by performing the three-way handshake with each target port in turn. In other words, Nmap tries to connect to each specified TCP port, and determines whether the service is open by the response it receives.

---

For example, if a port is closed, [RFC 9293(opens in new tab)](https://datatracker.ietf.org/doc/html/rfc9293) states that:

_"... **If the connection does not exist (CLOSED), then a reset is sent in response to any incoming segment except another reset.** A SYN segment that does not match an existing connection is rejected by this means."_

In other words, if Nmap sends a TCP request with the _SYN_ flag set to a **_closed_** port, the target server will respond with a TCP packet with the _RST_ (Reset) flag set. By this response, Nmap can establish that the port is closed.

![](https://assets.tryhackme.com/additional/imgur/vUQL9SK.png)

If, however, the request is sent to an **_open_ port, the target will respond with a TCP packet with the SYN/ACK flags set.** Nmap then marks this port as being _open_ (and completes the handshake by sending back a TCP packet with ACK set).

third possibility.

What if the port is open, but hidden behind a firewall?

Many firewalls are configured to simply **drop** incoming packets. **Nmap sends a TCP SYN request, and receives nothing back. This indicates that the port is being protected by a firewall and thus the port is considered to be _filtered_.**

That said, it is very easy to configure a firewall to respond with a RST TCP packet.

**SYN scans (`-sS`)**

SYN scans (`-sS`) are used to **scan the TCP port-range of a target or targets**; however, the two scan types work slightly differently. SYN scans are sometimes referred to as "_Half-open"_ scans, or _"Stealth"_ scans.  

Where **TCP scans perform a full three-way handshake with the target, SYN scans sends back a RST TCP packet after receiving a SYN/ACK from the server (this prevents the server from repeatedly trying to make the request).** In other words, the sequence for scanning an **open** port looks like this:

![[Pasted image 20260403145436.png]]
This has a variety of advantages

- It can be used to **bypass older Intrusion Detection systems** as they are looking out for a full three way handshake. This is often **no longer the case with modern IDS solutions;** it is for this reason that **SYN scans are still frequently referred to as "stealth" scans.**
- SYN scans are often **not logged by applications listening on open ports**, as standard practice is to log a connection once it's been fully established. Again, this plays into the idea of SYN scans being stealthy.
- Without having to bother about completing (and disconnecting from) a three-way handshake for every port, **SYN scans are significantly faster than a standard TCP Connect scan.**

Disadvantages to SYN scans, namely:

- They **require sudo permissions**[1] in order to work correctly in Linux. This is because **SYN scans require the ability to create raw packets (as opposed to the full TCP handshake),** which is a privilege only the root user has by default.
- Unstable services are sometimes brought down by SYN scans, which could prove problematic if a client has provided a production environment for the test.

, **SYN scans are the default scans used by Nmap _if run with sudo permissions_. If run without sudo permissions, Nmap defaults to the TCP Connect scan we saw in the previous task.**

---

When using a SYN scan to identify closed and filtered ports, the exact same rules as with a TCP Connect scan apply.

**If a port is closed then the server responds with a RST TCP packet. If the port is filtered by a firewall then the TCP SYN packet is either dropped, or spoofed with a TCP reset.**

In this regard, the two scans are identical: the big difference is in how they handle _open_ ports.

---

[1] SYN scans can also be made to work by giving Nmap the CAP_NET_RAW, CAP_NET_ADMIN and CAP_NET_BIND_SERVICE capabilities; however, this may not allow many of the NSE scripts to run properly.


**UDP Scans**

UDP connections are **_stateless_**. This means that, rather than initiating a connection with a back-and-forth "handshake", **UDP connections rely on sending packets to a target port and essentially hoping that they make it. This makes UDP superb for connections which rely on speed over quality (e.g. video sharing), but the lack of acknowledgement makes UDP significantly more difficult (and much slower) to scan. The switch for an Nmap UDP scan is (`-sU`)**

When a packet is sent to an **open UDP port, there should be no response**. When this happens, **Nmap refers to the port as being `open|filtered`**. **The port is open, but it could be firewalled. If it gets a UDP response (which is very unusual), then the port is marked as _open_**. More commonly there is no response, in which case the request is sent a second time as a double-check. **If there is still no response then the port is marked _open|filtered_ and Nmap moves on.**  

When a packet is sent to a **_closed_ UDP port**, the **target should respond with an ICMP (ping)** packet **containing a message** that the port is unreachable. This clearly identifies closed ports, which Nmap marks as such and moves on.

Due to this difficulty in identifying whether a **UDP port is actually open**, UDP scans tend to be incredibly slow in comparison to the various TCP scans **(in the region of 20 minutes to scan the first 1000 ports, with a good connection)**. For this reason it's usually good practice to run an Nmap scan with `--top-ports <number>` enabled. For example, scanning with  `nmap -sU --top-ports 20 <target>`. Will scan the top 20 most commonly used UDP ports, resulting in a much more acceptable scan time.

---

When scanning UDP ports, **Nmap usually sends completely empty requests -- just raw UDP packets. That said, for ports which are usually occupied by well-known services, it will instead send a protocol-specific payload which is more likely to elicit a response from which a more accurate result can be drawn.**


**NULL, FIN and Xmas**

NULL, FIN and Xmas TCP port scans are **less commonly used** than any of the others we've covered already, so we will not go into a huge amount of depth here. All three are interlinked and are used primarily as they tend to be even **stealthier**, relatively speaking, than a SYN **"stealth" scan. Beginning with NULL scans:**

As the name suggests, **NULL scans (`-sN`**) are **when the TCP request is sent with no flags set at all**. As per the RFC, the target host should **respond with a RST if the port is closed.**

![[Pasted image 20260403171908.png]]
FIN scans (`-sF`) work in an almost identical fashion; however, instead of sending a completely empty packet, a request is sent with the FIN flag (usually used to gracefully close an active connection). Once again, Nmap expects a RST if the port is closed.
![[Pasted image 20260403172138.png]]
As with the other two scans in this class, Xmas scans (`-sX`) send a malformed TCP packet and expects a RST response for closed ports. It's referred to as an xmas scan as the flags that it sets (PSH, URG and FIN) give it the appearance of a blinking christmas tree when viewed as a packet capture in Wireshark.
![[Pasted image 20260403172434.png]]
The expected response for _open_ ports with these scans is also identical, and is very similar to that of a UDP scan. If the port is open then there is no response to the malformed packet. Unfortunately (as with open UDP ports), that is _also_ an expected behaviour if the port is protected by a firewall, so NULL, FIN and Xmas scans will only ever identify ports as being _open|filtered_, _closed_, or _filtered_. If a port is identified as filtered with one of these scans then it is usually because the target has responded with an ICMP unreachable packet.  

It's also worth noting that while RFC 793 mandates that network hosts respond to malformed packets with a RST TCP packet for closed ports, and don't respond at all for open ports; this is not always the case in practice. In particular Microsoft Windows (and a lot of Cisco network devices) are known to respond with a RST to any malformed TCP packet -- regardless of whether the port is actually open or not. This results in all ports showing up as being closed.  

That said, the goal here is, of course, firewall evasion. Many firewalls are configured to drop incoming TCP packets to blocked ports which have the SYN flag set (thus blocking new connection initiation requests). By sending requests which do not contain the SYN flag, we effectively bypass this kind of firewall. Whilst this is good in theory, most modern IDS solutions are savvy to these scan types, so don't rely on them to be 100% effective when dealing with modern systems.

ICMP Network Scanning

 Nmap sends an ICMP packet to each possible IP address for the specified network. When it receives a response, it marks the IP address that responded as being alive.
 
`-sn` switch in conjunction with IP ranges which can be specified with either a hypen (`-`) or CIDR notation. i.e. we could scan the `192.168.0.x` network using:

- `nmap -sn 192.168.0.1-254`

or

- `nmap -sn 192.168.0.0/24`

The `-sn` switch tells Nmap not to scan any ports -- forcing it to rely primarily on ICMP echo packets (or ARP requests on a local network, if run with sudo or directly as the root user) to identify targets. In addition to the ICMP echo requests, the `-sn` switch will also cause nmap to send a TCP SYN packet to port 443 of the target, as well as a TCP ACK (or TCP SYN if not run as root) packet to port 80 of the target.


## What Nmap Does By Default (Two Separate Steps)

```
Step 1: PING the host      → "Are you alive?"
Step 2: SCAN the ports     → "Which ports are open?"
```
## The Problem `-Pn` Solves

Some hosts **block ICMP ping** entirely (Windows does this by default, many firewalls too):

```
Nmap: "ping 10.10.10.5" → no response
Nmap: "host must be dead, skip it"  ← WRONG assumption
```

But the host IS alive — it just silently drops pings.

---

## What `-Pn` Does

```
Without -Pn:   Ping first → no response → skip host → miss it entirely
With -Pn:      Skip ping → go straight to port scanning → find open ports
```

So `-Pn` is saying **"assume the host is alive, don't ping, just scan"**

It's worth noting that if you're already directly on the local network, Nmap can also use ARP requests to determine host activity.

The following switches are of particular note:

- **`-f`**:- Used to **fragment the packets (i.e. split them into smaller pieces) making it less likely that the packets will be detected by a firewall or IDS.**
- An alternative to `-f`, but providing more control over the size of the packets: **`--mtu <number>`, accepts a maximum transmission unit size to use for the packets sent. This _must_ be a multiple of 8.**
- **`--scan-delay <time>ms`**:- used to add a delay between packets sent. This is very useful if the network is unstable, but also for evading any time-based firewall/IDS triggers which may be in place.
- **`--badsum`**:- this is used to generate in **invalid checksum for packets**. Any real TCP/IP stack would drop this packet, however, firewalls may potentially respond automatically, without bothering to check the checksum of the packet. As such, this switch can be used to determine the presence of a firewall/IDS.

https://nmap.org/book/man-bypass-firewalls-ids.html


