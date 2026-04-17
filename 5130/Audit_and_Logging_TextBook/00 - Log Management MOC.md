# 📘 Chapters 2-3 — Computer Security Log Management (Map of Content)

> **Purpose:** These chapters cover the fundamentals of security log management — what logs are, why they matter, the challenges of managing them at scale, and the infrastructure (architecture, syslog, SIEM) needed to do it effectively. Based on NIST SP 800-92 guidance.

---

## 🗂️ Topics

| # | Topic | Link |
|---|-------|------|
| **Ch 2** | **Introduction to Computer Security Log Management** | |
| 2.1 | The Basics of Computer Security Logs | [[2.1 - Basics of Computer Security Logs]] |
| 2.2–2.5 | Need, Challenges, and Meeting the Challenges | [[2.2-2.5 - Need Challenges and Solutions]] |
| **Ch 3** | **Log Management Infrastructure** | |
| 3.1–3.6 | Architecture, Syslog, SIEM, and More | [[3.1-3.6 - Log Management Infrastructure]] |

---

## 🔗 Key Relationships

```
Basics of Logs (2.1)
    ├── log sources: Security Software, OS, Applications
    └── usefulness drives → Need for Log Management (2.2)

Challenges (2.3)
    ├── Generation & Storage → solved by → Architecture (3.1)
    ├── Protection → solved by → Syslog Security (3.3.2)
    └── Analysis → solved by → SIEM (3.4)

Infrastructure (Ch 3)
    ├── Architecture (3.1) — how log systems are built
    ├── Syslog (3.3) — the standard protocol
    └── SIEM (3.4) — correlation and analysis at scale
```

---

#log-management #SIEM #syslog #NIST #security-monitoring
