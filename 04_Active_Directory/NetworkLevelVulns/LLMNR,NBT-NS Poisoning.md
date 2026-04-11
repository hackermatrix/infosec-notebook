
## 🔥 What is LLMNR / NBT-NS Poisoning?

- It’s a **Windows internal network attack** where you **impersonate a server** and trick machines into **sending you NTLM hashes**.

- Why it works?  
	Because Windows tries _desperately_ to resolve names when DNS fails.

---
## 🧠 The Core Problem

- When a Windows machine tries to reach:
	`\\fileserver123`

	and **DNS fails**, Windows falls back to:
	1. **LLMNR** (UDP 5355)
	2. **NBT-NS** (UDP 137)

- These protocols:
	- Have **no authentication**
	- Accept **any response**
	- Trust the _fastest responder_
- So the attacker says:
> “Yeah bro, I’m fileserver123 😈”

---
# 🧪 How LLMNR / NBT-NS Poisoning Is Tested

> This is **not a “scan” vulnerability**  
> It’s a **behavioral misconfiguration test**

You’re testing:

> **Does the network allow unauthenticated name resolution poisoning?**

---
## 🔍 Preconditions (Before You Test)

You need:
- Internal network access (VPN / on-site / lab)
- Layer-2 or same subnet (usually)
- A Linux attack box (Kali / Parrot)

That’s it. No creds.

---

## 🧠 Step 1: Passive Recon (No Poisoning Yet)

Before attacking, check if the environment is **chatty**.
`sudo tcpdump -i eth0 port 5355 or port 137`

What you’re looking for:

- LLMNR broadcasts
- NBT-NS name queries

Example:
`LLMNR Query: FILESERVER123 NBT-NS Query: WPAD`

👉 If you see traffic → **attack surface exists**

---

## 🧨 Step 2: Start the Poisoner (Responder)

`sudo responder -I eth0`
Important modes:
- Default = **safe enough for testing**
- It:
    - Listens    
    - Responds
    - Captures hashes
You’re now **waiting**, not spamming.

---

## 🎣 Step 3: Trigger (If Needed)

Often, you don’t even need this — but if the network is quiet:
### Option A: Wait (Realistic)

Users will:
- Mistype paths
- Open old shares
- Auto-discover printers

### Option B: Gentle Trigger (Lab / Explicit Test)

From a **Windows machine**:
`\\thisdoesnotexist`
Or:
`net use \\fakehost`

This forces:
- DNS fail
- LLMNR / NBT-NS broadcast
    

---

## 🎯 Step 4: Observe the Results

Responder output example:

`[LLMNR] Poisoned answer sent to 192.168.1.10 [SMB] NTLMv2-SSP Hash     : john::CORP:hash`

This confirms:

- LLMNR/NBT-NS enabled
- Client trusts broadcast responses
- Credentials exposed

👉 **Vulnerability confirmed**


---

# 🛡️ How to Fix LLMNR / NBT-NS Poisoning (Properly)

> Goal: **Stop unauthenticated name resolution + stop NTLM abuse**

###### Reference: https://projectblack.io/blog/disable-llmnr-gpo-netbios-mdns/
---
## ✅ 1. Disable LLMNR (MOST IMPORTANT)

### 🔹 Via Group Policy (Domain Environment)

**Path:**
`Computer Configuration → Administrative Templates → Network → DNS Client → Turn off Multicast Name Resolution`

**Setting:**
`Enabled`

📌 This disables **LLMNR (UDP 5355)** entirely.

---

### 🔹 Verify LLMNR Is Disabled

On a domain machine:

```
Get-ItemProperty `  "HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient" `  -Name EnableMulticast
```

Expected:

`EnableMulticast : 0`

---

## ✅ 2. Disable NBT-NS (NetBIOS Name Service)

### 🔹Disable NBT‑NS via GPO 

### Step 1: Open Group Policy Management

	On the DC:
	
	`gpmc.msc`

---

### Step 2: Create a New GPO

- Right‑click **Domain** (or an OU like `Workstations`)
- **Create a GPO in this domain**
- Name it:
	`Disable NBT-NS`

---

### Step 3: Edit the GPO

Go to:
```
Computer Configuration  
└─ Preferences     
	└─ Windows Settings        
		└─ Registry
```

---

### Step 4: Create Registry Item

- **New → Registry Item**

| Field      | Value                                                   |
| ---------- | ------------------------------------------------------- |
| Action     | Update                                                  |
| Hive       | HKEY_LOCAL_MACHINE                                      |
| Key Path   | `SYSTEM\CurrentControlSet\Services\Dnscache\Parameters` |
| Value Name | `EnableNetbios`                                         |
| Value Type | REG_DWORD                                               |
| Value Data | `0`                                                     |

✔ This disables NetBIOS over TCP/IP.

---

### Step 5: Link the GPO

- Link it to:
    - **Domain** → affects all machines
    - or **Workstations OU** → safer, avoids breaking legacy servers

---


##  3. Disable mDNS via Registry

mDNS can be disabled through the registry editor. The following registry key can be added to disable mDNS on the local machine.

Note: Microsoft currently advises leaving this running as some technologies utilise the protocol (Display adapters, chrome cast, printer discover).

1. Open Windows Registry Editor
2. Navigate to HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters
3. create a DWORD "EnableMDNS" with the value “0”.



---

## ✅ 3. Enforce SMB Signing (Stops NTLM Relay)

Even if hashes leak, **relay attacks fail**.

### 🔹 Domain GPO

`Computer Configuration → Windows Settings → Security Settings → Local Policies → Security Options`

Set:

`Microsoft network client: Digitally sign communications (always) → Enabled Microsoft network server: Digitally sign communications (always) → Enabled`

📌 This blocks **ntlmrelayx**, a HUGE win.

---

## ✅ 4. Reduce / Restrict NTLM (Advanced but Powerful)

### 🔹 Audit First (DO NOT BLOCK YET)

`Network security: Restrict NTLM: Audit NTLM authentication → Enable auditing for all accounts`

Check logs:

`Event ID 4624 / 4776`

---

### 🔹 Then Restrict NTLM (Carefully)

`Network security: Restrict NTLM: NTLM authentication in this domain → Deny all`

⚠️ Only after confirming **no legacy systems break**.

---

## ✅ 5. Disable WPAD (Bonus Fix)

Responder LOVES WPAD.

### 🔹 Via GPO

`Computer Configuration → Administrative Templates → Windows Components → Internet Explorer → Disable changing Automatic Configuration settings`

OR registry:

``reg add `  "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" `  /v DisableWpad /t REG_DWORD /d 1 /f``

---

## 🧪 How to Confirm the Fix (VERY IMPORTANT)

### 🔍 Retest with Responder

`sudo responder -I eth0`

Expected:

- ❌ No LLMNR responses
    
- ❌ No NBT-NS responses
    
- ❌ No NTLM hashes
    

If Responder is **dead silent** → you fixed it right 🧘‍♂️