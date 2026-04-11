Primitives :
- **Principal :** User of the system
- **Subject :** Entity that acts on behalf of the Principal.
- **Object :**  Resource that is being acted upon

![[Pasted image 20260220143530.png]]


# Access Control Models :

1. Discretionary Access Control (DAC )
2. Mandatory Access Control (MAC)



## 1. Discretionary Access Control (DAC ):

-  **Discretionary Access Control (DAC)** is a way of controlling access to files or resources where **the owner decides who can access them**.
- Access control is at the **discretion (choice)** of the owner.
- In Linux environments only the owners have the permissions to chmod.
- Group membership doesn’t grant chmod ability **(IMPORTANT)**

### # Some Rules of Linux DAC
1. Only owner and root user can make changes to the perms .
2. The owner has to be in the group to which the permission is being given to.
		- For example if the owner wants to add a group ownership to a file called as "XYZ" for the group "ABC", the owner must be a part of the ABC group.
3. Only the sudo/root user can change the owner of the file.

### # ACLS in Linux 
- Extension of the traditional 3-permission (u,g,o) system access control
- ![[Pasted image 20260220151307.png]]

- **Named User** : A specific user (other than the file owner) who is given special permissions on a file.
- **Named Group**: A specific group (other than the file’s main group) that is given special permissions.
- **Mask:** Its the Maximum permissions the Named users and the Named Groups could have on a file.

### # FROM PRINCIPALS TO SUBJECTS 
- Thus far, we have focused on **principals**
	-  What user created/owns an object ?
	- What groups does a user belong to ?
- What about **subjects**?
	- When you run a program, what permissions does it have ?
	- Who is the “owner” of a running program ?
#### # SUID , SGID and Sticky Bit :
![[Pasted image 20260220154941.png]]

#### # Visual indicators for the above : 
![[Pasted image 20260220160848.png]]


>[!info] Confused Deputy Problem
>- The Confused Deputy Problem occurs when a privileged program is tricked into performing an action on behalf of a less-privileged user, misusing its authority.
>- Here the program in question is the **Deputy**.


## 2. MANDATORY ACCESS CONTROL (MAC)
- **Mandatory Access Control (MAC)** is a **security model** used in operating systems where access to resources is **strictly controlled by the system**, not by the individual users.
- **Examples** : [[SELinux]] , Apparmour

### # MLS (Multi Level Security):
- Multi-Level Security (MLS) is a system design concept in which **data and users are classified at multiple security levels**, and the system enforces **access control based on these levels**.

### # BELL-LAPADULA
- The **Bell–LaPadula** model is a **Mandatory Access Control (MAC) model**
- Main goal is to **protect confidentiality** of information.
- It enforces **who can read and write files** based on their **security clearance** and the **classification of the file**.
- **Security Levels:**
	- **Top Secret > Secret > Confidential > Unclassified**
- 2 Important rules :
	 1. **Simple Security Property (ss-property)** – **No Read Up**
		 - A subject **cannot read an object at a higher security level**
	 2. ***-Property (star property)** – **No Write Down**
		 -  A subject **cannot write information to a lower security level**.
		 - Prevents sensitive information from leaking downward.