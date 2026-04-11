# Reverse Engineering Map of Content (MOC)

> [!NOTE]
> This is a central index for all Reverse Engineering notes. Use this as your starting point for navigation.

## 🧱 01. Foundations
- [[05_Reverse_Engineering/01_Foundations/Concepts|RE Overview & Concepts]]
- [[05_Reverse_Engineering/01_Foundations/Registers|CPU Registers (x64 Breakdown)]]
- [[05_Reverse_Engineering/01_Foundations/Types and Size|Data Types & Memory Sizes]]
- [[SysCalls and Privilege Levels|SysCalls & CPU Rings]]
- [[05_Reverse_Engineering/01_Foundations/Address Spaces|Virtual vs. Physical Memory]]

## ⚡ 02. Memory & Assembly
- [[05_Reverse_Engineering/02_Memory_Assembly/Instructions|Assembly Instruction Reference]]
- [[05_Reverse_Engineering/02_Memory_Assembly/The Stack|The Stack & Function Lifecycle]]
- [[05_Reverse_Engineering/02_Memory_Assembly/MemorySections|Process memory Layout (.text, .data, etc.)]]
- [[05_Reverse_Engineering/02_Memory_Assembly/Execution Flow|Fetch-Decode-Execute Cycle]]

## 🛡️ 03. Exploitation & Security
### **Stack-Based Attacks**
- [[ret2libc Summary|ret2libc Exploit Strategy]]
- [[05_Reverse_Engineering/03_Exploitation_Security/Stack_Based/GOT overwrite|GOT Overwrite Attacks]]
- [[05_Reverse_Engineering/03_Exploitation_Security/Stack_Based/Stack Canaries|Detailed Stack Canary Notes]]
- [[05_Reverse_Engineering/03_Exploitation_Security/Security Mechanisms|Binary Protections Overview]]

### **Heap-Based Attacks**
- [[Heap_Based_README|Upcoming: Heap Study Roadmap]]

## 🛠️ 04. Tools & Cheat Sheets
- [[05_Reverse_Engineering/04_Tools_CheatSheets/GDB How to's|GDB & pwndbg/GEF Power-User Guide]]
- [[05_Reverse_Engineering/04_Tools_CheatSheets/Radare2 Cheat Sheet|Radare2 (r2) Analysis Guide]]
- [[05_Reverse_Engineering/04_Tools_CheatSheets/TOOLS|Essential RE Toolset Overview]]

## 🎓 05. Academic Notes
- [[05_Reverse_Engineering/05_Academic_Notes/Class Notes 5130 (15-01-2026)|Class Notes: Passing Arguments]]
- [[05_Reverse_Engineering/05_Academic_Notes/Class Notes 5130 (22-01-2026)|Class Notes: Defense overhead & Rings]]

## 📂 06. Resources & Misc
- [[05_Reverse_Engineering/06_Resources_Misc/Resources|External Links & Workshops]]
- [[05_Reverse_Engineering/06_Resources_Misc/MISC|Lab Compilations & GCC Flags]]

---
**Project Tracking:** [[VERSIONING]]
