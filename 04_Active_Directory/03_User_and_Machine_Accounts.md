

# User Accounts :z
- Every company we encounter will have at least one AD user account provisioned per user. <mark style="background: #FFB86CA6;">Some users may have two or more accounts provisioned based on their job role (i.e., an IT admin or Help Desk member).</mark>
- There are also service accounts which are used to run a particular application or service in the background or perform other vital functions within the domain environment.


## 1. Local Accounts
- Local accounts are stored locally on a particular server or workstation. 
- Local user accounts are considered security principals but can only manage access to and secure resources on a standalone host.
- Types of users and accounts : 
	- `Administrator`: 
		- This account has the SID `S-1-5-domain-500` and is the first account created with a new Windows installation. 
		- It has full control over almost every resource on the system. It cannot be deleted or locked, but it can be disabled or renamed. Windows 10 and Server 2016 hosts disable the built-in administrator account by default and create another local account in the local administrator's group during setup.
	
	- `Guest`: this account is disabled by default. 
		- The purpose of this account is to allow users without an account on the computer to log in temporarily with limited access rights.
		
	- `SYSTEM`: The SYSTEM (or `NT AUTHORITY\SYSTEM`) account on a Windows host is the default account installed and used by the operating system to perform many of its internal functions. 
		- <mark style="background: #BBFABBA6;">Unlike the Root account on Linux, `SYSTEM` is a service account and does not run entirely in the same context as a regular user</mark>. Many of the processes and services running on a host are run under the SYSTEM context. 
		- One thing to note with this account is that a profile for it does not exist, but it will have permissions over almost everything on the host. It does not appear in User Manager and cannot be added to any groups. 
		- A `SYSTEM` account is the highest permission level one can achieve on a Windows host and, by default, is granted Full Control permissions to all files on a Windows system.
	
	- `Network Service`: This is a predefined local account used by the Service Control Manager (SCM) for running Windows services. When a service runs in the context of this particular account, it will present credentials to remote services.
	
	- `Local Service`: This is another predefined local account used by the Service Control Manager (SCM) for running Windows services. It is configured with minimal privileges on the computer and presents anonymous credentials to the network.

## 2. Domain Users
- Domain users differ from local users in that they are granted rights from the domain to access resources such as file servers, printers, intranet hosts, and other objects based on the permissions granted to their user account or the group that account is a member of. 
- Domain user accounts can log in to any host in the domain, unlike local users.
- <mark style="background: #FFF3A3A6;">One account to keep in mind is the `KRBTGT` account</mark>, however. This is a type of local account built into the AD infrastructure. This account acts as a service account for the Key Distribution service providing authentication and access for domain resources.
- This account is a common target of many attackers since gaining control or access will enable an attacker to have unconstrained access to the domain. 
- It can be leveraged for privilege escalation and persistence in a domain through attacks such as the [Golden Ticket](https://attack.mitre.org/techniques/T1558/001/) attack.




![[Pasted image 20260714141531.png]]





# AD Groups :
- They can place similar users together and mass assign rights and access.

## How is this different from OUs ?

### Think of a Company

Imagine this company:

```
ABC Company
├── HR Department
├── IT Department
├── Sales Department
```

These departments are your **OUs**.

<mark style="background: #FF5582A6;">Inside the IT OU:</mark>

```
IT OU
├── Alice
├── Bob
├── PC-01
├── PC-02
```

The OU simply organizes these objects.

### Now suppose only some people should access the Finance server.

<mark style="background: #BBFABBA6;">Create a **Group**:</mark>

```
Finance Access Group
├── Alice
├── Charlie
```

Then give the **group** permission:

```
Finance Server
    ↓
Allowed:
Finance Access Group
```

Windows checks:

> Is Alice in the Finance Access Group?

Yes → Access granted.


### Important Characteristics for Groups 
- Groups in Active Directory have two fundamental characteristics: `type` and `scope`. The `group type` defines the group's purpose, while the `group scope` shows how the group can be used within the domain or forest. 
- When creating a new group, we must select a group type. There are two main types: 
	- `security`  groups.
	- `distribution` groups.


### Group Types :
#### 1. Security Groups :
- Security groups are used to **give permissions** to users.
- Instead of giving permissions to each user one by one, you give the permission to the **group**, and everyone in the group gets it automatically.

#### 2. `distribution` groups:
- Distribution groups are **only for sending emails**.
- They work like a mailing list.
- ##### Example
Suppose you create:

```
All_Employees
├── Alice
├── Bob
├── Charlie
└── David
```

When someone sends an email to:

```
All_Employees@company.com
```

Everyone in the group receives the email.


### Group Scopes: 

#### 1. Domain Local Group
##### Purpose: 
- Used to **assign permissions to resources in its own domain**.

Think:
> **"Protects resources inside my domain."**
##### Members
- A Domain Local group **can contain users and groups from any domain**.
##### Permissions
- <mark style="background: #FFF3A3A6;">It can only give permissions to resources in the same domain where it exists.</mark>

#### 2. Global Group
##### Purpose:
- Represents people with the same job or role.
##### Members: 
 - A Global Group can contain **only users from its own domain**.
##### Permissions:
- <mark style="background: #FF5582A6;">A Global Group can be given permissions in any domain.</mark>

**Note: The above may feel incorrect, but it is correct a global group can have members of the domain where the group exists, but it can grant perms for other domain resources.**
#### 3. Universal Group
###### Purpose:
- Used across the **entire forest**.
##### Members:
- Can contain users and groups from **any domain**.
##### Permissions:
- <mark style="background: #BBFABBA6;">Can receive permissions anywhere in the forest.</mark>


### Why not use Universal Groups for everything?
Because **Universal Groups are stored in the Global Catalog (GC).**
Whenever membership changes:

```
Add user
        ↓
Entire forest must update
```

This is called **forest-wide replication**.
If a company has:

- 30 domains
- 200 domain controllers

every membership change is copied to all of them.
That creates unnecessary network traffic.



### Group Conversions:
- A Global Group can only be converted to a Universal Group if it is NOT part of another Global Group.
- A Domain Local Group can only be converted to a Universal Group if the Domain Local Group does NOT contain any other Domain Local Groups as members.
- A Universal Group can be converted to a Domain Local Group without any restrictions.
- A Universal Group can only be converted to a Global Group if it does NOT contain any other Universal Groups as members.

### Important Group Attributes:
Like users, groups have many [attributes](http://www.selfadsi.org/group-attributes.htm). Some of the most [important group attributes](https://docs.microsoft.com/en-us/windows/win32/ad/group-objects) include:
- `cn`: The `cn` or Common-Name is the name of the group in Active Directory Domain Services.
- `member`: Which user, group, and contact objects are members of the group.
- `groupType`: An integer that specifies the group type and scope.
- `memberOf`: A listing of any groups that contain the group as a member (nested group membership).
- `objectSid`: This is the security identifier or SID of the group, which is the unique value used to identify the group as a security principal.






# Active Directory Rights and Privileges

- **RESOURCES**:
	- [Abuse user rights attacks ](https://blog.palantir.com/windows-privilege-abuse-auditing-detection-and-defense-3078a403d74e)
	- [Abuse Tokens (Hacktricks)](https://hacktricks.wiki/en/windows-hardening/windows-local-privilege-escalation/privilege-escalation-abusing-tokens.html)

- There are Several Built-in security Groups in AD.
- Some of them grant their members powerful rights and privileges which can be abused to escalate privileges within a domain and ultimately gain Domain Admin or SYSTEM privileges on a Domain Controller (DC). Membership in many of these groups should be tightly managed
- Find the Full list here : https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#default-active-directory-security-groups


## User Rights Assignment
- Besides being members of groups, **users can also be given special rights**.
- These rights determine **what actions a user is allowed to perform** on a computer or in the domain.
- Examples of user rights:
	- Log in locally
	- Shut down a computer
	- Back up files
	- Restore files
	- Load device drivers
	- Debug programs
	- Log in through Remote Desktop (RDP)
- These rights are usually assigned through **Group Policy Objects (GPOs)**.


--- 

## GPO's Vs Groups :
- Lets understand this with an Example.
- #### Example
	Suppose you have:

```
Company

IT OU
├── Alice
├── Bob
└── Charlie
```

### 1. Group
Create:

```
IT_Admins
├── Alice
└── Bob
```

Now give the group access:

```
IT_Admins
      │
      ▼
Server01
```

Only Alice and Bob can access the server.

---

### 2. GPO

Create a GPO:

```
IT Security Policy

✓ Disable USB
✓ Install Antivirus
✓ Enable Firewall
✓ Set Password Policy
```

Link it to the IT OU.

Result:

```
Alice's PC
✓ USB Disabled
✓ Firewall Enabled

Bob's PC
✓ USB Disabled
✓ Firewall Enabled

Charlie's PC
✓ USB Disabled
✓ Firewall Enabled
```

Notice that **Charlie also gets the settings**, even though he is **not** in the IT_Admins group.

<mark style="background: #FFF3A3A6;">That's because GPOs are linked to **OUs**, not to groups (in the typical case).</mark>



# Viewing a User's Privileges

Windows users have **privileges (special rights)** that determine what actions they can perform.

You can see your current privileges by running:

```
whoami /priv
```

This command lists all the privileges assigned to your account.

---

# What is UAC?

**UAC (User Account Control)** is a Windows security feature.

Even if you are an **Administrator**, Windows does **not** automatically give every program full administrator privileges.

Instead:

- Opening PowerShell normally → **Non-elevated session**
- Opening **"Run as Administrator"** → **Elevated session**

This prevents malware from automatically getting full administrator access.

---

# Standard User

Suppose you're a normal domain user.

```
whoami /priv
```

Output:

```
SeChangeNotifyPrivilege
SeIncreaseWorkingSetPrivilege
```

These are basic privileges that almost every user has.

A standard user **cannot**:

- Debug programs
- Load drivers
- Back up system files
- Take ownership of files

---

# Domain Admin (Normal PowerShell)

Now imagine you're a **Domain Admin**, but you just open PowerShell normally.

```
PowerShell
```

Running:

```
whoami /priv
```

shows only a few privileges.

Why?

Because **UAC is limiting them**.

Windows says:

> "You're an administrator, but I'm not going to give every application full power."

---

# Domain Admin (Run as Administrator)

Now right-click PowerShell and choose:

```
Run as Administrator
```

Run:

```
whoami /priv
```

Now you'll see many more privileges:

- SeDebugPrivilege
- SeBackupPrivilege
- SeRestorePrivilege
- SeTakeOwnershipPrivilege
- SeLoadDriverPrivilege
- SeImpersonatePrivilege

These are powerful privileges.

---

# Why does Windows do this?

Imagine you're an administrator browsing the internet.

If your browser automatically had **full admin privileges**, then any malware it ran would also get those privileges.

Instead, Windows makes applications run with **limited privileges** unless you explicitly approve elevation through UAC.

---

# Example

Imagine Alice is a Domain Admin.

### Opening PowerShell normally

```
Alice
      ↓
PowerShell

Limited privileges
```

She is still an administrator, but Windows hides many powerful privileges.

---

### Opening "Run as Administrator"

```
Alice
      ↓
Run as Administrator

Full administrator privileges
```

Now all admin privileges become available.
