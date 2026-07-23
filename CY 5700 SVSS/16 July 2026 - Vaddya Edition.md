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
### Demo
![[Pasted image 20260722212524.png]]

![[Pasted image 20260722212547.png]]

## Analyzing a Native Binary

### Static Analysis 
![[Pasted image 20260722213132.png]]

### Dynamic Analysis
![[Pasted image 20260722213516.png]]
 
![[Pasted image 20260722213716.png]]
## Static Techniques 

### Gathering Information
![[Pasted image 20260722214010.png]]

### Symbols
![[Pasted image 20260722214334.png]]
### Libraries

![[Pasted image 20260722215810.png]]

Example

Suppose a binary contains:

push rbp
mov rbp,rsp
mov rcx,rdx

.loop:
mov al,[rsi]
mov [rdi],al
inc rsi
inc rdi
dec rcx
jne .loop

A fingerprint engine may recognize this as

memcpy


### Disassembly
![[Pasted image 20260722220224.png]]

#### Fixed-length 

![[Pasted image 20260722222441.png]]
- **Examples:** SPARC, MIPS, most ARM (32-bit ARM instructions are always 4 bytes; even Thumb is a fixed 2 or 4 bytes within its own mode).
- **Why it matters for disassembly:** Since every instruction occupies the same number of bytes, a disassembler can simply chop the byte stream into fixed-size chunks and decode each one independently. You can start disassembling from _any_ aligned offset and still land on valid instruction boundaries.

#### Variable-length 

![[Pasted image 20260722222526.png]]

- **Examples:** Intel x86, x86-64 (instructions can range from 1 byte to 15 bytes).
- **Why it matters for disassembly:** Since instruction length depends on opcode, prefixes, ModR/M bytes, displacement, and immediate values, the disassembler must actually **decode** each instruction to know how many bytes it consumed before it can find the start of the next one.
- **Consequence:** This creates real ambiguity problems:
    - **Misaligned disassembly:** If you start decoding at the wrong byte offset (e.g., in the middle of a real instruction), you can get a completely different — but still "valid-looking" — sequence of instructions.
    - **Overlapping instructions:** The same byte can be part of two different valid instructions depending on where decoding starts. Obfuscated or malicious code sometimes exploits this deliberately to confuse disassemblers (a classic anti-analysis trick).
    - This is why disassemblers for x86 often need **control-flow-based (recursive descent) disassembly**
### Two Algos to disassembly (Imp for endterm):
1.  Linear Sweep diassembly 
	- Disassemble linearly until all bytes processed .
	- Start at the beginning of a code section and decode instructions one after another, sequentially, without regard to control flow. 
	- Once you decode an instruction and know its length, you just move to the very next byte and decode again. 
	- Repeat until you reach the end of the section.

```
addr:  decode instruction → get its length L → next addr = addr + L → repeat
```

#### Why it's simple and popular

- No need to trace jumps, calls, or branches, you don't have to understand _what the program does_, just walk through memory.
- Fast and easy to implement.
- Used by tools like the classic `objdump -d` in its basic mode.
1. Recursive decent/traversal disassembly :
	- It follows the control flow of the code .
	- Recursively follow branching code paths.
	- <mark style="background: #FFB86CA6;">Not vulnerable to inline data</mark> 
	- it fails if there is indirect branches (example : jmp %eax )
treat code like a graph, not a sequence of bytes.
### Anti-disassembly
![[Pasted image 20260722223204.png]]

## Dynamic Techniques

### General Information

![[Pasted image 20260722225117.png]]
### Network
![[Pasted image 20260722225218.png]]
### Call Tracing & Debugging
![[Pasted image 20260722225239.png]]

### Breakpoints

![[Pasted image 20260722225715.png]]


### 