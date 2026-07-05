- Aside from Kerberos and LDAP, Active Directory uses several other authentication methods which can be used (and abused) by applications and services in AD. These include LM, NT, NTLMv1, and NTLMv2.
- <mark style="background: #FFB86CA6;">LM and NT are hash algorithms used to store password credentials. NTLMv1 and NTLMv2 are authentication protocols built on top of these hashes.</mark>
- NTLMv1 can use either LM or NT hashes, while NTLMv2 exclusively uses NT hashes.
![[Pasted image 20260705175504.png]]

## LM Hash (Obsolute and not in use anymore)
- Poor implementation 
- Disabled by default.

## NTHash (NTLM)
- Used by modern Windows systems.
- Uses Challenge-response authentication Protocol.
![[Pasted image 20260705180109.png]]
The Flow :
- **You try to log in** to a server (say, a file share).
- **The server sends you a random number** (the "challenge") — this is just to prevent replay attacks.
- **Your computer encrypts that random number using a hash of your password** as the key, and sends the result back (the "response").
- **The server does the same calculation** (or asks a domain controller to do it) using its own copy of your password hash, and checks if it gets the same result.
- **If the two match, you're authenticated** — because only someone with the correct password hash could have produced that exact response.



## NTLMv1 (Net-NTLMv1)

- <mark style="background: #FFB86CA6;">It is not someting different from NTLM above .</mark>

- **Net-NTLMv1 hash** (sniffed off the wire during a login) = the _challenge already baked in_ to the response → can't be replayed as a PTH key directly, but it _can_ be cracked offline (via the DES weakness) to recover the underlying NTLM hash, or relayed live to another server before it expires.


## NTLMv2 (Net-NTLMv2)
- NTLMv2 is Microsoft's fix for the specific weaknesses we just covered — it doesn't change the overall challenge-response philosophy of NTLM, but it replaces the weak DES-based math with something much stronger.

**Key improvements over v1:**

- **HMAC-MD5 instead of DES.** No more splitting the hash into three DES keys — which is what killed v1 via that weak "2 real bytes" third key. HMAC-MD5 doesn't have that structural flaw.
- **A client nonce is added.** <mark style="background: #FFB86CA6;">In v1, the response was built only from the server's challenge. In v2, the client also generates its own random value and mixes it in. </mark>This means the same login attempt never produces the same response twice — even against a malicious server replaying an old challenge.
- **A timestamp is included.** This adds freshness and helps prevent replay attacks — a captured response has a shelf life.
- **The response is variable-length** (the "blob"), containing the timestamp, client nonce, target info (domain/server names), and more — versus v1's fixed 24 bytes. This kills precomputed rainbow-table attacks against the full response, since the extra entropy varies every time.
- **No LM hash fallback** — NTLMv2 always uses the NT hash, avoiding that legacy weak-hash path entirely.
![[Pasted image 20260705183810.png]]


## MSCache2 
- When you log into a Windows machine joined to a domain, it normally authenticates you against the domain controller. But if you're offline (say, a laptop with no VPN connection), Windows still needs to let you log in with cached credentials from your _last successful_ domain login. DCC2 is how that cached credential is stored and verified.

![[Pasted image 20260705184343.png]]
