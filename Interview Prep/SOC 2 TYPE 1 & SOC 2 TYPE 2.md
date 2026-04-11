System and Organization Controls (SOC)]

An attestation means an independent CPA firm examined your controls and issued an opinion about them.

A certification (like ISO 27001) means an accredited body formally certifies you meet a standard. An attestation means an independent CPA firm examined your controls and issued an opinion about them.

SOC 2 is voluntary, with most companies choosing to pursue it to build trust, not to meet regulatory requirements

SOC2 is very horizontal but you do it through domains like access control, encryption at rest and in transit (public data does not require encryption), change management, do you use bitbucket or github, does you have pull or merge requests template that ensures developers are following a consistent pracitse.  by the developer. 


The auditor issues one of four possible opinions:

**Unqualified**, your systems meet all SOC 2 criteria, so you pass the audit. **Qualified** — most criteria are met, but one or more controls fell short. **Adverse** — certain issues prevent your organization from meeting most criteria. **Disclaimer of opinion** — the auditor didn't have enough evidence to provide an opinion. 

**Type 1** evaluates whether controls are designed properly at a single point in time, a snapshot. at a  certain date. 

**Type 2** evaluates whether those controls are actually working effectively over a period, typically 3 to 12 months.

eg. if assessing change requests will ask you for pull requests in last 6 months and then take a sample 

Let me search for current, accurate information on this.Here's a clear breakdown of the differences.

**What they focus on (SOC 1 vs SOC 2)**

SOC 1 examinations are designed for service organizations that handle financial transactions and reporting for their clients. SOC 1 is centered around internal controls over financial reporting (ICFR). Think payroll processors, payment platforms, or any company whose services feed into a client's financial statements.

SOC 2, on the other hand, evaluates **security, availability, processing integrity, confidentiality, and privacy of data for service organizations.** These five areas are called the **Trust Services Criteria (TSC).** Think cloud providers, SaaS companies, data centers — anyone handling sensitive customer data where security matters more than financial reporting accuracy.

Important: 
How a **service organization** **handles data for its clients. Review of company's controls to protect customer information.** 

*Of the five Trusted Services Criteria, **Security** is the only one which is required to be tested and undergone. 

SOC2 readiness process: 
For a company to be SOC2 compliant they should choose the five areas (Trusted Services Criteria) in which they want to be SOC2 compliant 
Most organizations want to do Security, Availability, Confidentiality

1. Policies and procedures are taken into consideration
eg. annual program of reviewing employee access on the AWS platform. 


**What Type 1 vs Type 2 means (applies to both SOC 1 and SOC 2)**

This is a separate axis from SOC 1 vs SOC 2. Both SOC 1 and SOC 2 can be either Type 1 or Type 2.

Type 1 reports aim to explore the functionality of a service organization's controls at a single point in time — basically a snapshot. Are the controls properly designed as of this specific date? A Type 1 does not test the operating effectiveness of controls over time, but instead serves as an initial validation that controls are in place and properly designed.

A Type 2 examination also looks at the design of controls, but additionally includes testing of the operating effectiveness of controls over a period of time. A Type 2 report covers a minimum of six months. The goal is eventually to have annual Type 2 reports covering 12 months for continuous coverage.

**A practical example**

Consider background checks for new employees. For Type 1 evidence, an example of a background check completed for a recent new hire is provided to auditors. For Type 2 evidence, the population of all new hires throughout the audit period will be sampled, and additional evidence of completed background checks for the selected samples will be provided.

So Type 1 is "show me one example that proves this control exists," while Type 2 is "show me it's been working consistently for months."

**Which comes first?**

Most organizations start with a Type 1 as a stepping stone before undergoing a Type 2 examination. If there's not a rush, starting directly with a Type 2 is generally recommended. It depends on urgency and maturity.

SOC for Cybersecurity, you can use a range of underlying frameworks — including TSC, NIST, COBIT or FISMA — as the controls baseline. A SOC 2 report, however, is based exclusively on the Trust Services Principles

**Reference links:**

- Linford & Co — SOC 1 vs SOC 2: https://linfordco.com/blog/soc-1-vs-soc-2-audit-reports/
- Schellman — Type 1 vs Type 2: https://www.schellman.com/blog/soc-examinations/soc-report-type-1-vs-type-2
- AuditBoard — SOC 2 Type 1 vs Type 2: https://auditboard.com/blog/soc-2-type-1-vs-type-2
- Secureframe — SOC 1 vs SOC 2: https://secureframe.com/blog/soc-1-vs-soc-2
- IS Partners — Type 1 vs Type 2 testing explained: https://www.ispartnersllc.com/blog/soc2-type1-vs-soc2-type2/

1. **Control Environment (CC1 series)**
2. **Information and Communication (CC2 series)**
3. **Risk Assessment (CC3 series)**
4. **Monitoring of Controls (CC4 series)**
5. **Control Activities Related to The Design and Implementation of Controls (CC5 series)**

These five categories are also referred to as common criteria