# Radare2 (r2) Cheat Sheet

Radare2 is a powerhouse CLI for static and dynamic analysis.

## 🏁 Startup
- `r2 <binary>`: Open in read-only.
- `r2 -d <binary>`: Open in **debug** mode.
- `r2 -A <binary>`: Open and run full analysis immediately.

## 🔍 Analysis (The 'a' commands)
- `aa`: Analyze all symbols.
- `aaa`: Full analysis (functions, cross-references).
- `afl`: List all discovered functions.
- `pdf @ <function>`: Print Disassembly of Function.

## 📍 Navigation (The 's' commands)
- `s main`: Seek to the `main` function.
- `s 0x401000`: Seek to a specific address.
- `s-`: Go back to the previous location.

## 🖼️ Visual Mode
- `V`: Enter visual mode.
- `p / P`: Cycle through views (Hex, Disassembly, Debug).
- `?`: Help in visual mode.
- `q`: Exit visual mode / Exit r2.

---
**Related Topics:**
- [[05_Reverse_Engineering/04_Tools_CheatSheets/GDB How to's|GDB Guide]]
- [[05_Reverse_Engineering/04_Tools_CheatSheets/TOOLS|Tools Overview]]
