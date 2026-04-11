# Linux Privilege Escalation

The art of going from a low-privileged user to `root`.

## 🛠️ Step 0: Shell Stabilization
Before escalating, get a full TTY shell:
```bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
# Press CTRL+Z
stty raw -echo; fg
# Press ENTER twice
export TERM=xterm
```

---

## 🚀 The "Quick Win" Checklist
1. **`sudo -l`**: Check what you can run as root without a password.
2. **SUID Files**: `find / -perm -4000 -type f 2>/dev/null`
   - Check results against [GTFOBins](https://gtfobins.github.io/).
3. **Internal Ports**: `netstat -punta` or `ss -lntu`. Look for services bound to `127.0.0.1`.
4. **`bash_history`**: `cat ~/.bash_history`. Look for passwords in command lines.

---

## 📁 Writable File Hazards
| File | Impact |
| :--- | :--- |
| `/etc/passwd` | Add a new root user directly. |
| `/etc/shadow` | Read hashes for offline cracking. |
| `/etc/crontab` | Modify system-wide scheduled tasks. |
| `root` scripts | Any script run by root that you can edit = root shell. |

---

## 💍 Capabilities
Capabilities provide fine-grained control over privileges.
- **Check**: `getcap -r / 2>/dev/null`
- **Exploit**: If you find `cap_setuid+ep` on `python` or `perl`, you can set your UID to 0.

---

## 🌊 NFS No_Root_Squash
If you find a mount with `no_root_squash` in `/etc/exports`:
1. Mount the share on your machine.
2. Create a C file that spawns `/bin/bash`.
3. Compile and set SUID bit on the shared folder.
4. Run it on the target machine for root access.

---

## 🧠 Mental Model
> **Privilege escalation is finding something root trusts and making it betray root.**

---
**Tools:**
- [[05_Reverse_Engineering/04_Tools_CheatSheets/TOOLS|Toolbox]]
- **LinPEAS**: The gold standard for automated enumeration.
