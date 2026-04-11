# Windows Privilege Escalation

Moving from a standard user to `Administrator` or `LocalSystem`.

## 🛡️ Token Impersonation (`SeImpersonate`)
If `whoami /priv` shows **SeImpersonatePrivilege** enabled, you can usually become SYSTEM.
- **Tools**: `JuicyPotato.exe`, `PrintSpoofer.exe`, `GodPotato.exe`.
- **Target**: Usually Windows Servers or services running as Service Accounts.

---

## 📂 Service Misconfigurations
### **Unquoted Service Paths**
If a service runs from `C:\Program Files\My App\service.exe` (unquoted):
- Windows tries to execute `C:\Program.exe`, then `C:\Program Files\My.exe`.
- Plant your payload as `C:\Program.exe` if you have write access to `C:\`.

### **Weak Service Permissions**
- **Check**: `accesschk.exe /accepteula -uwcqv "Users" *`
- **Impact**: If you can change the `BINARY_PATH_NAME`, redirect it to `net user /add` or a reverse shell.

---

## 💍 AlwaysInstallElevated
- **Check Registry**:
  - `reg query HKCU\Software\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated`
  - `reg query HKLM\Software\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated`
- **Exploit**: Generate a malicious `.msi` payload with `msfvenom` and run it. It will execute as SYSTEM.

---

## 🔨 Registry Hijacking
### **Autoruns**
Check for writable keys in `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`.
Anything run here at login can be replaced with a payload for persistence/privesc.

---

## 🔍 Stored Credentials
- **CMDKEY**: `cmdkey /list` (check for stored admin passwords).
- **unattend.xml**: Often contains plaintext passwords from deployment.
- **Config files**: Search for "password" in web.config or application.ini.

---

## 🧠 One-Line Mental Model
> **Windows privesc is finding what SYSTEM trusts and abusing it before SYSTEM notices.**

---
**Next Steps:**
- [[04_Active_Directory/AD_Basics|Moving to AD (Post-Compromise)]]
- **WinPEAS**: Execute `winPEASany.exe` for deep automated scans.