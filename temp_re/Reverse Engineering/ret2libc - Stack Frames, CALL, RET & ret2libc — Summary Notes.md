
### 📍 How Function Calls Work (x86)

1. **CALL instruction**
    - Pushes the address of the next instruction (return address) onto the stack
    - Jumps to function
        
2. **Function Prologue**
    ```
    push ebp 
    mov ebp, esp 
    sub esp, <locals>
    ```
    Creates a new **stack frame**
    
3. **Stack layout inside function foo**
    
    ```
    [ebp+8]   arg2 
    [ebp+4]   return address   ← address pushed by CALL 
    [ebp]     old EBP 
    [ebp-..]  local variables
    ```
    
    
4. **Function Epilogue**
    
    ```
    mov esp, ebp 
    pop ebp 
    ret
    ```

---

### 🎯 Where the Return Address Actually Lives

- Return address lives at the **top of the stack at the time of RET**
- Humans and debuggers refer to `EBP+4` because EBP is stable and makes addressing easier
- **The CPU does not care about EBP**
- **RET only does this:**
    
    ```
    POP into EIP      (jump target) 
    ESP += 4
    ```
📌 Key Point:

> **Return address appears to be at $ebp+4 only because of calling conventions.  
> RET consumes whatever is on top of the stack — wherever ESP points.**

---
### 🔥 ret2libc Strategy (no shellcode needed)

Goal:  
Hijack control flow and call library functions like:

`system("/bin/sh") exit()`

We overflow a buffer and overwrite:

```
return address of current function → system() next stack word → exit() (system’s return address) next stack word → pointer to "/bin/sh" (system’s argument)
```

Stack after overflow:

```
[ebp+4]   system()       ← foo returns here 
[ebp+8]   exit()         ← system returns here 
[ebp+12]  "/bin/sh"
```

---

### 🚀 Execution Flow During ret2libc

1. **foo() RET executes**
    ```
    RET pops system() into EIP 
    ESP now points to exit()
    ```
    
2. **system() runs**
    - It receives its argument from the already‑prepared stack
    - It did not push any return address itself
        
3. **system() RET executes** 
    ```
    RET pops exit() into EIP ESP now points at "/bin/sh"
    ```
    
4. **exit() runs cleanly**
    - No crash
    - Program terminates normally
---

### 🔍 Why `$ebp+8` Happens to Store exit(), not the return address

Because after foo RETs:

`ESP == EBP+8`

So from **system’s point of view**, the return address is  
whatever is at the top of the stack, not necessarily `$ebp+4`.

---

### 💡 Critical Insights

- CPU never references `EBP+anything`
- **Stack frames are a debugging convenience**
- **ESP is the real execution point**
- ret2libc tricks the stack into looking like:

    `foo ret → system ret → exit`
    

---

### ⚙️ Why system("/bin/sh") Works

You supply:

- system() function address    
- A valid return address (exit)
- The argument string (`/bin/sh`) in memory

No need to inject shellcode — just reuse libc code already loaded into memory.

---

### 🚫 Why It Only Works With Protections Off

Modern systems protect against this with:

- **ASLR** (randomizes addresses)
- **DEP / NX** (non-executable stack)
- **Stack canaries**
- **PIE executables**
- **Fortified libraries**

Turning them off recreates the classic unsafe environment.

---

### 🎉 TL;DR

`EBP-based addressing = debugging convention RET-based control flow = hardware reality ret2libc = overflow return address → system() → exit()`