
## 1. User Address Space: 

- **User address space = the virtual memory map that a process can access while running in user mode.**
	- Private for each program
	- Hardware-enforced isolation
	- Contains code, stack, heap, globals
	- Kernel memory is _visible only to the OS_

## How User Address Space Maps to Physical Memory ?

- Modern CPUs don’t let programs touch physical RAM directly. Instead, each process works with **virtual addresses**, which the CPU translates to **physical addresses** via the **Memory Management Unit (MMU)**.


	## 1. **Virtual Address vs Physical Address**
	
	- **Virtual address**: what your program sees (`0x7fff12345678`)
	- **Physical address**: actual location in RAM (`0x1a3b5000`)
	
	- **Example:**
		- `Program thinks: malloc() returned 0x601000 MMU maps it to: RAM location 0x1f3a1000`
		- Each process can have **the same virtual address**, but it maps to **different physical memory**.