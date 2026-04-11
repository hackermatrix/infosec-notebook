2## How execution actually works

### 1️⃣ Instructions live in the **.text section**

- `.text` (code section) contains machine instructions
- It is marked **read-only + executable**
- It sits at a fixed virtual memory range

### 2️⃣ The CPU has an **instruction pointer (RIP/EIP)**

- It **reads** instructions from `.text`
- One instruction at a time
- NEVER copies the instruction into the stack
    

Think of `.text` as the chapter of a book the CPU is reading.  
The CPU just **reads** it — doesn't rip the pages out and paste them somewhere else.