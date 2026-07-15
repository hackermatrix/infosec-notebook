

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