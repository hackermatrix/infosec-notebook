**What is GRC?** 
Governance is establishing policies and procedures. 
Business risks is involved with the cybersecurity procedure.

Risk: 
Identifying, managing and assessing potential threats
Compliances: 
Ensuring that companies are meeting the regulatory requirements, compliance standards, 

**Why GRC:** 
GRC help organizations make informed decisions, companies do not have infinite time, money & resources. 
Companies need to choose where to spend their time and money. What controls to put it, we need to implement those controls which will give the **maximum risk reduction.** for business.

It is important to operate the **business safely.** 

**How would you conduct a risk assessment?** 
1. Asset recognition (Recogniztion of the crown jewels
    what are we protecting here what data, assets, people. 
2. Threat identification (cyber threat actors, natural disasters, human errors, insider threats)
3. Vulnerability assessment if the threats are successfully exploited (what is the likelihood) what is the impact, consequences of it.  
      - LIKELIHOOD 
      - IMPACT 
  -Black swan events one in thousand years (high risk, low likelihood)
  4. Four choices of risk are: 
   Accept, mitigate, transfer (Gemini insuring the cold storage) , avoid 
Help organizations make informed decisions. 


**What is the difference between a policy, procedure and a standard:** 
Policies are high level statements, they define what we do and why. 
Policies are rules, they set the direction.

Standard, the password has to be 12 charachters long, TLS 1.2 has to be for encryption in transit. 
Standards define the requirement.

Procedures are like step-by-step instructions on how to implement the policies. 
Procedures set the execution.

**How do you stay current in cybersecurity?** 
I take a layered approach. For daily awareness, I follow channels like IBM Technology and NetworkChuck, and I follow several CISOs and security engineers on LinkedIn to stay plugged into current challenges.

But what's really helped me the most is networking with practitioners. For example, I've been reading a lot about AI governance , I completed a course on it and learned that companies need to document model cards for their AI systems. But when I attended an event at Red Hat, a product manager introduced me to eval cards, system cards, and data cards, concepts I hadn't encountered in any course material. That one conversation expanded my understanding more than weeks of self-study.

So I actively try to be part of security events and forums and talk to people doing the work — I believe that's the best way to stay truly current. For deeper learning, I try reading some whitepaper.


**Decribe a time when you identified some gap or vulnerability.** 
**Describe a situation where you identified a significant security risk with**   
**a third party. How did you mitigate this risk?**

**Situation:** At Deloitte, I was conducting a third-party vendor risk assessment for a BFSI client. The vendor was a marketing company that supported targeted campaigns. Based on the initial risk profiling, the vendor was rated as medium risk because the client believed the vendor only stored basic customer data like names and phone numbers.

**Task:** My responsibility was to assess the vendor cloud platform's security controls and understand their data handling practices.

**Action:** During the assessment, I didn't just review the documentation at face value, I took a walkthrough of the vendor's platform to understand the actual data flow. That's when I identified two significant gaps:

First, I discovered that the vendor was storing far more sensitive data than the client realized, including salary information, PAN card numbers, and Aadhaar numbers. This was never disclosed during the initial vendor profiling, which meant the risk rating of medium was inaccurate.

Second, during the cloud security review, the vendor pointed to an S3 bucket as their storage location. But I asked them to confirm by showing the client;s data in any of the folder or object.  That was not the actual bucket it turned out the bank's customer data was stored in an S3 bucket in the US region, which was a data residency violation, since the regulation required that Indian customer data remain within India.


**Result:** Both findings were immediately communicated to my manager and escalated to the client. The vendor's risk rating was reclassified from medium to high, and they were given a remediation timeline to address both the data residency violation and the undisclosed sensitive data. The client also updated their vendor onboarding process to include mandatory data flow validation

**How would you explain a complex compliance requirement to a non-technical stakeholder?**

Start with the business impact, regulation. 
**S — Situation**

At Deloitte, I was auditing a BFSI client's cloud infrastructure. Part of the scope was evaluating their adherence to a Zero Trust architecture. The client's RDS database, which stored customer data, was hosted inside a VPC on AWS.

**T — Task**
My task was to assess the cloud architecture per CIS, AWS best practices keepign the zero trust approach in mind and communicate any findings to both the technical DevOps team and the non-technical business stakeholder who owned the risk decision.

A — Action

During the assessment, I found that the NACLs on the database subnet had unrestricted inbound and outbound rules and the security Groups were properly restricted to specific ports and source IPs, but they were the only line of defense.

The DevOps team acknowledged the Security Group restrictions but argued they couldn't restrict the NACLs without impacting other services. I documented the finding and needed to explain the risk to the business stakeholder, who wasn't technical.

I used a simple analogy: I explained that the NACLs are like the campus gate of an office building, and the Security Groups are like individual office door locks. Right now, the campus gate is wide open, anyone can walk in freely, and the only thing preventing unauthorized access to sensitive areas is the individual door locks. If even one door lock is misconfigured, there's no fallback. Under Zero Trust, every layer should independently verify access, the campus gate should check IDs, the building entrance should verify badges, and then the office door should check keycards. Relying on a single layer violates the defense-in-depth principle that Zero Trust requires.


R — Result
The stakeholder immediately understood the risk and approved the remediation. The DevOps team was directed to restrict the NACLs to allow only the specific IP ranges and ports needed for application traffic to reach the database subnet.
