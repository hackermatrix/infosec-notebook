# GDB Power-User Guide

GDB (GNU Debugger) is the standard tool for dynamic analysis. For a better experience, use extensions like **pwndbg** or **GEF**.

## 🚀 Basic Essentials
- `gdb <binary>`: Start GDB.
- `run` (r): Start execution.
- `break *<address/function>` (b): Set breakpoint.
- `continue` (c): Continue execution.
- `stepi` (si): Execute one assembly instruction (step into).
- `nexti` (ni): Execute one assembly instruction (step over).

## 🛠️ Examining Memory (x/...)
Format: `x/<count><size><format> <address>`
- `x/gx $rsp`: Examine a Giant word (8 bytes) at the Stack Pointer in Hex.
- `x/10i $rip`: Disassemble the next 10 instructions.
- `x/s 0x1234`: See string at address.

---

## 🔥 Pwndbg / GEF Essentials
If you are using an extension, these commands are lifesavers:

| Command | Description |
| :--- | :--- |
| `context` | Shows registers, code, and stack all at once. |
| `tele` (telescope) | Recursively follows pointers (great for stack/heap). |
| `vmmap` | Shows memory segments and their permissions (RWX). |
| `checksec` | Checks for NX, Canary, ASLR, PIE. |
| `stack` | Shows a clean view of the current stack. |
| `search <string>` | Search for a string/value in memory. |

---
**Related Topics:**
- [[05_Reverse_Engineering/04_Tools_CheatSheets/Radare2 Cheat Sheet|Radare2 Cheat Sheet]]
- [[05_Reverse_Engineering/02_Memory_Assembly/The Stack|The Stack]]