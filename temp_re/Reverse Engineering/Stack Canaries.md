- Stack canaries are a **security mechanism to detect stack-based buffer overflows** before they can be exploited.
- ![[Pasted image 20260122125756.png]]

## How it actually works:

1. **At function entry**
    - The compiler inserts a random value (the _canary_) onto the stack.
    - This value is taken from a global secret (stored at **TLS** (**Thread-Local Storage**)).

> [!NOTE]
>     - Thread-Local Storage is a memory area where each thread gets its own private copy of variables.


        
2. **Before function returns**
    - The compiler inserts a check:
        - Compare the stack canary with the original value.
    - If it **changed** → something overwrote the stack.
        
3. **If mismatch**
    - Program immediately aborts (e.g. `__stack_chk_fail()`).
    - No return → no control-flow hijack.



## Types of Stack Canaries : 

![[Pasted image 20260122130204.png]]


## # How does each these canary work:

#### 1. What is a null canary?
- A **null canary** is a stack canary whose **first byte is `0x00` (NULL)**.

	**Why this works (the idea):**
	- Most classic overflows use **string functions**:
		- `strcpy`
		- `strcat`
		- `gets`
		- `sprintf`
	 - These functions **stop copying at `\0`**.
	 - So the overflow does not reach the return address.


### 2. Terminator Canaries :
- A **terminator canary** is a stack canary made up of **special “terminator” bytes** that commonly end input in C string operations.
- **Examples**:
	- `0x00` → `\0` (string terminator)
	- `0x0A` → `\n` (newline)
	- `0x0D` → `\r` (carriage return)
	- `0xFF` → EOF / invalid char
- 