Auditing My Own AWS Account: A Before/After Cloud Security Story

This blog demonstrates an end-to-end cloud security audit from the initial baseline scan to final revalidation. We deployed a small set of AWS services, all within what's available on a free-tier account, with the intent of covering the major security domains: Identity & Access Management, Network, Compute, Storage, and Logging & Monitoring. The demo use case was a social media application hosted on an EC2 instance, with user images stored in an S3 bucket. Instead of building our own scanning tool or checking configurations manually, We used Prowler, an open-source AWS compliance scanner, to run the assessment on this demo environment.
# Initial Setup.

For initial Deployment and feasibility of the project We choose to deploy through AWS console. We understand for enterprise level environments an Infrastructure a Code tool is used. 

Firstly used my root user account for the deployments, which we were hoping to be flagged as per the security practice root user should not be used for frequently. We did not set up any form of multi-factor authentication on the root account. Then We created user tara and attached administrative IAM policy to it. Deployed EC2 instance with over-permissive NACL and security group. S3 bucket was configured with public access open, the security features such as object lock, versioning multi-factor authentication disabled. We  did not configure the S3 bucket policy. Did not configure logging and monitoring. 

# Configuring Prowler

![[Screenshot 2026-07-07 162541.png]]

![[Pasted image 20260709144803.png]]

## Creating a user called audit with read permissions for scanning


![[Pasted image 20260709145111.png]]


![[Screenshot 2026-07-07 162828.png]]

![[Screenshot 2026-07-07 163035.png]]

![[Screenshot 2026-07-07 163101.png]]

## Started the scan 

![[Screenshot 2026-07-07 165619.png]]

![[Pasted image 20260709145420.png]]

# Findings

![[Pasted image 20260709145514.png]]

![[Pasted image 20260709145620.png]]

Per the below image you can observe that same finding for security group has been iterated again the security concern can be communicated through the failed finding that the security groups does not have all ports open to the internet. Rest just seem repeated. 

![[Screenshot 2026-07-07 172224.png]]

![[Pasted image 20260709145938.png]]

# Mapping across compliances

![[Pasted image 20260709150022.png]]

![[Pasted image 20260709150052.png]]

![[Pasted image 20260709150239.png]]

![[Pasted image 20260709150307.png]]
![[Pasted image 20260709150336.png]]

# Remediation 

After going through the findings we realized some of the findings are false positive. Even though the service was not configured it was being flagged like Bedrock. We first remediated the key ones. 

### 1. Removing Administrative IAM Policy from user Tara

![[Pasted image 20260707210918.png]]


### 2. Setting up MFA on root account 

![[Pasted image 20260707211230.png]]

### 3. Restricting Security Groups Inbound to port 22 and my IP
![[Pasted image 20260707211754.png]]


### 4. Enabled Cloud Trail Logging 
![[Pasted image 20260707212640.png]]


### 5. S3 bucket Public Access block
![[Pasted image 20260707212858.png]]


### 6. S3 bucket Https policy enforeced 
![[Pasted image 20260707213059.png]]

### 7. S3 Bucket MFA delete enabled


### 8 . VPC flow log enabled 
![[Pasted image 20260707214810.png]]


### 9. VPC has both public and private subnets 
![[Pasted image 20260707220107.png]]

### 10. IAM strong Password Policy

![[Pasted image 20260707220545.png]]

# False Positives/ Risk Accepted 
- An Automated tool can surely find misconfiguration. However, to report the finding as a valid finding, we need to consider the business context(even if the finding is a critical one ). We call these findings False positives .

1. AWS Organization restricts operations to only the configured AWS Regions with SCP policies

![[Pasted image 20260709151802.png]]

Considering this is a demo environment where AWS organization is not configured. This finding marked as High by the tool stands not-applicable. 

2. EBS volume is encrypted

![[Pasted image 20260709152136.png]]

Considering this is a demo environment where encryption can be expensive the ebs volume are not encrypted.  

3. Bedrock has at least one guardrail configured in the audited region

Bedrock is not configured in the demo environment. 

![[Pasted image 20260709154913.png]]


4. EC2 instance has detailed monitoring enabled. Risk Accepted (cost vs. benefit).
![[Pasted image 20260709161710.png]]
Considering our demo account EC2 instance with the added observability doesn't justify the cost. Would be reconsidered for production workloads

5.  CloudTrail records all S3 object-level API operations for all buckets - Not Applicable.
![[Pasted image 20260709161938.png]]
Object-level (data event) logging has a real cost at scale and is most valuable when a bucket holds sensitive or regulated data.

6. VPCs are present in more than one region" — Not Applicable. 
![[Pasted image 20260709162200.png]]

Per our demo environment this is a single-region-by-design lab; the finding is a non-issue here, not a gap. 

## Reporting 
- After segregating the Findings , we used a risk matrix to find the Severity of each valid finding, risk and the recommendations to mitigate the risk. 
- To determine the severity, we evaluated the finding in conjunction with other related findings that could potentially influence the overall risk impact of the identified issue.
- ![[Pasted image 20260709160951.png]]


