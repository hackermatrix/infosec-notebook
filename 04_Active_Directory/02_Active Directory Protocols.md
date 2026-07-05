	

## 1. DNS - Do not sssssssss
- Active Directory Domain Services (AD DS) uses DNS to allow clients (workstations, servers, and other systems that communicate with the domain) to locate Domain Controllers and for Domain Controllers that host the directory service to communicate amongst themselves.
- DNS is used to resolve hostnames to IP addresses and is broadly used across internal networks and the internet. 
- Private internal networks use Active Directory DNS namespaces to facilitate communications between servers, clients, and peers. <mark style="background: #FFB86CA6;">AD maintains a database of services running on the network in the form of service records (SRV)</mark>. 
- These service records allow clients in an AD environment to locate services that they need, such as a file server, printer, or Domain Controller.

### 1.2 DNS vs SRV
- **DNS** : Name - > IP
- **SRV** : Service → Server + Port

## 2. LDAP
- Active Directory supports [Lightweight Directory Access Protocol (LDAP)](https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol) for directory lookups.
- LDAP uses <mark style="background: #FF5582A6;">port 389</mark>, and LDAP over SSL (LDAPS) communicates over <mark style="background: #FFB86CA6;">port 636</mark>.
- An LDAP session begins by first connecting to an LDAP server, also known as a <mark style="background: #FFB86CA6;">Directory System Agent</mark>.
- ![[Pasted image 20260621195244.png]]
>[! Information]
>The relationship between AD and LDAP can be compared to Apache and HTTP. The same way Apache is a web server that uses the HTTP protocol, Active Directory is a directory server that uses the LDAP protocol.

### 2.2 AD LDAP Authentication
- LDAP is set up to authenticate credentials against AD using a "BIND" operation.
- There are two types of LDAP auth in AD.
	1. **Simple Authentication** :
		- Simple authentication means that a `username` and `password` create a BIND request to authenticate to the LDAP server.
	2. **SASL Authentication** :
		-  [The Simple Authentication and Security Layer (SASL)](https://en.wikipedia.org/wiki/Simple_Authentication_and_Security_Layer) framework uses other authentication services, such as Kerberos, to bind to the LDAP server and then uses this authentication service (Kerberos in this example) to authenticate to LDAP.
		
> [!Important]
>LDAP authentication messages are sent in cleartext by default so anyone can sniff out LDAP messages on the internal network. It is recommended to use TLS encryption or similar to safeguard this information in transit.

## 3. MSRPC
- MSRPC is Microsoft's implementation of Remote Procedure Call (RPC).
- Windows systems use MSRPC to access systems in Active Directory using four key RPC interfaces.
- <mark style="background: #BBFABBA6;">MSRPC lets a program on one computer execute functions on another computer as if they were local.</mark>
- 