- Aside from Kerberos and LDAP, Active Directory uses several other authentication methods which can be used (and abused) by applications and services in AD. These include LM, NT, NTLMv1, and NTLMv2.
- <mark style="background: #FFB86CA6;">LM and NT are hash algorithms used to store password credentials. NTLMv1 and NTLMv2 are authentication protocols built on top of these hashes.</mark>
- NTLMv1 can use either LM or NT hashes, while NTLMv2 exclusively uses NT hashes.
![[Pasted image 20260705175504.png]]

## LM Hash (Obsolute and not in use anymore)
- Poor implementation 
- Disabled by default.

## 