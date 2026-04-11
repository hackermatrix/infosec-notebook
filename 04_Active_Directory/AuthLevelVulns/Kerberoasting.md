##### Resource : https://www.semperis.com/blog/protecting-active-directory-from-kerberoasting/

## What is Kerberoasting?

**Kerberoasting** is a post-exploitation attack technique that takes advantage of how Microsoft Active Directory uses the Kerberos protocol for authentication. Specifically, it targets the **Service Principal Names (SPN)** registered to domain user accounts.

When a user wants to access a service (like SQL or a Web server), they request a Service Ticket (TGS) from the Domain Controller. This ticket is encrypted with the NTLM hash of the service account's password. 

The key vulnerability is that **any authenticated domain user** can request these service tickets for any service account. Since the ticket is encrypted with the account's password hash, an attacker can request the ticket, extract it from memory, and attempt to crack it offline to reveal the plaintext password.

---

## The Basic Process

1. **Discovery**: Authenticated user identifies domain accounts with Service Principal Names (SPNs) set.
2. **Ticket Request**: The user requests a service ticket (TGS) for those accounts from the Domain Controller.
3. **Extraction**: The tickets are extracted from memory (or via tools that perform the request and save the ticket).
4. **Offline Cracking**: The attacker uses tools like Hashcat or John the Ripper to brute-force the password hash contained in the ticket.

---

## How is Kerberoasting Tested By Pentesters?

Pentesters use various tools to automate the discovery and ticket request process:

### 1. Discovery & Requesting Tickets (Windows)
Using **PowerView**:
```powershell
# Find users with SPNs and request tickets
Get-DomainUser -SPN | Get-DomainSPNTicket -Format Hashcat
```

Using **Rubeus**:
```powershell
# Perform Kerberoasting and output hashes in Hashcat format
.\Rubeus.exe kerberoast /format:hashcat /outfile:hashes.txt
```

### 2. Remotely (Linux/Impacket)
If you have valid domain credentials, you can Kerberoast from an external machine:
```bash
GetUserSPNs.py -dc-ip <DC_IP> <DOMAIN>/<USER>:<PASSWORD> -request
```

### 3. Cracking the Hashes
Once the hashes are obtained, use **Hashcat**:
```bash
hashcat -m 13100 hashes.txt /path/to/wordlist.txt
```

---

## How to fix it 

Kerberoasting is a design feature of Kerberos, but it can be mitigated and detected:

1. **Strong Passwords**: Ensure that service accounts have long, complex passwords (25+ characters). This makes offline cracking statistically impossible.
2. **Managed Service Accounts (gMSA)**: Use Group Managed Service Accounts (gMSAs). These accounts have complex, 120-character passwords that are automatically managed and rotated by Windows, making them immune to Kerberoasting.
3. **Least Privilege**: Only assign SPNs to service accounts that absolutely require them. Avoid using high-privileged accounts (like Domain Admins) as service accounts.
4. **Monitoring and Detection**:
    - Monitor for **Event ID 4769** (A Kerberos service ticket was requested).
    - Look for an unusual volume of requests for RC4-encrypted tickets (0x17) from a single user.
    - Set up **Honey SPNs**—fictitious service accounts that, when accessed, trigger an alert.