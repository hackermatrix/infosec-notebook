
**Prepared by:** Hrishikesh Jadhav  
Tanishka Chitnis
**Engagement Type**: Independent Cloud Security Assessment (Self-Initiated Lab) **Cloud Provider:** Amazon Web Services (AWS) **Account Scope:** Single AWS Account — Personal Sandbox ("rootaccount", Account ID 966042699310) **Assessment Tool:** Prowler v5.33.0 (open-source AWS CIS/compliance scanner) **Report Date:** July 2026 **Classification:** Internal / Portfolio Demonstration — No production or client data involved

---

## 1. Executive Summary

This report documents a self-directed cloud security assessment performed on a deliberately misconfigured AWS sandbox environment, modeled after the audit methodology used in enterprise GRC engagements (risk-rated findings, walkthrough-based context, and recommendation tracking). The objective was to demonstrate the full audit lifecycle: baseline scan → risk-rated findings → stakeholder walkthrough context → remediation → validation scan.

|Metric|Before Remediation|After Remediation|
|---|---|---|
|Prowler ThreatScore|46.98%|96.11%|
|Total checks evaluated|—|445|
|Failing checks|~104+ (Critical/High concentration in IAM & Network)|214|
|Passing checks|—|231|
|Critical findings open|6+|0|
|High findings open|5|1 (accepted risk, see §7)|

The initial scan surfaced multiple Critical and High severity misconfigurations concentrated in Identity (root account without MFA, an over-privileged developer account) and Network (a security group open to the internet on all ports). All Critical findings were remediated. A small number of Low/Medium findings were reviewed and formally risk-accepted or marked not-applicable based on the lab's actual use case — documented in §7 rather than silently ignored, consistent with how these would be handled in a real audit workpaper.

---

## 2. Scope of Audit

- **In scope:** IAM (users, policies, password policy, credential hygiene), VPC/EC2 networking (security groups, NACLs, subnet configuration, IMDS), S3 (bucket policy, public access, encryption, MFA delete), CloudTrail/logging configuration, CloudWatch alarming.
- **Out of scope:** Application-layer testing, third-party integrations, cost optimization, multi-account/Organizations posture (single account only), production workloads (none present).
- **Environment:** Single-region-primary AWS sandbox account with one EC2 instance, one S3 bucket, two IAM users (`tara` — developer profile, `auditor` — Prowler scanning identity), and a VPC containing both public and private subnets.

## 3. Methodology

**Risk Analysis Matrix.** Each finding is rated using a Likelihood × Impact model, consistent with standard GRC practice:

|Likelihood ↓ / Impact →|Low|Medium|High|
|---|---|---|---|
|**High**|Medium|High|Critical|
|**Medium**|Low|Medium|High|
|**Low**|Low|Low|Medium|

- **Critical** — Immediately exploitable, direct path to full account/data compromise.
- **High** — Exploitable with modest effort or chaining; significant business/data impact.
- **Medium** — Requires specific conditions or insider access; moderate impact.
- **Low** — Defense-in-depth / hardening; low likelihood or low impact in this context.

**Tooling.** Prowler CLI/UI v5.33.0 against a live AWS account via an IAM user (`auditor`) with `SecurityAudit` + `ViewOnlyAccess` managed policies. No write access was granted to the scanning identity — consistent with real-world segregation between assessor and remediator.

**Process.**

1. Baseline scan against the intentionally misconfigured environment.
2. Findings triage and walkthrough (simulated stakeholder context — see Observation column).
3. Remediation of Critical/High findings.
4. Validation re-scan.
5. Formal disposition of remaining Low/Medium findings (Remediate / Accept Risk / Not Applicable).

## 4. Application / Functionality Reviewed

The environment hosts no production application; it is a controlled sandbox built specifically to exercise realistic misconfigurations (an EC2 instance behind an intentionally over-permissive security group, an S3 bucket without public access blocks, and an IAM user with excess privileges). This section would describe actual application functionality and business criticality in a real client engagement.

## 5. Architecture

_(Diagram placeholder — recommend a simple network diagram showing: Internet → VPC → Public Subnet (EC2 instance, IGW-routed) + Private Subnet → S3 bucket (accessed via bucket policy) → CloudTrail → S3/CloudWatch Logs. I can generate this as an inline diagram — just ask.)_

Key components:

- 1 VPC (`vpc-05408b69a53452fe4`) spanning `us-east-2`, with one public and one private subnet
- 1 EC2 instance behind security group `launch-wizard-1` (originally all-ports-open)
- 1 S3 bucket (`cloudsecuritylabdemobucket`)
- 2 IAM users: `tara` (developer), `auditor` (Prowler scan identity)
- CloudTrail trail `management-events` (multi-region)

## 6. Data Flow

_(Data flow placeholder for a real engagement — describe how data moves between the EC2 instance, S3 bucket, and any external consumers, and where trust boundaries sit.)_ In this lab, data flow is minimal: no application traffic; flows of interest are (a) administrative/API access via IAM credentials, and (b) audit log flow from CloudTrail into the log-storage bucket.

## 7. Findings

|Sr. No|Observation|Severity|Risk|Recommendation|Status|
|---|---|---|---|---|---|
|1|User `tara` had the AWS-managed **AdministratorAccess** policy directly attached. Per walkthrough, `tara` is a developer and does not require admin-level access.|Critical|Privilege escalation; excessive permissions increase blast radius of a compromised credential and create audit/compliance exposure.|Remove AdministratorAccess; grant only the permissions required for the developer role, applied via a group rather than directly on the user.|**Remediated** — policy detached.|
|2|The AWS root user account did not have MFA enabled.|Critical|Root has unrestricted account access; without MFA, a leaked root password is a single point of total account compromise.|Enable MFA (hardware key or authenticator) on the root account immediately; avoid routine use of root entirely.|**Remediated** — MFA enrolled.|
|3|Security group `launch-wizard-1` (`sg-0cfdf42f420d5530f`) allowed inbound traffic on **all ports from 0.0.0.0/0**, generating 15+ individual port-exposure findings (SSH, RDP, SQL Server, MySQL, PostgreSQL, MongoDB, Redis, Kafka, LDAP, Kerberos, FTP, Telnet, Elasticsearch/Kibana, CIFS, Cassandra).|Critical|Direct, unauthenticated network exposure of the instance to the entire internet; trivial reconnaissance and exploitation path.|Restrict ingress to only required ports and known-good source IPs (least privilege at the network layer); never use 0.0.0.0/0 for administrative ports.|**Remediated** — restricted to TCP/22 from a single trusted IP.|
|4|S3 bucket `cloudsecuritylabdemobucket` did not have Block Public Access (BPA) enabled at the bucket level.|High|Risk of unintended public read/write exposure of bucket contents.|Enable all four BPA settings at the bucket (and ideally account) level unless a documented business need for public access exists.|**Remediated** — BPA enabled.|
|5|No CloudTrail trail with logging enabled was found in the region reviewed.|High|Loss of audit trail; an attacker's actions (or accidental misconfiguration) would go undetected and un-investigable.|Enable a multi-region CloudTrail trail with log file validation and deliver logs to a dedicated, access-controlled S3 bucket.|**Remediated** — multi-region trail `management-events` enabled.|
|6|EC2 metadata service did not require IMDSv2 at the account default level.|High|IMDSv1 is vulnerable to SSRF-based credential theft (a compromised web app can retrieve instance role credentials from the metadata endpoint).|Enforce IMDSv2 as the account-wide default (`http-tokens: required`) for all current and future instances.|Open — recommended for next remediation cycle.|
|7|IAM user `auditor` (the Prowler scanning identity) uses long-lived access keys to reach services other than IAM/STS.|High|Long-lived keys are a durable credential-theft target if leaked (e.g., committed to a repo).|Where possible, prefer short-lived STS credentials or role assumption; if long-lived keys are operationally required (as here, for an external scanning tool), enforce strict rotation and least-privilege scoping.|**Risk Accepted** — see §8, item (a).|
|8|S3 bucket did not have MFA Delete enabled.|Medium|Without MFA Delete, a compromised credential with delete permissions can permanently destroy bucket objects/versions.|Enable MFA Delete on buckets holding data of any sensitivity.|**Remediated.**|
|9|VPC did not have flow logging enabled.|Medium|No visibility into network traffic patterns for incident response or anomaly detection.|Enable VPC Flow Logs, delivered to CloudWatch Logs or S3.|**Remediated.**|
|10|S3 bucket policy did not enforce HTTPS-only (TLS) access.|Medium|Requests over plain HTTP can be intercepted in transit (credential/data exposure).|Add a bucket policy statement denying requests where `aws:SecureTransport` is `false`.|**Remediated.**|
|11|VPC contained only public subnets; no private subnet segmentation existed.|Medium|Lack of network segmentation increases exposure of resources that don't need direct internet reachability.|Introduce private subnets for resources that don't require inbound internet access; route via NAT for outbound-only needs.|**Remediated** — private subnet added.|
|12|IAM account password policy did not meet CIS baseline (length, complexity, reuse, expiration).|Medium|Weak password policy increases susceptibility to credential guessing/reuse attacks.|Enforce ≥14 character minimum, upper/lower/number/symbol complexity, 24-password reuse prevention, and a defined expiration window.|**Remediated** — 14-char minimum, full complexity, 24-password reuse prevention, 90-day expiration configured.|
|13|No CloudWatch Logs metric filters/alarms exist for security-relevant CloudTrail events (unauthorized API calls, console sign-in without MFA, root account usage, IAM policy changes, security group/NACL/route table/gateway changes, S3 bucket policy changes, CMK deletion, Organizations changes).|Medium|Even with logging enabled, there is no active alerting — detection depends entirely on someone manually reviewing logs after the fact.|Implement the CIS-recommended metric filter + alarm set on the CloudTrail log group (13 filters); route to an SNS topic or equivalent for real-time notification.|Open — recommended as Phase 2 (requires CloudWatch Logs group + SNS setup not yet built).|
|14|User `tara` (post-remediation) still had the AWS-managed **AmazonS3FullAccess** policy directly attached to the user rather than assigned via a group.|Low|Direct-to-user policy attachment (rather than group-based) makes access reviews and least-privilege audits harder to scale and increases risk of privilege drift over time.|Move `AmazonS3FullAccess` (scoped down if possible) onto a group and assign `tara` to that group instead of attaching directly.|Open — partial remediation; admin policy removed but direct attachment pattern remains.|

## 8. Findings Reviewed and Not Remediated (False Positive / Risk Acceptance / Not Applicable)

A mature audit distinguishes between "the tool flagged it" and "it's actually a risk in this context." The following findings were deliberately not remediated, with rationale documented rather than silently dismissed:

**(a) IAM user `auditor` uses long-lived credentials outside IAM/STS — Risk Accepted.** This is the Prowler scanning tool's own service identity. It requires standing programmatic access to run scans on a schedule from outside AWS (no EC2/Lambda role available to assume from an external scanner). Compensating control: least-privilege read-only policy (`SecurityAudit` + `ViewOnlyAccess` only, no write access) and a defined key-rotation cadence.

**(b) "At least one AWS Backup vault exists" — Not Applicable.** This lab environment holds no data requiring backup/recovery (no persistent business data, disposable sandbox resources). Backup vault creation would be pure overhead with no risk reduction in this context. Would flip to "in scope" the moment real data is introduced.

**(c) "EC2 instance has detailed monitoring enabled" — Risk Accepted (cost vs. benefit).** Detailed (1-minute) CloudWatch monitoring has a per-instance cost and is primarily an operational/performance control, not a security control. For a single non-production instance, the added observability doesn't justify the cost. Would be reconsidered for production workloads with an on-call/incident-response process to actually consume the metrics.

**(d) "CloudTrail records all S3 object-level API operations for all buckets" — Not Applicable.** Object-level (data event) logging has a real cost at scale and is most valuable when a bucket holds sensitive or regulated data. This lab bucket holds only test artifacts; management-event logging (already enabled) is sufficient for this environment's risk profile.

**(e) "VPCs are present in more than one region" — Not Applicable.** This finding assumes multi-region VPC presence is inherently risky (unused regions = unmonitored attack surface). This is a single-region-by-design lab; the finding is a non-issue here, not a gap. Would be relevant to re-check in a multi-account/Organizations context.

## 9. Overall Risk Rating

**Pre-remediation: Critical.** Multiple Critical findings (open root MFA gap, unrestricted network ingress, over-privileged IAM user) represented an immediately exploitable path to full account compromise.

**Post-remediation: Low.** All Critical and all-but-one High finding remediated. Remaining items are either explicitly risk-accepted with documented rationale, or scoped as Phase 2 hardening work (CloudWatch alarming, IMDSv2 enforcement, group-based IAM assignment).

## 10. Appendix

- Full Prowler finding export: 445 checks evaluated, final pass rate 96.11%.
- Screenshots referenced: provider setup, scan execution, findings detail views, compliance framework scoring (CIS 1.4–8.0, NIST CSF, PCI DSS, ISO 27001, SOC2, and others — 47 frameworks scored automatically by Prowler).
- Tool: Prowler v5.33.0, AWS provider, account 966042699310.