

## RBAC
- Role-Based Access Control model employs pre-defined roles that carry a specific set of privileges associated with them and to which subjects are assigned.
- For example, a subject assigned the role of Manager will have access to a different set of objects than someone assigned the role of Analyst.

### Limitations of RBAC 
- **Rigidity with complex policies.** RBAC works well for straightforward role hierarchies, but struggles when access decisions depend on context like time of day, location, device type, or resource attributes.
- **Role explosion.** As organizations grow, the number of roles can proliferate dramatically. If you need fine-grained permissions across many departments, projects, and seniority levels, you can end up with hundreds or thousands of roles  making the system difficult to manage and audit.
- **Lack of dynamic or attribute-based decisions.** RBAC assigns permissions statically. It doesn't natively support rules like "allow access if the user's department matches the document's department" without creating a role for every possible combination.
- **Difficult separation of duties.** While RBAC can enforce some separation-of-duties constraints, modeling complex mutual-exclusion rules (e.g., "the person who submits a request cannot also approve it") often requires additional logic outside the core RBAC model.
## What is ABAC ?
- Provide access on the evaluation of attributes
- But these attributes are not limited( like **roles** in RBAC ).
- ABAC grant access base on arbitrary, dynamic attributes for both subjects and objects .... AND the environment conditions.
- In general, ABAC avoids the need for capabilities (operation/object pairs) to be directly assigned to subject requesters or to their roles or groups before the request is made. Instead, when a subject requests access, the ABAC engine can make an access control decision based on the assigned attributes of the requester, the assigned attributes of the object, environment conditions, and a set of policies that are specified in terms of those attributes and conditions. Under this arrangement policies can be created and managed without direct reference to potentially numerous users and objects, and users and objects can be provisioned without reference to policy.[NIST-SP.800-162]
- ![[Pasted image 20260412140234.png]]




## Access Control in AWS 

- Think of it as giving people _labels_, and then writing rules based on those labels instead of naming specific people or resources.

- **The core idea:** Instead of saying _"Alice can access this exact S3 bucket"_, you say _"Anyone with the label `team=finance` can access anything also labeled `team=finance`."_ The tags do the matching automatically.

- **The 3 pieces you need:**

	1. **Tag the user (or role)** : when Alice logs in, her session gets a tag like `team=finance`
	2. **Tag the resource** : your S3 bucket gets the same tag `team=finance`
	3. **Write one IAM policy** : it says: _allow access if your tag matches the resource's tag_

This means you write the policy **once**, and it works for every team, every resource : automatically.

![[Pasted image 20260415143930.png]]
![[Pasted image 20260415144022.png]]
- **The key insight:** You never name _Alice_ or _Bob_ in the policy. You never name a specific bucket. The policy just says: _"if your tag matches the resource tag, go ahead."_ Add a new employee? Give them the right tag and they automatically get the right access. Create a new bucket? Tag it and the right people automatically have access. Zero policy changes needed.
- **The IAM condition that makes this magic happen** looks like this:

```json
"Condition": {
  "StringEquals": {
    "aws:ResourceTag/team": "${aws:PrincipalTag/team}"
  }
}
```

- `aws:PrincipalTag/team` = the logged-in user's tag `aws:ResourceTag/team` = the resource's tag When they're equal → access granted.
- ![[Pasted image 20260415144558.png]]
![[Pasted image 20260415144622.png]]

### TYPES OF POLICIES IN AWS
![[Pasted image 20260415145351.png]]

#### What is AWS STS ?
- **STS stands for Security Token Service.** Think of it as a vending machine for temporary AWS credentials. Instead of giving someone a permanent password, STS hands out a time-limited pass it works for a while, then expires and becomes useless automatically.
- ![[Pasted image 20260415150114.png]]
### IAM POLICY EVALUATION LOGIC
![[Pasted image 20260415150731.png]]

|#|Policy type|Effect if matched|
|---|---|---|
|1|**Explicit Deny** (any policy)|Always DENY — no override possible|
|2|**SCP** (AWS Organizations)|No Allow in SCP → DENY|
|3|**Resource-based policy**|Allow → GRANT (same-account, stops here)|
|4|**Identity-based policy**|No Allow → DENY|
|5|**Permissions boundary**|No Allow → DENY|
|6|**Session policy**|No Allow → DENY|
|7|_(all checks passed)_|**ALLOW**|
## Access Control in Google Cloud


### TYPES OF POLICIES IN GCP
![[Pasted image 20260415153619.png]]

![[Pasted image 20260415164429.png]]
![[Pasted image 20260415164442.png]]
![[Pasted image 20260415164501.png]]
![[Pasted image 20260415164522.png]]
![[Pasted image 20260415164535.png]]
![[Pasted image 20260415164547.png]]
![[Pasted image 20260415164601.png]]


![[Pasted image 20260415165706.png]]

### Why do we even need the deny policy ?
Here's the situation where Deny becomes necessary:

**Scenario:** You have 500 developers in a Google Group. That group has `roles/storage.admin` on a project so everyone in the group can do everything to every bucket, including delete them.
Now you want **just one specific person** (Bob) to lose the delete permission temporarily, without removing everyone else from the group or restructuring the whole group.
You have two options:

| Option                                | Problem                                       |
| ------------------------------------- | --------------------------------------------- |
| Remove Bob from the group             | He loses ALL his permissions, not just delete |
| Create a new group without Bob        | Massive restructuring work for 500 people     |
| **Write a Deny policy targeting Bob** | Clean, surgical, done in 30 seconds           |

![[Pasted image 20260415170050.png]]


## Access Control in AZURE

#### Two seperate systems 
![[Pasted image 20260415171343.png]]
>**This split is unique to Azure.** In AWS and GCP, identity and resource access live in the same IAM system. In Azure they're separate products. Entra ID manages who you are. RBAC manages what Azure resources you can touch.

![[Pasted image 20260415171621.png]]
### ROLE DEFINITION
![[Pasted image 20260415174623.png]]

>**NotActions is NOT a Deny.** If another role assignment grants the same permission elsewhere, NotActions does not block it. To truly block something you need a Deny Assignment. NotActions just shapes what a single role definition offers.

### Groups and additivity 
![[Pasted image 20260415175206.png]]

### SCOPE IN AZURE
![[Pasted image 20260415180603.png]]
When you assign a role at a higher scope, **it automatically applies to everything inside it** — you don't have to reassign at each level.

- **Mgmt Group**: Alice gets Reader →She can read every resource in every subscription in the org
- **Subscription:** Bob gets Contributor →He can manage all resources in every resource group in that subscription
- **Resource Group**: Marketing gets a role →Only resources inside rg-pharma-sales — nothing outside
- **Resource:** Carol gets Storage Blob Reader →Only that one storage account — nothing else at all

>**Rule of thumb : assign as LOW as possible.** The lower the scope, the smaller the blast radius if something goes wrong. A compromised account with Reader on one storage account is far less dangerous than Reader on the whole management group.