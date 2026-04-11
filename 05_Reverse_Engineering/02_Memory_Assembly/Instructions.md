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

---

## 5. Comparison & Testing
- **`CMP destination, source`**: Performs subtraction and updates flags, but **doesn't store the result**.
- **`TEST destination, source`**: Performs a bitwise AND and updates flags, but **doesn't store the result**. (Used to check for NULL/0).

---
**Related Topics:**
- [[05_Reverse_Engineering/01_Foundations/Registers|CPU Registers]]
- [[05_Reverse_Engineering/02_Memory_Assembly/The Stack|The Stack]]