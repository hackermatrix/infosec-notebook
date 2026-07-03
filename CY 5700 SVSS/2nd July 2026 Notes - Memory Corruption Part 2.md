
# Defenses 
Human defenses - do input validation this will defeat run out of bounds. 

hardware defense mechanism. but used by os, enabed/disabled by compiler. 
int i = a + b is not operating system;s business. you cannot intercept something like this. that is why you need hardware support hardware will know this is happening then hardware will tell Os by sending something like interrupt that this happening 

different vendors have different names.

elf file has the information that this executable. os needs to set page tables. 
you need cordination from hardware, compliler and memory management unit. though mmu is the one that executes. 
windows: data execution prevention 
openbsd, mac osx : W ^ X 
which says that code region can be writable or executable never both. 
it doesn't solve the data and control problem it is just a security control. 
# Requirements for basic shellcode injection 
1. run out of bounds. 
2. inject malicious code. - non executable memory this is a technology that allows you to mark certain technology as non-executable this exists in every desktop and server. Everything learnt till last week 
3. overwrite control fields. - what do you mean by this. 
4. Guess important addresses. 

# Workaround - Code Reuse Attack  

Use code that is already executable. like system. 
anything in the exec family. 

e.g. system("/bin/sh") - overflow the buffer. make the cpu think that this is what it was suppose to run. 

for the challenge do system win

analyze the system() inside libc you can easily look at dynamic symbol symbol is a label that points to there is a symbol table which says this function is at this address. 

Spawning a shell 

/bin/sh already exists in libc so you need to give the address from lic.  

bash security feature - when we are launched the real user id is different from setid it says drop it and but launch it through the  user id - this will be in the challenge. 

# Chaining function calls. 

In 64 bit the arguments are passed in the register. 

-fno turns off executable 

readelf - standard utility

base + main_offset 


# Return-oriented programming 

extens the idea of return-to-libc 

# turing complete: by using this technique you can use any exploit. 


Gadgets are tiny code sequences that end with a return. 
<a-single-instruction>
ret 

#How to compose exploits 

1. Identify the gadgets in the program. 
2. Figure out the 

By looking at libc you can have all the gadgets that you want. 

%eax = %eax -1 

Instead of doing everything with return to address you can pair it with return to library. 

# Finding gagdgets 

finding c3 - return address. 

can you existing instructions. 







