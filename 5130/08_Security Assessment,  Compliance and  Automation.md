

## VULNERABILITIES LIFE-CYCLE

#### **Stage 1: Vulnerability Discovery**
- Discovery is the process of finding new and novel software, configuration, and environmental vulnerabilities that may be exploited at some point in the future.
- Just because a vulnerability has been discovered does not mean that it will be exploited.
- However, for our purposes an exploit needs to be created to ‘activate’ a vulnerability into something that can be acted upon.
- By definition a ‘0-day’ vulnerabilities, are not known until seen in an attack, making them extremely difficult to defend.

#### **Stage 2: Coordination**
- So basically Making the Vulns Public.
- During the coordination stage a researcher discloses an exploit proof of concept either through a VDP report, by publishing the exploit to a public source (example would be the CVD, or Common Vulnerability Database), or by incorporating an exploit into an existing research tool or framework for public use.
- Two concepts are useful when discussing specific vulnerabilities at the system level: 

1. [Common Weakness Enumeration (CWE)](https://cwe.mitre.org/) is common list of software security weaknesses coordinated by MITRE Corporation.
2. Another useful term commonly used in describing vulnerabilities is a [Common Vulnerability and Exposure (CVE)](https://cve.mitre.org/), also curated by MITRE.

#### **Stage 3: Mitigation**
- At some point a mitigation strategy for a vulnerable system is publicly released, either through a vendor-supplied patch or update, or a list of ‘fixes’ that need to be performed to secure the system.

#### **Stage 4: Management**

- Once a mitigation for a vulnerability has been released, it is the responsibility of the system owner to deploy and implement the required mitigation.

#### **Stage 5: Lessons Learned**

- The final stage of a vulnerability is to collect, evaluate, and institutionalize the successful mitigations in the form of research reports, trend reports, inter-organizational information sharing, and staff training.



## ENUMERATIONS 
- **Enumerations** are standardized naming and classification systems that provide a common language for identifying and categorizing security-related elements like vulnerabilities, weaknesses, platforms, and attack patterns.
- They assign unique, consistent identifiers to things so that everyone in the security community (vendors, researchers, tools, organizations) is talking about the same thing without ambiguity.

#### Why do we need them ?
- Without them, one vendor might call a flaw "buffer overflow in web server," another might call it "memory corruption in HTTP daemon"

#### **CVE ( Common Vulnerabilities and Exposures) **


