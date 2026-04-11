
## Identity Inventory
- Identity inventory is a catalogue of corporate employees (user accounts), services (machine accounts), and their details like **privileges, contacts, and roles** within the company. For the scenario above, identity inventory would help you get context about G.Baker and R.Lund, and make it simpler to decide if the activity was expected or not


## Asset Inventory
- Asset inventory, also called asset lookup, is a list of all computing resources within an organisation's IT environment.
- Note that while **"asset" is a vague term and can also refer to software, hardware, or employees**.


## Network Diagrams
- A **network diagram**, a visual schema presenting existing locations, subnets, and their connections.
![[Pasted image 20260330161329.png]]

## SOC Workbooks

- **SOC workbook**, also called playbook, runbook, or workflow, is a structured document that defines the steps required to investigate and remediate specific threats efficiently and consistently.
- A workbook can be divided into 3 parts :
	1. **Enrichment**: Use Threat Intelligence and identity inventory to get information about the affected user
	2. **Investigation**: Using the gathered data and SIEM logs, make your verdict if the login is expected
	3. **Escalation**: Escalate the alert to L2 or communicate the login with the user if necessary