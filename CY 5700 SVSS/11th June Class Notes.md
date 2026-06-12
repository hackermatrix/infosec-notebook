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

### Machine Code 

CPU

Linux executable format - elf 
Bin

### Instruction Set Architecture 

List of instructions your CPU understands. 
RISC (keep your instructions simple they should do only one thing, these architecutres tend to have seperate memory RAM, ROM, load THIS data from RAM into register, they have many registers available to them ) v.s
CISC(on the other hand goes to complete opposite direction, they do lot of things have lot of side effects. eg, add instruction reads from one and it needs to store . rewrite and give error somewhere else, small number of registers, difficicult to write code for compile for. we are stuck with this)

## Assembly 
is not change in the level of abstraction when you look at binary represnetation of the program and compare with C LEVEL . they are different levels of abstraction 

C makes sense to human 
binary makes sense to 
with assembly  abstraction same as binary  

32 bit version will be taken as reference. 
We will go with the AT&T version of flavor. 

With memory not being represented as single box separation of data and memory is being violated. if you tell the cpu execute the address it goes ahead and executes. 

## Registers 

6 general purpose registers. 





## Confused Deputy 


## CSRF Tokens 


