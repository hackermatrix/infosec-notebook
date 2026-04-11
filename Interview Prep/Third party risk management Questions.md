![[Pasted image 20260308141510.png]]

**Situation:** At Deloitte, I conducted vendor risk assessments for BFSI clients, specifically assessing SaaS vendors' cloud environments as part of the bank's annual reassessment cycle. These assessments were evaluated against the master service agreement, the bank's cloud security policy, and RBI guidelines.

**Task:** My responsibility was to assess whether vendors were meeting the bank's data segregation and security requirements in their multi-tenant environments, and to identify and communicate any gaps.

**Action:** During one assessment, I found that the vendor was operating at the weakest isolation level, shared database, shared schema, where all clients' data sat in the same tables, separated only by a tenant ID filter in the application layer. Vendor's would call it segregation but I also correctly pointed it out that it is filtering. 

I also flagged that for the most sensitive data, the bank should consider separate database instances per tenant, true physical segregation, though that would require an additional cost discussion between the bank and the vendor since it means provisioning dedicated infrastructure.

The second type was broader information security assessments led by the bank's infosec team, covering the full spectrum from physical security and access controls through to HR security, things like background checks, termination procedures, and security awareness training for vendor staff. The most overlooked aspect here used to be physical security where we would literally go early and observe there used to be no security in the premises, we could directly sit in the vendor;s office, one we had a quick office tour also had a look at their on-prem servers early morning only later did the vendor realized we were the audit team.

**How do you prioritize which risks to address first when conducting a third-party risk assessment?**
I prioritize based on risk ratings, each finding gets rated based on likelihood and impact on a scale of high, medium, low based on the heat map. I address high-risk findings first because that's where you get the maximum risk reduction. At Deloitte, we followed a 30-60-90 day remediation timeline, particularly for PCI DSS assessments, high findings had to be closed within 30 days, medium within 60, and low within 90. The goal was to ensure that by the time the QSA finalized the ROC, all findings were remediated so the client could achieve a compliant status.

![[Pasted image 20260308161824.png]]

**How do you ensure that third-party risk assessments are conducted consistently and thoroughly ?**
I'd focus on three things.
First, **proper vendor documentation**, not just self-certification but validated data flow diagrams and architecture reviews, built through collaboration between business and technical teams. From my experience at Deloitte, vendor self-reported information often doesn't match reality, so independent validation is critical.

Second, **risk-tiered assessment frequency**. Classify vendors per an applicable framework, then set review cadence accordingly — high-risk vendors assessed quarterly or annually, lower-risk vendors on a longer cycle. The classification should drive the rigor.

Third, The **assessment checklist should map directly to the contractual security requirements**, so when we assess a vendor, **we're not just checking generic best practices, we're verifying that they're meeting the specific obligations they agreed to in the master service agreement**. For example, frameworks like NIST AI RMF now require transparency about AI usage, which means our vendor assessment criteria should include AI-related questions if vendors are processing our data using AI models.

Once this process is streamlined and documented in a centralized repository, clean thorough documentaton, then you can look at automation

https://www.future-processing.com/blog/multi-tenant-architecture/
https://workos.com/blog/tenant-isolation-in-multi-tenant-systems#:~:text=Shared%20database%2C%20shared%20schema%20(table,scale%20compared%20to%20separate%20databases.

**Can you provide an example of a time when you had to update or revise security guidelines due to new regulatory requirements or emerging threats ?**
**Situation:** "In August 2023, India enacted the Digital Personal Data Protection Act, the country's first comprehensive data protection law. This directly impacted our BFSI clients at Deloitte because banks are among the largest processors of personal data in India, identity documents, financial transactions, biometrics, credit histories and the Act introduced new obligations around consent, data processing, breach notification, and individual data rights."

**Task:** "As part of the advisory and audit team, I needed to understand the new requirements and help assess how they impacted the client's existing security and privacy policies, particularly around data handling practices with their third-party vendors."

**Action:** "I was involved in reviewing the client's existing data protection and privacy policies to identify gaps against the new DPDPA requirements. Key areas we focused on included: consent mechanisms, the Act requires explicit, informed consent before collecting personal data, which meant the bank needed to update how they obtained and recorded customer consent. Breach notification, DPDPA requires notifying CERT-In within 6 hours and the Data Protection Board promptly, which was stricter than what the bank's existing incident response policy specified. And third-party vendor obligations since the bank was the data fiduciary, they were primarily responsible for compliance even when vendors were processing data on their behalf. This meant vendor contracts and our vendor assessment checklists needed to be updated to include DPDPA-specific requirements around data handling, consent verification, and breach reporting."

**Result:** "We delivered a gap analysis highlighting the areas where existing policies didn't meet DPDPA requirements. The client updated their privacy policy, revised their incident response timelines to meet the stricter breach notification window, and updated their vendor contract templates to include DPDPA-specific data processing obligations. This proactive approach positioned the client for compliance ahead of the enforcement timeline rather than scrambling after penalties were enforced."

**Key DPDPA points to remember if they probe further:**

Penalties can go up to **₹250 crore (~$30M)** per breach. Banks are likely classified as **Significant Data Fiduciaries** which triggers additional requirements, appointing a DPO, conducting annual Data Protection Impact Assessments, and independent audits. The DPDP Rules were finalized in **November 2025**, with full enforcement expected by **mid-2027**.


**What steps do you take to ensure that security requirements are met  during contract negotiations with third-party vendors?**

Always remember that client wants certain security measures from the vendor and vendor wants a limit on those controls. Security requirements can only be enforced to the vendor through: 
1. Master Service Agreement
2. Service Level Agreement 
3. Contractual Agreements 

**Before the negotiation,** I'd **collaborate with internal stakeholders IT, legal, and the business team** — to understand **what we need from this vendor and what data they'll be handling.** Then I'd **conduct or outsource whatever is the business practise**, a preliminary security assessment of the vendor — request their SOC 2 report, review their security posture, and identify gaps. This gives us leverage going into the negotiation because we're not guessing, we know exactly where the vendor's weaknesses are.

**During the negotiation,** I'd work with the **legal team to ensure the contract includes enforceable security clauses**. The non-negotiables would be: **data protection requirements like encryption standards and access controls, compliance obligations aligned to our regulatory requirements, right-to-audit clauses** so we can independently **verify the vendor's controls at any time, incident response and breach notification timelines, confidentiality agreements especially for sensitive data,** and **clear penalties for non-compliance or SLA breaches** **(leverage any findings from the preliminary assesments).** The key here is a risk-based approach, not every vendor gets the same level of scrutiny. **A vendor handling customer PII and cardholder data gets far stricter contractual requirements than a vendor handling our public data.** High-risk controls are non-negotiable, lower-risk items can have flexibility.

**After the contract is signed,** the work doesn't stop. Ongoing monitoring based on the vendor's **risk tier, periodic reassessments, evidence collection, SLA tracking.** From my experience at Deloitte, I've seen organizations that had strong contracts but never enforced them. The **contract is only as good as the monitoring behind it."**
1. **Audit & Monitoring Rights:** 
2. **Penalties & Incentives:**
3. **Post Contract Monitoring:**




