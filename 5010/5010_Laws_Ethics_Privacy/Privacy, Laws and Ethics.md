

---

## 🔒 Privacy

**Privacy** = your right to control who knows what about you.

Two roles in any data situation:

- **Subject** : the person the data is about
- **Owner** : whoever holds the data

### What counts as private data?

Identity, finances, health records, biometrics (fingerprints, face scans), privileged communications (lawyer/doctor conversations), and location data.

---

## ⚠️ Why Computers Make Privacy Harder

1. **Collection is massive** : storage is cheap, so companies collect everything they can
2. **You don't know what's collected** : notice and consent are supposed to protect you, but in practice you rarely know what's being gathered
3. **Once you share data, you lose control** : it can be kept forever and shared without you knowing

---

## 📜 Fair Information Practices (The Golden Rules)

These are the widely accepted principles for handling personal data responsibly:

- Get data **lawfully** and keep it **accurate and relevant**
- State **why** you're collecting it, and **delete it** when you're done
- Don't use it for anything else without **consent or legal authority**
- Put **safeguards** in place against loss or misuse
- Let people **see and challenge** their own data
- Assign someone to be **accountable**

---

## 🛡️ How to Protect Stored Data

Four simple strategies (Ware & Turn, 1975): collect **less** data, **reduce** its sensitivity, **anonymize** it, and **encrypt** it.

---

## 🇺🇸 Key U.S. Privacy Laws

|Law|What it covers|
|---|---|
|**Privacy Act (1974)**|Government-collected data only|
|**ECPA (1986)**|Protection from electronic wiretapping|
|**HIPAA**|Healthcare data|
|**GLBA**|Financial data|
|**COPPA**|Children online|
|**FERPA**|Student records|

> [!important] Federal laws mostly cover **government** systems. **State laws** vary widely and also apply to private companies : security professionals need to know both.

---

## 🌐 FTC and Website Privacy

The **FTC** oversees how websites handle your data using five principles: **Notice** (tell users what you collect), **Choice** (let them opt in/out), **Access** (let them check their data), **Security** (protect the data), and **Enforcement** (punish violations).

The **E-Government Act (2002)** requires all federal agencies to publicly post their privacy policies.

---

## ⚖️ Section 5 of the FTC Act

This is the FTC's main weapon for consumer protection. The core idea: **unfair or deceptive business practices are illegal.**

### Deceptive = you misled people

A company said something (or hid something) that would trick a reasonable person into making a different decision. Examples: vague privacy policies, hidden tracking, undisclosed data sharing.

### Unfair = you caused harm people couldn't avoid

The company caused real damage (financial, health, safety) that consumers couldn't reasonably protect themselves from, and the harm outweighs any benefits. Examples: weak security leading to breaches, ignoring users' privacy choices.

### What the FTC expects from companies

- Be **transparent** and **truthful** about data practices
- Implement **reasonable security** for the data you hold
- Get **consent** before using data in new ways
- Let users **access, correct, and delete** their data
- **Keep your promises** : if your policy says it, do it

### Common violations

Changing privacy policies retroactively, poor security, secretly sharing data with third parties, lying about encryption, and making opt-out nearly impossible.

---

## 🕵️ Privacy Tools

|Tool|Does|Doesn't|
|---|---|---|
|**Incognito**|Stops your browser from saving local history/cookies|Hide you from your ISP, employer, or websites|
|**VPN**|Encrypts your traffic in transit|Make you fully anonymous|
|**Tor**|Routes traffic through multiple nodes for anonymity|Guarantee speed; exit nodes can be monitored|

**Do Not Track (DNT)** is an HTTP header that asks websites not to track you : but it's voluntary and mostly ignored.

---

## 📚 Protecting Software: Three Legal Tools

### 1. Copyright

- Protects the **code itself** (the expression), not the underlying algorithm
- Automatic upon creation : you get exclusive right to copy and sell
- "Fair use" allows limited use for teaching, research, criticism
- If only compiled code is released, copyright may not apply
#### Work-for-Hire

**Work-for-hire** is a concept in copyright law that says **the employer, not the employee, is considered the legal author and owner** of something created on the job.

Think of it this way: if your boss pays you to write code, the company owns that code — not you. You were hired to create it, so it's theirs from the moment it exists. You can't take it, sell it, or market it yourself.

##### How do you know if it's work-for-hire?

The textbook gives four conditions. The more of these that are true, the stronger the work-for-hire claim:

1. **The employer supervises how the work is done**  they're directing and overseeing your creative process
2. **The employer can fire you** there's a clear employer-employee power relationship
3. **The employer arranged for the work before it was created** — they hired you to make this specific thing, it wasn't something you already had
4. **There's a written contract** stating the employer hired you to do this work

##### The grey areas
- **Edye writes a program at work, as part of her job** → clearly work-for-hire, the company owns it
- **Edye writes a program at home in the evenings, but she works as a programmer** → grey area. Her employer will argue she used skills, training, and ideas gained on the job. The employer likely has at least partial ownership
- **Edye writes a program at home, but she's a TV newscaster, not a programmer** → the employer probably has no claim, because the work has nothing to do with her job
- **Edye is a freelance consultant who wrote the program for a client** → both sides can argue ownership. She says she created it, the client says they paid for it. This is why written contracts matter so much
#### Licenses

- The **opposite arrangement** from work-for-hire. Instead of the employer owning everything, the **programmer keeps full ownership** of the software and simply grants the company permission to use it  for a fee. 
- The license can be customized in many ways: limited time or unlimited, one copy or many, one location or everywhere. This setup heavily favors the programmer, while work-for-hire heavily favors the employer. Which one applies depends on what both parties agree to.

#### Employment Contracts

- These are written agreements that spell out who owns what **before** any work begins. A typical contract says the employee is hired to work exclusively for the company, that it's a work-for-hire situation, and that the company owns all rights to everything the employee creates — including copyright and the right to sell the product. The contract may also state that the employee is receiving access to trade secrets and agrees not to reveal them.

- **More restrictive contracts** go further — they assign the employer rights to **all** inventions and creative works, even ones not directly related to the employee's job. So if an accountant at a car company invents a better engine while on the clock, the company could claim ownership.

#### Agreements Not to Compete (Non-Competes)

- Sometimes included in employment contracts. The idea is that by working at a company, you've learned so much about their systems and secrets that you'd be incredibly valuable to a competitor. 
- So the employer makes you agree **not to work for a rival** for a certain period after you leave. 
- For example, a senior operating systems developer might memorize the design of a proprietary OS and could quickly build a similar one for a competitor. A non-compete prevents this.
### 2. Patent

- Protects **inventions and algorithms** (since 1981 for software)
- Must be **novel** and non-obvious
- You have to **actively defend** it or risk losing rights
- Requires a formal application to the patent office

### 3. Trade Secret

- Protects **secret competitive information** (like a secret algorithm)
- No registration needed : just keep it secret
- If someone figures it out independently or reverse-engineers it, that's **not illegal**
- Useless against software piracy

### Quick Comparison

| |Copyright|Patent|Trade Secret|
|---|---|---|---|
|**What it protects**|Code expression|Inventions/algorithms|Secret business info|
|**Registration**|Automatic|Required|None|
|**Duration**|Author's life + 70 yrs|20 years|As long as it's secret|
|**Reverse engineering**|N/A|Doesn't matter (it's public)|Allowed|
|**Independent discovery**|Must prove copying|Still infringement|Not infringement|

---

## 🇪🇺 International Privacy

**EU Privacy Directive (1995)** : extended fair information practices to businesses, not just governments. Added protections for sensitive data and limits on data transfers.

**GDPR (2018)** : applies to **all EU resident data** regardless of where the company is based. The big one for modern privacy compliance.

---

## 🧭 Ethics

### Law vs. Ethics

**Laws** tell you what you **must or must not** do (with legal consequences). **Ethics** tell you what you **should or shouldn't** do (based on values). Laws change over time; ethical principles tend to be more stable but less clear-cut.

### How to analyze an ethical dilemma

1. Understand the situation
2. Apply ethical reasoning : **rule-based** (is there a principle that applies?) vs. **consequence-based** (what outcome does each choice produce?)
3. Weigh competing principles
4. Make and defend your choice

### Preventing unethical behavior

**Education** is the #1 factor. People act unethically because of ignorance, accident, or intent. Deterrence works only if people believe they'll be **caught**, **punished**, and the **penalty is real**.

---

##  The RAND Report 
- The RAND Report was basically a **1973 government study** led by a guy named **Willis Ware** that asked one big question: **"How should we protect people's personal data in computers?"**
- His team came up with a set of common-sense rules:
	 - **Collection limitation** : don't collect more data than you actually need, and do it lawfully
	- **Data quality** : keep the data accurate, complete, and up to date
	- **Purpose specification** : be clear about why you're collecting it, and delete it when you're done
	- **Use limitation** : don't use the data for anything other than what you said, unless the person agrees or the law allows it
	- **Security safeguards** : protect the data from being lost, stolen, or misused
	- **Openness** : let people know that these data systems exist and what they do
	- **Individual participation** : give people the right to see their own data and correct mistakes
	- **Accountability** : put someone in charge who is responsible for following all of these rules

## 🏷️ Tags

`#privacy` `#law` `#ethics` `#cybersecurity` `#GDPR` `#FTC` `#copyright` `#patents` `#trade-secrets`