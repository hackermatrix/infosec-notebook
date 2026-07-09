
**Prepared by:** Hrishikesh Jadhav  
Tanishka Chitnis
**Engagement Type**: Independent Cloud Security Assessment (Self-Initiated Lab) 
**Cloud Provider:** Amazon Web Services (AWS) 
**Account Scope:** Single AWS Account. Personal Sandbox (Account ID 966042699310) 
**Assessment Tool:** Prowler v5.33.0 (open-source AWS CIS/compliance scanner) 
**Report Date:** July 2026 **
**Classification:**** Internal / Portfolio Demonstration (No production or client data involved)

## 1. Executive Summary

This report documents a self-directed cloud security assessment performed on a deliberately misconfigured AWS sandbox environment, modeled after the audit methodology used in enterprise GRC engagements (risk-rated findings, walkthrough-based context, and recommendation tracking). The objective was to demonstrate the full audit lifecycle: 
1. baseline scan  
2. risk-rated findings  
3. remediation 
4. revalidation scan.

| Metric                 | Before Remediation                                   | After Remediation         |
| ---------------------- | ---------------------------------------------------- | ------------------------- |
| Prowler ThreatScore    | 46.98%                                               | 96.11%                    |
| Total checks evaluated | —                                                    | 445                       |
| Failing checks         | ~104+ (Critical/High concentration in IAM & Network) | 214                       |
| Passing checks         | —                                                    | 231                       |
| Critical findings open | 6+                                                   | 0                         |
| High findings open     | 5                                                    | 1 (accepted risk, see §7) |

The initial scan surfaced multiple Critical and High severity misconfigurations concentrated in Identity (root account without MFA, an over-privileged developer account) and Network (a security group open to the internet on all ports). All Critical findings were remediated. A small number of Low/Medium findings were reviewed and formally risk-accepted or marked not-applicable based on the lab's actual use case — documented in §7 rather than silently ignored, consistent with how these would be handled in a real audit workpaper.

---

## 2. Scope of Audit

##### In scope:

| **Identity**:                | Identity Access Management                            |
| ---------------------------- | ----------------------------------------------------- |
| **Network**                  | Virtual Private Cloud (VPC)                           |
| **Compute**                  | Amazon EC2 (Elastic Compute Cloud)                    |
| **Storage**                  | S3                                                    |
| **Logging** **& Monitoring** | CloudTrail/logging configuration, CloudWatch alarming |

##### Out of scope: 
- Third-party integrations, 
- Multi-account/Organizations posture (single account only),
- Production workloads (none present)
## 3. Methodology

**Risk Analysis Matrix.** Each finding is rated using a Likelihood × Impact model, consistent with standard GRC practice:

|Likelihood ↓ / Impact →|Low|Medium|High|
|---|---|---|---|
|**High**|Medium|High|Critical|
|**Medium**|Low|Medium|High|
|**Low**|Low|Low|Medium|

**Tooling.** Prowler CLI/UI v5.33.0 against a live AWS account via an IAM user (`auditor`) with `SecurityAudit` + `ViewOnlyAccess` managed policies. No write access was granted to the scanning identity.

**Process.**

1. Baseline scan against the intentionally misconfigured environment.
2. Findings triage and walkthrough (simulated stakeholder context.
3. Remediation of Critical/High findings.
4. Validation re-scan.
5. Formal disposition of remaining Low/Medium findings (Remediate / Accept Risk / Not Applicable).

## 5. Architecture

#### Before 
![[aws-architecture-before.png]]

#### After 
![[aws-architecture-fixed.png]]


_(Diagram placeholder — recommend a simple network diagram showing: Internet → VPC → Public Subnet (EC2 instance, IGW-routed) + Private Subnet → S3 bucket (accessed via bucket policy) → CloudTrail → S3/CloudWatch Logs. I can generate this as an inline diagram — just ask.)_

Key components:

- 1 VPC (`vpc-05408b69a53452fe4`) spanning `us-east-2`, with one public and one private subnet
- 1 EC2 instance behind security group `launch-wizard-1` (originally all-ports-open)
- 1 S3 bucket (`cloudsecuritylabdemobucket`)
- 2 IAM users: `tara` (developer), `auditor` (Prowler scan identity)
- CloudTrail trail `management-events` (multi-region)

## 6. Data Flow

 In this lab, data flow is minimal: no application traffic; flows of interest are (a) administrative/API access via IAM credentials, and (b) audit log flow from CloudTrail into the log-storage bucket.

## 7. Findings

| Sr. No | Observation                                                                                                                                                                                                                                                                                           | Severity | Risk                                                                                                                                                                                                             | Recommendation                                                                                                                                                                                                      | Status                                                                                                         |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| 1      | User `tara` had the AWS-managed **AdministratorAccess** policy directly attached. Per walkthrough, `tara` is a developer and does not require admin-level access.                                                                                                                                     | High     | This gives excessive permission to the account in question and could have critical impact in instance of account compromise.                                                                                     | Remove AdministratorAccess grant only the required permissions for the developer role.                                                                                                                              | **Remediated** — policy detached.                                                                              |
| 2      | The AWS root user account did not have MFA enabled.                                                                                                                                                                                                                                                   | Critical | Without MFA on the Root account, a password compromise could lead to compromise of organization's cloud assets.                                                                                                  | Enable MFA (hardware key or authenticator) on the root account immediately; avoid routine use of root entirely.                                                                                                     | **Remediated** — MFA enrolled.                                                                                 |
| 3      | Security group `launch-wizard-1` (`sg-0cfdf42f420d5530f`) allowed inbound traffic on **all ports from 0.0.0.0/0**                                                                                                                                                                                     | High     | Unrestricted access to all ports from all origins could create a risk of service on the instance getting compromised. And this may lead to compromise of credentials and related resources to that EC2 instance. | Restrict ingress to only required ports and known-good source IPs (least privilege at the network layer)  never use 0.0.0.0/0 for administrative ports.                                                             | **Remediated** — restricted to TCP/22 from a single trusted IP.                                                |
| 4      | S3 bucket `cloudsecuritylabdemobucket` did not have Block Public Access (BPA) enabled at the bucket level.                                                                                                                                                                                            | High     |                                                                                                                                                                                                                  | Enable all four BPA settings at the bucket (and ideally account) level unless a documented business need for public access exists.                                                                                  | **Remediated** — BPA enabled.                                                                                  |
| 5      | No CloudTrail trail with logging enabled was found in the region reviewed.                                                                                                                                                                                                                            | High     |                                                                                                                                                                                                                  | Enable a multi-region CloudTrail trail with log file validation and deliver logs to a dedicated, access-controlled S3 bucket.                                                                                       | **Remediated** — multi-region trail `management-events` enabled.                                               |
| 6      | EC2 metadata service did not require IMDSv2 at the account default level.                                                                                                                                                                                                                             | High     |                                                                                                                                                                                                                  | Enforce IMDSv2 as the account-wide default (`http-tokens: required`) for all current and future instances.                                                                                                          | Open — recommended for next remediation cycle.                                                                 |
| 7      | IAM user `auditor` (the Prowler scanning identity) uses long-lived access keys to reach services other than IAM/STS.                                                                                                                                                                                  | High     |                                                                                                                                                                                                                  | Where possible, prefer short-lived STS credentials or role assumption; if long-lived keys are operationally required (as here, for an external scanning tool), enforce strict rotation and least-privilege scoping. | **Risk Accepted** — see §8, item (a).                                                                          |
| 8      | S3 bucket did not have MFA Delete enabled.                                                                                                                                                                                                                                                            | Medium   |                                                                                                                                                                                                                  | Enable MFA Delete on buckets holding data of any sensitivity.                                                                                                                                                       | **Remediated.**                                                                                                |
| 9      | VPC did not have flow logging enabled.                                                                                                                                                                                                                                                                | Medium   |                                                                                                                                                                                                                  | Enable VPC Flow Logs, delivered to CloudWatch Logs or S3.                                                                                                                                                           | **Remediated.**                                                                                                |
| 10     | S3 bucket policy did not enforce HTTPS-only (TLS) access.                                                                                                                                                                                                                                             | Medium   |                                                                                                                                                                                                                  | Add a bucket policy statement denying requests where `aws:SecureTransport` is `false`.                                                                                                                              | **Remediated.**                                                                                                |
| 11     | VPC contained only public subnets; no private subnet segmentation existed.                                                                                                                                                                                                                            | Medium   |                                                                                                                                                                                                                  | Introduce private subnets for resources that don't require inbound internet access; route via NAT for outbound-only needs.                                                                                          | **Remediated** — private subnet added.                                                                         |
| 12     | IAM account password policy did not meet CIS baseline (length, complexity, reuse, expiration).                                                                                                                                                                                                        | Medium   |                                                                                                                                                                                                                  | Enforce ≥14 character minimum, upper/lower/number/symbol complexity, 24-password reuse prevention, and a defined expiration window.                                                                                 | **Remediated** — 14-char minimum, full complexity, 24-password reuse prevention, 90-day expiration configured. |
| 13     | No CloudWatch Logs metric filters/alarms exist for security-relevant CloudTrail events (unauthorized API calls, console sign-in without MFA, root account usage, IAM policy changes, security group/NACL/route table/gateway changes, S3 bucket policy changes, CMK deletion, Organizations changes). | Medium   |                                                                                                                                                                                                                  | Implement the CIS-recommended metric filter + alarm set on the CloudTrail log group (13 filters); route to an SNS topic or equivalent for real-time notification.                                                   | Open — recommended as Phase 2 (requires CloudWatch Logs group + SNS setup not yet built).                      |
| 14     | User `tara` (post-remediation) still had the AWS-managed **AmazonS3FullAccess** policy directly attached to the user rather than assigned via a group.                                                                                                                                                | Low      |                                                                                                                                                                                                                  | Move `AmazonS3FullAccess` (scoped down if possible) onto a group and assign `tara` to that group instead of attaching directly.                                                                                     | Open — partial remediation; admin policy removed but direct attachment pattern remains.                        |


## 9. Appendix

- Full Prowler finding export: 445 checks evaluated, final pass rate 96.11%.
- Screenshots referenced: provider setup, scan execution, findings detail views, compliance framework scoring (CIS 1.4–8.0, NIST CSF, PCI DSS, ISO 27001, SOC2, and others — 47 frameworks scored automatically by Prowler).
- Tool: Prowler v5.33.0, AWS provider, account 966042699310.