
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


### Privilege drop gone wrong exploit
![[Pasted image 20260621162545.png]]

1. get_nobody is a convention for a user who has acccess to nothing. 
2. strcpy the user input to the char buffer which is a problem because user_input could be 100 and copied into 63 byte char buf. 
3. your setuid bit will be a uid which would be user with less prvilege 
4. so you could argue it is dropping privledge but the system(buf) is anoying now the value of buffer is the strcpy(user_input).


If you can overflow this and then the uid comes before the buffer at a higher address deep in the stack. 

## Demo 

![[Pasted image 20260621184720.png]]

You want to get into this speakeasy code. 

### Look at the source code. 

![[Pasted image 20260621185015.png]]
![[Pasted image 20260621185100.png]]


Everything writes on the variable is_valid 
you see scanf("%s) which means it is string & you write that into buffer. 
strcmp and other things are hardcoded so this tells us that only the is_valid argument is what we 
you overflow the buffer and reach the is_valid argument. 

### Drafting the exploit 
Looking at the code we understand 128 bytes declared that is a start to the payload. 
For junk we will use the A's 

We can see the integers declared 1 and 0. We will use 4 bit of integer 1. because is_valid is an integer that is 4 bytes. 
00 00 00 01
Now thinking about the Little-Endian.
01 00 00 00

scanf does not care about null terminators. 
scanf is a vulnerable. 

https://medium.com/@hritombhattacharya029/why-scanf-function-is-just-like-your-ex-5ceb468585cb

![[Pasted image 20260621195539.png]]

Use python as an array and then print that. 

**What `|` (pipe) does:**

python -c "print('asd')" | ./club

LEFT side          RIGHT side
python generates   ./club receives
output             it as input

**Without pipe — normal way:**

./club
→ program waits
→ YOU type input manually on keyboard
→ press enter
→ scanf reads it


**With pipe — automated way:**
python generates "asd\n"
→ pipe sends it directly to ./club's stdin
→ scanf reads it AS IF you typed it manually
→ no human needed

**Why this matters for exploitation:**
Your payload has non-printable bytes:
b"A" * 128 + b"\x01\x00\x00\x00"

You CANNOT type \x00 on a keyboard!
Keyboard = only printable characters

Python generates ANY byte value
Pipe sends it to program
scanf receives raw bytes

![[Pasted image 20260621200846.png]]

sys          → access system
.stdout      → output channel
.buffer      → raw bytes mode (most important part!)
.write()     → send it

Together = "send these exact raw bytes to output"

python;s program does not use string python 3 print is a unicode we want a ram byte printer not an acii printer that is why use 
sys.stdout.buffer.write("asd") 

![[Pasted image 20260622122742.png]]

Why does this work 

![[Pasted image 20260622125502.png]]

When you write `'asd'` (string):

Python stores it as TEXT
worries about encoding (UTF-8, ASCII etc)
adds extra metadata
not raw bytes

When you write `b'asd'` (bytes):

Python looks up each character in ASCII table:
'a' → 0x61
's' → 0x73
'd' → 0x64

stores exactly: [0x61][0x73][0x64]

![[Pasted image 20260622130007.png]]

### Assumptions when drafting the paylaod
1. When  you request 128 in the buffer , but there is no guarantee that gcc would give you 128. 

#### Reason 1 - Alignment:
CPU reads memory most efficiently in chunks of 4 or 8 bytes
If buffer ends at non-aligned address
GCC adds PADDING bytes to align next variable

char buffer[128]    = 128 bytes
padding             = maybe 4 extra bytes added
int is_valid        = 4 bytes

Real layout might be:
[128 bytes buffer][4 bytes padding][4 bytes is_valid]

#### **Reason 2 — GCC reorders variables:**

```
You wrote:
int is_valid;      ← first
char buffer[128];  ← second

GCC might put on stack:
char buffer[128]   ← first
int is_valid       ← second

OR completely different order!
Compiler optimizes for performance
not for your assumptions
```

#### **Reason 3 — Stack canaries:**

```
GCC security feature adds SECRET VALUE between
buffer and return address:

[buffer][CANARY][saved ebp][return address]

If canary changes → buffer overflow detected → crash
Attacker must know canary value to bypass
```

#### **Reason 4 — Extra space:**

```
GCC sometimes allocates MORE than you asked:
char buffer[128] → GCC gives 144 bytes
                   for alignment purposes
```

## Understanding objdump 

So we can't rely on souce code you need to check disassembly & giving out the correct number. 
![[Pasted image 20260622131228.png]]

objdump is present on every linux ststem  it is used to display detailed information about object files, executables, and shared libraries
https://man7.org/linux/man-pages/man1/objdump.1.html

Why objdump -d ./club & not disas main 
→ disassembles ENTIRE binary at once
→ no need to run program at all
→ see ALL functions together
→ can pipe output, grep, save to file
→ works on binary directly

### Step 1: 
We are only interested in function main 

![[Pasted image 20260622131808.png]]
why do we see the initial instructions before the epilogue i.e, 

`main()` is SPECIAL — it's different from normal functions:

Normal function:
caller controls esp → no alignment needed → straight to prologue

main():
OS controls esp → alignment NOT guaranteed → 
GCC fixes it first → THEN prologue

for practise make an another function and make it vulnerable not main. 

### Step 2: look at the clues from the calling conventions 

### Step 3: abuse the fact ebp is the fixed point in stack. 

Looking at the code use of ebp to access the data. 
![[Pasted image 20260622143315.png]]