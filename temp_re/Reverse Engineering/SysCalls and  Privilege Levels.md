
# **What Are System Calls (syscalls)?**

- A **system call** is a controlled entry point for a user program to request a privileged operation from the kernel.

- User programs run in **user mode** and _cannot_ access hardware directly.  
- When they need something only the OS can do, they make a _system call_.


A **privilege level** is a security boundary enforced by the CPU that decides:
- What memory a program can touch
- Which CPU instructions it is allowed to execute
- Whether it can talk directly to hardware

- Think of them as **rings of authority**.



![[Pasted image 20260116152443.png]]