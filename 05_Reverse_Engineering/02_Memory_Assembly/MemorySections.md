# Process Memory Layout

Understanding how a program is laid out in memory is critical for reverse engineering and exploitation.

## 🗺️ Visual Overview
```text
High Addresses (0xFFFFFFFF)
+-----------------------+
|        Kernel         | (OS Reserved)
+-----------------------+
|         Stack         | (Grows DOWN ↓)
+-----------------------+
|           ↓           |
|                       |
|           ↑           |
+-----------------------+
|         Heap          | (Grows UP ↑)
+-----------------------+
|         .bss          | (Uninitialized Data)
+-----------------------+
|         .data         | (Initialized Data)
+-----------------------+
|         .text         | (Code / Instructions)
+-----------------------+
Low Addresses (0x00000000)
```

---

## 🏗️ Common Binary Sections

### 1. .text — Code Section
- **Permissions**: `R-X` (Read + Execute)
- **Content**: Compiled machine instructions.
- **Note**: Marked Read-Only to prevent self-modifying code.

### 2. .data — Initialized Data
- **Permissions**: `RW-` (Read + Write)
- **Content**: Global and static variables with initial values set at compile time (e.g., `int x = 5;`).

### 3. .bss — Uninitialized Data
- **Permissions**: `RW-` (Read + Write)
- **Content**: Global and static variables that are not initialized (e.g., `int y;`). These are zeroed out by the OS at startup.

### 4. .rodata — Read-Only Data
- **Permissions**: `R--` (Read Only)
- **Content**: Constant values and string literals (e.g., `printf("Hello");`).

### 5. .plt & .got (ELF Linux)
- **PLT (Procedure Linkage Table)**: Small stubs used to jump to external functions in dynamic libraries.
- **GOT (Global Offset Table)**: Stores the actual addresses of external functions after they are resolved.
- **Security Note**: [[05_Reverse_Engineering/03_Exploitation_Security/Security Mechanisms#5. Relocation Read-Only (RELRO)|RELRO]] protects this section.

---

## 🌊 Dynamic Segments

### 📥 The Stack
- **Growth**: **Downwards** (towards lower addresses).
- **Permissions**: `RW-` (Read + Write).
- **Security**: Often protected by the **NX bit** (Non-Executable) and **Canaries**.
- **Usage**: Local variables, function arguments, and return addresses.
- [[05_Reverse_Engineering/02_Memory_Assembly/The Stack|Detailed Notes on The Stack]]

### 📤 The Heap
- **Growth**: **Upwards** (towards higher addresses).
- **Permissions**: `RW-` (Read + Write).
- **Usage**: Dynamically allocated memory (via `malloc`, `new`).

---

## 🛠️ Auxiliary Sections
- **.symtab**: Symbol table (names of functions/variables). Often removed ("stripped").
- **.strtab**: String table for symbols.
- **.debug**: Debugging information (DWARF format). Only present if compiled with `-g`.


![[Pasted image 20260331090815.png]]


**System Code** is the kernel's executable code, the operating system's own `.text`. Things like the scheduler, memory manager, device drivers, and system call handlers. Your program can't access this directly; it goes through system calls (`syscall` instruction) to request services from this code.

**System Data** is the kernel's own data, its internal data structures like the process table, page tables, file descriptor tables, and so on. Again, your program can't touch this directly.

The thick black line in the diagram between "Local Data" and "System Data" represents the **privilege boundary**. Everything above that line runs in user mode (ring 3), everything below runs in kernel mode (ring 0).
[[SysCalls and Privilege Levels]]
