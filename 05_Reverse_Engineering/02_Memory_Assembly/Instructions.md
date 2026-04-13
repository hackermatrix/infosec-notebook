# Assembly Instructions Reference (x86/x64)

Instructions are the low-level machine commands that tell the CPU what to do.

## 1. Data Transfer
| Instruction | Full Name              | Description                                   | Example            |
| :---------- | :--------------------- | :-------------------------------------------- | :----------------- |
| `MOV`       | Move                   | Copies data from source to destination.       | `mov rax, 1`       |
| `LEA`       | Load Effective Address | Computes an address without accessing memory. | `lea rsi, [rax+8]` |
| `PUSH`      | Push onto Stack        | Subtracts ESP/RSP and stores data.            | `push rax`         |
| `POP`       | Pop from Stack         | Retrieves data and adds to ESP/RSP.           | `pop rbx`          |
|             |                        |                                               |                    |

---

## 2. Arithmetic
| Instruction | Description | Example | Flags Affected |
| :--- | :--- | :--- | :--- |
| `ADD` | Addition | `add rax, rbx` | ZF, SF, CF, OF |
| `SUB` | Subtraction | `sub rax, 5` | ZF, SF, CF, OF |
| `INC` / `DEC` | Increment / Decrement | `inc rcx` | ZF, SF, OF |
| `MUL` / `IMUL` | Unsigned / Signed Multiplication | `imul rax, 2` | CF, OF |
| `DIV` / `IDIV` | Unsigned / Signed Division | `idiv rbx` | (None) |

---

## 3. Logical & Bitwise
| Instruction | Description | Example | Notes |
| :--- | :--- | :--- | :--- |
| `AND` | Bitwise AND | `and al, 0x0F` | Often used for masking. |
| `OR` | Bitwise OR | `or rax, rbx` | |
| `XOR` | Exclusive OR | `xor rax, rax` | Fastest way to zero a register.|
| `NOT` | Bitwise NOT | `not bl` | One's complement inversion. |
| `SHL` / `SHR` | Shift Left/Right | `shl rax, 1` | Multiply/Divide by 2. |

---

## 4. Control Flow (Branching)
| Instruction | Description | Condition |
| :--- | :--- | :--- |
| `JMP` | Unconditional Jump | Always |
| `JE` / `JZ` | Jump if Equal / Zero | `ZF = 1` |
| `JNE` / `JNZ`| Jump if Not Equal / Not Zero | `ZF = 0` |
| `JG` / `JL` | Jump if Greater / Less (Signed) | (Complex Flag Check) |
| `CALL` | Call Procedure | Push RIP, Jump to address |
| `RET` | Return from Procedure | Pop RIP back into EIP |
```asm
jmp 0x401234
```

That's it — it just sets `RIP = 0x401234`. The CPU then fetches and executes whatever instruction lives at that address. No value is saved, nothing is pushed to the stack.

```
Before jmp:
  RIP = 0x400100   (currently executing jmp instruction)

After jmp:
  RIP = 0x401234   (CPU jumps here next)
```
**`call` vs `jmp` — the key difference**

`call` is like a jump, but it **saves the return address** first:

asm

```asm
call 0x401234
```

What actually happens:

1. RSP decrements by 8
2. The **current RIP** (address of the next instruction after call) is pushed onto the stack
3. RIP = 0x401234

```
Before call:
  RIP = 0x400100
  RSP = 0x7fffffffe010

After call:
  [0x7fffffffe008] = 0x400108  ← return address saved on stack
  RSP = 0x7fffffffe008
  RIP = 0x401234
```

And `ret` reverses it — it **pops** the saved address off the stack back into RIP:

```
ret:
  RIP = pop from stack
  RSP += 8
```

#### Since `ret` just pops whatever is on the stack into RIP — if you can overflow the stack and overwrite that saved return address, you control where RIP goes next. That's the entire basis of buffer overflow exploitation and ROP chains, which you've been working through in your labs.
---

**Why this matters for exploitation**

Since `ret` just pops whatever is on the stack into RI

---

## 5. Comparison & Testing
- **`CMP destination, source`**: Performs subtraction and updates flags, but **doesn't store the result**.
- **`TEST destination, source`**: Performs a bitwise AND and updates flags, but **doesn't store the result**. (Used to check for NULL/0).

---
**Related Topics:**
- [[05_Reverse_Engineering/01_Foundations/Registers|CPU Registers]]
- [[05_Reverse_Engineering/02_Memory_Assembly/The Stack|The Stack]]