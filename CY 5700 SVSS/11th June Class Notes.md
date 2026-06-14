Midterm: Until the end of lecture, Challenge 4, piazza. 
don't memorize syntax 
look at design 
look at snippet of the code - if you know the language 
abstract and theory questions. 
no more than 90 minutes 

Why not use encryption mechanism to protect proxies. 
Suppose the web-origin is encrypted. 
Proxy and the origin need to share keys. 
Data is encrypted on the cache 
it gets decrypted when it reaches you. 
even with all of this attacker is just a normal user you can;t really 
By encrypting it you are making content unique for each user and defying the purpose of cache. 

## HTTP Parameter Pollution 

What happens if you send multiple parameters with the exact same name in an HTTP request? 

www.example.com/login?id=kaan&id=bob

Behaviour depends on implementation!

This applies to everything that takes parameters

Real Example: Blogger 

If you standardized parsing you will still need to understand that it is not your own code. You may not have much control since this is not your third party system. 

Make your error messages consistent. 

Side Channel Attack - A More Subtle Example. 

## Three Modern Mechanisms 

### Content Security Policy (CSP)
With ## Content Security Policy (CSP) you are making the SOP stricter. 
SOP
**Same Origin Policy is important** 

### Cross-Origin Resource Sharing (CORS)

Read about AJAX request 

preppolite request 

IF YOU want to relax the same origin policy use CORS if you want to strengthen the same origin policy you can use CSP. 
What should be allowed should come from server configuration. 

One request Origin: https:// - this does not complete the request 

This completes the request. 

Access-Control-Allow-Origin : t

## Can be asked in exam.  
CORS is not a security technology it makes it more vulnerable. It is an excellent example of **security architecture one is least privilege**. This is clever example of least privilege. 

## Sub resource Integrity (SRI)

It is not in use so much cause it is operationally not feasible. 
you see this only cause if you go with the most cheapest not something like Amazon or Azure. 

## Browser Extensions

## Question on mid term design on extension ask you security question 

It is different from the browser plugin. 

Extension is designed to scan the website you are looking at like phone number which makes it clickable. 
you're entire website can be untrusted input to the extension which increases the attack surface. 
make sur 

What if the extension has a bug in it. 

## Memory Corruption 

Low-Level Essentials 

Will come into mid-term expect one point from midterm.

Computer Architecture. 
Intructution set Architecture. 
Memory Organization. 
Compilers. 
Assembly 
More C. 
More Linux 

### Basics Revision  

**Machine code** (or machine language) is the fundamental, lowest-level programming language directly understood by a computer's CPU. Composed entirely of binary digits (0s and 1s).



https://stackoverflow.com/questions/466790/assembly-code-vs-machine-code-vs-object-code

![[Pasted image 20260614140903.png]]

Linux executable format - elf 
.Bin a generic binary file that stores raw data (0s and 1s)
### Instruction Set Architecture 

![[Pasted image 20260614141605.png]]
List of instructions your CPU understands. 
RISC (keep your instructions simple they should do only one thing, these architectures tend to have separate memory RAM, ROM, load THIS data from RAM into register, they have many registers available to them ) v.s
CISC(on the other hand goes to complete opposite direction, they do lot of things have lot of side effects. eg, add instruction reads from one and it needs to store . rewrite and give error somewhere else, small number of registers, difficult to write code for compile for. we are stuck with this)

Anything that comes from Intel is CISC.

![[Pasted image 20260614142051.png]]

## Assembly 

**Assembly code** is plain text and (somewhat) human-readable source code with a mostly-direct 1:1 relationship to machine instructions. This is accomplished using mnemonics for the actual instructions, registers, or other resources. Examples include `JMP` and `MULT` for the CPU's jump and multiplication instructions. Unlike machine code, the CPU does not understand assembly code. You convert assembly code to machine code with the use of an **assembler** or a **compiler**,

![[Pasted image 20260614142318.png]]

32 bit version will be taken as reference. 
We will go with the AT&T version of flavor. 

https://gist.github.com/youkaichao/9fe03d94839886c74acc847d82b57b66


## Von Neumann Architecture

![[Pasted image 20260614142726.png]]


With memory not being represented as single box separation of data and memory is being violated. 
There's no hardware enforcement separating "this region is code" from "this region is data." The CPU doesn't inherently know it just fetches whatever address `%eip` (the program counter) points to and executes it.
Exploited through buffer overflow.

![[Pasted image 20260614143038.png]]

https://www.geeksforgeeks.org/computer-organization-architecture/different-instruction-cycles/

## Registers 

6 general purpose registers. 

![[Pasted image 20260614151004.png]]

Compilers need to think about allocation of registers. 

Google "x86 cheatsheet"

## Operands 

% you are accessing the contents of the registers 
$2500 is a number 
no dollar just integer this is a pointers. Memory address: 2500 
suppose you don;t want to hardcode it this is how you go it 
 res

displacement(base_reg,index_reg, scale)
result = base + displacement + (index *scale)

## Comparison and Branch 
jmp 
call 
if you want to jump to a function you want to return to the function to enable that to remember we have a call function it takes the address of the return address and pushes to the stack. it looks at the return address and jumps back to it. and 

## End-ianess 

you can;t access address 0 , if you do it will throw an error. 

local function like main will be in the stack, malloc will be in heap

## Confused Deputy 


## CSRF Tokens 


