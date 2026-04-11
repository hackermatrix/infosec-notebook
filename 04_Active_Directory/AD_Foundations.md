# Active Directory Foundations

Fundamental components that make up the Active Directory environment.

## 1. Domain Controller (DC)
- **What it is:** A Windows Server that hosts Active Directory and handles authentication and authorization.
- **Key functions:**
  - Authenticates users and computers (Kerberos / NTLM).
  - Acts as a **KDC (Key Distribution Center)**.
  - Stores the AD database (`NTDS.dit`).
  - Replicates data with other DCs.
  - Enforces security policies.
  - Usually runs **DNS**.
- **Pentesting Relevance:**
  - Compromising a DC = full domain compromise.
  - Access to credentials, Kerberos tickets, trust relationships.

---

## 2. Domain
- **What it is:** A logical and administrative boundary for managing AD objects.
- **Structure:** DNS-based naming (e.g., `company.com`, `lab.local`).
- **Key points:**
  - Domain is a **replication boundary**.
  - Domain-wide policies like password policy apply here.

---

## 3. Forest
- **What it is:** A collection of one or more domains sharing a common schema, Global Catalog, and trust relationships.
- **Root domain:** First domain created.
- **Pentesting Relevance:**
  - Forest compromise = total AD compromise.
  - Trust abuse, SIDHistory, and child-to-root escalation are common attack paths.

---

## 4. Organizational Units (OUs)
- **What it is:** Containers used to organize objects inside a domain.
- **Purpose:**
  - Apply Group Policies.
  - Delegate administrative control.
- **Important:** OUs are **NOT security principals** (cannot be assigned permissions directly).

---
**Next Steps:**
- [[04_Active_Directory/AD_Objects|AD Objects (Users, Groups, Computers)]]
- [[Kerberos|Authentication Protocols (Kerberos)]]
