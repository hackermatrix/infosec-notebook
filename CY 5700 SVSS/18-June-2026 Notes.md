
## Basic Revision 
Per the calling convention before the caller calls the calleee the arguments are pushed in the reverse order in the stack. First argument 2 goes and then argument 1. The hardware is designed like that. 

![[Pasted image 20260621104419.png]]

If you want to reference local data it is ebp - 8. 

## Spot the problem 

![[Pasted image 20260621142220.png]]

![[Pasted image 20260621142804.png]]

### Understanding the problem 

Strings have a null byte. 
char buffer[100]
strcpy(bufffer,msg) 
1. The `strcpy(buffer, msg)` function copies a string from a source variable (`msg`) into a destination variable (`buffer`). 
2. You must include `#include <string.h>` in C or `#include <cstring>` in C++ to use this function.
3. strcpy` copies the `msg` character by character until it hits a null terminator (`\0`), which tells the computer where the string ends. It copies this null terminator as well.
4. msg has to be a string and not a null byte. 

### Difference between a null terminator and row terminator 
![[Pasted image 20260621144123.png]]

In C strings are byte arrays 
they are terminated with the 0 bytes. 
everything other than the 0 byte should be a printable ASCII character. There is no such thing as a non-printable ASCII character. 

### Understanding segmentation fault. 

![[Pasted image 20260621154353.png]]
if you crash something you get segmentation fault 
0x414141 in ?? ()'
Capital A is 0x414141 

why we see the 0x41 in ?? () and what is this function

return address overwritten with 0x41414141
eip tries to jump to 0x41414141
that address doesn't exist
CPU crashes → SIGSEGV
GDB shows ?? () because no real function there


ebp is pointing to 0x41414141.
Why ebp?" 

Yes ebp IS the base pointer. But remember the epilogue order:

asm

```asm
movl %ebp, %esp    ; step 1
popl %ebp          ; step 2 ← HERE is the problem
ret                ; step 3
```

Step 2 — `popl %ebp`:

```
reads whatever is on stack at that moment
that slot was overwritten with 0x41414141
loads 0x41414141 INTO ebp

ebp = 0x41414141 now
ebp is supposed to be base pointer
but now points to garbage
```




Return address is the key. 


Use python as an array and then print that. 

python;s program does not use string python 3 print is a unicode we want a ram byte printer not an acii printer that is why use 
sys.stdout.buffer.write("asd") 

objdump is present on every linux ststem

for practise make an another function and make it vulnerable. 
look at the clues from the calling conventions 
abuse the fact ebp is the fixed point in stack. 


### Privilege drop gone wrong exploit
![[Pasted image 20260621162545.png]]

1. get_nobody is a convention for a user who has acccess to nothing. 
2. strcpy the user input to the char buffer which is a problem because user_input could be 100 and copied into 63 byte char buf. 
3. your setuid bit will be a uid which would be user with less prvilege 
4. so you could argue it is dropping privledge but the system(buf) is anoying now the value of buffer is the strcpy(user_input).


If you can overflow this and then the uid comes before the buffer at a higher address deep in the stack. 