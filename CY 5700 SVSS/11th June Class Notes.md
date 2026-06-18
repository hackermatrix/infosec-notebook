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

# Classic Web Security
## HTTP Parameter Pollution 

What happens if you send multiple parameters with the exact same name in an HTTP request? 

www.example.com/login?id=kaan&id=bob

You keep supplying parameters that makes sense. Server passes the string. 

Behaviour depends on implementation!, you application can be a monolithic architecture where different components process the string parameters different. This applies to everything that takes parameters

### Real Example: Blogger 
![[Pasted image 20260617044335.png]]
What you did here is supply two ids yours (attacker) and the victim's id. ofcourse it will ask you for credentials so give your token. You send this to the server, the server authenticates you (attacker), it looks at your token. 

For authorization privileges the server looks at the second one. is this person making the request have privileges and authorized to this blog (checks the access control list). This allows you to take over somebody else's blog. 

Why it looks at different parameters for different actions like authentication and authorization nobody knows. 

Suppose you are a developer and in you company 

If you standardized parsing (you do that if you are writing the entire tech stack) you will still need to understand that these issues do not come from your own code. E.g. it might come from nginx or flask an open source web application framework. You may not have much control since this is not your third party system. Testing it is the only option. 

## Improper error handling 

![[Pasted image 20260617045916.png]]
Example, you send a bad request to a server & it gives 500 something error. But it dumps you will lot of information you had no business seeing. 

![[Pasted image 20260617050617.png]]
it gives you source code and stack trace. With flask if you don;t configure it properly it would give a 500 error and shell access which was a default behaviour.

![[Pasted image 20260617051311.png]]

If the error says  just wrong username or password it gives a hint. 
Suppose you have a list of usernames and suppose a bad actor finds a leaked database or something they can just use a password spray attack. 
**Username enumeration** (or account enumeration) is a reconnaissance technique used to discover valid usernames or email addresses within a system.

Couple of years back staples.com used to have this problem. if you care about this kind of information leakage you should think about. **Make your error messages consistent.** This is the very definition of 

### **Side Channel Attack

Here you are not doing access control , you are not logging into somebody;s account. check but you are measuring some side effects inside the application which gives you different error codes. 

### Example: Gmail 
![[Pasted image 20260617052613.png]]
if you type something wrong 
![[Pasted image 20260617052647.png]]

it will only let you in if you type something that exists 

![[Pasted image 20260617052721.png]]

Here the user interface is designed in such manner. Now everyone majorly have a gmail account so the information leak part does not matter. This is for user experience user might not know what is wrong username is wrong or password is wrong. In this case they will call up the customer support which is not economically feasible for companies

## Three Modern Mechanisms 

### Content Security Policy (CSP)

![[Pasted image 20260617055029.png]]


CSP is implemented in the response header that you return from the server. You know your application needs to be secure. You configure your application or server to return this header. The value of the header is a complex syntax. In that language you can see a script that mentions I want to include these origins. I want image tags, videos frames from these origins. If you don;t want any cross-communication origin at all you can simply say that.  

**`script-src 'self'**` Content Security Policy (CSP) directive, it tells the browser to only execute JavaScript files that are hosted on your own domain. 

If you see something **`img-src 'self'`** (note that it uses **`img-src`**, not `image-src`) is a Content Security Policy (CSP) directive that **restricts the browser to only load images originating from the exact same domain, protocol, and port** as the hosted website.

With Content Security Policy (CSP) you are making the SOP stricter. The problem is if you go to strict you may break the application.  cross-origin interactions can cause or facilitate Denial of Service (DoS) attacks.

### Cross-Origin Resource Sharing (CORS)
![[Pasted image 20260617061317.png]]
An **AJAX request** is a web development technique that allows a web page to send or retrieve data from a server in the background without refreshing the entire page.

In this case your browser is not going to immediately block it. 
![[Pasted image 20260617061642.png]]


Preflight request.  https://developer.mozilla.org/en-US/docs/Glossary/Preflight_request

**IF YOU want to relax the same origin policy use CORS if you want to strengthen the same origin policy you can use CSP.** 

**CORS and CSP enforcement comes from the browser.** **But the specification comes from the application owners.** **What should be allowed should come from server configuration.** 

![[Pasted image 20260617062315.png]]


One request Origin: https:// - this does not complete the request 

This completes the request. 

Access-Control-Allow-Origin : t


![[Pasted image 20260618054440.png]]
https://medium.com/@apmaduwantha/cors-vs-csp-a-practical-developer-focused-guide-to-web-security-6d056566c96c

## Can be asked in exam.  
CORS is not a security technology it makes it more vulnerable. It is an excellent example of **security architecture one is least privilege**. This is clever example of least privilege. Because different origins cannot interact with each other. So you use CORS to keep the same origin policy 

## Sub resource Integrity (SRI)

![[Pasted image 20260617063344.png]]
![[Pasted image 20260617064109.png]]


It computes the hash on your computer inside the browser & sees if it matches if it doesn;t match it blocks the content. You will need to track changes. 

It is not in use so much cause it is operationally not feasible. 
you see this only cause if you go with the most cheapest not something like Amazon or Azure. 

## Browser Extensions

### Difference between plugin and extension 
**Plugin** = a **native binary program** that runs on your computer. It's basically a separate application that the browser hands off certain content to.

Examples:

- Adobe Flash → browser says "this is a Flash file, Flash player handle it"
- Java applets → browser hands it to your Java installation
- Widevine → handles DRM encrypted video (Netflix etc.)

They're compiled code (`.exe`, `.dll` type stuff), run outside the browser's JavaScript sandbox, have deep system access.

**Extension** = code (mostly JavaScript) that runs **within the browser's own architecture**. It's not a separate program, it lives inside the browser.

Examples:

- uBlock Origin (ad blocker)
- LastPass (password manager)
- Grammarly

![[Pasted image 20260617144454.png]]
![[Pasted image 20260617144548.png]]
![[Pasted image 20260617144957.png]]
### **1. Code injection — Extension calls eval() with parts of HTML**

Remember from the slides `eval()` is called "the greatest evil" — it takes a **string and executes it as code**.

So if an extension does something like:
eval(document.getElementById("someDiv").innerHTML)

An attacker can put malicious code inside that div on their webpage, and the extension will **execute it with extension-level privileges** — way more powerful than normal webpage JS.

### 2. Replacing native APIs — Script redefines DOM APIs and confuses extension

JavaScript lets you **overwrite built-in functions**. So a malicious website could do:

javascript

```javascript
document.cookie = function() {
    sendToAttacker(arguments);  // steal data first
    return originalCookie;       // then behave normally
}
```

Your extension comes along and calls `document.cookie` thinking it's talking to the **real browser API** — but it's actually calling the **attacker's fake version**.

The extension never knew it was swapped. It gets the right answer back so it doesn't suspect anything. Meanwhile the attacker got the data.

### 3. Capability leaks — Extension leaks privileged objects to website**

Extensions have special powers normal webpages don't — like reading your bookmarks, history, filesystem etc.

If an extension accidentally **exposes those privileged objects** to the webpage:

javascript

```javascript
// Extension accidentally makes this accessible to the page
window.extensionAPI = this.privilegedObject
```

Now any website can grab `window.extensionAPI` and use those extension-level powers — powers they were never supposed to have.


### **4. Mixed content — Extension injects HTTP script into HTTPS page**

You're on `https://bank.com` — fully encrypted, secure connection.

But your extension injects:

html

```html
<script src="http://somesite.com/script.js"></script>
```

That script loads over **plain HTTP** — unencrypted, can be intercepted and tampered with by a man-in-the-middle attacker. The whole security of HTTPS is now undermined because the extension punched a hole in it.

### **XPCOM Framework:**
![[Pasted image 20260617145738.png]]

XPCOM = Cross Platform Component Object Model

Think of it as a **set of tools/APIs** Firefox gave to extensions that allowed them to do basically anything the browser itself could do:

```
Normal webpage JS can do:    Extension with XPCOM could do:
─────────────────────────    ──────────────────────────────
Read DOM                     Read DOM
Make HTTP requests           Make HTTP requests
                             + Read your filesystem
                             + Access bookmarks/history
                             + Intercept ALL HTTP traffic
                             + Modify browser UI itself
                             + Run native code
```

So it was essentially giving extensions **root-level browser access** with no restrictions. That's the problem — way too much power given by default.

![[Pasted image 20260617145834.png]]
In JavaScript, namespace is much simpler — it just means the **shared memory space where all variables and functions live**.

// Extension A writes on the whiteboard:
var userPassword = "abc123"
function getPasswords() { ... }

// Extension B can just... read it:
console.log(userPassword)  // "abc123" — oops!

// Extension B can even overwrite it:
getPasswords = function() { sendToAttacker() }

## CrossFire
![[Pasted image 20260617145922.png]]

 This diagram shows how a malicious extension M abuses the shared namespace + XPCOM to attack your computer. Let me walk through each step:

---

**The players:**

- **Extension M** = malicious extension (has the skull)
- **Extension X** = a legitimate extension that has **download capability** (like a download manager)
- **Extension Y** = a legitimate extension that has **execute capability** (like a file launcher)
- **XPCOM** = the powerful framework giving access to everything

---

**Step by step:**

**Step 1 — M tells X to download:**

```
M → X: "hey use your download capability 
        to grab this .exe from the internet"
```

M itself might not have download permission, but X does. Because of shared namespace, M can just **call X's functions directly**.

**Step 2 — X uses XPCOM to access internet:**

```
X → XPCOM → Internet
```

X has legitimate internet access through XPCOM, so this works fine, no suspicion.

**Step 3 — .exe gets saved to filesystem:**

```
Internet → .exe file → Filesystem
```

The malicious executable is now sitting on your computer.

**Step 4 — M tells Y to execute:**

```
M → Y: "hey use your execute capability 
        to run this file I just downloaded"
```

Again M borrows Y's capability through shared namespace.

**Step 5 — Y uses XPCOM to run the file:**

```
Y → XPCOM → Filesystem → runs .exe
```

Malware is now executing on your machine.

---

**The key insight:**

M never directly downloaded or executed anything — it **borrowed legitimate capabilities from X and Y** through the shared namespace. So if anyone was watching:

- X did the download — X is a trusted extension, looks fine
- Y did the execution — Y is a trusted extension, looks fine
- M just quietly orchestrated everything behind the scenes

This is exactly the **confused deputy problem** from the slides applied to extensions — X and Y were legitimate deputies that got confused into doing M's dirty work.

Let us say you installed some extension on the browser & the extension has a bug or vulnerability in it. Anything you visit on the browser becomes a vulnerable input. Most of the browser extensions are designed to scan the websites you visit. E.g, you scan the website you are looking at like phone number which makes it clickable. you're entire website can be untrusted input to the extension which increases the attack surface. 
Question on mid term  on extension ask you security design question 



# Memory Corruption 

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
It is an abstraction because it give you list of things your cpu can implement, But it does not tell you how they implement. 
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

An accumulator register is a high-speed temporary storage location inside a computer's CPU. Its primary job is to hold the intermediate results of ongoing arithmetic and logic operations (like adding numbers or comparing values) so the CPU doesn't have to keep accessing slower main memory.

A loop counter in a register is a dedicated hardware mechanism or standard software usage that tracks the number of times a block of code (a loop) repeats.

![[Pasted image 20260614151004.png]]

![[Pasted image 20260614161736.png]]

![[Pasted image 20260614162058.png]]

Compilers need to think about allocation of registers. 

ebp's role is to stay put and never move. To point to the location in previous stack frame. 



![[Pasted image 20260614161620.png]]

![[Pasted image 20260614162300.png]]

## Operands 

**% - Register operand**
 you are accessing the contents of the registers. % eax
 
**$ Immediate** 
$2500 is a number. 
A literal hardcoded number. The `$` means "the value 2500 itself." No memory involved, no dereferencing.

**`2500` — Memory address**  
No `$`, no `%`  this is a pointer, exactly as you said. It means "go to address 2500 in memory and read what's there." Like dereferencing in C: `*(2500)`. Hardcoded address  rarely useful in real code.

displacement(base_reg,index_reg, scale)
address = base_reg + displacement + (index_reg * scale)

## Operand Size 

![[Pasted image 20260615142312.png]]

![[Pasted image 20260615143229.png]]
This is the pointer/dereference distinction:

movl $100, %eax   →   eax = 100        (immediate, just the number)
movl 100, %eax    →   eax = *(100)     (go to address 100, read 4 bytes from there)
movl %eax, 100       →   *(100) = eax    write eax's value TO address 100
movl %eax, (%ebx)    →   *(ebx) = eax    write eax's value TO address stored in ebx

![[Pasted image 20260615170253.png]]

Push tells you what am i pushing on top of my stack. 
## Comparison and Branch 

![[Pasted image 20260615171051.png]]

### jmp 
**What `jmp` actually does physically:**

```
jmp 0x8048400
```

Is literally just:

```
%eip = 0x8048400
```

That's it. Nothing more. The CPU writes the destination address into the instruction pointer register. The next fetch-decode-execute cycle picks up from that new address.

jmp  means writing the destination value and writing it inside the pointer value. 

### call 
if you want to jump to a function you want to return to the function to enable that to remember we have a call function it takes the address of the return address and pushes to the stack. it looks at the return address and jumps back to it. and 


![[Pasted image 20260616124615.png]]



## End-ianess 
![[Pasted image 20260615143918.png]]

you can;t access address 0 , if you do it will throw an error. 

Let us say in your c program you create a character array of hexadecimal value.
In the memory you expect to see an exact same thing. 

![[Pasted image 20260615171902.png]]

Suppose in C you see an integer array of 4 bytes long. There are two elements integer1 and integer2. but you would see this 

![[Pasted image 20260615172153.png]]

Why does the endianess click in integer 

**Why? Little-endian rule:**

```
Least significant byte goes FIRST (lowest address)
```

For `0x11223344`:

```
11 = most significant byte  → goes LAST  (highest address)
44 = least significant byte → goes FIRST (lowest address)
```

![[Pasted image 20260615172616.png]]

Think of it like writing a number backwards byte by byte.
## Memory Layout 

This picture demonstrates the RAM. memory addressing starts at zero, the highest accessible address is exactly \(2^{32} - 1\)

Every process running on the computer thinks that they own the entire ram to themselves there is nothing else running on. If it wan;t for virutalization each program had to know about each other's memory for interaction. Operating system is responsible for virtualizing the memory. Program's can read  or write any address. The operating system works with the hardware & memory unit to map these addresses to your physical ram locations.

Stack is an array. 
![[Pasted image 20260615144059.png]]

![[Pasted image 20260615144122.png]]



Address 0 is special it is reserved so that anytime you access it the cpu complains cause we need something to initialize invalid address. 

https://stackoverflow.com/questions/34739117/why-is-the-memory-address-0x0-reserved-and-for-what

local function like main will be in the stack, 

### Text 

Code will be stored in text. 
Contains all the information that come from executable. (.exe) .
text region contains all the instructions from the executable but the program has your instructions. 
If your program needs a syscall basically the code that comes from kernel. 
Those instructions i.,e mean the kernel addresses also need to be mapped inside your virtual memory address. 
All the code that the kernel developers wrote & internal kernal data structures will be accessible in these addresses. 

Other code i.,e dynamic libraries, e.g. libsodium in challenge 1. All the code will be in the memory mapping. All the dyanamic libraries will be mapped to this address range 

High Address 0xFFFFFFFF
┌─────────────────────┐
│   Kernel Space      │ ← kernel code + data structures
├─────────────────────┤
│   Stack             │
├─────────────────────┤
│   Memory Mapping    │ ← dynamic libraries live HERE (not text!)
│   (mmap region)     │    e.g. libsodium, libc
├─────────────────────┤
│   Heap              │
├─────────────────────┤
│   BSS               │
│   Data              │
│   Text              │ ← YOUR program's instructions only
└─────────────────────┘
Low Address 0x00000000

## Data

Let us say if you define initialized global variables and integers. 

## BSS

If you define global variables not but initilize i
###  heap

 malloc will be in heap 

- **The Program Break:** The `brk` (break) system call defines the absolute end of the program’s data segment (the top of the heap).
- **Dynamic Adjustment:** `sbrk` (set break) is used to increment or decrement this limit. When your program asks for more memory (e.g., using `malloc`), `sbrk` moves the break point upward to expand the heap size. 
- 
## Stack

Local functions including the main() will be in the stack. 

## Stack Frames 

Every time a function is called, the OS carves out a dedicated chunk of the stack just for that function. That chunk is called a **stack frame**. and when you are done with the function so pop that stack frame

![[Pasted image 20260616154451.png]]


![[Pasted image 20260615144416.png]]

## Calling Conventions  

https://cs61.seas.harvard.edu/site/2018/Asm2/

Calling conventions constrain both callers and callees. A caller is a function that calls another function; a callee is a function that was called. The currently-executing function is a callee, but not a caller. is what the slide means in a different vocabulary.

main() calls foo() calls bar()

![[Pasted image 20260615155536.png]]

### Example 


![[Pasted image 20260616154917.png]]

main has to do her is call sum

![[Pasted image 20260616155042.png]]

sum needs to add two operands here 
but before you call the sum you need to pass the arguments into something which should be accessible by sum.  

![[Pasted image 20260616155721.png]]

![[Pasted image 20260616160138.png]]
![[Pasted image 20260616160117.png|546]]

What if there are two different people writing this program. for this you need to follow the calling convention. We should know the rules to abuse the rules. 

### Rules



![[Pasted image 20260615160255.png]]
#### Rule 1
reverse order" is about _push order_.

c

```c
foo(arg1, arg2, arg3)
```

Pushed onto stack as:

```
push arg3   ← first pushed (deepest)
push arg2
push arg1   ← last pushed (top of stack)
call foo
```

#### Rule 2; eax, ecx, edx are caller saved

main is doing some work, stores important value in %eax = 5
main calls sum
sum also uses %eax internally for its own math
sum overwrites %eax = 99
sum returns
main looks at %eax expecting 5
%eax = 99 now — main's value is GONE

The rule says: this is main's problem, not sum's.

If main wants to keep %eax safe:
main saves it BEFORE calling:

pushl %eax    ← save 5 on stack
call  sum     ← sum can do whatever with %eax
popl  %eax    ← get 5 back after

#### Rule 3: Remaining registers are callee saved.

callee functions know how to find the variables on stack

main trusts that %ebx won't change across a function call
sum wants to use %ebx internally

sum MUST:
    save %ebx at start    → pushl %ebx
    do its work
    restore %ebx at end   → popl %ebx
    return

main gets %ebx back unchanged. Happy.
#### Rule 4: Return value goes in eax.

```
int sum(int a, int b) {
    return a + b;     // answer = 21
}
```

```
sum:
    add %ebx, %eax    ; eax = 10 + 11 = 21
    ret               ; eax = 21, that's the return value

main:
    call sum
    ; answer is in %eax = 21
    ; both sides know to look here
```

Both sides agreed: result always goes in %eax. Simple.
#### Rule 5: Caller pops arguments after return.

Clean up of the arguments in the stack is done by the caller because caller sets up the entire function.

#### Rule 6: Return address saved on the stack, governed by the architecture.



## Demo
![[Pasted image 20260616174640.png]]

Every time you call a function you build these things. The stack persented here is upside down. 


![[Pasted image 20260616174847.png]]

ebp+12 means growing the stack, - means shrinking the stack. 

Suppose there is a new function that you are going to call, that function is called subroutine. 

![[Pasted image 20260616175100.png]]

The very first thing you need to do is pass the arguments. You will push the arguments in the reverse order t
![[Pasted image 20260616175812.png]]


![[Pasted image 20260616175600.png]]



Now will call the subroutine. 

![[Pasted image 20260616175940.png]]

Esp always points to the top of the stack. remember in call subroutine will have current+4 address to come back to it. 

Definition of return address is take whatever is at the top of the stack and jump to it. 

→ take whatever is at top of stack (%esp)
→ pop it into %eip
→ CPU jumps there

![[Pasted image 20260616232604.png]]

### Prologue 
**First two instructions (function SETUP):**
pushl %ebp          ; save caller's frame pointer
movl  %esp, %ebp    ; set MY frame pointer = current stack top

Every single function starts with these two. Always. Without exception.

If you are building the stack frame the ebp is saved to the previous stack frame. 
In the new stack frame it is suppose to be pointing somewhere. 
You need to allow ebp to move to the previous location i.e, save the old value of ebp to restore it later. 
This is what the first instruction pushl %ebp means pushing the value of ebp on top of the stack. we call it the saved ebp. 
We do it for every function call.    
Next thing we do is take the previous ebp and make it point to it;s new place. 
Take the value inside esp & write into ebp which means make ebp point to the same location as esp. 

![[Pasted image 20260616234740.png]]

### Epilogue — last three instructions

movl %ebp, %esp     ; throw away local vars (esp jumps back up to ebp)
popl %ebp           ; restore CALLER's frame pointer
ret                 ; pop return address into %eip, jump back

### Local Data

 we allocate the local storage data let us say inside the function we created an array of 32 bits. It is subtracting from the stack. Sub means you are expanding your stack 
![[Pasted image 20260616235646.png]]

![[Pasted image 20260616235806.png]]

Necessarily it need not be an array it could be Integers. Local Data means you are reserving the area for local data switch. Compiler decides how much space is to be given depending on the code we write. e.g if you have one integer it will be 4 bytes. 

![[Pasted image 20260617001128.png]]

e.g this is the function 

![[Pasted image 20260617000958.png]]

int sock is the argument here int fd , i & read_count inside read_key is the local data

### Callee and Caller saved registers. 

![[Pasted image 20260617001822.png]]

**Caller saved registers — go ABOVE arguments (before the call):**

; caller (main) does this BEFORE calling:
pushl %eax        ← caller saved registers pushed HERE
pushl %ecx        ← caller saved registers pushed HERE
pushl %edx        ← caller saved registers pushed HERE
pushl <argument_2>
pushl <argument_1>
call  subroutine

![[Pasted image 20260617001906.png]]

**Callee saved registers — go INSIDE local data area:**
; subroutine does this AFTER prologue:
pushl %ebp
movl  %esp, %ebp
subl  $32, %esp
pushl %ebx        ← callee saved registers pushed HERE (inside local area)
pushl %esi        ← callee saved registers pushed HERE
pushl %edi        ← callee saved registers pushed HERE

![[Pasted image 20260617002011.png]]

### Time to return 

you clean up all the mess, get rid of the local data. but here is the thing the local data area might have changed. Initially you allocated 32 bytes. Take esp and put it where ebp is. we know the ebp is at the base of the local data. 

Anything that is above esp does not exist. Take ebp where the stack is. 

![[Pasted image 20260617002841.png]]
![[Pasted image 20260617033717.png]]
![[Pasted image 20260617033753.png]]
![[Pasted image 20260617033817.png]]
![[Pasted image 20260617033904.png]]

After pop ret 
![[Pasted image 20260617034244.png]]
![[Pasted image 20260617034324.png]]

![[Pasted image 20260617034520.png]]
![[Pasted image 20260617034717.png]]
![[Pasted image 20260617034744.png]]
**Why exactly 8 in `addl $8, %esp`?**

Because 2 arguments were pushed, each 4 bytes:

```
2 arguments × 4 bytes each = 8 bytes total

pushl argument_2    → 4 bytes
pushl argument_1    → 4 bytes
                      --------
total to clean up   = 8 bytes

addl $8, %esp    → skips over exactly those 8 bytes
```

If you had 3 arguments → `addl $12, %esp`  
If you had 1 argument → `addl $4, %esp`

**It's always: number of args × 4 bytes.**

![[Pasted image 20260617035105.png]]

We don;t know these addresses i.e, why refer it with the help of ebp, why not esp because it keeps move around. 


local data is never in the order right per our code. need to check the disas to see it is mapped per our code

![[Pasted image 20260617035607.png]]







