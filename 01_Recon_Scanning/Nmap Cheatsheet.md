# Nmap Cheatsheet

Nmap ("Network Mapper") is the essential tool for network discovery and security auditing.

## 🚀 The Golden Scan Combo
Use this for 90% of initial CTF/Pentest targets:
```bash
nmap -sC -sV -T4 -oA nmap/initial <target_ip>
```
- `-sC`: Run default NSE scripts.
- `-sV`: Probe open ports to determine service/version info.
- `-T4`: Set timing template (higher is faster).
- `-oA`: Output in all 3 formats (Nmap, XML, Grepable).


---

## 🛠️ Essential Scan Types
| Flag  | Name              | Description                                              |
| :---- | :---------------- | :------------------------------------------------------- |
| `-sS` | SYN Scan          | Default, stealthy (half-open scan).                      |
| `-sT` | Connect Scan      | Slower, completes the 3-way handshake.                   |
| `-sU` | UDP Scan          | Scans for UDP services (DNS, SNMP, etc.).                |
| `-p-` | Full Port Scan    | Scans all 65,535 ports.                                  |
| `-Pn` | No Ping           | Assume host is up (bypasses ICMP blocks).                |
| -A    | agressive mode    |                                                          |
| -O    | OS detection      | Detect which operating system the target is running on   |
| -sV   | Service Detection | Detect the version of the services running on the target |
| -v    | Output            | Verbiosity                                               |
| -vv   | Output            | Increased Verbiosity                                     |
| -oA   | Output            | Save the nmap results in three major formats             |
| -oG   | Output            | Save results in grepable format                          |
| -sn   | Ping Sweep        | Ping scan: find live hosts on the subnet                 |

---

## 🔍 NSE (Nmap Scripting Engine)
Scripts are located in `/usr/share/nmap/scripts/`.

### **Common Categories:**
- `default`: Basic enumeration (-sC).
- `vuln`: Checks for known vulnerabilities.
- `auth`: Bypass or test authentication.
- `brute`: Brute force attacks.

### **Pro Combos:**
- `nmap --script smb-vuln* -p 445 <IP>`: Scan for SMB vulns (like EternalBlue).
- `nmap --script http-enum -p 80 <IP>`: Directory/File enumeration via Nmap.

---

## 🥷 Firewall & IDS Evasion
- `-f`: Fragment packets.
- `--mtu 24`: Set custom Maximum Transmission Unit.
- `-D RND:5`: Use 5 random decoys.
- `--source-port 53`: Spoof DNS port to bypass strict rules.

---

## 💡 Quick Tips
- **Grep for open ports**: `grep "open" scan.gnmap | awk '{print $2}'`
- **Output to directory**: Always create an `nmap/` directory before scanning.
- **Top 100 UDP**: `nmap -sU --top-ports 100 <IP>`

---
**Related Topics:**
- [[04_Active_Directory/AD_Foundations|AD Recon]]
- [[05_Reverse_Engineering/04_Tools_CheatSheets/TOOLS|Toolbox Overview]]