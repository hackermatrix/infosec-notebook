

# Common Binary Sections:

## 1. **.text — Code Section**

- Contains **machine instructions**
- Executable, usually **read-only**
- This is where your CPU runs the program from
- This is the store for the code .

Example:

`main function, loops, syscalls, etc.`

## 2 **.data — Initialized Data**

- Stores **global and static variables** with **values assigned** at compile time
- **Readable + Writable**

Example in C:

`int x = 5;   // goes in .data`


## 3 **.bss — Uninitialized Data**

- Holds **global and static variables** that are **not initialized**
- Takes **no space in the file**, OS allocates at runtime
- **Writable memory**

Example:

`int y;      // goes in .bss`

## 4 **.rodata — Read-Only Data**

- Stores **constants** and **string literals**
- Marked **read-only**
- Helps memory protection / avoids accidental overwrite

Example:

`printf("Hello"); // "Hello" in .rodata`

### 5 **.symtab**

- Contains **symbol table** (function/variable names)
- Removed in optimized/released binaries (stripped)
    

### 6 **.strtab**

- Strings referenced by symbols
- Used by debuggers
    

### 7 **.rel / .rela**

- Relocation information for linking dynamic addresses
    

### 8 **.plt & .got** (ELF Linux)

- **PLT (Procedure Linkage Table)** → call external functions (printf, libc)
    
- **GOT (Global Offset Table)** → holds runtime addresses resolved by the dynamic loader
	- Example : It will have the offset address to **system()** from the libc library since it is dynamically loaded.
		- Helps program to find the functions addresses when ASLR is active.
    

### 9 **.debug**

- Debugging info (DWARF format)
- Present only if compiled with `-g`