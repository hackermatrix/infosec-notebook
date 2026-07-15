

## 1. LAPS
- The [Microsoft Local Administrator Password Solution (LAPS)](https://www.microsoft.com/en-us/download/details.aspx?id=46899) is used to randomize and rotate local administrator passwords on Windows hosts and prevent lateral movement.



## 2. Audit Policy Settings (Logging and Monitoring)
- Every organization should **keep records (logs)** of important activities happening in the network.
- Windows records events such as:

- Who logged in
- Who changed a password
- Who created a new user
- Who deleted an account
- Who changed permissions
- Who accessed important files

## 3. Group Policy Security Settings
- **Group Policy Objects (GPOs)** are virtual collections of policy settings that can be applied to specific users, groups, and computers at the OU level.
- The following is a non-exhaustive list of the types of security policies that can be applied:
	-  [Account Policies](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/account-policies) 
	- [Local Policies](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/security-options) 
	- [Software Restriction Policies](https://docs.microsoft.com/en-us/windows-server/identity/software-restriction-policies/software-restriction-policies) - Settings to control what software can be run on a host.
	- [Application Control Policies](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/windows-defender-application-control)
	- [Advanced Audit Policy Configuration](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/secpol-advanced-security-audit-policy-settings) 

## 4. Update Management (SCCM/WSUS)
- Proper patch management is critical for any organization, especially those running Windows/Active Directory systems.
- The [Windows Server Update Service (WSUS)](https://docs.microsoft.com/en-us/windows-server/administration/windows-server-update-services/get-started/windows-server-update-services-wsus) can be installed as a role on a Windows Server and can be used to minimize the manual task of patching Windows systems.

## 5. Group Managed Service Accounts (gMSA)
- **gMSA** stands for **Group Managed Service Account**.
- It is a **special Active Directory account** used by **services and applications**, **not by people**.
####  Why do services need accounts?
- Some Windows services need to log in to:
	- Access a database
	- Read files from a network share
	- Connect to another server

## 6. Security Groups:
- A **Security Group** is a collection of users (or computers) that is used to **assign permissions**.
- Instead of giving permissions to each user individually, you give the permission to the **group**.
- Everyone in the group automatically gets those permissions.

## 7. Account Separation:
- Administrators must have two separate accounts. One for their day-to-day work and a second for any administrative tasks they must perform.


## 8. Limiting Domain Admin Account Usage
- All-powerful Domain Admin accounts should only be used to log in to Domain Controllers, not personal workstations, jump hosts, web servers, etc.

## 9. Periodically Auditing and Removing Stale Users and Objects
- It is important for an organization to periodically audit Active Directory and remove or disable any unused accounts.
- For example, there may be a privileged service account that was created eight years ago with a very weak password that was never changed, and the account is no longer in use.


## 10. Auditing Permissions and Access
- Organizations should also periodically perform access control audits to ensure that users only have the level of access required for their day-to-day work.


## 11. Audit Policies & Logging


## 12. Using Restricted Groups
- [Restricted Groups](https://social.technet.microsoft.com/wiki/contents/articles/20402.active-directory-group-policy-restricted-groups.aspx) allow for administrators to configure group membership via Group Policy.


## 13. Limiting Server Roles
- It is important not to install additional roles on sensitive hosts, such as installing the `Internet Information Server` (IIS) role on a Domain Controller.






# Examining Group Policy
![[Pasted image 20260715142805.png]]

### Why do attackers care about GPOs?
- If an attacker gains permission to modify a GPO, they can:
	- Add themselves as an administrator
	- Run malicious scripts
	- Install malware
	- Create scheduled tasks
	- Move to other computers (lateral movement)
	- Gain full control of the domain


- <mark style="background: #FFB86CA6;">GPO settings are processed using the hierarchical structure of AD and are applied using</mark> the `Order of Precedence` rule as seen in the table below:

![[Pasted image 20260715143041.png]]


![[Pasted image 20260715143327.png]]




EXAMPLE : 
![[Pasted image 20260715144157.png]]
-  When more than one GPO is linked to an OU, they are processed based on the `Link Order`.
- The GPO with the lowest Link Order is processed last, or the GPO with link order 1 has the highest precedence, then 2, and 3, and so on.

>[! Information]
>- **Link Order** only matters when **multiple GPOs are linked to the same Site, Domain, or OU**.
>- Since **the last GPO applied wins** (if two GPOs configure the same setting), Link Order determines which one has higher priority.
>- Suppose you have this in Linked GPOs:
>	- Link Order 1 → Password Policy 
>	- Link Order 2 → Disable USB 
>	- Link Order 3 → Login Banner
>- **Link Order 3** is processed **first** and since **Password Policy (Link Order 1)** is processed last, it has the **highest precedence**.


### A. Now let's make the Domain GPO Enforced

```
Domain
│
├── Password Length = 8   (ENFORCED)
│
└── IT OU
      └── Password Length = 12
```

- Normally, the IT OU would override the Domain setting.
- But because the Domain GPO is **Enforced**, Windows says:

> **"This policy cannot be overridden."**

- ✅ **Final Result:** Password length = **8**
- The IT OU's setting is ignored for that conflicting setting.
#### Enforced GPO Policy Precedence
![[Pasted image 20260715153956.png]]



### B. What about Default Domain Policy ?
#### Normally
Suppose you have:
```
Domain
│
├── GPO A
│
└── IT OU
      └── GPO B
```
If **GPO A** is **Enforced**, then **IT OU (GPO B)** cannot override any conflicting settings from **GPO A**.
#### What is the Default Domain Policy?
- When you install Active Directory, Windows automatically creates a GPO called:
	- **Default Domain Policy**
- It is linked at the **Domain** level and usually contains important domain-wide settings such as:
	- Password Policy
	- Account Lockout Policy
	- Kerberos Policy
- <mark style="background: #FFF3A3A6;">If the Default Domain Policy itself is marked Enforced, then its conflicting settings cannot be overridden by any other GPO, no matter where those GPOs are linked (Domain, OU, or Child OU).</mark>

Example:
```
Domain
│
├── Default Domain Policy (Enforced)
│      Password Length = 12
│
└── IT OU
       └── IT Policy
             Password Length = 8
```

Normally, the IT OU policy would be processed later.
But because the **Default Domain Policy is Enforced**:
	✅ Final password length = **12**

The IT OU cannot override it.
#### Default Domain Policy Override
![[Pasted image 20260715154445.png]]



### C. Block inheritance





## Group Policy Refresh Frequency
- When a new GPO is created, the settings are not automatically applied right away.
- default is done every<mark style="background: #FFB8EBA6;"> 90 minutes with a randomized offset of +/- 30 minutes </mark><mark style="background: #FF5582A6;">for users and computers.</mark>
- The period is only <mark style="background: #FFB8EBA6;">5 minutes </mark><mark style="background: #FF5582A6;">for domain controllers</mark> to update by default.
- **Why Random Offset?** -> Prevents all computers from contacting the Domain Controller at the same time but its Not needed for DCs  because there are relatively few Domain Controllers.