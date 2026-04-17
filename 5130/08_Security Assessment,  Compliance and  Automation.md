

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

**CVE : Common Vulnerabilities and Exposures**

Imagine someone discovers a bug in Google Chrome that lets hackers steal your data. That bug gets reported and assigned a name like CVE-2024-5678. Now every security person, every company, and every tool in the world can refer to that exact bug by that exact name. No confusion. It's like giving every known bug its own ID card. There are thousands of CVEs published every year.

---

**CCE : Common Configuration Enumeration**

This is about settings, not bugs. Your computer has hundreds of settings : password length, firewall on/off, which users can log in remotely, etc. CCE gives each important security setting a unique ID. So instead of saying "that setting where you turn off root SSH access," you just say CCE-12345. It makes it easy for tools to check if your settings are correct.

`CCE-<number>-<checksum>`



---

**CPE : Common Platform Enumeration**

This is just a standard way to name what software or hardware you're running. For example, "Windows 11 version 22H2" or "Red Hat Enterprise Linux 9.2" each get a specific CPE name. This matters because security checks need to know what system they're looking at. A rule for Linux doesn't apply to Windows, so CPE helps tools figure out which checks to run on which machines.

`cpe:/<part>:<vendor>:<product>:<version>:<update>:<edition>:<language>`

- **`<part>`** → Type of system
    - `a` → Application
    - `h` → Hardware
    - `o` → Operating System
- **`<vendor>`** → Company that created the product
- **`<product>`** → Product name
- **`<version>`** → Product version
- **`<update>`** → Product update (if any)
- **`<edition>`** → Edition of the software
- **`<language>`** → Language of the product

- Example : `cpe:/a:adobe:airsdk%26_compiler:18.0.0.180`

---

**CWE : Common Weakness Enumeration**

This categorizes the types of mistakes programmers make. For example, "buffer overflow" is one type of mistake. "SQL injection" is another. While CVE points to one specific bug in one specific product, CWE describes the general category of the problem. Think of it this way: if CVE is "John got the flu on March 5th," CWE is "the flu" as a general illness. It helps developers understand patterns so they can avoid making the same kinds of mistakes.

---

**CVSS : Common Vulnerability Scoring System**

When a bug (CVE) is found, people need to know how dangerous it is. CVSS gives it a score from 0 to 10. A score of 2 might mean it's hard to exploit and doesn't do much damage. A score of 9.8 means it's easy to exploit and could be devastating. This helps organizations decide what to fix first. If you have 500 bugs to patch, you start with the ones scored 9 and above.

---

**How they all fit together**

Imagine you're running a security scan on your server:

1. **CPE** identifies your server as "Red Hat Linux 9.2"
2. The scanner checks for known **CVEs** (bugs) that affect that system
3. It also checks your **CCEs** (settings) to make sure things are configured securely
4. Each bug found is categorized by **CWE** (what type of mistake caused it)
5. Each bug is scored by **CVSS** (how dangerous it is)
6. You get a report telling you what to fix and in what order

