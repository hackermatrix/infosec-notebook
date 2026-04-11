
You've been assigned to audit a mid-size financial services client. During your initial review, you discover that their AWS root account has no MFA enabled, the root account access keys are active, and three developers are sharing a single IAM user account with admin privileges. The client says they're a small team and this setup is 'convenient.'
Walk me through — what are the specific risks here, what findings would you raise, and how would you prioritize your recommendations? Don't just list best practices — tell me the actual business impact if each of these isn't fixed." Couple of issues that , one I think 

Risk 1: 
Root accout should not have access keys , as being said the one with max priviledges should not be used for progmmatic access. 

Risk 2:
AWS root account should have an MFA enabled, it is the account with maximum privileges, a second layer of authentication like a MFA/hardware has to be there

Risk 3: 
I understand that it is a small set and you have developers with more privlieges required but you can create a developer group - attach an policy with required permissiosn (don’t think developer will require access to biling) or if suppose it is required create an access management policy 

Business Impact: 


Remediation medium: 
stating that access reviewes should be conducted quarterly considerinf 3 months down the line the team grows one should relook at the access grated. 

Impact:

**accountability**. If something goes wrong, data deleted, unauthorized access, configuration change that causes an outage your CloudTrail logs show the shared account did it, but you cannot determine which of the three developers actually performed the action. You've lost non-repudiation.

an attacker with root access could access customer financial data (PII, account numbers, transaction history), spin up resources for crypto mining costing hundreds of thousands of dollars overnight, delete entire environments including backups, modify CloudTrail to cover their tracks, and create new IAM users for persistent backdoor access. For a Fidelity-type client, this is a regulatory nightmare


You correctly identified that root without MFA is the highest risk finding. You connected access keys on root to programmatic exposure risk. The insider threat angle with the departing developer was excellent — that's exactly the kind of business impact thinking John wants to hear. Suggesting a developer group with scoped permissions shows you understand least privilege. Mentioning quarterly access reviews shows you think about governance, not just technical fixes.

Remediation: 

**One thing you missed:** You didn't mention prioritization explicitly. John asked you to prioritize. A strong answer would be:

**Critical (fix immediately):** Enable MFA on root and delete root access keys — this is a one-hour fix with the highest risk reduction.

**High (fix within a week):** Create individual IAM users for each developer, disable the shared account, and implement least privilege through groups.

**Medium (implement within 30 days):** Establish access review process, enable CloudTrail monitoring with alarms for root usage and IAM changes.


**Scenario:**

"Same client. You've now moved into the network and infrastructure review. You discover the following: they have a web application running on EC2 instances in a public subnet with public IPs. The application processes customer financial transactions. The security group on these EC2 instances allows inbound SSH from 0.0.0.0/0 on port 22, and inbound HTTPS from 0.0.0.0/0 on port 443. There is no WAF, no load balancer, and VPC Flow Logs are disabled. The developers SSH directly into production servers using a shared key pair to deploy code.

As the auditor, walk me through your findings. But here's what I really want to know — if you had to explain to the client's CISO why this architecture is dangerous, using a real-world attack scenario, how would you describe what could go wrong step by step?"

Finding 1: 
EC2 instance is in a public subnet 
Finding 2: 
Security group permissions are wide open
Finding 3: 
There is no WAF, loadbalancer
Finding 4: 
VPC Flow logs are not enabled
Finding 5: 
Usafe of shared key pair 

I would draw analogy to this architecture to something like you have your bank safe: which should be in a locker, but know you have it left it open like a public subnet the doors to the room - security groups are not look you are allowing everything through a window and door. 
WAF is like you security guard who allows only authorized people and you havent kept a security guard as well, Flow logs ensure audit trail 

### Finding 1 — Direct Public Exposure of Production Servers

The application servers are directly exposed to the internet without an intermediary layer such as a load balancer or application gateway.

### Finding 2 — SSH Open to the Internet

Allowing SSH access from `0.0.0.0/0` means **anyone on the internet can attempt to connect to the server**.

### Finding 3 — Shared SSH Key Pair

Developers share the same SSH key, which creates **no accountability and increases insider risk**.

### Finding 4 — No Web Application Firewall

Without a WAF, the application has **no protection against common web attacks** like SQL injection, credential stuffing, or malicious traffic patterns.

### Finding 5 — No VPC Flow Logs

Disabling flow logs removes **network visibility and forensic capability**.

![[Pasted image 20260312231958.png]]
You are a cloud security consultant who wants to embed cloud: 

Before you audit.
Understand the business and regulatory requirement. 

Example if you are in Europe, understand the GDPR requirement. 

![[Pasted image 20260312232453.png]]

Eg. data localization: 
If I am a customer in India, and AWS is done then the another zone is Singapore, 


![[Pasted image 20260312232819.png]]



![[Pasted image 20260312232927.png]]


![[Pasted image 20260312233333.png]]
1. Conduct Root Cause Analysis: 
2. Impact of the incident
3. Identify the gap , CURent controls where do they lack
4. Per the gap: implement the new controls 



How is ultimately accountable for data in GRC:
Though it is to a cloud customer, ultimately you are. 

Who is responsible for physical security:
Cloud provider
