# CPU Execution Flow

Understanding how the CPU executes instructions is the core of reverse engineering.

## ⚙️ The Instruction Cycle
The CPU follows a continuous loop called the **Fetch-Decode-Execute** cycle:

1. **Fetch**: The CPU reads the instruction from memory (at the address in **RIP**).
2. **Decode**: The Control Unit interprets the machine code to determine what action to take.
3. **Execute**: The CPU performs the operation (e.g., an addition in the ALU or a data move).

## 📍 Linear vs. Non-Linear Flow
- **Linear**: Instructions are executed one after another (`RIP` is automatically incremented).
- **Non-Linear**: Instructions like `JMP`, `CALL`, and `RET` change the `RIP` to point to a different memory location, redirecting the "flow".

## 🧱 The Code (.text) Section
- Instructions are stored in the **.text section** of a binary.
- This section is marked **Read-Only + Executable**.
- The CPU reads from here but never writes to it.

---

## 🎨 Analogy: The Reading Room
Imagine a library where you are only allowed to read books at a desk:
- **.text section** is the book on the shelf.
- **CPU** is the reader.
- **RIP** is your finger pointing to the current line.
- **Registers** are your post-it notes for quick calculations.
- **The Stack** is your temporary notepad for tracking which chapter you came from.

---
**Related Topics:**
- [[05_Reverse_Engineering/02_Memory_Assembly/Instructions|Instructions]]
- [[05_Reverse_Engineering/01_Foundations/Registers|Registers (RIP)]]