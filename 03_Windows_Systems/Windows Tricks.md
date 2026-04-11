
## 1. Have creds but no domain-joined machine:

```bash
runas /netonly /user:CORP\j.smith cmd.exe
```
- Access domain resources from a **non-domain machine**.
- Enumerate shares & AD
- Use AD Recon Tools With Domain Identity **(SharpHound, Powerview ,etc).**
-