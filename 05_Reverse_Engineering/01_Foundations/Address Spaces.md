# Virtual vs. Physical Address Spaces

Memory management is complex. Programs do not deal with physical RAM directly; they use Virtual Memory.

## 👻 Virtual Memory
Each process thinks it has its own private, massive address space (e.g., 2^64 bytes on x64).

- **Isolation**: Process A cannot read Process B's memory.
- **Paging**: The OS maps small chunks (pages, usually 4KB) of Virtual Memory to Physical RAM.
- **Swap**: Pages not in use can be moved to the disk (pagefile/swap) to free up RAM.

## 🗺️ The Layout (Simplified)
A virtual address space is split between:
- **User Space**: Where the application, its stack, heap, and libraries live.
- **Kernel Space**: Reserved for the OS kernel. User programs cannot access this directly.

---

## 🛠️ Translation (MMU)
The **Memory Management Unit (MMU)** in the CPU handles the translation from a virtual address to a physical RAM address using **Page Tables**.

> [!NOTE]
> When a process tries to access a virtual address that isn't mapped to physical RAM, a **Page Fault** occurs, and the OS must handle it.

---
**Related Topics:**
- [[05_Reverse_Engineering/02_Memory_Assembly/MemorySections|Memory Sections]]
- [[SysCalls and Privilege Levels|SysCalls & Privilege]]