# The Stack

The **stack** is a LIFO (Last-In, First-Out) memory structure used for temporary storage, function calls, and local variables.

## 📥 Stack Mechanics
- **Pointer**: Managed by the **RSP** (Stack Pointer) register.
- **Growth**: The stack grows **downward** (towards lower memory addresses).
- **Operations**:
    - `PUSH`: Decrement RSP, store value.
    - `POP`: Retrieve value, increment RSP.

## 🖼️ Visual Stack Frame
When a function is called, a "Frame" is created to hold its data.

![[Pasted image 20260115173248.png]]


```text
Higher Addresses
+-----------------------+
|  Function Arguments   |
+-----------------------+
|    Return Address     | <--- Pushed by CALL
+-----------------------+
|     Saved RBP         | <--- "Old" Frame Pointer
+-----------------------+ <--- New RBP points here
|    Local Variables    |
|       (Buffer)        |
+-----------------------+ <--- RSP points here (Top)
Lower Addresses
```

## 🏗️ Function Lifecycle

### **1. Prologue (Setup)**
At the start of every function:
```nasm
push rbp        ; Save caller's frame pointer
mov rbp, rsp    ; Set new frame pointer
sub rsp, 0x20   ; Allocate space for locals
```

### **2. Epilogue (Cleanup)**
Before returning:
```nasm
mov rsp, rbp    ; Restore stack pointer
pop rbp         ; Restore caller's frame pointer
ret             ; Jump to return address
```

> [!TIP]
> Modern compilers often use the `leave` instruction as a shorthand for the first two steps of the epilogue.

---
**Related Topics:**
- [[05_Reverse_Engineering/02_Memory_Assembly/Instructions|Instructions (PUSH/POP)]]
- [[03_Exploitation_Security/Stack Canaries|Security (Stack Canaries)]]