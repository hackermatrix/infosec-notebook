# Data Types and Sizes

In Reverse Engineering, understanding the size of data is crucial for interpreting memory correctly.

## 📏 Data Size Table

| Name | Assembly Prefix | Size (Bits) | Size (Bytes) | C Data Type |
| :--- | :--- | :--- | :--- | :--- |
| **Byte** | `byte ptr` | 8 | 1 | `char`, `int8_t` |
| **Word** | `word ptr` | 16 | 2 | `short`, `int16_t`|
| **Dword** | `dword ptr` | 32 | 4 | `int`, `long`, `int32_t`|
| **Qword** | `qword ptr` | 64 | 8 | `long long`, `int64_t`|

---

## 🔍 Addressing Memory
When the CPU accesses memory, it often uses these prefixes to know how many bytes to read:
- `mov al, byte ptr [rbx]` -> Read 1 byte.
- `mov eax, dword ptr [rbx]` -> Read 4 bytes.
- `mov rax, qword ptr [rbx]` -> Read 8 bytes.

## 🔡 Signage
- **Signed**: Can be positive or negative (uses Two's Complement).
- **Unsigned**: Only positive values (higher range for the same number of bits).

---
**Related Topics:**
- [[05_Reverse_Engineering/01_Foundations/Registers|CPU Registers]]
- [[05_Reverse_Engineering/02_Memory_Assembly/MemorySections|Memory Sections]]