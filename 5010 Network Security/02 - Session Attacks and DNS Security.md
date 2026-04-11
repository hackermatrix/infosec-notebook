# Session Attacks and DNS Security

## Session Hijacking
![[Pasted image 20260408131306.png]]

**Two different types** of session hijacking:

![[Pasted image 20260408132206.png]]

### Refresher: What Are Sequence Numbers?

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

### How TCP Session Hijacking Works

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

### How is This Different From a Replay Attack?

Great question — they sound similar but are fundamentally different:

![[Pasted image 20260408132457.png]]

### Session Hijacking Exploits Weak Application Session Management

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

### Why TLS/HTTPS Basically Killed TCP Session Hijacking

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

> See [[05 - Encryption and Secure Protocols#🔒SSL/TLS|SSL/TLS]] for a full breakdown of how TLS works.

## DNS Spoofing
![[Pasted image 20260408141952.png]]

### Quick Recap of DNS Spoofing

```
User asks DNS: "what is the IP for microsoft.com?"
Attacker intercepts and replies faster with fake IP
User goes to attacker's server thinking it's Microsoft
```

This affects **one user at a time**, the attacker has to race the DNS server for every single victim individually. That's exhausting and doesn't scale.

**DNS cache poisoning is the smarter, more devastating version.**

## DNS Spoofing Attack Methods:

### Man in the Middle (MITM):

### Exploiting Time-To-Live (TTL):

https://www.imperva.com/learn/application-security/dns-spoofing/

### DNS Server Compromise:

### What is DNS Caching?

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

### DNS Cache Poisoning

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

### Side by Side Comparison

![[Pasted image 20260408142253.png]]

### What is a Transaction ID?

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

### The Key Problem — Attacker Does NOT Know the ID

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

### It's a Race Against Time

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

### Why DNS Server Accepts the First Match

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

### Why 16 bits is Too Small

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

## DNSSEC

### How DNSSEC Works

**DNS Security Extensions** — adds cryptographic signatures to DNS responses.

Remember the pattern we've seen before:

- BGP had no verification → [[01 - DoS and DDoS Attacks#What is RPKI?|RPKI]] added cryptographic certificates
- DNS had no verification → DNSSEC adds cryptographic signatures

Same concept, same solution.

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

### DNSSEC Chain of Trust

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

### All Together

```
DNS Spoofing        = race one user's query with fake response
DNS Cache Poisoning = poison the DNS server itself → affects thousands
DNSSEC              = cryptographic signatures on DNS responses
                      fake responses fail signature check
                      cache poisoning becomes impossible
```


