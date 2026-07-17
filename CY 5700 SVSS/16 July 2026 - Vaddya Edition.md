RESOURCES : "Engineering a Safer World" by Nancy Leveson, MIT
# Systems Safety (IMPORTANT)

**Accident Analysis** : Done Post Incident 
**Accident Modelling** : Predict what could go wrong 


### Acccident Modeling :
- Was done based on Event Chains and Direct causality.
- We drew linear event chain illustrations based on Event that could happen and impact they could cause.
- We then, try to break the chain. So that the remaining chain of events does not happen.


### Accident Analysis:
- You build someting , it breaks and then you analyse the root cause and check why did this happend.
- We call this Root Cause analysis.



### Problems with RCA :
- World is not a Linear Chain of Events.
- Other factors matter too.
- In majority cases the Root cause would always be Human error **(Human error - > bad System Design !).**
- These event chains ignore **systemic factors** .



# Look online : Three Mile Island Accident 






## The New Model !!

- WE SHIFT to <mark style="background: #FFB86CA6;">SYSTEMS THEORY from  RELIABILITY THEORY</mark>.

- Systems Have emergent properties that only appear when system is analyzed as whole ( Not when we follow divide and concoure )
- <mark style="background: #FF5582A6;">Safety is an emergent property of a complex system.</mark> (IMPORTANT !!!!!!!!!!!!!!!!)




## STAMP
- Systems Theoritic Accident Model and Process .





# Reverse Engineering 

- Reversing is the process of creating a higher level abstraction of a low level thing.
- Binary to Assembly is not reversing 



- We can use Prologues and Elilogues as indicators to find function blocks.( Only if No optimization are applied by the Compiler)


- The compiler may also add some padding code that 



## Bytecode :
- An intermediate code before the actual assembly.
- For example : Java.

- The Bytecode is much more structured than machine code .
- So, if you have bytecode instead, the reversing task become a lot easier.




### Two Algos to disassembly (Imp for endterm):
1.  Linear Sweep diassembly 
	- Disassemble linearly until all bytes processed .
	- <mark style="background: #FFB86CA6;">vulnerable to inline data </mark> (check the recording time : 8:28 PM)
2. Recursive decent/traversal disassembly :
	- It follows the control flow of the code .
	- Recursively follow branching code paths.
	- <mark style="background: #FFB86CA6;">Not vulnerable to inline data</mark> 
	- it fails if there is indirect branches (example : jmp %eax )