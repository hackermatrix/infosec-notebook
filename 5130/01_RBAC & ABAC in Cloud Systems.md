

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


## Access Control in Google Cloud


## Access Control in AZURE