

OWASP Top 10 is a list of the **ten most critical web application security risks**, published by the Open Web Application Security Project. It's updated every few years. The JD mentions it under "familiarity with key security best practices." You don't need deep technical exploitation knowledge — just know what each one is.

**A01 — Broken Access Control** (was #5, now #1) Users can act outside their intended permissions. Example: a regular user accessing admin pages, or viewing another user's account by changing the ID in the URL. At Gemini, this could mean one customer accessing another's crypto balance.

**A02 — Cryptographic Failures** (previously "Sensitive Data Exposure") Weak or missing encryption protecting sensitive data. Example: transmitting passwords over HTTP instead of HTTPS, storing PAN in plain text instead of encrypted. Directly connects to PCI DSS Req 3 and 4.

**A03 — Injection** Untrusted data is sent to an interpreter as part of a command or query. Most famous: SQL injection — where an attacker enters SQL code in a login field and extracts the entire database. Remember your multi-tenancy discussion — a SQL injection in a shared-schema environment could expose all tenants' data.

**A04 — Insecure Design** Flaws in the design itself, not the implementation. Missing security controls that should have been designed in from the start. Example: a password reset flow that doesn't verify identity properly. This is about "we didn't think about security during design" rather than "we coded it wrong."

**A05 — Security Misconfiguration** Default settings left unchanged, unnecessary features enabled, error messages revealing too much information. Example: leaving default admin passwords on a server, having S3 buckets publicly accessible, or the open NACLs you found in your audit.

**A06 — Vulnerable and Outdated Components** Using libraries, frameworks, or software with known vulnerabilities. Example: running an old version of Apache with a known exploit. This is why patching within 30 days matters in PCI DSS.

**A07 — Identification and Authentication Failures** (previously "Broken Authentication") Weak authentication mechanisms. Example: allowing weak passwords, not implementing MFA, session tokens that don't expire. Gemini addresses this with hardware security keys and mandatory 2FA.

**A08 — Software and Data Integrity Failures** (new in 2021) Not verifying that software updates, data, or CI/CD pipelines haven't been tampered with. Example: a supply chain attack where malicious code is injected into a trusted library update (like the SolarWinds attack).

**A09 — Security Logging and Monitoring Failures** (previously "Insufficient Logging") Not logging security events or not monitoring them. Without logs, you can't detect breaches. Connects directly to PCI DSS Req 10 (logging) and NIST CSF Detect function. If Gemini's SIEM misses an alert, an attacker could be in the system for months undetected.

**A10 — Server-Side Request Forgery (SSRF)** (new in 2021) An attacker tricks the server into making requests to unintended locations, potentially accessing internal systems. Example: exploiting a URL fetch feature to access internal metadata services in cloud environments — a common attack vector in AWS.

**Quick memory trick — group them by theme:**

**Access problems:** A01 (Broken Access Control), A07 (Authentication Failures)

**Data protection:** A02 (Cryptographic Failures), A03 (Injection)

**Design and config:** A04 (Insecure Design), A05 (Misconfiguration)

**Supply chain and integrity:** A06 (Vulnerable Components), A08 (Integrity Failures)

**Visibility and infrastructure:** A09 (Logging Failures), A10 (SSRF