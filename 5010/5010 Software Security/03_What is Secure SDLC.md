
- 5 Phases, which go hand-in-hand with Normal SDLC at every phase.


## STAGE 1 : Requirements 
**Step 1 : Identify stakeholders**
	- Means getting the right people in the room. Security isn't just a "security team" problem. Product managers know what the business needs, developers know what's buildable, legal knows what's required by law, and end users know what they're trusting you with.

**Step 2 : Classify data** 
	- It is about figuring out which data is precious and which is ordinary. Your user's password needs maximum protection. The color theme they chose for their profile? Not so much. You label everything by sensitivity so the team knows what deserves the strongest defenses.

**Step 3 : Compliance needs** 
- Means checking which laws apply to you. If you serve European customers, GDPR applies. If you handle health records, HIPAA applies. If you process payments, PCI-DSS applies. Missing these early means painful, expensive rework later.

**Step 4 : Security requirements** 
- It is where you turn fuzzy goals like "make it secure" into specific, testable rules like "lock accounts after 5 failed login attempts." If a developer can't build it and a tester can't verify it, it's not a real requirement.

**Step 5 : Abuse cases** 
- It is where you flip your thinking. Instead of asking "what should users do?", you ask "what could attackers do?" For every feature, you imagine how it could be exploited and write down a countermeasure.

**Step 6 : Risk assessment** 
- This is about prioritizing. You can't protect everything equally, so you score each threat by how likely it is and how bad it would be, then focus your energy on the biggest risks first.

## STAGE 2 : Threat modeling
- Threat modeling = systematically asking "what could go wrong?" for every part of your system, before you build it.
- **The STRIDE framework** is the most popular way to organize your thinking. It gives you six categories of threats to check for every component :
	- Spoofing (fake identity) 
	- Tampering (changing data) 
	- Repudiation (denying actions) 
	- Information disclosure (leaking data) 
	- Denial of service (crashing the system)
	- Elevation of privilege (gaining unauthorized power).

## STAGE 3 : Code Review
**Code review is one of four layers of defense** that work together in this phase. No single layer catches everything, so they complement each other:

- **Layer 1 : Secure coding standards** are the rulebook. Before writing a single line, developers know the rules: always use parameterized queries, never log sensitive data, always validate input server-side, hash passwords with bcrypt, and so on. The OWASP Top 10 is the most widely used reference.

- **Layer 2 : SAST (static analysis tools)** are the automated scanners. Every time a developer commits code, tools like SonarQube or Semgrep scan it automatically and flag patterns known to be dangerous  SQL injection, hardcoded secrets, XSS vulnerabilities. They catch the obvious mistakes in seconds.

- **Layer 3 : SCA (dependency scanning)** checks the code _you didn't write_. Modern apps import hundreds of third-party libraries, and each one could contain a known vulnerability. Tools like Snyk and Dependabot compare your dependencies against CVE databases and alert you immediately.

- **Layer 4 : Peer code review** is the human layer, and the one you asked about. This is where a teammate reads your code with a security mindset and asks questions no tool can ask: "Could someone manipulate this workflow to skip a payment step? Could a race condition let two requests withdraw money simultaneously? Does this error message reveal too much about our infrastructure?"


## STAGE 4 : Security Testing
**The four main types of security testing:**

**1. SAST (Static Application Security Testing)** : This actually starts in Phase 3 but continues here. It scans source code without running the application, looking for known vulnerability patterns like SQL injection, buffer overflows, and hardcoded credentials. Think of it as a grammar checker for security : it reads the code and flags risky patterns. Tools like SonarQube, Checkmarx, and CodeQL handle this.

**2. DAST (Dynamic Application Security Testing)** : This is the opposite of SAST. Instead of reading code, DAST tools attack the _running_ application from the outside, just like a real hacker would. They send malicious inputs to URLs, forms, and APIs, then watch how the app responds. If the app leaks an error message with database details, DAST catches it. If a form is vulnerable to XSS, DAST finds it. Tools like OWASP ZAP and Burp Suite are the most popular.

The simple difference: SAST looks at your code from the inside. DAST attacks your app from the outside.

**3. Penetration testing (pen testing)** : This is where real humans : ethical hackers : try to break into your system using the same techniques real attackers use. Unlike DAST which follows automated scripts, pen testers think creatively. They chain multiple small weaknesses together, try social engineering, test for business logic flaws, and explore attack paths that no automated tool would think of. For example, a pen tester might discover that by creating an account, adding items to a cart, applying a coupon, then deleting and recreating the account, they can use the coupon infinite times. No automated tool catches that.

**4. Fuzz testing (fuzzing)** : This involves throwing massive amounts of random, malformed, or unexpected data at the application to see what breaks. Feed a file upload 10 million weird files. Send a form field a string that's 50,000 characters long. Pass special characters, null bytes, and binary data where the app expects a name. The goal is to find crashes, memory leaks, and edge cases that developers never anticipated. Fuzzing is particularly effective at finding buffer overflows and input handling bugs.

## STAGE 5 : Secure Configuration /Deployment

**1. Infrastructure hardening** : This means locking down every server, container, and cloud resource before your app touches it. In simple terms, you're removing everything unnecessary and tightening everything that remains.

**2. Secure configuration management** : Every environment : development, staging, production  needs consistent, documented, and version-controlled configurations. When configurations are managed manually ("I'll just SSH in and change that setting"), mistakes happen and nobody can trace them

**3. Secrets management** : This is about how you handle passwords, API keys, database credentials, encryption keys, and certificates. The rule is simple: secrets should never exist in your code, your config files, your environment variables in plain text, or your chat logs.

**4. Container and cloud security** : If you're deploying with Docker, Kubernetes, or cloud services, there's a whole additional layer to secure.

**5. CI/CD pipeline security** : The deployment pipeline itself is a target. If an attacker compromises your build system, they can inject malicious code into every release. Securing the pipeline means restricting who can trigger deployments, requiring approvals for production releases, signing build artifacts so you can verify nothing was tampered with, scanning container images and IaC templates as part of the pipeline, and keeping build agents isolated and ephemeral (destroy and recreate them for each build so nothing persists).

**6. Security sign-off** : The final gate. Before anything goes live, a designated person (usually from the security team) reviews the deployment checklist and confirms everything is in order: hardening complete, secrets properly managed, scans passing, configurations validated, rollback plan documented. This isn't bureaucracy : it's the last human checkpoint before your application faces the real world.