### **1. General-Purpose Registers (GPRs)**

- **Purpose:** Hold data and intermediate results for arithmetic, logic, and other operations.
- **Usage:** Can be used by the programmer for calculations.
- **Examples:**
    
    - **Accumulator (ACC):** Often used for arithmetic and logic operations.
    - **Data registers (DX, AX, etc., in x86 architecture):** Store temporary data.
    - **Index registers (SI, DI, etc.):** Used for addressing memory locations.


### **2. Special-Purpose Registers (SPRs)**

- **Purpose:** Used for a specific function inside the CPU.
- **Examples:**
    - **Program Counter (PC) / Instruction Pointer (IP):**    
        - Holds the address of the next instruction to be executed.       
    - **Instruction Register (IR):**    
        - Holds the instruction currently being executed.        
    - **Stack Pointer (SP):**      
        - Points to the top of the stack in memory.        
    - **Base Pointer / Frame Pointer (BP/FP):**
        - Used to reference variables in the current function call.
    - **Status Register / Flags Register:**    
        - Holds condition flags (zero, carry, overflow) and control bits.




### **3. Segment Registers** (mainly in x86 architectures)

- **Purpose:** Hold memory segment addresses for segmented memory access.
- **Examples:** 
	- CS (Code Segment)
	- DS (Data Segment)
	- SS (Stack Segment)
	- ES (Extra Segment).