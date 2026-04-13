# Wireless Security

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

### Access Point — Bridge Between Wireless and Wired

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

## WiFi Authentication

### Key Terminology

[WiFi Hacking CheatSheets ](https://github.com/koutto/pi-pwnbox-rogueap/wiki/07.-WPA-WPA2-Enterprise-\(MGT\)#8021x-terminology)

**Supplicant** = The user or client device that wants to be authenticated and given access to the network.
    Eg. your laptop/phone
    
**Authenticator** = The device in between the **Supplicant and Authentication Server** (i.e. AP in wireless network).
Access Point is like a Middle man it does NOT check credentials itself Just passes messages between supplicant and authentication server Like a receptionist forwarding your ID to the security office

**Authentication server** = The actual server doing the authentication, typically a **RADIUS server**. (R**emote Authentication Dial-In User Service)**. Server that can be used to query either a local user database, or an external database via LDAP protocol.

**EAP (Extensible Authentication Protocol)** = Authentication framework, not a specific authentication mechanism. It provides various authentication methods. Some methods also support the encapsulation of an "inner method".

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

### EAP / RADIUS / LDAP

#### What is LDAP?

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
#### How RADIUS and LDAP Connect

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

### PSK vs EAP/RADIUS Side by Side

![[Pasted image 20260408181252.png]]

### Challenge-Response Mechanism

![[Pasted image 20260409160015.png]]
Challenge-response flow: **AP sends challenge (plain)** → gives client something to encrypt Client encrypts it with PSK → proves knowledge without revealing key AP verifies by decrypting → if it matches, client is authentic 

**Why plain challenge first:** Creates a shared test case
Client has something specific to encrypt AP has something specific to verify against Challenge itself is not secret, response proves the secret PSK = yes, essentially the WiFi password.
Technically passphrase → PBKDF2 → actual 256 bit key But PSK and password refer to the same thing in practice 
Note placement: Under PSK authentication section 
As the authentication mechanism Before four-way handshake section (authentication happens first, then key exchange)

## WiFi Frames

### What is SSID?

**Service Set Identifier** — simply the **name of your WiFi network.**

```
When you look at available WiFi networks on your phone:
"HomeNetwork_5G"        ← this is an SSID
"Starbucks WiFi"        ← this is an SSID
"FBI Surveillance Van"  ← this is an SSID (someone's joke)
"iPhone of John"        ← this is an SSID
```

Every wireless network must have an SSID so devices know **which network is which** when multiple WiFi networks exist in the same area.

### What is a Frame?

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

### Management Frames — Connection Control

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

Key property: NEVER encrypted in WPA2 ❌ Exist BEFORE any keys are established — this is exploited by the [[#Disassociation Attack Explained|Disassociation Attack]]. 
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
#### What Are Beacons?

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

#### What's Inside a Beacon Frame

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

#### Why This is a Security Problem

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

#### Can You Hide Your SSID?

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

### Control Frames — Traffic Management

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

### Data Frames — Your Actual Content

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

### How All Three Work Together — Real Example

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
### Frame vs Packet — The Relationship

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

### Basic Frame Knowledge for Networking

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

### Connecting to Everything We Studied

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
### Summary

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

### The Weaknesses 

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

## WPA2

WPA2 uses a 4-way handshake to negotiate a fresh encryption key for each session.

Uses PBKDF2 key hierarchy — new keys generated per session, encryption key changed per packet. Supports AES encryption, 64-bit cryptographic integrity check, and authentication via password/token/certificate.

Note: WPA (2003) and WPA2 (2004) replaced WEP with major security improvements.

![[Pasted image 20260408223327.png]]
![[Pasted image 20260408223341.png]]

### Key Hierarchy

#### How WPA2 Key Hierarchy Works

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

#### What PBKDF2 Actually Does — Step by Step

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
#### The SSID as Salt — Why This Matters

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

#### Why 4096 Rounds — The Key Innovation

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

#### What is the PMK?

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
#### What PMK is NOT

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
#### PMK's Only Job, Proving Both Sides Know the Password

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

#### Quick Recap — Why PTK Exists

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

#### What is the PTK?

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
#### The Nonces — Why They Make PTK Unique

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
#### PTK Sub-keys Pairwise Transient Keys
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
#### What is MIC?

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

#### Why KCK specifically generates MIC

```
KCK = Key Confirmation Key (first 128 bits of PTK)
Used ONLY during the four-way handshake
Specifically to protect handshake messages
Making sure nobody tampers with the handshake itself

After handshake is complete:
KCK's job is done
TK takes over for data encryption
```

#### MIC vs CRC (WEP's broken version)

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

#### What is GTK?

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

##### How GTK is delivered

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

##### GTK security properties

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


### Note: GTK is completely separate from PTK. This is a common confusion.

```
PTK (Pairwise Transient Key):
→ Pairwise = between ONE client and AP
→ Unique per client
→ Generated from PMK + nonces
→ Split into KCK + KEK + TK
→ Your laptop's PTK ≠ your phone's PTK

``
#### Data Frames — What Temporal Key Actually Encrypts

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

#### MIC Uses KCK or TK?

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

### Per-Packet Encryption

#### Where We Are in the Key Hierarchy

```
Password → PBKDF2 → PMK → Four-way handshake → PTK
                                                  ↓
                                            TK (Temporal Key)
                                            THIS is where
                                            per-packet keys start
```

The TK from the PTK is the **starting point** for per-packet encryption — but it never directly encrypts data either.

---

#### The Problem With Using TK Directly

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
#### How WPA2 Solves This — TKIP vs CCMP

WPA2 uses two possible protocols for per-packet key mixing:

```
WPA  (2003) → TKIP (transitional, still had weaknesses)
WPA2 (2004) → CCMP with AES (proper solution)
```

Let me explain both:

#### TKIP — How WPA (First Version) Did It

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

#### CCMP — How WPA2 Properly Does It

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

#### AES Counter Mode — How it Actually Works

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

#### The MIC — Integrity Per Packet

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

#### Full Per-Packet Flow Visualized

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

### WPA2 Full Flow Example

#### Stage 0 — Before You Do Anything

```
Your router is already:
Broadcasting beacons every 100ms:
"I am HomeNetwork, WPA2, channel 6"
        ↓
Your laptop passively hears beacon
"HomeNetwork" appears in your WiFi list
```
#### Stage 1 — You Type the Password

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

#### Stage 2 — Association (Before Encryption)

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

#### Stage 3 — Four Way Handshake Begins

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
#### Stage 4 — Encrypted Communication Begins

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

#### Stage 5 — Broadcast Traffic Uses GTK

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

#### Complete Picture in One View

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

#### Why Does Laptop Send MIC Again in Phase 3?

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

### WPA2 Weaknesses

1. Man-in-the-Middle: Frames lack integrity protection — disassociate messages from rogue hosts aren't identified as fake

2. Incomplete authentication: Access point validation can be bypassed

3. Exhaustive key search: Weak passwords are still vulnerable to brute force

4. Attacks are particularly effective against weak passwords

> These weaknesses are addressed in [[#WiFi Protected Access (WPA) 3|WPA3]].

#### Disassociation Attack Explained

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

> Deauthentication attacks are a form of DoS — see [[01 - DoS and DDoS Attacks|DoS and DDoS Attacks]].


#### Incomplete Authentication — AP Validation Bypassed

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

#### Susceptible to Weak Passwords

#### The Offline Attack — No Replay Needed

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
**The attacker never touches the network again.**

```
No replay of handshake
No interaction with AP
No interaction with client
Purely mathematical computation
Done entirely on attacker's own machine
```

#### What Each Key ACTUALLY Prevents

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

#### The Core Issue — What Nothing Can Prevent

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

### Recap of What We Established

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
### How KRACK Exploits This

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

### Why Nonce Reuse is Catastrophic

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

### Is Nonce Reuse Built Into WPA2?

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

### What Attacker Can Do With Nonce Reuse

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
### How It Was Fixed

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

### Why it led to WPA3

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

## WPA3

Terminologies in WPA3

WPA3 introduces **Management Frame Protection (MFP):** 
Cryptographically signs management frames 
Even deauth frames get integrity check Forged deauth → MIC fails → client ignores it ✅

### SAE (Simultaneous Authentication of Equals)

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

### Dragonfly Key Exchange

Dragonfly is the specific mathematical protocol that makes SAE work. It is an improved version of Diffie-Hellman specifically designed for password authentication.

> For the mathematical foundations, see [[05 - Encryption and Secure Protocols#Diffie-Hellman — The Magic Explained|Diffie-Hellman Key Exchange]].

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

### Perfect Forward Secrecy (PFS)

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

> PFS is also a core feature of [[05 - Encryption and Secure Protocols#ECDHE — What TLS Actually Uses|ECDHE in TLS]] — the same concept applied to HTTPS.

---

### OWE (Opportunistic Wireless Encryption)

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
