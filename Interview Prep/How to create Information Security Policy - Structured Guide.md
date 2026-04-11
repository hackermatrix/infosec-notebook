

---

## Step 0: Understand the Foundation (Before Writing)

### Policy Hierarchy (Top → Bottom)

| Level         | What it is                                                                         | Example                                                                                  |
| ------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **Principle** | Highest-level ideas and values. Understand the company's mission, vision, culture. | "We respect and protect our clients' data."                                              |
| **Policy**    | High-level, mandatory statements. The rules.                                       | "All users must have unique passwords."                                                  |
| **Standard**  | Prescribed levels or measurable criteria.                                          | "Passwords must be at least 12 characters. TLS 1.2 is the minimum baseline."             |
| **Guideline** | Best practices — recommended, not enforced.                                        | "Consider using a password manager."                                                     |
| **Baseline**  | Minimum configuration requirements for systems.                                    | "All servers must have AES-256 encryption enabled before deployment."                    |
| **Procedure** | Step-by-step instructions on how to implement.                                     | "Step 1: Open AWS Console. Step 2: Navigate to S3. Step 3: Enable default encryption..." |

---

## Step 1: Gather Requirements

### Schedule Meetings With:

- **Legal team** — Understand regulatory and contractual obligations (GDPR, HIPAA, GLBA, PCI DSS, state laws, etc.)
- **Business team** — Understand business operations, data flows, and what data is being processed
- **Management/Leadership** — Understand risk appetite, strategic direction, and approval expectations
- **Privacy officers** — Understand privacy requirements and data protection obligations

### Key Questions to Answer:

- What laws and regulations apply to us? (GDPR, HIPAA, GLBA, NYDFS, MiCA, etc.)
- What contractual obligations do we have? (Client contracts, vendor agreements, card brand requirements)
- What data do we handle and where does it live? (On-prem, cloud, third-party)
- What jurisdictions do we operate in?
- What frameworks are we aligned to? (NIST CSF, ISO 27001, PCI DSS, SOC 2)

---

## Step 2: Design the Template

### First Page / Cover Page:

- Policy name
- Company name and location
- Version control / version history

### Version History Table Must Include:

|Field|Purpose|
|---|---|
|**Document Owner**|Who is accountable for this policy|
|**Author**|Who wrote it|
|**Reviewer(s)**|Who reviewed and approved it (maker-checker principle)|
|**Version Number**|Track changes over time (v1.0, v1.1, v2.0)|
|**Date Created**|When the policy was first created|
|**Last Review Date**|When it was last reviewed|
|**Next Review Date**|When it's due for next review (typically annually)|
|**Approval Signature**|Who approved it (typically CISO, CIO, or Board)|

### Decide the Structure:

Before writing, determine how many sections and sub-sections you need. Plan the template layout first, then fill in content.

---

## Step 3: Write the Policy Sections

### Section 1: Policy Statement / Introduction

This is the opening statement that establishes what the policy is about and why it exists.

**What to include:**

- What this policy governs
- The CIA triad connection (Confidentiality, Integrity, Availability)
- Reference to the organization's commitment to security

**Example (Incident Management Policy):**

> "All departments and assets must be protected by an incident management process. This policy establishes the incident management framework to ensure timely identification, response, containment, and recovery from security incidents across the organization."

**Example (General Information Security Policy):**

> "[Company Name] is committed to maintaining the confidentiality, integrity, and availability of all information assets. This policy establishes the mandatory security requirements that all employees, contractors, and third parties must adhere to."

**Language guidance:**

- Use **"shall"** and **"must"** for mandatory requirements (e.g., "We shall comply with GDPR requirements")
- Use **"should"** for recommendations
- Use **"must not"** for prohibitions (e.g., "Employees must not share passwords")

---

### Section 2: Purpose

State why this policy exists. Link it to:

- **Regulatory compliance** — "To ensure compliance with HIPAA, GDPR, and applicable data protection regulations"
- **Business objectives** — "To protect the organization's information assets and maintain customer trust"
- **Contractual obligations** — "To fulfill requirements per [specific contractual obligation]"

**Tip:** The phrase "in accordance with [regulation/standard]" should come from the legal team based on actual contractual and regulatory obligations.

---

### Section 3: Scope

Define the **boundary** of what this policy covers. Be explicit and comprehensive.

**What to include:**

- Which people: employees, contractors, third parties, vendors
- Which data: customer data, employee data, financial records, marketing plans, operational data
- Which systems: on-premises, cloud environments (AWS, GCP, Azure), third-party hosted
- Which locations/jurisdictions: all offices, all countries of operation
- Which activities: data processing, storage, transmission, disposal

**Critical: Extend scope to cloud environments.** If the policy says "all data at rest must be encrypted with AES-256" without mentioning cloud, someone could argue that S3 buckets or cloud databases aren't covered. Explicitly state: "data at rest in cloud environments, on-premises systems, and third-party hosted environments."

**Example:**

> "The scope of this Information Security Policy extends to all [Company Name] information and its operational activities including but not limited to:
> 
> - All data processed, stored, or transmitted by the organization
> - All IT systems, whether on-premises, cloud-hosted, or managed by third parties
> - All employees, contractors, vendors, and third-party partners
> - All geographic locations where the organization operates"

**Gemini-specific example:** The scope would cover data and information processed in accordance with the regulatory requirements of all operating countries, including NYDFS (US), MiCA (EU), and applicable local regulations.

---

### Section 4: Roles and Responsibilities

Define who is responsible for what. Reference the organization's **RACI chart** (Responsible, Accountable, Consulted, Informed).

**Typical roles:**

|Role|Responsibility|
|---|---|
|**Board of Directors**|Approve policies, set risk appetite|
|**CISO / Information Security Officer**|Create, maintain, and enforce security policies|
|**IT / DevOps Teams**|Implement technical controls per policy requirements|
|**Legal / Privacy Officers**|Advise on regulatory requirements|
|**All Employees**|Comply with policies, report incidents|
|**Third Parties / Vendors**|Comply with applicable security requirements per contract|

**Created by:** Information Security Officer **Approved by:** Board of Directors (or CISO, depending on policy level)

---

### Section 5: Definitions

Create a definitions table for key terms used in the policy. This ensures everyone interprets the policy consistently.

**Standard definitions to include:**

- **Confidentiality** — Ensuring information is accessible only to authorized individuals
- **Integrity** — Ensuring information is accurate, complete, and not tampered with
- **Availability** — Ensuring information and systems are accessible when needed
- **Asset** — Any resource of value to the organization (data, systems, people, facilities)
- **Incident** — Any event that compromises the CIA of information or systems
- **Risk** — The potential for loss or harm resulting from a threat exploiting a vulnerability

Reference the **General Policy Definitions** document if the organization maintains one centrally.

---

### Section 6: Policy Requirements (The Core Content)

This is where the actual mandatory requirements go. Structure them logically based on the policy topic.

**Example structure for a Data Encryption Policy:**

- 6.1 Encryption at Rest — "All data at rest must be encrypted using AES-256 or equivalent, across all environments including cloud, on-premises, and third-party hosted systems."
- 6.2 Encryption in Transit — "All data in transit must be encrypted using TLS 1.2 or higher."
- 6.3 Key Management — "Encryption keys must be managed in accordance with [Key Management Policy]. Keys must be rotated annually."

**Example structure for an Incident Management Policy:**

- 6.1 Incident Identification — "All employees must report suspected security incidents within [X] hours."
- 6.2 Incident Classification — "Incidents must be classified using the severity matrix (P1-P4)."
- 6.3 Incident Response — "L1/L2/L3 escalation procedures must be followed per the Incident Response Playbook."
- 6.4 Post-Incident Review — "A root cause analysis must be completed within [X] days of incident closure."

---

### Section 7: Compliance and Standard/Framework Mapping

If you are aligned to any standard or framework, **mention the specific clause**.

**Examples:**

- "This policy supports compliance with ISO/IEC 27001:2013, Annex A, Control A.10 (Cryptography)"
- "This policy addresses PCI DSS v4.0, Requirement 3 (Protect Stored Account Data)"
- "This policy aligns with NIST CSF 2.0, Protect (PR) function"
- "This policy supports SOC 2 Trust Services Criteria — CC6 (Logical and Physical Access Controls)"

**Why this matters:** During audits, the assessor needs to see that your policies map to the specific requirements of the framework being assessed. This section makes that connection explicit.

---

### Section 8: Exceptions

Document how exceptions are handled. No policy can cover every scenario, so there must be a formal process.

**Example:**

> "Any exception to this policy must be formally requested, documented, and approved by the CISO or designated authority. Exception requests must include:
> 
> - The specific policy requirement being excepted
> - Business justification for the exception
> - Risk assessment of the exception
> - Compensating controls in place
> - Duration of the exception (exceptions must not be permanent)
> - Review date"

---

### Section 9: Enforcement and Non-Compliance

State the consequences of not following the policy.

**Example:**

> "Non-compliance with this policy may result in disciplinary action, up to and including termination of employment or contract. Violations may also result in legal consequences under applicable laws and regulations."

---

### Section 10: Review and Maintenance

**Example:**

> "This policy shall be reviewed at least annually, or whenever significant changes occur to the regulatory environment, business operations, or threat landscape. The Document Owner is responsible for initiating the review process."

---

## Quick Reference: Policy Creation Checklist

- [ ] Gathered requirements from Legal, Business, Management, and Privacy
- [ ] Identified applicable regulations and contractual obligations
- [ ] Designed the template with cover page and version control
- [ ] Written the Policy Statement / Introduction
- [ ] Defined the Purpose (linked to regulations and business objectives)
- [ ] Defined the Scope (people, data, systems, locations, cloud environments)
- [ ] Defined Roles and Responsibilities (referenced RACI chart)
- [ ] Included Definitions table
- [ ] Written the core Policy Requirements
- [ ] Mapped to applicable standards/frameworks with specific clause references
- [ ] Documented the Exceptions process
- [ ] Stated Enforcement and Non-Compliance consequences
- [ ] Defined Review and Maintenance schedule
- [ ] Version controlled with owner, author, reviewer, dates, and approval

---

## Applying This to Other Policies

This same template structure works for any security policy. Just change the core content (Section 6) based on the topic:

|Policy Type|Section 6 Core Content Focuses On|
|---|---|
|**Access Control Policy**|User provisioning, deprovisioning, least privilege, MFA, access reviews|
|**Data Encryption Policy**|Encryption at rest, in transit, key management, approved algorithms|
|**Incident Response Policy**|Identification, classification, escalation, containment, recovery, RCA|
|**Vendor Risk Management Policy**|Vendor assessment, due diligence, contractual requirements, ongoing monitoring|
|**Acceptable Use Policy**|Permitted/prohibited use of company systems, internet, email, devices|
|**Data Retention Policy**|How long data is kept, when it's destroyed, legal hold requirements|
|**Business Continuity Policy**|Recovery objectives (RTO/RPO), backup procedures, disaster recovery|
|**Logging and Monitoring Policy**|What's logged, retention periods, review frequency, SIEM requirements|
|**Change Management Policy**|Change request process, approval workflow, testing, rollback procedures|

The structure (Statement → Purpose → Scope → Roles → Definitions → Requirements → Compliance Mapping → Exceptions → Enforcement → Review) stays the same for all of them.