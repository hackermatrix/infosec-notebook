# Active Directory Basics

Active Directory (AD) is a directory service developed by Microsoft for Windows domain networks.

## 🧱 Category Roadmap

> [!NOTE]
> This note has been split into specific modules for better clarity and performance.

### 1. [[04_Active_Directory/AD_Foundations|AD Foundations]]
Basic architecture: Forests, Domains, DCs, and OUs.

### 2. [[04_Active_Directory/AD_Objects|AD Objects]]
The building blocks: Users, Computers, and Groups (Scopes & Permissions).

### 3. [[04_Active_Directory/AD_GPOs|Group Policy Objects (GPOs)]]
How policies are applied and abused for lateral movement.

### 4. [[Kerberos|Authentication Protocols]]
Deep dive into the Kerberos flow (AS-REQs, TGTs, TGSs).

---

## 💡 Key Mental Models
- Everything in AD is an **object**.
- Not all objects are **security principals**.
- OUs organize; Groups control access; GPOs enforce behavior.

---
**Related Indexes:**
- [[04_Active_Directory/AD Vulns Index|Vulnerabilities Index]]
- [[Reverse Engineering MOC|Global Master MOC]]