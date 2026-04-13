# Firewalls and Network Architecture

## Firewall Fundamentals
![[Pasted image 20260408144125.png]]

### Firewall Policy Example

![[Pasted image 20260408144304.png]]

## Types of Firewalls
![[Pasted image 20260408144342.png]]

### Packet Filtering Firewall (Layer 3/4)

The most **basic and oldest type of firewall.** It performs a **simple check on data packets — inspecting information such as destination and origination IP address, packet type, port number, and other surface-level details** without opening the packet to examine its contents. [Compuquip](https://www.compuquip.com/blog/types-firewall-architectures)

```
Looks at: IP headers, ports, protocol
Does NOT look at: actual content inside packet
Memory: depends on subtype (static/stateless vs dynamic/stateful)
```

Its subtypes:

| Subtype       | What it means                                                        |
| ------------- | -------------------------------------------------------------------- |
| **Static**    | **Rules are fixed, manually set, never change**                      |
| **Dynamic**   | **Rules can change automatically based on traffic**                  |
| **Stateless** | No memory, **each packet judged alone**                              |
| **Stateful**  | Tracks connection state, knows if packet belongs to existing session |

---

### Circuit-Level Gateway (Layer 5)

A circuit-level gateway functions primarily at the **session layer of the OSI model.** Its role is to oversee and **validate the handshaking process between packets for TCP and UDP connections.** When a user seeks to initiate a connection with a remote host, the **circuit-level gateway establishes a circuit** — essentially a virtual connection between the user and intended host. [Palo Alto Networks](https://www.paloaltonetworks.com/cyberpedia/types-of-firewalls)

```
Looks at: Is this a legitimate session/handshake?
Does NOT look at: content inside packets
Key feature: Hides internal IPs from outside world (NAT)
```

While circuit-level gateways ensure that traffic is from a legitimate connection, they don't check the contents of the packet — **meaning a circuit-level gateway will permit malicious connections if they are properly established**. [Cato Networks](https://www.catonetworks.com/network-firewall/firewall-types/)

---

### Stateful Inspection Firewall (Layer 3/4)

Stateful inspection firewalls combine packet inspection technology and TCP handshake verification to offer more serious protection than either architecture could provide alone. They also keep a contextual database of vetted connections and draw on historical traffic records to make decisions. [Compuquip](https://www.compuquip.com/blog/types-firewall-architectures)

```
Looks at: packet headers + tracks entire connection state
Knows: "this packet is a response to a request made 2 seconds ago"
Smarter than basic packet filtering
```

---

### Application-Level Gateway / Proxy (Layer 7)

Application-layer proxy firewalls operate up to Layer 7. Unlike packet filter and stateful firewalls that make decisions based on layers 3 and 4 only, application-layer proxies can make filtering decisions based on application-layer data, such as HTTP traffic. This allows tighter control — instead of relying on IP addresses and ports alone, an HTTP proxy can also make decisions based on HTTP data, including the content of web data. [ScienceDirect](https://www.sciencedirect.com/topics/computer-science/packet-filtering-firewall)

```
Looks at: everything — including actual content of packets
Acts as: middleman between you and the internet
User never directly connects to destination
Proxy connects on your behalf
```

---

### Personal / Host-Based Firewall

This is simply a firewall that runs on your **individual device** rather than at the network level:

```
Windows Defender Firewall = host based firewall
Protects just your machine
Not the whole network
```

https://www.compuquip.com/blog/types-firewall-architectures

## Network Architecture

### Network Address Translation (NAT)

The firewall replaces the internal source IP with its own public IP before forwarding packets to the internet.

→Internal host (192.168.1.35) sends packet to external host (65.216.161.24)

→Firewall (173.203.129.90) rewrites source IP from 192.168.1.35 → 173.203.129.90

→Adds an entry in its translation table: 192.168.1.35:80 ↔ 65.216.161.24:80

→External host sees traffic from 173.203.129.90, not the internal IP

→Prevents internal hosts from being reached directly from the internet

→Enables use of private (RFC 1918) address space internally

### DMZ (Demilitarized Zone)

```
Internet ──→ [Outer Firewall] ──→ DMZ ──→ [Inner Firewall] ──→ Internal Network

DMZ = middle zone
Not fully public (has some firewall protection)
Not fully private (internet can reach it)
```

The DMZ is specifically designed for servers that **need to be reachable from the internet** but should **never have direct access to your internal network.**

→Outer firewall sits between Internet and DMZ

→Inner firewall sits between DMZ and internal network

→DMZ hosts: **web servers, email gateways, remote access servers, FTP servers**

→Systems in the DMZ must be **tightly controlled and hardened**

→**If a DMZ server is compromised, the inner firewall still protects internal resources**

**→Database servers and sensitive systems stay behind the inner firewall**

#### FTP in the DMZ

You're right that FTP is insecure:

- Transfers data in **plain text**
- **No encryption**
- **Credentials sent in clear**
- **Vulnerable to many attacks**

But some organizations still need FTP because:

- **Legacy systems require it**
- **Partners/clients only support FTP**
- **Public file distribution**

So the logic is:
```
"We HAVE to run FTP"
"FTP is risky and faces internet"
"Put it in DMZ so if attacker compromises it"
"They are trapped in DMZ"
"Internal network stays safe behind inner firewall"

vs

Putting FTP inside internal network:
"FTP gets compromised"
"Attacker now has foothold INSIDE your network"
"Access to everything — databases, HR systems, etc"
```

#### Remote Access Servers — Same Logic

Remote access servers (VPN gateways, RDP servers) are also risky because:

- They are specifically designed to **let people in from outside**
- High value target for attackers
- If compromised, attacker gets network access

```
DMZ placement logic:
User from internet → connects to Remote Access Server in DMZ
                              ↓
                    Authentication happens here
                    Identity verified
                              ↓
                    Only THEN allowed through inner firewall
                    into internal network

vs

Internal network placement:
User from internet → directly hits internal network
Compromise = immediate full internal access
```

> Remote access to internal networks is typically secured with VPN tunnels — see [[05 - Encryption and Secure Protocols#IPSec|IPSec/VPN]].

---

#### The Real Purpose of DMZ Placement

|Server|Why Risky|Why Still in DMZ|
|---|---|---|
|**Web Server**|Public facing, HTTP attacks|Needs internet access, isolated if compromised|
|**Email Gateway**|Spam, malware, phishing|Must receive external email, filters before internal|
|**FTP Server**|No encryption, plain text|Legacy needs, isolated so compromise stays contained|
|**Remote Access**|Designed to let people in|Authentication checkpoint before internal access|

## Firewall Limitations

1. **Perimeter Control Only**
2. **Firewalls only protect if they control the ENTIRE perimeter**
3. **No External Protection**
4. **Cannot protect data outside the perimeter**
5. **Attractive Target**
6. Most **visible part of an installation to outsiders — prime attack target**
7. **Configuration Dependent**
8. Must be **correctly configured, updated as environment changes, and logs reviewed periodically**
9. **Limited Content Control**
10. Minor control over admitted content, **malicious code must be controlled inside the perimeter**
11. **Blind to Encryption:** Cannot inspect encrypted communications passing through — see [[05 - Encryption and Secure Protocols#🔒SSL/TLS|SSL/TLS]] and [[05 - Encryption and Secure Protocols#IPSec|IPSec]] for context.


---

## Network Architecture Diagram

```
          Internet (Untrusted)
                  │
                  ▼
  ┌───────────────────────────────────┐
  │   Packet-filtering Firewall       │  L3–4 · IP · port · protocol ACL
  └───────────────────────────────────┘
                  │
                  ▼
  ┌───────────────────────────────────┐
  │   Circuit-level Gateway           │  L5 · TCP/UDP handshake validation
  └───────────────────────────────────┘
                  │
                  ▼
  ╔═══════════════════════════════════╗
  ║  DMZ Zone                         ║
  ║  [ DNS Server ]  [ Mail Server ]  ║
  ║        [ Web Server ]             ║
  ║                                   ║
  ║  ┌─────────────────────────────┐  ║
  ║  │  Web Application Firewall   │  ║  L7 · HTTP/S · SQLi · XSS · OWASP
  ║  └─────────────────────────────┘  ║
  ╚═══════════════════════════════════╝
                  │
                  ▼
  ┌───────────────────────────────────┐
  │   Stateful Inspection Firewall    │  L4 · Connection state table
  └───────────────────────────────────┘
                  │
                  ▼
  ╔═══════════════════════════════════╗
  ║  Internal Network                 ║
  ║  [ PCs ]  [ Wi-Fi APs ]           ║
  ║  [ VoIP Phones ]  [ IoT ]         ║
  ║                                   ║
  ║  ┌─────────────────────────────┐  ║
  ║  │  Proxy Firewall (App GW)    │  ║  L7 · Full content inspection
  ║  └─────────────────────────────┘  ║
  ║  ┌─────────────────────────────┐  ║
  ║  │  IDS / IPS (inline)         │  ║  L3–7 · Deep packet inspection
  ║  └─────────────────────────────┘  ║
  ╚═══════════════════════════════════╝
                  │
                  ▼
  ┌───────────────────────────────────┐
  │   Next-Generation Firewall (NGFW) │  L3–7 · App-aware · TLS · Threat Intel
  └───────────────────────────────────┘
                  │
                  ▼
  ╔═══════════════════════════════════╗
  ║  Secure Server Zone               ║
  ║  [ Database ]   [ App Servers ]   ║
  ║  [ Active Directory ] [ Files ]   ║
  ╚═══════════════════════════════════╝
```

### Firewall Details

> [!info]- Packet-filtering Firewall — L3–4
> Operates at OSI layers 3–4. Examines each packet independently against an ACL (source/dest IP, port, protocol). No connection awareness. Extremely fast — the first line of defense at the network edge.

> [!info]- Circuit-level Gateway — L5
> Operates at OSI layer 5 (session layer). Instead of inspecting individual packet contents, it monitors the TCP handshake (SYN → SYN-ACK → ACK) to determine whether a session is legitimate. Once a connection is established and verified, all subsequent packets flow through without further inspection — making it very fast after the initial check.
>
> **Key traits:**
> - Validates sessions, not payloads — cannot detect malicious data inside packets
> - Hides internal network details by acting as a relay between source and destination
> - Lower overhead than application-layer proxies since it doesn't parse content
> - Often implemented as part of SOCKS proxies (e.g., SOCKS5)
> - Best placed just inside the perimeter — after packet filtering strips bad IPs, but before deeper inspection begins
>
> **Limitation:** Because it ignores payload content, it cannot block application-layer attacks (SQLi, XSS). That's why the WAF and NGFW sit deeper in the network.

> [!info]- Web Application Firewall (WAF) — L7
> Operates at OSI layer 7 targeting HTTP/HTTPS. Parses request bodies, headers, cookies, and query strings to detect injection attacks, cross-site scripting, and OWASP Top 10 threats. Protects public-facing apps in the DMZ.

> [!info]- Stateful Inspection Firewall — L4
> Maintains a connection state table tracking every active session. Only packets belonging to a known, valid session are allowed through. Catches spoofed packets and out-of-state attacks. Sits between the DMZ and internal network.

> [!info]- Proxy Firewall (Application-level Gateway) — L7
> Acts as an intermediary, terminating the internal connection and opening a new one outbound. Inspects full application-layer content (URLs, file types, commands). Hides internal topology and often adds caching and content filtering.

> [!info]- IDS / IPS (Inline Sensor) — L3–7
> Performs deep packet inspection using signature-based and anomaly-based detection. IDS monitors and alerts; IPS actively blocks. Catches port scans, buffer overflows, malware, and lateral movement.

> [!info]- Next-Generation Firewall (NGFW) — L3–7
> Combines stateful inspection, application awareness, integrated IPS, TLS decryption, sandboxing, and threat intelligence. Controls traffic by application and user identity. The most comprehensive gatekeeper before critical assets.

### OSI Layer Coverage

| Firewall | OSI Layer | Key Capability |
|---|---|---|
| Packet-filtering | L3–4 | IP · port · protocol ACL |
| Circuit-level gateway | L5 | TCP/UDP session handshake validation |
| Stateful inspection | L4 | Connection state table |
| WAF | L7 | HTTP/S payload · OWASP Top 10 |
| Proxy firewall | L7 | Full content inspection · topology hiding |
| IDS / IPS | L3–7 | Signature + anomaly-based detection |
| NGFW | L3–7 | App-aware · TLS decryption · threat intel |
