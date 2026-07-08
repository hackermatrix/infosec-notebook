
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
### 1. The Code Reuse attack - Workaround Non-executable memory
- Use code that is already executable. like system.  anything in the exec family. 
-  execute existing functions with the arguments you choose .e.g. system("/bin/sh") make the cpu think that this is what it was suppose to run. 
- analyze the system() inside libc you can easily look at dynamic symbol symbol that points to there is a symbol table which says this function is at this address. 
![[Pasted image 20260708122835.png]]

>[! Info]
>in bash if the launch UID is different that setuid  bash will drop the setuid  but launch it through the user id </mark>

![[Pasted image 20260708120259.png]]


#### 1.2 chaining Function call
**Get this part from the recordings as well. **

- In 64 bit systems you can put args in registers.


### 2. Return Oriented Programming 
- Extends the idea of return-to-libc.
	-  Much finer code granularity.
	- Can be turing complete ! ( By this u can write any type of exploit)

#### 2.1 the Idea
- Reuse tiny code chunks.
	- **Gadgets** : code sequences that end with a return.
	- **How to find them ?** : find /xc3 in executable sections of your code thats the return instruction and go back one address and use that as your gadget but you also may use more instructions if needed.( Look at the Finding Gadgets slide).
- chain them together to compose exploit.
- Sooooo the steps are :
	1. Identify the Gadgets from the Code.
	2. Figure out how to use them to fulfil your purpose. <mark style="background: #FF5582A6;">(Does not need to be about gettting a shell on the system.)</mark>


> [! Interesting ]
> - \xc3 is **considered** as return instruction
> - you can find unaligned instructions to get more variety.
> - So if an instruction has a \xc3 in it, even if it is not an return instruction, the CPU thinks its a return address . (This happens because in RISC arch the instruction can be of variable lengths.)
> - We can chain different gadgets to get the same effect as a return. <mark style="background: #FFF3A3A6;">(LOOK MORE INTO THIS !!!!!!)</mark>
> - There are also other instructiosn like **jmp,call,etc**


# 3. Overwrite control fields

## A. Defenses:

#### 1. Stack Canaries 
- Add a canary value on stack and before return , if canary is dead, then attack detected .
- This is a compiler based defense.

- So how do we answer these?:
	- Structure ? - **( Many types of Canaries)**
	- Stored Where ? - **Thread Local Storage.**
	- Generated When ? 
	- Refreshed When ?

- **The answer the above question depends on the compiler devs**

## B. Attacks 

### 1. Brute Force :
- Depends on what you are attacking.
- Feasible for instances where you have things like a web server where you have threads or child processes.

### 2. Memory Leak:
- Rebase Code section.
- try reading up on this (incomplete info)



# 4. Guess important addresses


## A. Defenses:

### 1. ASLR ( Address Space Layout Randomization)
- Randomize the addresses and make them difficult to gues.
- **For this to work , PIE(Position Independent Code) is importanta]**

#### 1.2 How Random is it ?
- The OS allocates memory in the form of Pages and each page is around 4KB ( may differ) so the randomiaztion is not greater than that 

- ALL of the section in the mem are randomized independently, but there is no randomization within the sections.

- **The randomization pattern differes based on the arch (x86 and x64) because x64 has a lot more space**