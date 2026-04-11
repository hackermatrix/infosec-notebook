# Active Directory Group Policy Objects (GPOs)

GPOs are the primary mechanism for enforcing security settings and behavior across an AD environment.

## 1. Anatomy of a GPO
A GPO consists of two distinct parts:
1. **Group Policy Container (GPC)**: Stored in AD database. Contains metadata and versioning.
2. **Group Policy Template (GPT)**: Stored in **SYSVOL**. Contains the actual scripts, registry settings, and ADMX data.

---

## 2. GPO Linking & Targeting
GPOs can be linked at the following levels:
- **Site**
- **Domain**
- **Organizational Unit (OU)**

> [!WARNING]
> GPOs **cannot** be linked directly to individual Groups or Users. They apply based on the OU location of the object.

---

## 3. Security Filtering
- **OUs** define **WHERE** policies apply.
- **Security Groups** (via ACLs) define **WHO** within that scope actually receives the policy.

---

## 4. Pentesting Relevance
- **GPO Modification**: If you can write to a GPO, you can achieve mass compromise (e.g., adding a local admin to all machines).
- **SYSVOL Leaks**: Ancient GPOs might contain passwords in `Groups.xml` (GPP passwords).
- **Persistence**: GPOs are an excellent way to maintain long-term access via scheduled tasks.

---
**Related Topics:**
- [[04_Active_Directory/AD_Foundations|AD Foundations]]
- [[01_Recon_Scanning/Nmap Cheatsheet|Recon Tools]]
