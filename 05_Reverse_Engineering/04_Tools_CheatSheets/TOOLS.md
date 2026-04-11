# Reverse Engineering Toolset

A summary of essential tools for various RE tasks.

## 🕵️ Static Analysis
- **Ghidra**: NSA's open-source decompiler (Great for C/C++).
- **IDA Pro / Free**: The industry standard for complex binaries.
- **Binary Ninja**: Modern GUI with a clean API and lifting capabilities.
- **Strings**: Extract printable text from a binary.

## ⚡ Dynamic Analysis (Debugging)
- **GDB**: Linux standard. Use with **GEF** or **pwndbg**.
- **x64dbg**: The best modern debugger for Windows.

## 🛠️ CLI Utilities
- **file**: Identify file types and architecture.
- **nm**: List symbols in object files.
- **objdump**: Basic disassembler (e.g., `objdump -d <binary>`).
- **strace**: Traces System Calls (Essential! See [[SysCalls and Privilege Levels|SysCalls]]).
- **ltrace**: Traces Library Function calls.
- **Checksec**: Script to check binary protections (NX, PIE, etc.).

---
**Related Topics:**
- [[05_Reverse_Engineering/04_Tools_CheatSheets/GDB How to's|GDB Power-User]]
- [[05_Reverse_Engineering/04_Tools_CheatSheets/Radare2 Cheat Sheet|Radare2 Cheat Sheet]]