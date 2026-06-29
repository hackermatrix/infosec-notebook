

## Different types of BufferFlow Attacks 

### 1 . Overwriting The Return Address 
- We write the address of a code in the return address that we control (shell-code).
- <mark style="background: #FFB86CA6;">shellcode are raw assembly instructions ( used for mailicious code )</mark>.
- You can put your shell-code almost anywhere in the memory given the following  :
	- writable area.
	- executable area.
	- have enough space.
- Even env vars are present on the stack. So,,,,,, we can have our shell-code in the env variable.

#### 1.2 Where to inject the shellcode in the memory ?
1. In the Overflown buffer. overflow the buffer means writing past the written address.
2. <mark style="background: #FFF3A3A6;">Environment Variable.</mark>
3. many other places.

#### 1.3 How to write the shellcode ?
- <mark style="background: #FF5582A6;"> Is it difficult!!!!!!!!!!!!.</mark>
- Use a Generator like **Metasploit**.

##### Let's Spawn A Basic Shell

![[Pasted image 20260629091514.png]]
![[Pasted image 20260629094217.png]]

![[Pasted image 20260629094625.png]]

##### What execve actually needs

execve("/bin/sh", argv_ptr, env_ptr)

- **path** → a pointer to the string `"/bin/sh"`
- **argv** → an _array of pointers_ that represents the command + arguments
- **env** → an _array of pointers_ for environment variables

##### What is argv_ptr[] exactly
/bin/sh         ← that's argv[0]  (the program itself)
                ← argv[1] would be first argument, but there is none

argv_ptr[] = { pointer_to_"/bin/sh",  NULL }
                      argv[0]          argv[1] ← signals "no more args"

The NULL at the end is **required by convention** — it's how the kernel knows where the argument list ends. Without it, it **keeps reading garbage memory looking for more arguments.**

#### Why the NULL in env_ptr[]?

`env_ptr[] = {NULL}` means "empty environment." Just one NULL = an empty but valid array. The kernel needs a valid pointer, not nothing.


![[Pasted image 20260629095023.png]]


#### 1.4 How do you find the location of your shell code ?
1. You Guess !!.  We don't know the address of the injected shellcode.
- We basically we use **NOP sleds** . (0x90)
-  A NOP sled is a **single byte** instructionthat does nothing.

> [! Information]
> - You can find the stack location of a program by looking at the memory mapping of the program.
> Mostly present under **/proc**
> -  The<mark style="background: #ABF7F7A6;"> **int**</mark> instruction means "Hey OS, I want to launch a syscall !!"
> - syscalls do not follow calling conventions. (They have specifications documented online )
> - The **jmp** instructions use relative addresses .
> - <mark style="background: #FF5582A6;">**Always Test you Shellcodes!!!!**</mark>

##### NOP SLEDS

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




