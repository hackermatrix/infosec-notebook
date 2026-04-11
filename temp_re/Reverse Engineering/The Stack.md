## #1 What is the Stack?

The **stack** is just a **chunk of memory** your computer uses to store temporary data while a program runs.

- It is **one continuous piece** of memory.
- A special register called **SP (Stack Pointer)** always points to the **top** of the stack (where the newest item is).
![[Pasted image 20260115160040.png]]
## #2 Push and Pop

The CPU has two built-in actions:

- **PUSH** = Put something on the stack (like adding a plate on a plate stack)
- **POP** = Take something off the stack (remove the top plate)

![[Pasted image 20260115155844.png]]



## #3 Stack Frames

Whenever your program **calls a function**, the CPU creates a new **stack frame**.
- **It is an area for that particular function.**
 
![[Pasted image 20260116190427.png]]

When the function finishes, the frame is **removed (popped)**.

![[Pasted image 20260115173248.png]]

### #4 **FP — Frame Pointer** (also called BP / EBP / local base pointer)

- Points to a **fixed spot inside the current stack frame**.
- **(imp)** Local variables and parameters can be found at **fixed distances** from FP.
- Their location doesn’t change even when the stack grows/shrinks.

That’s why compilers use FP → **less bookkeeping, faster access**.



## \*Note: Whenever a function is called in assembly or low-level code,   the CPU needs to **prepare the stack** and **clean it up**.

### 1. **Prolog = Setup phase**
- This runs **at the start of a function**.
- It usually does 3 things:
	1️⃣ **Save the old frame pointer (FP/EBP)**  
	2️⃣ **Make a new frame pointer for this function**  
	3️⃣ **Move the stack pointer to make room for local variables**
### 2. **Epilog = Cleanup phase**
- This runs **at the end of a function**.
- It does the opposite:
	1️⃣ **Restore the old frame pointer**  
	2️⃣ **Free the local variables**  
	3️⃣ **Return to caller**