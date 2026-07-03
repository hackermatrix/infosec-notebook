
# Memory corruption in the modern world


## # Basic requirements for basic shellcode Injection
1. Run out of bounds 
2. inject mal code
3. overwrite control fields 
4. guess imp addresses



## Defenses 

### 1. Non-Executable Mem:
- Used to mark stack non-executable.
- **Common name:** NX bit or DEP or XD ot XI or XN. (**W^X** in Mac OSX meaning that mem is Writable or Executable not both )
- This is implemented on the hardware side( The h/w signals the OS about the event happening).
- So what do we do ????????????????????????????? <mark style="background: #FFB86CA6;">( Use the code that is already executable )</mark>






## Attacks 
### 1. The Code Reuse attack
- We can use libc .
- execute existing functions with the arguments you choose.
- e.g system().
- The address of a funtion is stored in a symbol table .
- For the argument of system() we need the address for "/bin/sh" we can get it from libc again.


>[! Info]
>in bash if the launch UID is different that setuid   <mark style="background: #FFF3A3A6;">( Lost it get this part from the lecture recording )</mark>

#### 1.2 chaining Function call
**Get this part from the recordings as well. **

- In 64 bit systems you can put args in registers.


### 2. Return Oriented Programming 
- Extends the idea of return-to-libc.
	-  Much finer code granularity.
	- Can be turing complete ! ( By this u can write any type of exploit)

#### 2.1 the Idea
- Reuse tiny code chunks.
	- **Gadgets** : code sequences that end with a return.
	- **How to find them ?** : find /xc3 in executable sections of your code thats the return instruction and go back one address and use that as your gadget but you also may use more instructions if needed.( Look at the Finding Gadgets slide)
- chain them together to compose exploit.
- Sooooo the steps are :
	1. Identify the Gadgets from the Code.
	2. Figure out how to use them to fulfil your purpose. <mark style="background: #FF5582A6;">(Does not need to be about gettting a shell on the system.)</mark>
	