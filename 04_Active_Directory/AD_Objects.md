# Active Directory Objects

Detailed breakdown of users, computer accounts, and groups in an AD environment.

## 1. User Accounts
- **Types:** Domain Users, Service Accounts, Built-in Accounts (Administrator, Guest, **krbtgt**).
- **Critical Attributes:**
  - `sAMAccountName`: Login name.
  - `userPrincipalName (UPN)`: email-like identity.
  - `servicePrincipalName (SPN)`: Target for **Kerberoasting**. See [[04_Active_Directory/AD_SPN|SPN Notes]].
  - `userAccountControl`: Flags for status (e.g., password not required).
- **Pentesting Notes:**
  - `krbtgt` compromise leads to **Golden Ticket** attacks.
  - Service accounts often have weak, static passwords.

---

## 2. Computer Accounts
- Every domain-joined machine has a computer account ending with `$`.
- Passwords auto-rotate every 30 days.
- **Abuse Vectors:**
  - Lateral movement.
  - Resource-Based Constrained Delegation (RBCD).
  - NTLM Relay attacks.

---

## 3. Groups
- **Security Groups**: Apply permissions and GPO filtering.
- **Distribution Groups**: Email only (no security context).

### **Group Scopes**
- **Domain Local**: Members from any domain, permissions only in local domain.
- **Global**: Members from local domain, permissions anywhere.
- **Universal**: Members from any domain, permissions anywhere in the forest.

### **High-Value Groups**
- Domain Admins / Enterprise Admins
- Account / Server / Backup Operators
- DnsAdmins

---
**Related Topics:**
- [[04_Active_Directory/AD_Foundations|AD Foundations]]
- [[04_Active_Directory/AD_GPOs|AD Group Policies]]
