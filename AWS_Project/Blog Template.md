# Blog Structure: "Auditing My Own AWS Account: A Before/After Cloud Security Story"

Purpose of this post: demonstrate you can operate on both sides of a cloud security engagement — building/breaking, scanning, triaging (including saying "this finding doesn't actually matter here"), fixing, and validating. The false-positive triage section is your differentiator; most portfolio posts stop at "ran a scanner, fixed stuff."

---

## Suggested Title Options

- "I Deliberately Misconfigured My Own AWS Account — Here's the Audit"
- "46% to 96%: A Cloud Security Audit From the Inside"
- "Running an Enterprise-Style Security Audit on My Own AWS Sandbox"

## Structure

### 1. The Hook (2–3 sentences)

Open with the ThreatScore jump: 46.98% → 96.11%. Frame it as: this is what a real GRC audit cycle looks like end-to-end, done on a lab account instead of a client environment, using the same discipline — scope, methodology, risk-rated findings, walkthrough context, remediation, re-validation.

### 2. Why I Built This

- Your GRC background (Deloitte: cloud security assessments, third-party risk, compliance) gave you the audit _process_. This project was about pairing that with hands-on technical execution — actually building, breaking, and fixing infrastructure rather than only assessing documentation and interviewing control owners.
- Brief mention of the tool choice (Prowler) and why: open-source, maps findings to 47+ compliance frameworks out of the box (CIS, NIST CSF, PCI DSS, ISO 27001, SOC2), which mirrors how real engagements need multi-framework mapping.

### 3. The Setup

- One VPC, one EC2 instance, one S3 bucket, two IAM users — deliberately configured with realistic mistakes: an all-ports-open security group, a developer with AdministratorAccess, no root MFA, no CloudTrail, a public-accessible S3 bucket.
- Briefly explain _why_ these particular misconfigurations: they're the ones that show up repeatedly in real breach post-mortems (Capital One-style SSRF/IMDS exposure, S3 bucket leaks, overprivileged IAM).

### 4. The Baseline Scan — What Prowler Found

- Lead with the headline number (46.98% ThreatScore) and the shape of the findings: IAM and network exposure dominated the critical/high bucket.
- Pick 3–4 findings to walk through in detail with a screenshot each (root MFA, the AdministratorAccess attachment, the open security group, missing CloudTrail) — explain the _actual_ exploitation path in plain language for each, not just "this failed a check."
- This is where you show you understand _why_ something is dangerous, not just that a tool flagged it red.

### 5. Fixing It

- Short, punchy list of the 10 fixes (matches your Config_Fixes doc): remove admin policy → root MFA → restrict SG to your IP → enable CloudTrail → S3 BPA → HTTPS-only bucket policy → MFA delete → VPC flow logs → private subnet → strong password policy.
- One or two screenshots showing a fix in progress (e.g., the password policy screen, the SG rule edit) — visually satisfying "before/after" pairs work well here.

### 6. The Re-Scan — And the Interesting Part

- New ThreatScore: 96.11%. But don't stop at the number — this is the section that separates your post from a generic "I ran a tool twice" writeup.
- **Not every remaining "Fail" is a real problem.** Walk through 3–4 of the findings you explicitly did _not_ fix, and explain your reasoning like an analyst would in a workpaper:
    - The scanning tool's own IAM user needs long-lived keys — that's an accepted, compensating-controlled risk, not a gap.
    - "AWS Backup vault exists" doesn't apply to a lab with no data worth backing up.
    - Detailed EC2 monitoring is a cost/ops tradeoff, not a security control, for a single non-prod instance.
    - Multi-region VPC presence is a non-issue in a single-region-by-design lab.
- Frame this explicitly: _"A scanner tells you what's different from a baseline. An analyst decides what that difference means."_ This is the sentence that shows hiring managers you understand risk triage, not just tool output.

### 7. What I'd Do Next (Phase 2)

- CloudWatch alarming on the 13 CIS-recommended CloudTrail event patterns (currently open in your report as a Medium finding) — good tee-up for a follow-up post.
- IMDSv2 account-wide enforcement.
- Moving `tara`'s remaining S3FullAccess to group-based assignment instead of direct attachment.
- Tie back to your broader portfolio: this feeds directly into the custom boto3/CIS scanner you're building for the Fidelity co-op narrative — mention it briefly as "coming next," don't overexplain it here.

### 8. Closing

- One or two sentences tying this back to why it matters for actual GRC work: automated scanning finds the misconfigurations, but translating findings into business risk, remediation priority, and defensible risk acceptance is the part that doesn't get automated. That's the muscle this exercise was built to demonstrate.

---

## Tone/Length Guidance

- Aim for 1,000–1,500 words — long enough to show depth, short enough that a hiring manager reads the whole thing.
- Screenshots do a lot of work here; don't over-narrate what's visually obvious in them.
- Avoid restating the audit report verbatim — the blog should read as the _story_ of doing the work; the report is the _artifact_ of having done it. Link to the report (or offer it as a downloadable PDF) rather than duplicating the findings table in full.



## 8. Findings Reviewed and Not Remediated (False Positive / Risk Acceptance / Not Applicable)

A mature audit distinguishes between "the tool flagged it" and "it's actually a risk in this context." The following findings were deliberately not remediated, with rationale documented rather than silently dismissed:

**(a) IAM user `auditor` uses long-lived credentials outside IAM/STS — Risk Accepted.** This is the Prowler scanning tool's own service identity. It requires standing programmatic access to run scans on a schedule from outside AWS (no EC2/Lambda role available to assume from an external scanner). Compensating control: least-privilege read-only policy (`SecurityAudit` + `ViewOnlyAccess` only, no write access) and a defined key-rotation cadence.

**(b) "At least one AWS Backup vault exists" — Not Applicable.** This lab environment holds no data requiring backup/recovery (no persistent business data, disposable sandbox resources). Backup vault creation would be pure overhead with no risk reduction in this context. Would flip to "in scope" the moment real data is introduced.

**(c) "EC2 instance has detailed monitoring enabled" — Risk Accepted (cost vs. benefit).** Detailed (1-minute) CloudWatch monitoring has a per-instance cost and is primarily an operational/performance control, not a security control. For a single non-production instance, the added observability doesn't justify the cost. Would be reconsidered for production workloads with an on-call/incident-response process to actually consume the metrics.

**(d) "CloudTrail records all S3 object-level API operations for all buckets" — Not Applicable.** Object-level (data event) logging has a real cost at scale and is most valuable when a bucket holds sensitive or regulated data. This lab bucket holds only test artifacts; management-event logging (already enabled) is sufficient for this environment's risk profile.

**(e) "VPCs are present in more than one region" — Not Applicable.** This finding assumes multi-region VPC presence is inherently risky (unused regions = unmonitored attack surface). This is a single-region-by-design lab; the finding is a non-issue here, not a gap. Would be relevant to re-check in a multi-account/Organizations context.
