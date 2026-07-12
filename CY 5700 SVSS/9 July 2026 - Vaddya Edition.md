
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
#### **Lomuto Scheme** : We take the **last element at the pivot.**
- complexity: nlog(n)
- what if the attacker passes an input that could cause a DOS attack?
- Consider an already sorted array , With Lomuto partitioning, the pivot is always the _last_ element. If the array is already sorted ascending, the last element is always the **maximum** of whatever sub-array you're looking at. 
- Each recursive call only shrinks the problem by 1 element (n → n−1 → n−2 → ...) instead of splitting it roughly in half. You get n levels of recursion, each doing O(n) work to scan/partition → n × n = **O(n²)**.

![[Pasted image 20260711195525.png]]

- All identical elements, like `4 4 4 4 4 4 4 4 4`
- ![[Pasted image 20260712123020.png]]
- Since every element equals the pivot, none of them is strictly "less than" the pivot — so, depending on how the partition handles ties (`<=` vs `<`).
- n levels of recursion, O(n) work each → **O(n²)**.
- In both cases, the pivot choice (last element) turns out to be an _extreme_ value relative to the rest of the array.
#### Better strategy to choose the pivot.
- input[first], input[mid], input[last]. Pick the median
- **Array:** `1 2 3 4 5 6 7 8 9`
- first = 1
- mid = 5 (the middle element, index 4 in a 9-element array)
- last = 9

Median of {1, 5, 9} → sort them mentally: 1, 5, 9 → the middle value is **5**. So yes, pivot = 5. You've got it right.

**Why this actually fixes the O(n²) problem:**
With median-of-three, pivot = 5. Now when you partition around 5:

- Left side: `{1, 2, 3, 4}` → 4 elements
- Right side: `{6, 7, 8, 9}` → 4 elements

That's a perfect 50/50 split! Instead of n levels of recursion (each doing O(n) work → O(n²)), you now get log n levels of recursion → back to **O(n log n)**.
## Algorithmic Complexity and Side Channel attacks 

![[Pasted image 20260711201324.png]]

### 1. Hash Table :

- In a hash table what happens your hash and the value of which is being hashed eg. tanishka is passed through a hash function it;s value is stored in the hash table. 
- so when the backend wants that particular hash it does search tanishka-> hash value and gives it i.e, why the complexity is O(1). 
- but since there are limitations to our hash functions where we have collisions. suppose tanishka and vadya both have the same hash function. that is why they are stored in a linked list format this is known as linear probing.  

geeksforgeeks.org/dsa/hash-table-data-structure/
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
