RESOURCES : "Engineering a Safer World" by Nancy Leveson, MIT
# Systems Safety (IMPORTANT)

**Accident Analysis** : Done Post Incident 
**Accident Modelling** : Predict what could go wrong 


### Acccident Modeling :
- Was done based on Event Chains and Direct causality.
- We drew linear event chain illustrations based on Event that could happen and impact they could cause.
- We then, try to break the chain. So that the remaining chain of events does not happen.


### Accident Analysis:
- You build someting , it breaks and then you analyse the root cause and check why did this happend.
- We call this Root Cause analysis.



### Problems with RCA :
- World is not a Linear Chain of Events.
- Other factors matter too.
- In majority cases the Root cause would always be Human error **(Human error - > bad System Design !).**
- These event chains ignore **systemic factors** .



# Look online : Three Mile Island Accident 






## The New Model !!

- WE SHIFT to <mark style="background: #FFB86CA6;">SYSTEMS THEORY from  RELIABILITY THEORY</mark>.

- Systems Have emergent properties that only appear when system is analyzed as whole ( Not when we follow divide and concoure )
- <mark style="background: #FF5582A6;">Safety is an emergent property of a complex system.</mark> (IMPORTANT !!!!!!!!!!!!!!!!)




## STAMP
- Systems Theoritic Accident Model and Process .





# Reverse Engineering 

- The process of analyzing a system to create representations of that system at a higher level of abstraction.
- Process of analyzing a system to understand the structure, behavior, functionality semantics
- **Binary to Assembly is not reversing** 
-

- 
![[Pasted image 20260721203842.png]]

Extracting code from the binary 
Extracting data from the binary 
Recover semantics from the binary 
Recover control flow from the binary 
The compiler may also add some padding code that

- We can use Prologues and Epilogues as indicators to find function blocks.( Only if No optimization are applied by the Compiler)

## Decompilation Is Harder

![[Pasted image 20260721212422.png]]
### Demo 

#### Source Code 

![[Pasted image 20260721212452.png]]
#### gcc -O0 (unoptimized) 

![[Pasted image 20260721212616.png]]

Compiles almost literally, mirroring the C:

- `push %ebp` / `mov %esp,%ebp` — function prologue (standard stack frame setup).
- `call __x86.get_pc_thunk.ax` / `add $0x1aeb,%eax` — position-independent code boilerplate, unrelated to the actual logic.
- `cmpl $0x0,0x8(%ebp)` — compares `n` (at `%ebp+8`) to 0. This _is_ `if (n > 0)`.
- `jle 525 <abs+0x18>` — jump to else-branch if `n <= 0`.
- `mov 0x8(%ebp),%eax` then `jmp` — the `return n;` path: load `n` into return register, skip the else.
- `mov 0x8(%ebp),%eax` then `neg %eax` — the `return -n;` path: load `n`, negate it.
- `pop %ebp` / `ret` — epilogue/return.

The `if/else` structure is clearly visible here — you can basically read the source logic back out of the assembly.

####  gcc -O3 (fully optimized)
![[Pasted image 20260721212709.png]]
Same function, but the compiler replaced the branch with a **branchless bit trick**:

- `mov 0x4(%esp),%eax` — load `n`.
- `cltd` — sign-extends `%eax` into `%edx:%eax`: if `n` is positive, `%edx = 0`; if negative, `%edx = 0xFFFFFFFF` (-1).
- `xor %edx,%eax` — no-op if `n` positive; flips all bits of `n` if negative.
- `sub %edx,%eax` — no-op if `n` positive; subtracting -1 = adding 1 if negative.
- Together, for negative `n`: flip bits then add 1 = two's-complement negation = `-n`. For positive `n`: both steps do nothing.
- `xchg %ax,%ax` lines are just padding/alignment NOPs, not real logic.


Both versions compute the exact same result (same _semantics_), but at `-O3` **the `if/else` is completely gone** — no comparison, no jump, no visible branching at all. If you're trying to reverse-engineer this binary back to source, at `-O0` it's easy (structure preserved), but at `-O3` you'd need to recognize `cltd`/`xor`/`sub` as an "absolute value" idiom with zero structural hints that an if/else ever existed.

This is exactly the "compilers optimize the crap out of your code" line from the deck optimization destroys the high-level structure that a decompiler would otherwise rely on, which is why decompilation is unreliable and much harder than disassembly.
## Bytecode :
- An intermediate code before the actual assembly.
- For example : Java.
- The Bytecode is much more structured than machine code .
- So, if you have bytecode instead, the reversing task become a lot easier.


```
Java source  →  Bytecode  →  (interpreted or JIT-compiled to machine code at runtime)
```

Here, the compiler stops at an intermediate representation (bytecode) instead of going straight to native machine code. That bytecode then either:

- gets interpreted by a virtual machine (JVM for Java, CLR for .NET), or
- gets dynamically translated to machine code at runtime (JIT compilation).
- ==**bytecode can be used for C**==, but it is not how the language traditionally operates. By default, C is a fully compiled language, meaning a compiler like GCC or Clang translates C source code directly into native machine code (binary) for a specific hardware processor.
- However, you can compile C into bytecode by routing it through alternative tools, compilers, and virtual machines. 

## Distributed With Source Code

![[Pasted image 20260721214455.png]]
### How to protect this 
![[Pasted image 20260721214923.png]]
Transform the code and make it difficult to read.
1.  **Confusing and deceptive names for identifiers**. - Instead of `calculatePassword()`, you get `a1()` or `xK9z()`.
- Or worse — deliberately misleading names, like naming a decryption function `printLogo()` to throw reversers off.

1. **Syntax tricks** : instead of `if (x > 0)`, write some tangled nested ternary/ bitwise expression that produces the same result but takes way longer to parse mentally.
2. **Control flow redirections:** - Add fake branches that are never actually taken.
- Break a simple function into a scattered mess of jumps back and forth, so tracing "what happens next" becomes a nightmare — even though the real logic is simple underneath.
3. **Compression, encoding, encryptio**n: Hide the actual code/data by packing or scrambling it, then unpack/decrypt it only at runtime.
![[Pasted image 20260721215310.png]]

## Demo 

### Two Algos to disassembly (Imp for endterm):
1.  Linear Sweep diassembly 
	- Disassemble linearly until all bytes processed .
	- <mark style="background: #FFB86CA6;">vulnerable to inline data </mark> (check the recording time : 8:28 PM)
2. Recursive decent/traversal disassembly :
	- It follows the control flow of the code .
	- Recursively follow branching code paths.
	- <mark style="background: #FFB86CA6;">Not vulnerable to inline data</mark> 
	- it fails if there is indirect branches (example : jmp %eax )