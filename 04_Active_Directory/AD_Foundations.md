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






## AD Structure 

- A forest is the security boundary within which all objects are under administrative control. A forest may contain multiple domains, and a domain may include further child or sub-domains. A domain is a structure within which contained objects (users, computers, and groups) are accessible. It has many built-in Organizational Units (OUs), such as `Domain Controllers`, `Users`, `Computers`, and new OUs can be created as required. OUs may contain objects and sub-OUs, allowing for the assignment of different group policies

![[Pasted image 20260614121335.png]]
- Here we could say that `INLANEFREIGHT.LOCAL` is the root domain and contains the subdomains (either child or tree root domains) `ADMIN.INLANEFREIGHT.LOCAL`, `CORP.INLANEFREIGHT.LOCAL`, and `DEV.INLANEFREIGHT.LOCAL` as well as the other objects that make up a domain such as users, groups, computers, and more as we will see in detail below. 
- It is common to see multiple domains (or forests) linked together via trust relationships in organizations that perform a lot of acquisitions.


## AD Trusts 
![[Pasted image 20260614121802.png]]


- `INLANEFREIGHT.LOCAL` and `FREIGHTLOGISTICS.LOCAL`. The two-way arrow represents a bidirectional trust between the two forests, meaning that users in `INLANEFREIGHT.LOCAL` can access resources in `FREIGHTLOGISTICS.LOCAL` and vice versa.
-  In this example, we can see that the root domain trusts each of the child domains, <mark style="background: #FF5582A6;">but the child domains in forest A do not necessarily have trusts established with the child domains in forest B.</mark>
- This means that a user that is part of `admin.dev.freightlogistics.local` would NOT be able to authenticate to machines in the `wh.corp.inlanefreight.local` domain by default even though a bidirectional trust exists between the top-level `inlanefreight.local` and `freightlogistics.local` domains.
- To allow direct communication from `admin.dev.freightlogistics.local` and `wh.corp.inlanefreight.local`, another trust would need to be set up.


## AD Terminologies 

#### 1. Object
- An object can be defined as ANY resource present within an Active Directory environment such as OUs, printers, users, domain controllers, etc.
#### 2. Attributes
- Every object in Active Directory has an associated set of [attributes](https://docs.microsoft.com/en-us/windows/win32/adschema/attributes-all) used to define characteristics of the given object. 
- A computer object contains attributes such as the hostname and DNS name. 
- <mark style="background: #FFB86CA6;">All attributes in AD have an associated LDAP name that can be used when performing LDAP queries</mark>, such as `displayName` for `Full Name` and `given name` for `First Name`.

#### 3. Schema
- The Active Directory [schema](https://docs.microsoft.com/en-us/windows/win32/ad/schema) is essentially the blueprint of any enterprise environment. It defines what types of objects can exist in the AD database and their associated attributes. 
- It lists definitions corresponding to AD objects and holds information about each object. For example, users in AD belong to the class "user," and computer objects to "computer," and so on. 
- Each object has its own information (some required to be set and others optional) that are stored in Attributes. 
- When an object is created from a class, this is called <mark style="background: #BBFABBA6;">instantiation</mark>, and an object created from a specific class is called an <mark style="background: #BBFABBA6;">instance</mark> of that class. 
- <mark style="background: #FFB86CA6;"> For example, if we take the computer RDS01. This computer object is an instance of the "computer" class in Active Directory.</mark>

#### 4. Container
- Container objects hold other objects and have a defined place in the directory subtree hierarchy.

#### 5. Leaf
- Leaf objects do not contain other objects and are found at the end of the subtree hierarchy.

#### 6. Global Unique Identifier (GUID)
- A [GUID](https://docs.microsoft.com/en-us/windows/win32/adschema/a-objectguid) is a unique 128-bit value assigned when an object is created.
- This GUID value is unique across the enterprise, similar to a MAC address.
- <mark style="background: #FFB86CA6;">The GUID is stored in the `ObjectGUID` attribute.</mark>
- It is used by AD to internally identify objects.
- 
****
---
**Next Steps:****
- [[04_Active_Directory/AD_Objects|AD Objects (Users, Groups, Computers)]]
- [[Kerberos|Authentication Protocols (Kerberos)]]
