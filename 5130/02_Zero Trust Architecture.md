## Terminologies 
- **Zero trust (ZT)** : This provides a collection of concepts and ideas designed to minimize uncertainty in enforcing accurate, least privilege per-request access decisions in information systems and services in the face of a network viewed as compromised.

- **Zero trust architecture (ZTA)**: It is an enterprise’s cybersecurity plan that utilizes zero trust concepts and encompasses component relationships, workflow planning, and access policies. 

- **Natural Language Policy (NLP):**
	- Think of a Natural Language Policy as the plain-English (or any human language) version of an access rule  the kind of statement a manager or policy maker would write or say naturally.
	- Example: "Only HR staff can view employee salary records during business hours."
	
- **Digital Policy (DP)**: 
	- The NLP is converted to create the DP .
	- Think of a Digital Policy as an access control rule written in a way that a computer can understand and enforce automatically no human needs to step in and make the decision each time. 
	- Subject/object attributes, operations, and environment conditions are the fundamental elements of DP, the building blocks of DP rules, which are enforced by an access control mechanism.

- **Metapolicy (MP)**: 
	- A policy about policies, or policy for managing policies, such as assignment of priorities and resolution of conflicts between DPs or other MPs.
	- if regular policies are the rules of a game, MetaPolicies are the rules about **who can make the rules, how the rules can be changed, and what rules are allowed to exist in the first place**

- **Policy decision point (PDP)** :
	- A **Policy Decision Point (PDP)** is the brain of the access control system it's the component that makes the actual **yes or no decision** when someone requests access to something.
	- Think of it like a **judge in a courtroom**. Someone comes in with a request, the judge looks at the relevant laws, considers the facts, and delivers a verdict allow or deny.
	
- **Policy enforcement point (PEP)** :
	- This is the gatekeeper that actually **blocks or allows** the access based on what the PDP decided. Think of it as the locked door. It asks the PDP "should I let this person in?" and then acts on the answer
- **PIP (Policy Information Point)** :
	- This is the data source that **feeds information** to the PDP. It provides the attributes the PDP needs, like user roles, resource classifications, or time of day.
- **PAP (Policy Administration Point)** :
	- This is where policies are **created and managed**. It's the tooling that administrators use to write and store the rules the PDP will evaluate.


![[Pasted image 20260412150735.png]]

>In the abstract model of access shown in Figure 1, a subject needs access to an enterprise resource. Access is granted through a policy decision point (PDP) and corresponding policy enforcement point (PEP).

- Zero trust applies to two basic areas: authentication and authorization.
- The “**implicit trust zone**” represents an area where all the entities are trusted to at least the level of the last PDP/PEP gateway. 
- For example, consider the passenger screening model in an airport. All passengers pass through the airport security checkpoint (PDP/PEP) to access the boarding gates. 
- The passengers, airport employees, aircraft crew, etc., mill about in the terminal area, and all the individuals are considered trusted. In this model, the implicit trust zone is the boarding area.


## Tenets  of ZT

**1. Everything is a resource.** Every device, service, and data source on the network is treated as a resource that needs protection whether it's a server, a laptop, a SaaS application, or even a personal device that connects to company systems.

**2. All communication must be secured, no matter where it comes from.** Being inside the company network doesn't make you trusted. A request from inside the office is treated with the same suspicion as one from a coffee shop. All communication must be encrypted and authenticated.

**3. Access is granted one session at a time.** Just because you were allowed in five minutes ago doesn't mean you're automatically allowed in again. Every session is evaluated individually, and you only get the minimum access needed to do your task (least privilege).

**4. Access decisions are based on dynamic policies.** The decision to allow or deny isn't just about who you are it also considers your device health, your location, the time of day, your behavior patterns, and the sensitivity of what you're trying to access. These rules can change based on risk.

**5. The organization continuously monitors all assets.** No device is automatically trusted. Every device and application is constantly checked for its security health things like whether it's patched, whether it has vulnerabilities, or whether it's been compromised. Unhealthy devices can be blocked.

**6. Authentication and authorization are dynamic and strictly enforced.** You don't just log in once and you're done. The system continuously reevaluates trust throughout your session. If something suspicious happens mid-session, you might need to re-authenticate. MFA is expected.

**7. Collect as much data as possible to improve security.** The organization gathers information about network traffic, access requests, device states, and user behavior then uses all of that data to get smarter about making policies and detecting threats over time.


## Logical Components of ZTA : The Core Pieces

The system is built around three core components:

- **Policy Engine (PE)** : The **decision maker**. It takes in all available information (user identity, device health, threat intelligence) and decides: allow or deny. Think of it as the brain.

- **Policy Administrator (PA)** : The **executor**. Once the PE makes a decision, the PA carries it out it sets up or tears down the connection. It also generates session tokens and credentials. Think of it as the hands.

- **Policy Enforcement Point (PEP)** : The **gatekeeper**. It sits between the user and the resource, and physically allows or blocks the connection based on what the PA tells it. Think of it as the door.

## Supporting Data Sources

The Policy Engine doesn't make decisions in a vacuum. It pulls information from several sources:

- **CDM System** : Tells the PE about device health (is it patched? any vulnerabilities?)
- **Compliance System** : Ensures rules meet regulatory requirements (HIPAA, FISMA, etc.)
- **Threat Intelligence** : Feeds in information about new attacks, malware, and vulnerabilities
- **Activity Logs** : Real-time data about what's happening on the network
- **Data Access Policies** : The actual rules about who can access what
- **PKI** : Manages certificates for authentication
- **ID Management** : Stores user identities, roles, and attributes
- **SIEM** : Collects and analyzes security events to refine policies and detect attacks

![[Pasted image 20260412160613.png]]