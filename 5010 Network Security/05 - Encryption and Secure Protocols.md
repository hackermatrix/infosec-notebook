# Encryption and Secure Protocols

## Link Encryption

### What is a Hop?

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
### What is a Node?

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

### How Link Encryption Works Hop by Hop

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

### "Data Partially Exposed in Sending Host"

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

## End-to-End Encryption

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

### If Data is Encrypted How Do Intermediate Nodes Know Where to Hop?

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

### "Applied by User Application" — Is it Signal/Telegram?

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

### "User Selects Algorithm" — How?

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

### "Requires One Key Per Pair of Users"

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

### "Provides User Authentication"

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

### Full Summary

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

### SSH (Secure Shell)

Originally for UNIX, now on most OSes. **Provides authenticated, encrypted path to OS command line over the network.** Replaces insecure Telnet, rlogin, rsh. Protects against spoofing and modification. Network application level.

#### What is Telnet?

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

#### What is rlogin?

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

> See [[01 - DoS and DDoS Attacks#What IP Spoofing Actually Is|IP Spoofing]] for a detailed explanation of how attackers forge source IPs.

Also like Telnet — everything transmitted in plain text.

---

#### What is rsh?

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

#### All Three Compared

![[Pasted image 20260408213216.png]]

#### How SSH Replaced All Three

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

#### "Network Application Level" — What Does This Mean?

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
### SSL/TLS

> TLS is the reason [[02 - Session Attacks and DNS Security#Why TLS/HTTPS Basically Killed TCP Session Hijacking|TCP session hijacking is largely obsolete]] on modern encrypted connections.

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

#### What is a Cipher Suite?

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
│ AES_256_GCM → Encryption algorithm          │
│               How to encrypt actual data    │
├─────────────────────────────────────────────┤
│ SHA384     → Hash algorithm                 │
│              How to verify data integrity   │
└─────────────────────────────────────────────┘
```

---

#### Cipher Suite Negotiation — The TLS Handshake

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

#### How Does TLS Provide Server Authentication?

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
#### Without Ever Transmitting the Key — How Does it Share the Key?
```
Alice and Bob want to encrypt communication
They need a shared secret key
But they are communicating over the internet
Attacker is watching EVERYTHING they send
        ↓
How do you agree on a secret key
when someone is watching every message?

```
#### Diffie-Hellman — The Magic Explained

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

##### Step by Step With Colors

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

##### The Real Mathematical Version

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

#### "Avoids Modifying TCP Stack"

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

#### "Minimal App Changes"

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

#### "Mostly Used to Authenticate Servers"

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
#### Full TLS Key Exchange Visualized

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

#### ECDHE — What TLS Actually Uses

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
### IPSec
#### What is Tunneling?

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
#### Why Tunneling is Useful
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

#### What is GRE?

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

#### IPSec Components — AH and ESP

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

#### What is ISAKMP Key Exchange?

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

#### Transport Mode vs Tunnel Mode

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

#### "Transparent to Application but Modifies Network Stack"

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

#### How IPSec Authenticates Network Nodes

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

#### "App Still Needs User Auth"

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

#### Full Summary

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


### Onion Routing (Tor)

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

#### How Tor Works

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

#### Why is the Final Link Unencrypted?

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

#### Layered Encryption — The Onion Explained

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
#### .Onion Sites — Hidden Services

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
#### TOR Domain Resolution

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

##### How Tor Actually Solves DNS

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

##### Does Tor Have Its Own DNS Server?

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

##### The .onion Special Case — No DNS Needed

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

##### DNS Leak — The Remaining Weakness

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