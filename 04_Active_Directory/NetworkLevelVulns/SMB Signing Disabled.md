## 🧠 What is SMB Signing?

**SMB Signing** is a security feature that:
- Digitally signs SMB traffic
- Ensures messages are **not tampered with**
- Confirms the server you’re talking to is legitimate

Think of it like a **tamper-proof seal** on SMB packets.

---
## ❌ What Does “SMB Signing Disabled” Mean?

It means:
- SMB traffic is **not integrity-protected**
- Attackers can **relay NTLM authentication**
- The client can’t tell **who it’s actually talking to**

👉 This does **NOT** mean passwords are sent in cleartext  
👉 It means **authentication can be reused by an attacker**

---
## 🧪 How the Attack Works (Conceptual)

Let’s say:

- User = `CORP\john`
- Attacker = you
- Target = File Server / DC
### Step-by-step:

1. John tries to access `\\fileshare`
2. You poison the response
3. John sends NTLM auth to **you**
4. You forward (relay) it to the real server
5. Server accepts it (no signing)
6. You are now authenticated **as John**

🎯 That’s the vuln.

---
## 🛠️ How Attackers Test SMB Signing

### 🔹 Step 1: Check SMB Signing
`nmap --script smb2-security-mode -p445 target`

**Result:**
`Message signing enabled but not required`

🚨 This means **vulnerable**

---

### 🔹 Step 2: Relay Test (Controlled)
Using:
- `responder` (capture)
- `ntlmrelayx.py` (relay)
If relay succeeds → **confirmed vulnerability**

---

## 🛡️ How to Fix SMB Signing Disabled

### 🔒 Enable SMB Signing (Mandatory)

#### Via Group Policy

`Computer Configuration → Windows Settings → Security Settings → Local Policies → Security Options`

Set BOTH:
`Microsoft network client:   Digitally sign communications (always) → Enabled  Microsoft network server:   Digitally sign communications (always) → Enabled`

📌 This forces signing for **all SMB connections**

---

## 🧪 How to Verify the Fix

### On Windows

`Get-SmbServerConfiguration | Select EnableSecuritySignature, RequireSecuritySignature`

Expected:

`EnableSecuritySignature = True RequireSecuritySignature = True`

---
