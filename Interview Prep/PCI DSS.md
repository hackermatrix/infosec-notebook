Payment Card Industry Data Security Standard

**Who created it?**

The PCI Security Standards Council (PCI SSC) — founded by Visa, Mastercard, American Express, Discover, and JCB. These are the card brands that said "if you want to process our cards, you must follow these rules."

**Who should have PCI DSS:** 
Any organization which comes under the purview of the payment lifecycle:

![[Pasted image 20260307120445.png]]

Service provider can be outsourced entity: which comes under the lifecycle of the payment.

PCI compliance is required for **any company that processes, stores, transmits, or impacts the security of cardholder data and/or sensitive authentication data.

PCI is **an attestation of compliance.** 

PCI DSS is **not a law**, PCI DSS is enforced through **contractual obligations, not law**. It's not enforced by any government agency. 

**Gemini**, because customers can buy crypto using debit/credit cards
### 🪙 Why Gemini Must Comply with PCI DSS

Gemini allows customers to buy crypto using **credit and debit cards.** The moment they accept card payments, they handle cardholder data, which means PCI DSS applies. 

**Important Terminologies:** 

**QSA (Qualified Security Assessor)** - The external auditor who comes in to assess PCI DSS compliance. At Deloitte, when you were supporting PCI DSS-aligned work, you were essentially supporting what a QSA evaluates. 

**ROC (Report on Compliance)** - The detailed report the QSA produces after the assessment. Think of it like the final audit report. It documents every requirement, whether it passed or failed, and any findings.

**AOC (Attestation of Compliance)** - A summary document that says "yes, we passed." .Think of ROC as the full exam paper and AOC as the certificate you hang on the wall.

**SAQ (Self-Assessment Questionnaire)** **A simpler, self-reported version for smaller merchants who process fewer transactions**. 

**ASV (Approved Scanning Vendor)**- A PCI SSC-approved company that runs external vulnerability scans on your systems quarterly. This is a PCI DSS requirement (Req 11). Gemini would use an ASV for their external scans.

**Electronic Self Service Device (Ex. ATM, CRM, POS, etc)**

Like ISO Lead Auditor Certificate, PCI DSS3 does not have single individual auditor. 

PCI says if you need to store the card information then store otherwise dont store.
![[Pasted image 20260306181434.png]]
**Truncation** — The digits are **permanently deleted**. They don't exist anywhere in the system anymore. Irreversible. You cannot **reconstruct the full PAN from truncated data.**

Example: Full PAN is `4532 7812 3456 4321`. After truncation, the database stores `4532 XXXX XXXX 4321`. The middle 8 digits are gone forever — not hidden, not encrypted, just deleted.

**Masking** — The full PAN **still exists** in the system, it's just hidden when displayed on screen or printed. The underlying data is intact. Someone with the right authorization level could still access the full number.

Example: Same PAN `4532 7812 3456 4321`. When a customer service agent views the account, the screen shows `XXXX XXXX XXXX 4321`. But the full PAN is still stored in the database — it's just not shown to that user because they don't have a business need to see it.

A quick way to remember: **truncation protects data at rest** (what's stored in the database), **masking protects data on display** (what someone sees on screen or on a printout). Truncation destroys the data permanently, masking just covers it up depending on who's looking.

In PCI DSS terms, both are methods of protecting the PAN, but they solve different problems at different points in the data lifecycle.

Tokenization in PCI DSS
Tokenization **reduces PCI scope** by removing cardholder data from your environment. It's a **data protection control**, not encryption (encryption is reversible with a key; tokens require the vault to map back).

Replacing sensitive cardholder data (like credit card numbers) with a random token that has no exploitable value. The real card data is stored in a secure "token vault," and systems only handle the useless token.

![[Pasted image 20260306185040.png]]
Trap data is when you swipe 

**What's on the magnetic stripe?**

The magnetic stripe (and chip) contains **two tracks of data** that include: 
1. PAN
2. Cardholder name
3. Expiration date
4. Service code
5. CVV/CVC value (this is a different CVV than the one printed on the back — it's called CVV1 and is embedded in the stripe itself).
All of this together is called "full track data."

Now here's the key distinction, the individual elements like **PAN, name, service code, and expiry** can each be stored separately (they're cardholder data). But the **full track data as a complete set** cannot be stored after authorization. Why? Because full track data contains everything needed to clone your physical card. If someone steals the complete track data, they can create a counterfeit card and use it at an ATM or store. Storing individual elements like the cardholder name or service code alone doesn't give an attacker enough to clone a card.

So: service code by itself — storable. Full track data containing everything — never storable after authorization.

![[Pasted image 20260306170040.png]]

Authorization is the moment when Visa routes the transaction to your issuing bank (your bank), your bank checks "does this person have $500, is the card valid, no fraud flags?" and sends back "Approved" or "Declined." That approval response is the "authorization."

So "must not be stored after authorization" means: during the transaction process, **the CVV, PIN, and magnetic stripe** data temporarily flow through the system so the transaction can be authorized. But the **instant** the bank says "approved" or "declined," that sensitive authentication data must be **immediately deleted** from every system it touched.


**What is a Service Code?**

It's a 3-digit number embedded in the magnetic stripe and chip of your card that tells the payment terminal how the card should be processed.

**Understanding of the PIN and the PIN BLOCK:** 

![[Pasted image 20260307115354.png]]
![[Pasted image 20260307115432.png]]
![[Pasted image 20260307115457.png]]
![[Pasted image 20260307115513.png]]
![[Pasted image 20260307115527.png]]
https://www.linkedin.com/pulse/what-pin-block-payment-systems-nayoon-cooray/


![[Pasted image 20260306192749.png]]

**Combination of Cardholder Data and Sensitive Authentication Data is know as Account Data**

Cardholder Data can be stored with appropriate Security Safeguard:- but remeber the first rule is only if you are required. 

There are Six goals in the PCI DSS requirement under which there are 12 requirements and then multiple controls under these requirements,360+ controls are there. 

The 6 Goals: 
1. Build and maintain a secure network. 
2. Protect Account Data. 
3. Maintain a vulnerability management program. 
4. Implement Strong Access Control
5. Regularly Monitor and Test Networks 
6. Maintain an information security policy. 

* if you are not dealing with cardholder data the 2nd goal is not applicable*
* if you are network provider, 1st goal becomes active. 

![[Pasted image 20260306170420.png]]
![[Pasted image 20260306170539.png]]
![[Pasted image 20260306170603.png]]

You proceed with the Assessment whether it is a merchant or a service provider and it falls according to that category. 

![[Pasted image 20260307121627.png]]
Each level has compliance obligations accordingly, Eg. Level 3 and Level 4 can be startups so they can do a self- assessment Questionnaire.  Level 1 and Level 2 will require a Qualified Security Assessor an external auditor. 

![[Pasted image 20260307122007.png]]

**Gemini can be a service provider as well as Merchant**  

**Service provider have strict category compared to merchants.**

![[Pasted image 20260307122910.png]]
Each card provider have their own nuances and contractual obligations. 

![[Pasted image 20260307144112.png]]Certification as an assurance which is to be done annual 

BAU means compliance activities happen **continuously at defined frequencies:**

**Daily** — review security logs, monitor alerts, check for unauthorized access attempts

**Weekly** — review log summaries for anomalies, check file integrity monitoring alerts

**Monthly** — install security patches within 30 days of release, review user access privileges

**Quarterly** — ASV external vulnerability scans, internal vulnerability scans, review firewall rules

**Half-Yearly** — malware risk evaluations (or as defined by your TRA), review segmentation controls

**Yearly** — full risk assessment, penetration test, security awareness training, policy review, TRA review

**Security Policies** — must exist, be reviewed annually, and be communicated to all relevant personnel

**Operational Procedures** — step-by-step instructions for daily security tasks must be documented and followed

The idea is that if you do these activities at the right cadence throughout the year, when the QSA arrives for the annual assessment, you're already compliant, there's nothing to scramble for. You just hand over the evidence you've been collecting all along.

Previous version is **3.2.1** and the current version is **PCI DSS 4.0** 


Council gives a timeline when they change the standard they dont expect you implement it right away. Post 31st March 2024 cant give PCI DSS 3.2.1 mandate. 

![[Pasted image 20260307144946.png]]



![[Pasted image 20260307145335.png]]
Any certification after or on 31st March 2025 will have to be compliant per PCI DSS v4, 
Suppose before 31st March eg. 28th March 2025 if you are PCI DSS 3.2.1 your certification is valid for a year till  28th March 2026 



**PCI DSS** uses the term **non-compliant**.
The QSA evaluates each requirement and marks it as "In Place," "Not in Place," "Not Applicable," or "Not Tested." If even one applicable requirement is marked "Not in Place" in the final ROC, the overall result is **non-compliant**. There's no "partially compliant" status in PCI DSS.

If a merchant **cannot** meet a specific **PCI DSS** requirement exactly as written (due to a legitimate technical or business constraint), they can implement a **compensating control**, an alternative control that meets the intent of the original requirement. But they must document why the original requirement can't be met, what the compensating control is, and how it provides equivalent security. The QSA evaluates whether the compensating control is acceptable. You can't just skip a requirement, you either meet it directly, meet it through a compensating control, or you're **non-compliant**.


One difference between ISO and PCI is **ISO is organization driven** and **PCI is environment driven.** 

![[Pasted image 20260307152904.png]]

![[Pasted image 20260307152927.png]]
![[Pasted image 20260307152946.png]]
![[Pasted image 20260307153004.png]]
