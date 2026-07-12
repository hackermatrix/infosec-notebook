
## what's wrong is the program ?
- The program has this :> **printf(buffer)**.
- The buffer is controlled by the attacker. 
- The attacker can put a format string in the buffer like : **%s ,%d, etc.**
- Because of this the **printf()** function tries to find a corresponding argument for each format string and since the second argument is not passed, the memory of position where the argument is expected to be present is read like : **stack canaries and any other info is present above it .**


#### %n format string 
- It can be used to do memory write attacks.
- it reads an address from memory and  write to that address.
- what does it write ? <mark style="background: #FF5582A6;">( watch the recordings )</mark>


# Algorithms and Data Structures 


### 1. QuickSort 
https://www.geeksforgeeks.org/dsa/quick-sort-algorithm/
- **Lomuto Scheme** : We take the last element at the pivot.
- complexity: nlog(n)
- what if the attacker passes an input that could cause a DOS attack?
- Consider an already sorted array 

![[Pasted image 20260711195525.png]]

    
    that's O(n2)
    input[first], input[mid], input[last]. Pick the median
## Complexity and Side Channel attacks 

### 1. Hash Table :
- Collision Protections:
	1. Linear Probing 
	2. Seperate Chaining




#### Space complexity attacks :

### 1. Compression Bombs:




### 2. Billion Laughs 
- attacks using XML entities .
- When custom symbols references other symbols.






### Real attacks 
- watch the video from the slides



# Side Channels Attacks 
