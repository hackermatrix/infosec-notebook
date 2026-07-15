
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
Gadget is a set of instructions which we use 
