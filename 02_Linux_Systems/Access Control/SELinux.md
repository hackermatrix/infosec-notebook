#### **RESOURCE:** 
	- https://opensource.com/business/13/11/selinux-policy-guide
	- https://cycle.io/learn/selinux-basics
	
- It’s a **Mandatory Access Control (MAC)** system built into the Linux kernel.
- SElinux is like a labeling system.Every process has a label. Every file/directory object in the operating system has a label. Even network ports, devices, and potentially hostnames have labels assigned to them.

 #### **Policy :** 
- We write rules to control the access of a process label to an a object label like a file. We call this **_policy_**.
- SELinux policies define the rules governing what actions processes can take on the system. While most policies are pre-defined by the Linux distribution, they can be customized to fit specific needs. 
- Policies are composed of types, roles, users, and contexts:
	1. **Types**: The core unit in SELinux policies. Every file, directory, and process is assigned a type, which dictates its access permissions.
	2. **Roles**: Limit the actions certain users or types can perform.
	3. **Users**: Mapped to Linux users, SELinux users define what roles a user can assume.
	4. **Contexts**: The context of a file or process includes the user, role, and type, which together determine the permissions.

### # Context 
In SELinux:
- Every **file**, Every **process** , Every **port**, Every **user** has a **security context**.
- This is how the context looks like :
	- `user : role : type : level`

### # Modes 
1. Enforcing
2. Disabled
3. Permissive

|Mode|Blocks attacks?|Logs violations?|
|---|---|---|
|Enforcing|✅ Yes|✅ Yes|
|Permissive|❌ No|✅ Yes|
|Disabled|❌ No|❌ No|

### Types of enforcement in SELinux policies

#### 1. **Type Enforcement**:
- It controls:
	- Which processes can access which files
	- Which ports they can bind
	- Which other processes they can interact with