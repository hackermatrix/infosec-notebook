
What is the specific purpose of the `eip` register in x86 architecture?
eip register points to the current instruction executed by the code.

What does it mean that the x86 family utilizes a "little-endian" architecture?
When we say little-endian it means the 4 bytes the lower bytes are stored in higher bytes and higher bytes are stored in lower bytes. 
eg. 84 is stored as x\48.

Which memory segment is responsible for storing uninitialized static variables?
Bss part is used for storing uni


According to the `cdecl` calling convention, how are arguments passed to a subroutine, and who is responsible for cleaning them up?
Arguments are passed in the reverse order. 
like example if we have a function 
int main(a, b)
b will be pushed first and then a. 


Define a "stack frame" in the context of memory layout.

So supose a function int sum(a,b) is being called by the function main 
the stack frame for int sum will be set up. 


| Argument 1                                                                        |     |     |
| --------------------------------------------------------------------------------- | --- | --- |
| Argument 2                                                                        |     |     |
| Return Address (address of the next instruction pushed by the previous function ) |     |     |
| Saved EBP (will jump to the previous function like main)                          |     |     |
| Local Data                                                                        |     |     |
| Stack top                                                                         |     |     |

What is the first fundamental requirement for a basic shellcode injection attack?
To be able to inject the shell code i guess I am mean if you cant inject the shell code you wont be able to do anything. 

What is a NOP sled and why is it used?
NOP sled means no operation and it is used so that our execution does not stop so when we are overwiting generally it is fine if we overwrite the local data with A's. it is fine but it you overwrite the return address or saved ebp with A;s it will be problem that is why we use NOP sled. 

What specific hardware defense mechanism does the NX bit (or W^X / DEP) provide?
It prevents both write and execution. Either you can write or you can execute. 


How does a Return-to-libc attack fundamentally differ from a standard shellcode injection?
Return-to-libc is a workaround the hardware defense mechanism of NX bit because what here we are leveraging the libc library which already has system, exec functions so we just use address at this library instead of injecting /bin/sh. 

What is a "gadget" in the context of Return-Oriented Programming (ROP)?
Gadget is a set of instructions with return. C3 is identified as a return. However not necessarily we used ret sometimes instructios like jump and pop are also used.


What is the purpose of a Stack Canary (or cookie)?
Stack canary is placed in the stack in between saved ebp and local data. So after the function runs the complier checks if the stack canary is same or corrupted if it is not the same it aborts the program. 


What does ASLR stand for, and what is its primary defense mechanism?
Address Space Layout Resolution means the address in runtime keeps changing it is not fixed. 

15. What is the worst-case time complexity of the Quicksort algorithm?
0(nlog(n))

16. What collision resolution mechanism in Hash Tables do algorithmic complexity attacks often target?
So for Collision resolution mechanism we have the liner probing and serial linked list in Hash Tables. Because of which the search goes from O(1) to O(n). 

17. What is the "Billion Laughs" attack?
Billio laughs attacks leverages the space complexity where they use xml as it parses 
x[0] = aaaaaa
x[1] = x[0]x[0]x[0]x[0]x[0]

18. What is a timing side-channel attack?
Timing side-channel attack is where the attack leverages the loop logic. Suppose if it does byte by byte comparison and if the looop breaks at particular iteration the attacker can leverage the key function or password. 

19.What physical property of computer memory is exploited in a Cold Boot attack?
The phyiscal property that if you store it at lower temperature the RAM stores data. So attackers do  a freeze spray and recover data from RAM. 

Briefly describe the mechanism of a Rowhammer attack.

Rowhammer leverages that capacitor placed in rows in the DRAM and when there is change from 0 bit to 1 bit. So the attackers does thing like voltage change or some physica damage because of which it interferes and causes damage. 



21. If an attacker injects shellcode but cannot perfectly guess the exact memory address where it lands, how can they reliably execute their payload without crashing the program?
For this the attacker do by testing like first send the calculated buffer, then by guesssing the return address by controlled overwrite.
22. A developer uses `strcpy(buf, user_input)` to copy a string into a 64-byte local buffer. Why is this specifically vulnerable, and what is the attacker's ultimate goal on the stack?
If a developer uses strcpy(buf, user_input) suppose the buffer is 256 the attacker can send 512 can crach the program. 
 23. Why must an attacker typically avoid including null bytes (`0x00`) when writing shellcode, and how might they initialize a register to zero without using one? 
 Attackers typically avoid including null bytes because if they exploiting something strcpy it gets terminated.  
24. In an x86 buffer overflow, if the attacker wants to spawn a shell using the `execve` syscall, what three arguments must they prepare in memory? 
25. A system administrator enables the NX bit but forgets to enable ASLR. Explain a practical attack technique that could still achieve arbitrary code execution. 
26. How does Return-Oriented Programming (ROP) manage to achieve Turing-complete execution without ever injecting new executable code? 
27. Why might an attacker intentionally look for "unaligned instructions" when building a ROP chain? 2
28. If a stack canary is enabled on a vulnerable application, how might an attacker utilizing a memory disclosure vulnerability successfully bypass it? 
29. How does Control Flow Integrity (CFI) attempt to mitigate code-reuse attacks like ROP? 
30. A modern web application parses incoming YAML configurations directly. What specific DoS vulnerability might it face, and what is the underlying mechanism? 
31. You notice a web server's CPU spikes to 100% when it receives a single POST request containing thousands of duplicate parameter names. What underlying algorithmic flaw is being exploited? 
32. A password checker function iterates through characters of a string, immediately returning `false` upon finding the first mismatch. How can an attacker practically exploit this logic to steal the password?
One thing the attacker can do is a Ddos i.e, it can pass 10000 length passsword and overwhelm the system second it knows it returns false upon finding the first mismatch suppose if it sends tara and the first three words tar are right and it declared problem on the 4th so till now it has run 3 and 4th wrong cycle which makes it easy for the attacker to guess. 
33. How does the "Hertzbleed" attack leverage dynamic voltage and frequency scaling (DVFS) to leak cryptographic keys? 
So when there is a key DVFS lowers the voltage which increases the processing time. 
34. Why is ensuring a program is "isochronous" (runs in constant time) a strong defense against side-channel attacks? 
Ensuring a program is isochrounous runs in constant time is a strong timing because then even if the attacker sends a raw charachter or key function it can;t guess with timing 
35. How can an attacker theoretically defeat ASLR if they discover an out-of-bounds read vulnerability in the application? 
If there is an out-of-bounds read vulnerability like if they can read addresses, then can look at the offset  and through brute force theoretically defeat ASLR. 
36. Why does a "Compression Bomb" (like 42.zip) act as an attack against both time and space complexity? 
Compression bomb like 42.zip acts an attack against both time and space because underneath it there are many zip files stored so 42.zip unzips to gigabytes which takes space and then the unzipping take time too. 
37. Explain the "jmp + call" trick used in shellcode writing and why it is necessary to solve the "Address Problem" for data strings like `/bin/sh`. it is necessary to solve the address problem means the attacks does not exact location to redirect to /bin/sh so what it does is call jmp when we do jump it goes to a different location and then call /bin/sh
38. A developer attempts to patch a buffer overflow by replacing `strcpy` with `strncpy`. Does this completely secure the application from all memory and complexity attacks? Why or why not?   strcpy and strncpy does not completly secure the application depend on the implementation.  

39. In what scenario would an attacker utilize "Fault Injection" (such as altering voltage or temperature), and what is the computational end goal. 
Attacker would use fault injection such as when aes computes the key it would send altering voltage because of which it computes less. 