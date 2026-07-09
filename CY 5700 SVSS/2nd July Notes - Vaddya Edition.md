
# Memory corruption in the modern world

![[Pasted image 20260708113347.png]]


## Basic requirements for basic shellcode Injection
1. Run out of bounds 
2. inject malicious code - non executable memory this is a technology that allows you to mark certain technology as non-executable this exists in every desktop and server. Everything learnt till last week 
3. overwrite control fields 
4. guess imp addresses

### Overwriting the Control fields"
 control _where execution goes next_ as opposed to just data your program uses for computation.

On the stack, you've got two categories of things:

**Data fields** — local variables, buffers, arguments. If you overflow into these, you can corrupt values the program uses for logic (a flag, a counter, a password check), but you haven't hijacked execution yet.

**Control fields** — things that determine the _flow_ of execution:

- The **saved return address** (the big one — this is what tells the CPU "when this function ends, jump back to here")
- The **saved %ebp** (saved base/frame pointer — used to restore the caller's frame; overwriting this can be used indirectly to corrupt future stack references)
- Function pointers, if any are stored nearby
- In C++, vtable pointers


# Defenses

## Human defenses

![[Pasted image 20260708114011.png]]

![[Pasted image 20260708114614.png]]

## Hardware Defense Mechanism

### 1. Non-Executable Mem:
- Used to mark stack non-executable.
- **Common name:** NX bit or DEP or XD ot XI or XN. (**W^X** in Mac OSX meaning that mem is Writable or Executable not both ). Data area is writable but not executable. Something that is s
- This is implemented on the hardware side( The h/w signals the OS about the event happening).
![[Pasted image 20260708122645.png]]
- So what do we do ????????????????????????????? <mark style="background: #FFB86CA6;">( Use the code that is already executable )</mark>

##  B. Attacks 
### 1. LIBC / The Code Reuse attack - Workaround Non-executable memory
- Use code that is already executable. like system.  anything in the exec family. 
-  execute existing functions with the arguments you choose .e.g. system("/bin/sh") make the cpu think that this is what it was suppose to run. 
- analyze the system() inside libc you can easily look at dynamic symbol symbol that points to there is a symbol table which says this function is at this address. 
![[Pasted image 20260708122835.png]]

>[! Info]
>in bash if the launch UID is different that setuid  bash will drop the setuid  but launch it through the user id </mark>

![[Pasted image 20260708120259.png]]

### System

![[Pasted image 20260708142522.png]]
Once the system opens a shell we are not looking at going back to the previous function. 
#### 1.2 chaining Function call
**Get this part from the recordings as well. **

- In 64 bit systems you can put args in registers.
![[Pasted image 20260708142718.png]]


### 2. Return Oriented Programming 
- Extends the idea of return-to-libc.
	-  Much finer code granularity.
	- Can be turing complete ! ( By this u can write any type of exploit)

#### 2.1 the Idea
- Reuse tiny code chunks.
	- **Gadgets** : code sequences that end with a return.

##### **How to find them ?** :
find /xc3 in executable sections of your code thats the return instruction and go back one address and use that as your gadget but you also may use more instructions if needed.
	- the smaller the gadget the more useful it becomes.
	- ![[Pasted image 20260708155321.png]]

##### How to compose exploits. 
1. Identify the gadget in the target program.
2. Figure out how to sequence those targets to craft your exploit &  how to use them to fulfil your purpose. <mark style="background: #FF5582A6;">(Does not need to be about gettting a shell on the system.)</mark>
3. Attack Payload: Addresses of the gadgets in the order you want them executed. 
4. Inject payload onto the stack: overwrite the saved return address with the address of the first gadget on return, execution becomes chain of gadgets. 

![[Pasted image 20260708164251.png]]
![[Pasted image 20260708164353.png]]

![[Pasted image 20260708164538.png]]

![[Pasted image 20260708164721.png]]
**Gadget 1** — jump to the very first byte (`89`), i.e. normal/aligned decoding:

```
89 50 04        → mov %edx, 0x4(%eax)
a3 40 c3 05 08  → mov %eax, 0x0805c340
83 c4 04        → add $0x4, %esp
5b              → pop %ebx
5d              → pop %ebp
c3              → ret
```

This _is_ one full gadget  it just happens to be a **long** one. It doesn't terminate after the `mov`; execution just keeps flowing byte-by-byte through every subsequent instruction until it finally hits that `c3` at the very end.

![[Pasted image 20260708155924.png]]
![[Pasted image 20260708165111.png]]
![[Pasted image 20260708162503.png]]

> [! Interesting ]
> - gadgets come from the code section of the binary
> - \xc3 is **considered** as return instruction
> - you can find unaligned instructions to get more variety.
> - So if an instruction has a \xc3 in it, even if it is not an return instruction, the CPU thinks its a return address . (This happens because in RISC arch the instruction can be of variable lengths.)
> - We can chain different gadgets to get the same effect as a return. <mark style="background: #FFF3A3A6;">(LOOK MORE INTO THIS !!!!!!)</mark>
> - There are also other instructiosn like **jmp,call,etc**
> - By looking at libc you can have all the gadgets that you want. 
> - Instead of doing everything with return to address you can pair it with return to library. 


#### 2.2 ROP Defenses

![[Pasted image 20260708170731.png]]

Normal function calls follow a strict discipline: `call` **pushes** the return address onto the stack, and later `ret` **pops** that exact same address off. It's a matched pair — every legitimate `ret` corresponds to a `call` that pushed something onto the stack just before it. The stack behaves like a well-formed FIFO/LIFO structure for this purpose: whatever was pushed last for a call is what gets popped first for the matching return.

In a ROP chain, this discipline breaks. You're not calling into gadgets with `call` — you're just landing on them because a previous `ret` jumped there (or because you overflowed the stack and set up fake return addresses yourself). So when gadget 1's `ret` executes, it pops an address that was **never pushed by a corresponding `call`** — it was pushed by your overflow, or it's just the next gadget address sitting in memory from the last `ret`.

So the defense idea is: **maintain a separate record (often called a "shadow stack") of every address a `call` instruction actually pushed.** When a `ret` fires, check: does the address about to be popped match what's on top of the shadow stack? If yes, legitimate return. If no — nothing was ever properly `call`-ed to justify this `ret` — bail out, this is likely a ROP chain.

**Enforce good jump source & targets" — Control Flow Integrity (CFI)**

This is the general/compiler-based version of the same idea, but broader than just `ret`. The idea: at compile time, build a map of every legitimate place a jump/call/return is allowed to go **from** and **to**. For example:

- A `ret` in function `foo()` should only be able to jump back to the specific call sites that called `foo()` — not to some arbitrary gadget address in the middle of another function.
- An indirect `call *%eax` through a function pointer should only be allowed to land on the entry point of a function whose signature matches not on some byte offset three instructions into an unrelated function.
# 3. Overwrite control fields

## A. Defenses:

#### 1. Stack Canaries 
- Add a canary value on stack and before return , if canary is dead, then attack detected .
- This is a **compiler based defense.**
- ![[Pasted image 20260708174814.png]]
![[Pasted image 20260708174502.png]]
- So how do we answer these?:
	- Structure ? - **( Many types of Canaries)**
	- Stored Where ? - **Thread Local Storage.**
	- Generated When ? 
	- Refreshed When ?

- **The answer the above question depends on the compiler devs**

## B. Workaround for Stack Based Canary

### 1. Brute Force :
- Depends on what you are attacking.
- Feasible for instances where you have things like a web server where you have threads or child processes.
### 2. Memory Leak:
- Rebase Code section.
- Canaries only protect the control fields (saved %ebp and the return address), not the rest of your local variables.

Return Address
Saved %ebp
Canary          <-- the tripwire sits HERE
Local Data      <-- everything below this line is unprotected
Stack Top

The canary only sits **between** the local data and the control fields. It says nothing about what happens **within** the local data region itself.

**So a "data-only attack" is:**

If you have a vulnerable buffer and other local variables sitting near it in the same stack frame (say, an `int is_authenticated` flag, or a size variable, or a pointer, declared right after your overflowable buffer), you can overflow _just far enough_ to corrupt those neighboring local variables — **without ever touching the canary at all.**

Example:

c

```c
void check() {
    char buf[64];
    int authenticated = 0;
    gets(buf);          // vulnerable
    if (authenticated) { grant_access(); }
}
```

![[Pasted image 20260708175744.png]]

#### Ways to defeat stack canaries. 

Implementation decisions 
- Structure it is a hexadecimal value it is a random byte.  0xxxxxx0  -  7 bits with 0  with strcpy this gets blocked 
- Stored where? - thread local storage. libc generates the value randomly 
gcc single local cookie per program we have fixed location 
# 4. Guess important addresses

## A. Defenses:

### 1. ASLR ( Address Space Layout Randomization)
- Randomize the addresses and make them difficult to gues.
- **For this to work , PIE(Position Independent Code) is importanta]**

#### 1.2 How Random is it ?
- The OS allocates memory in the form of Pages and each page is around 4KB ( may differ) so the randomiaztion is not greater than that 

- ALL of the section in the mem are randomized independently, but there is no randomization within the sections.

- **The randomization pattern differes based on the arch (x86 and x64) because x64 has a lot more space**