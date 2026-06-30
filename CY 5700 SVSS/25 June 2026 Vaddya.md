## Going beyond manipulating the local data in stack frame
![[Pasted image 20260629113331.png]]

Return address and saved ebp are **control.** 
The return address is not instruction but pointer to the instruction. return address tells your cpu where to go next. if you change this you can influence the cpu to jump to a completely different place. 
Saved ebp is not the code pointer either. But by changing this you are changing the mechanism that allows you to access the arguments and local data. like ebp - is the data access and ebp + is the arguments. 
eg. in a function you can change the arguments/local data.
you can trick the saved ebp. (not in the course)

## Syscall 

![[Pasted image 20260629215323.png]]

Now suppose you want to run the syscall open 0x05 will be put in the eax register.  
## Different types of BufferFlow Attacks 

### 1 . Overwriting The Return Address 
- We write the address of a code in the return address that we control (shell-code).
- <mark style="background: #FFB86CA6;">shellcode are raw assembly instructions ( used for mailicious code )</mark>.
- You can put your shell-code almost anywhere in the memory given the following  :
	- **writable area.**
	- **executable area.**
	- **have enough space**
- **Even env vars are presen**t on the stack. So,,,,,, we can have our shell-code in the env variable.  Env var is a user space concept. They are located on the stack. 

![[Pasted image 20260629121811.png]]

#### 1.2 Where to inject the shellcode in the memory ?
1. In the Overflown buffer. overflow the buffer means writing past the written address.
2. <mark style="background: #FFF3A3A6;">Environment Variable.</mark>
3. many other places.


#### 1.3 How to write the shellcode ?
- <mark style="background: #FF5582A6;"> Is it difficult!!!!!!!!!!!!.</mark>  because you're writing raw machine code that has no linker, no libraries, no fixed addresses, and can't contain zero bytes  all constraints that normal assembly programming doesn't have.
- Use a Generator like **Metasploit**.
- Shell code should be a position independent code
![[Pasted image 20260629121910.png]]

##### 1.3.1 Let's Spawn A Basic Shell
1. To get a shell, you need to call `execve("/bin/sh", argv_ptr, env_ptr)`
![[Pasted image 20260629180253.png]]
why is there a null in argv_prt[] cause array don;t know their sizes and syscall says we need to mention seperate sizes for these things. null means end of an array.
why have we mentioned NULL in the env_ptr[] cause we dont want it to take any environments nor the parent environments. 

In the shellcode we need to mention it **as inline data and we need the data bytes"**. means we cannot reference `/bin/sh` from somewhere else in memory  have to **embed it directly inside the shellcode blob itself**

1. **Since syscalls don't use cdecl (arguments on stack), they use registers instead:**
%eax = 0xb        ← syscall number for execve
%ebx = address of "/bin/sh"
%ecx = address of argv_ptr[]
%edx = address of env_ptr[]
![[Pasted image 20260629180529.png]]

There is a huge problem here. 
The above is the **compiler-generated** version of execve. It accesses arguments using `%ebp` as a base — because in a normal function call, `%ebp` is set up properly by the function prologue:
So `0x8(%ebp)`, `0xc(%ebp)`, `0x10(%ebp)` are just offsets from a **known, valid frame pointer**.

###### The problem when this becomes shellcode

When your shellcode gets injected and executed, **there is no function prologue**. The CPU just jumps into your bytes mid-execution. So:

- `%ebp` contains **whatever garbage value it had** from the previous function
- `0x8(%ebp)` now points to some **completely random location** in memory
- That random location has nothing to do with your `/bin/sh` string

"We're taking these instructions and dropping them at a completely different memory address, which has its own stack context, we cannot guarantee `%ebp` maps to anything meaningful there


movl $0xb, %eax

`0xb` in 32-bit (4 bytes) is actually stored in memory as:

```
0x0b 0x00 0x00 0x00
```

Those three trailing zeros are **zero bytes**. and this becomes the problem. When `strcpy` or any string function is copying your shellcode byte by byte into the buffer, it treats every `0x00` as the **end of the string** and stops copying immediately. 

3. And the memory layout you need to set up is:
[ /bin/sh\0 | address | 0x00000000 ]
                ↑            ↑
           argv_ptr       env_ptr
           (points        (NULL = 
           back to        empty env)
           /bin/sh)
		   
4. The New Problem: Address of "/bin/sh"
**the `address` cell in that memory layout needs to point exactly to where `/bin/sh` sits.**
You need the _exact_ address of that string.

5.  The jmp+call Trick: Solving the Address Problem
![[Pasted image 20260630113414.png]]

shellcode writers use to figure out their own location at runtime. This is finding the absolute address relative to the executing instruction.  

jmp path        ← 1. jump to the END of shellcode

**back:**
  popl %esi     ← 3. pop the address! now %esi = address of "/bin/sh"
  ...

path:
  call **back**     ← 2. call pushes the NEXT instruction's address onto stack
  .ascii "/bin/sh\0"   ← this is what gets pushed!

###### How do we know the address of jump, how do we jump to "jump"
Jumps are relative jumps jump from the location (i.e, From wherever you currently are, skip forward 6 pages.) so we dont need to know the address. 

But data access is not done that way. Data access (like `movl 0x8(%esi), %ebx`) needs an actual address in a register to dereference. You can't say "read from 6 bytes forward" the same way the instruction needs a real number sitting in `%esi` to compute from.  

You need position independent code. i.e, executables that can be loaded anywhere in the memory. dynamic libraries can be loaded anywhere in the memory. you want to produce position independent code always. Position independent code, even though the compiler may not it is not allowed to do data access. Shell code should be a position independent code.  In intel 64 you can do relative data access through instructions. You do not need the jmp + call trick. 

6. The strcpy Problem: what if you inject this shellcode via `strcpy`
`strcpy` **stops copying when it hits a `\x00` byte**. But your shellcode has multiple zero bytes — in `movl $0x0`, `movl $0xb`, etc. strcpy would truncate your shellcode mid-copy and you'd get garbage on the stack.

7. Eliminating Zero Bytes 
fix is to rewrite every instruction that produces a `\x00` byte using equivalent zero-free alternatives:
movl $0x0, %eax   ← has zero bytes in encoding
→ replace with:
xorl %eax, %eax   ← XOR register with itself = 0, no zero bytes!

movl $0x1, %eax   ← has zero bytes
→ replace with:
xorl %eax, %eax
inc %eax          ← now eax = 1, still no zero bytes

movl $0xb, %eax   ← 0x0000000b has zeros in encoding
→ replace with:
movb $0xb, %al    ← only write the low byte, avoids the zeros

the `/bin/sh\0` null terminator can't be embedded directly — instead you write it programmatically at runtime using `movb %al, 0x7(%esi)` after you've already XOR'd %eax to zero.
8.  Test Shellcode
This is one of the template of the shellcode. 
![[Pasted image 20260629102150.png]]

###### 8.1  What happens if you display the array outside of main. 

you might have to declare it as global variable, then it will not be allocated on stack it will be allocated in data. 

![[Pasted image 20260630123520.png]]

#### 1.4 How do you find the location of your shell code ?
1. You Guess !!.  We don't know the address of the injected shellcode.
- We basically we use **NOP sleds** . (0x90)
-  A NOP sled is a **single byte** instructionthat does nothing.

> [! Information]
> - You can find the stack location of a program by looking at the memory mapping of the program.
> Mostly present under **/proc** The kernel generates it on the fly to expose information about running processes. Every running process gets its own directory:
> -  The<mark style="background: #ABF7F7A6;"> **int**</mark> instruction means "Hey OS, I want to launch a syscall !!"
> - syscalls do not follow calling conventions. (They have specifications documented online )
> - The **jmp** instructions use relative addresses .
> - <mark style="background: #FF5582A6;">**Always Test you Shellcodes!!!!**</mark>

##### 1.4.1 NOP SLEDS

Nop is used for normal running and padding by the cpu's. 

![[Pasted image 20260629085803.png]]
![[Pasted image 20260629085842.png]]

## What exactly Is Memory Corruption ?

- Going beyond **memory Bounds** 
- Do **Something Malicious** like :
	- **Hijack exec flow** 
	- **Hijacking execution flow** means an attacker tricks a computer into running their malicious code instead of the real program
	- **Overwrite Sensitive data**
	- **Overread sensitive data**
	- ...........etc
- <mark style="background: #FF5582A6;">**DOING BUFFEROVERFLOW AND JUMPING TO THE SHELLCODE IS NOT THE CORRECT ANSWER TO THIS QUESTION!!!!!!!!!**</mark>

The below is one of the method too. 

![[Pasted image 20260629090851.png]]



## space characters as a "data sled"

Just like NOP (`0x90`) is a "do nothing" instruction for code, **space characters (`0x20`)** can act similarly for _data_ like `/bin/sh`.

Here's the trick: if you pad your string with extra spaces:

```
"      /bin/sh\0"
 ^^^^^^
 padding with spaces
```

Then even if your address calculation is slightly off and you land a few bytes early, you still land on a **space character** — which is harmless filler — and as long as your shell parsing or path resolution tolerates leading whitespace, you can still reach `/bin/sh` correctly, or it gets trimmed/ignored.

## Why this works (the NOP sled parallel)

```
NOP sled (code):    [NOP][NOP][NOP][NOP][SHELLCODE]
                     any landing point slides to shellcode

Space "sled" (data): [' '][' '][' '][/][b][i][n]...
                      any landing point near the start
                      still resolves to a valid usable string
```

Both exploit the same principle: **build tolerance into your guess by padding with a "safe" byte**, so a slightly-wrong address guess doesn't break everything.

 whatever data structure you're injecting (a string, a struct, an array of pointers), if you pad it with bytes that are **harmless/neutral for that specific data type**, you build in tolerance for addressing errors — the same defensive trick as the NOP sled, just applied to data instead of code.

Spaces work for shell paths/strings because they're typically trimmed or treated as harmless. For other data types you'd pick a different "neutral" filler byte appropriate to that context.


# Demo 
