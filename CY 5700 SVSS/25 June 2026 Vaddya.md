## Going beyond manipulating the local data in stack frame
![[Pasted image 20260629113331.png]]

Return address and saved ebp are **control.** 
The return address is not instruction but pointer to the instruction. return address tells your cpu where to go next. if you change this you can influence the cpu to jump to a completely different place. 
Saved ebp is not the code pointer either. But by changing this you are changing the mechanism that allows you to access the arguments and local data. like ebp - is the data access and ebp + is the arguments. 
eg. in a function you can change the arguments/local data.
you can trick the saved ebp. (not in the course)

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
![[Pasted image 20260629121910.png]]

##### 1.3.1 Let's Spawn A Basic Shell
1. To get a shell, you need to call `execve("/bin/sh", argv_ptr, env_ptr)`
2. **Since syscalls don't use cdecl (arguments on stack), they use registers instead:**
%eax = 0xb        ← syscall number for execve
%ebx = address of "/bin/sh"
%ecx = address of argv_ptr[]
%edx = address of env_ptr[]


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

shellcode writers use to figure out their own location at runtime.

jmp path        ← 1. jump to the END of shellcode

back:
  popl %esi     ← 3. pop the address! now %esi = address of "/bin/sh"
  ...

path:
  call back     ← 2. call pushes the NEXT instruction's address onto stack
  .ascii "/bin/sh\0"   ← this is what gets pushed!


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
8.  Shellcode
![[Pasted image 20260629102150.png]]

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

- Going beyond memory Bounds 
- Do Something Malicious like :
	- Hijack exec flow 
	- **Hijacking execution flow** means an attacker tricks a computer into running their malicious code instead of the real program
	- Overwrite Sensitive data
	- Overread sensitive data
	- ...........etc
- <mark style="background: #FF5582A6;">**DOING BUFFEROVERFLOW AND JUMPING TO THE SHELLCODE IS NOT THE CORRECT ANSWER TO THIS QUESTION!!!!!!!!!**</mark>

The below is one of the method too. 

![[Pasted image 20260629090851.png]]




