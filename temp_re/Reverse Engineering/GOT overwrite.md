A **GOT overwrite** is an exploitation technique where an attacker **modifies an entry in the Global Offset Table (GOT)** so that when the program calls a function, **control flow is redirected to attacker‑chosen code**.

Instead of hijacking the return address, you hijack **function resolution**.

** What is GOT ? :**
	In dynamically linked ELF binaries:
		- The **GOT** stores **addresses of libc functions** at runtime


**What is PLT ? :**

**PLT = Procedure Linkage Table**
It’s a section in **dynamically linked ELF binaries** that acts as a **trampoline** between your program and shared library functions (like libc).

In simple terms:

> **PLT is the code that jumps to the real function using the GOT.**