
---

```
gcc -z execstack -fno-stack-protector -ggdb3 -o extra extra.c
```
#### ✅ `-z execstack`

_Marks the stack as executable._  
Normally Linux marks the stack **non-executable (NX bit)** so injected shellcode can’t run.  
This option **turns NX off** → the stack becomes executable → shellcode placed in buffers can run.

#### ❌ `-fno-stack-protector`

_Disables stack smashing protection._  
Modern GCC inserts **stack canaries** to detect buffer overflows.  
This flag **removes** that protection so overflows crash/run instead of aborting.

#### 🐞 `-ggdb3`

Adds **full debug symbols** for gdb:
- line numbers
- variable names
- macro expansion info  
    Makes debugging + reverse engineering easier.
    

#### 📁 `-o extra`

Output binary name → `extra`  
Without this, gcc would produce `a.out`.

#### 📄 `extra.c`

Your input C file.

--- 

