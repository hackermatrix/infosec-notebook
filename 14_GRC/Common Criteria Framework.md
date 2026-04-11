A Common Criteria Framework (formally known as the **Common Criteria for Information Technology Security Evaluation**, or just "Common Criteria" / CC) is an international standard (ISO/IEC 15408) used to evaluate and certify the security properties of IT products and systems.


### Why is it Required ?
- It provides a standardized, rigorous methodology for specifying security requirements and evaluating whether a product meets them. 
- This gives buyers (especially governments and large enterprises) confidence that a product's security claims have been independently verified.
![[Pasted image 20260406143122.png]]


### Concepts 
1. **TOE (Target of Evaluation)**:
	- It is the Product being Evaluated.
	- **Example**: Cisco Firewall
	
2. **TSF (TOE Security Functionality):**
	- Part of TOE.
	- Specific part of the product that enforces security.
	- **Example**: Using the Windows 11 example, the TSF would include components like BitLocker (encryption), Windows Defender (malware protection). 
	
3. **TOE Boundary**:
	- This defines what is "in scope" and what is "out of scope" for the evaluation. 
	- For example, if a company is evaluating a database like Oracle Database, the TOE boundary might include the database engine, its authentication module, and its encryption features.
	
4. **Operational Environment**:
	- Everything outside the TOE boundary that the product depends on. 
	- Continuing the Oracle Database example, the operational environment would include the Linux operating system it runs on, the network infrastructure, the physical server hardware, and the administrators who configure it.
	
5. **Security Objective**:
	- A high-level goal the product aims to achieve.
	- For a VPN application, security objectives might include "all data transmitted over the network must be encrypted" or "only authenticated users shall establish a VPN tunnel.
	
6. **PP (Protection Profile)**:
	- A standardized template of security requirements for a product category. 
	- For example, NIAP publishes a Protection Profile for "Network Devices" (NDcPP). Any vendor making a firewall or router for U.S. government use must meet the requirements defined in that PP.
	- Think of it like a blueprint that says "any firewall sold to the government must be able to do X, Y, and Z."
	- **Note: This says how it should be done **
	
7. **ST (Security Target)**:
	- A vendor-specific document that says "here is exactly what our product does and how it meets security requirements." 
	- For example, Cisco might write an ST for its ASA Firewall that says "our product meets the Network Device PP, and here are the specific security features we implement and how they work."
	- It's more detailed and product-specific than a PP.
	- **Note: It says how it is being done by the organization to meet PP.**
8. **EAL (Evaluation Assurance Level)**:
	- The depth of testing, on a scale of **1 to 7.**
	- A helpful analogy: think of EAL levels like building inspections. EAL1 is like checking that the doors lock. EAL7 is like verifying every single bolt, wire, and beam against mathematically proven engineering specifications.



## Security Functional Requirements (SFRs)

- Security Functional Requirements (SFRs) are the **specific, detailed security features and behaviors** that a product (TOE) **must** implement. 
- They define **what** the product does to enforce security. 
- The Common Criteria standard (ISO/IEC 15408-2) organizes SFRs into **11 classes**, each covering a different aspect of security.

- **not all SFRs apply to every product**
- **_Think of it this way:_** A car and a bicycle both need safety features, but a car needs airbags and seatbelts while a bicycle doesn't. Similarly, different products need different SFRs.
- SFRs are selected and combined in a Protection Profile (PP) or Security Target (ST) to express the security needs of a specific product or product type.

#### SFR Classes:
- FAU — Audit (logging and monitoring) 
- FCO — Communication (non-repudiation) 
- FCS — Cryptography (encryption and keys) 
- FDP — Data Protection (access and flow control) 
- FIA — Authentication (prove who you are) 
- FMT — Management (admin controls and roles) 
- FPR — Privacy (protecting personal info) 
- FPT — Protection of TSF (protecting the security system itself) 
- FRU — Resource Utilization (fair sharing of resources) 
- FTA — TOE Access (session and login controls) 
- FTP — Trusted Path (secure communication channels)

### SFR Structure:
- SFRs are organized in a **hierarchy** with four levels, going from broad to specific.
- The 4 Levels of SFR Structure:
	1. **Level 1:** Class (The big category) : _Example:_ FIA — Identification and Authentication
	
	2. **Level 2**: Family (A group within the class): _Example_ : FIA has several families: FIA_UID — User Identification FIA_UAU — User Authentication FIA_AFL — Authentication Failure Handling
	
	3. **Level 3:** Component (A specific requirement):
		- Each family has one or more components. A component is a specific, selectable security requirement.
		- Lets Consider **FIA_UAU ( UAU is User Authentication )**
		- _Example:_ FIA_UAU has components: 
			- FIA_UAU.1 — Timing of authentication (some actions allowed before login) 
			- FIA_UAU.2 — User authentication before any action (must login first for everything) 
			- FIA_UAU.5 — Multiple authentication mechanisms (e.g., password + fingerprint)
		- This means the Component is the specific aspect of the Family.
		
	4. **Level 4:** Element (The smallest detail):
		- Each component has one or more elements. An element is an individual, indivisible requirement that cannot be broken down further.
		- 