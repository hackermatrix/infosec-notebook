
Operating systems use privilege levels to protect critical resources from user programs.

## 💍 CPU Privilege Rings
The x86 architecture uses 4 rings (levels of protection), but modern OSs (Linux/Windows) primarily use only two:

- **Ring 0 (Kernel Mode)**:
    - Full access to hardware.
    - Can execute any CPU instruction.
    - Used for the OS Kernel and drivers.
- **Ring 3 (User Mode)**:
    - Restricted access.
    - Cannot access hardware directly.
    - Most applications run here.

---

## 🚪 System Calls (SysCalls)
A **SysCall** is the mechanism used by a Ring 3 program to request a service from the Ring 0 Kernel (e.g., reading a file, printing to screen).

### **The SysCall Process (x64 Linux)**
1. **Load SysCall Number**: Move the syscall ID into **RAX**.
2. **Setup Arguments**: Load parameters into **RDI, RSI, RDX, R10, R8, R9**.
3. **Trigger**: Execute the `syscall` instruction.
4. **Transition**: CPU switches to Ring 0, performs the task, and returns to Ring 3.

### **Common SysCall Examples**
- `0` -> `read`
- `1` -> `write`
- `2` -> `open`
- `60` -> `exit`

---
**Related Topics:**
- [[05_Reverse_Engineering/01_Foundations/Address Spaces|Address Spaces]]
- [[05_Reverse_Engineering/04_Tools_CheatSheets/TOOLS|Tools (strace)]]