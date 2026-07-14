

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




