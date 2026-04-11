

## **1. Data Transfer Instructions**

- **Purpose:** Move data between registers, memory, and I/O devices.
    
- **Examples:**
    
    - `MOV`: Move data from one place to another
    - `PUSH` / `POP`: Transfer data to/from the stack
    - `IN` / `OUT`: Input/output to ports
        
- **Use Case:** Copy a value from memory to a register, or push a value onto the stack.
    

---

## **2. Arithmetic Instructions**

- **Purpose:** Perform mathematical operations on data.
- **Examples:**
    
    - `ADD` – Addition
    - `SUB` – Subtraction
    - `MUL` – Multiplication
    - `DIV` – Division
    - `INC` / `DEC` – Increment / Decrement
        
- **Use Case:** Adding two numbers, decreasing a counter, multiplying values.
    

---

## **3. Logical Instructions**

- **Purpose:** Perform bitwise operations or compare values.
- **Examples:**
    
    - `AND` – Logical AND
    - `OR` – Logical OR
    - `XOR` – Exclusive OR
    - `NOT` – One’s complement
    - `CMP` – Compare two values
        
- **Use Case:** Testing flags, masking bits, decision-making.
    

---

## **4. Branch / Control Instructions**

- **Purpose:** Change the sequence of execution based on conditions.
    
- **Types:**
    
    1. **Unconditional Branch**
        - `JMP` – Jump to a specific instruction
            
    2. **Conditional Branch**
        - `JE` / `JZ` – Jump if equal / zero
        - `JNE` / `JNZ` – Jump if not equal / not zero
        - `JG` / `JL` – Jump if greater / less
            
    3. **Call / Return**
        - `CALL` – Jump to subroutine
        - `RET` – Return from subroutine
            
- **Use Case:** Loops, function calls, conditional execution.
    

---

## **5. Input/Output (I/O) Instructions**

- **Purpose:** Communicate with external devices.
- **Examples:**
    - `IN` – Read data from an input device
    - `OUT` – Send data to an output device
        
- **Use Case:** Reading a keyboard input, sending data to a monitor.
    

---

## **6. Stack Instructions**

- **Purpose:** Manage data in the **stack** (LIFO structure).
- **Examples:**
    - `PUSH` – Place value on the stack
    - `POP` – Remove value from the stack
    - `CALL` – Push return address to stack and jump
    - `RET` – Pop return address from stack
        
- **Use Case:** Function calls, storing temporary values.
    

---

## **7. Machine Control Instructions**

- **Purpose:** Control CPU operations or system state.
    
- **Examples:**
    
    - `NOP` – No operation (CPU does nothing)
    - `HLT` – Halt the processor
    - `WAIT` – Wait for an event
        
- **Use Case:** Pausing CPU, debugging, system initialization.
    

---

## **8. Shift and Rotate Instructions**

	- **Purpose:** Move bits left or right; used in arithmetic, logic, and encryption.
- **Examples:**
    
    - `SHL` / `SAL` – Shift left
    - `SHR` – Shift right
    - `ROL` – Rotate left
    - `ROR` – Rotate right
        
- **Use Case:** Multiply/divide by powers of 2, bit manipulation.



## **9. Special Instructions** 
## **1. LEA (Load Effective Address)**

**Purpose:**

- Loads the **address** of a memory location into a register.
- It **does not** access the memory itself; it only computes the address.
- Commonly used for pointer arithmetic or calculating offsets.
    

**Syntax (x86 assembly):**
`LEA destination_register, [memory_expression]`

**Example:**  `LEA EAX, [EBX + 4*ECX + 8]`
- Here, `EAX` will get the value `EBX + 4*ECX + 8`
- **Important:** It does **not** read the memory at that address. Only the address calculation happens.


## **2. TEST**

**Purpose:**
- Performs a **bitwise AND** between two operands.
- Sets CPU **flags** (like Zero Flag, Sign Flag) based on the result, but **does not store the result**.
- Essentially used to check bits without changing the values.
    
**Syntax (x86 assembly):**

`TEST operand1, operand2`

**Example:**

`TEST EAX, 1`

- This checks if the **least significant bit** of `EAX` is set.
- Flags affected:
	    - **ZF = 1** if result is 0 (bit not set)
    - **ZF = 0** if result is non-zero (bit is set)