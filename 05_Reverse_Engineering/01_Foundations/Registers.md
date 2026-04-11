# CPU Registers

Registers are small, high-speed storage locations within the CPU used to store data, addresses, and status information.

## 1. General-Purpose Registers (GPRs)

In modern x86/x64 systems, GPRs can be accessed in various sizes.

### **x64 Register Breakdown**
| 64-bit     | 32-bit   | 16-bit   | 8-bit (Low) | Description              |
| :--------- | :------- | :------- | :---------- | :----------------------- |
| **RAX**    | EAX      | AX       | AL          | Accumulator (Results)    |
| **RBX**    | EBX      | BX       | BL          | Base Register            |
| **RCX**    | ECX      | CX       | CL          | Counter (Loops)          |
| **RDX**    | EDX      | DX       | DL          | Data (I/O)               |
| **RSI**    | ESI      | SI       | SIL         | Source Index             |
| **RDI**    | EDI      | DI       | DIL         | Destination Index        |
| **RBP**    | EBP      | BP       | BPL         | Base Pointer             |
| **RSP**    | ESP      | SP       | SPL         | Stack Pointer            |
| **R8-R15** | R8D-R15D | R8W-R15W | R8B-R15B    | Additional x64 Registers |
|            |          |          |             |                          |

---

## 2. Special-Purpose Registers (SPRs)

- **Instruction Pointer (RIP/EIP)**: Points to the address of the **next** instruction to be executed.
- **Flags Register (RFLAGS/EFLAGS)**: Stores status bits resulting from operations:
    - **ZF (Zero Flag)**: Set if the result of an operation is 0.
    - **SF (Sign Flag)**: Set if the result is negative.
    - **CF (Carry Flag)**: Set if an unsigned overflow occurred.
    - **OF (Overflow Flag)**: Set if a signed overflow occurred.

---

## 3. Segment Registers
Mainly used in older architectures or for specific OS tasks (like thread-local storage).
- **CS**: Code Segment
- **DS**: Data Segment
- **SS**: Stack Segment
- **FS / GS**: Used for special OS structures (e.g., TEB/PEB in Windows, TLS in Linux).

---
**Related Topics:**
- [[05_Reverse_Engineering/01_Foundations/Concepts|RE Concepts]]
- [[05_Reverse_Engineering/02_Memory_Assembly/The Stack|The Stack]]