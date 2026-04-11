# Miscellaneous Reverse Engineering Snippets

Useful commands and small notes collected during lab work.

## 🛠️ GCC Compilation for Labs
When creating vulnerable binaries for practice, use these flags:

```bash
gcc -z execstack -fno-stack-protector -ggdb3 -o extra extra.c
```

### **Flag Breakdown:**
- `✅ -z execstack`: **Disables NX (No-Execute)**. Marks the stack as executable so injected shellcode can run.
- `❌ -fno-stack-protector`: **Disables Stack Canaries**. Removes the "canary" security check, allowing for simple stack smashing.
- `🐞 -ggdb3`: Adds **full debug symbols**. Includes line numbers and variable names for easier GDB analysis.
- `📁 -o extra`: Specifies the output binary name.

---
**Related Topics:**
- [[05_Reverse_Engineering/03_Exploitation_Security/Security Mechanisms|Security Mechanisms]]
- [[05_Reverse_Engineering/04_Tools_CheatSheets/GDB How to's|GDB Guide]]
