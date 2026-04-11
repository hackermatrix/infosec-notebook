## 🧠 What Does This Mean?

In most AD environments:

- Admins configure **IPv4**
- IPv6 is **left enabled by default**
- No IPv6 DNS
- No IPv6 DHCP
- No IPv6 monitoring

But Windows logic is:

> **If IPv6 exists, prefer it over IPv4**

That’s the problem.

---
## 💥 Why This Is Dangerous

An attacker can:
- Introduce a **rogue IPv6 service**
- Become:
    - DNS server
    - DHCPv6 server
    - Default gateway
- Man-in-the-middle authentication
👉 No need to poison LLMNR/NBT-NS  
👉 IPv6 **beats IPv4 automatically**

---
## 🧪 How This Is Tested (Pentest View)

### 🔹 Step 1: Check IPv6 Status

- On a Windows host:
	- `ipconfig`

- If you see:
	- `IPv6 Address . . . . . : fe80::`

👉 IPv6 is enabled.

---

### 🔹 Step 2: Confirm No Legit IPv6 Infra

Check:
- No IPv6 DNS servers
- No DHCPv6
- No IPv6 routing

That combo = **vulnerable**

---
### 🔹 Step 3: Controlled Attack Test

```
mitm6 -i eth0 
ntlmrelayx.py -6 -t ldap://dc.domain.local
```

If relay succeeds → vuln confirmed.

---

## 🛡️ How to Fix IPv6 Enabled but Not Used

### ✅ Option 1: Properly Deploy IPv6 (Best Practice)

- IPv6 DNS
- IPv6 DHCP
- IPv6 monitoring
- Secure configs

✔ Secure  
✔ Future-proof  
❌ Complex

---

### ✅ Option 2: Disable IPv6 (Most Common Fix)

#### ⚠️ DO NOT disable via adapter checkbox

Microsoft explicitly warns against that.

---

### 🔒 Correct Way (Registry / GPO)

`HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters`

Set DWORD:

`DisabledComponents = 0xFF`

This:

- Disables IPv6
- Preserves loopback behavior

---

### 🔹 Deploy via GPO

`Computer Configuration → Preferences → Windows Settings → Registry`

Add:

- Path: Tcpip6\Parameters
- Value: DisabledComponents
- Type: REG_DWORD
- Data: 0xFF