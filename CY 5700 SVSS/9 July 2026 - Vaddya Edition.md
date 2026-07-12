
## what's wrong is the program ?
- The program has this :> **printf(buffer)**.
- The buffer is controlled by the attacker. 
- The attacker can put a format string in the buffer like : **%s ,%d, etc.**
- Because of this the **printf()** function tries to find a corresponding argument for each format string and since the second argument is not passed, the memory of position where the argument is expected to be present is read like : **stack canaries and any other info is present above it .**


#### %n format string 
- It can be used to do memory write attacks.
- it reads an address from memory and  write to that address.
- what does it write ? <mark style="background: #FF5582A6;">( watch the recordings )</mark>


# Algorithmic Complexity: Time Complexity Attacks

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

![[Pasted image 20260711201324.png]]

### 2. Hash Table :

- In a hash table what happens your hash and the value of which is being hashed eg. tanishka is passed through a hash function it produces an index (say, index 4). The backend stores/retrieves at `table[4]` directlyis stored in the hash table. 
- so when the backend wants that particular  hash it does search tanishka-> hash value and gives it i.e, why the complexity is O(1). 
- but since there are limitations to our hash functions where we have collisions. 
-
geeksforgeeks.org/dsa/hash-table-data-structure/
####  Collision Protections:
##### Separate Chaining 
![[Pasted image 20260712130409.png]]
![[Pasted image 20260712130503.png]]
	![[Pasted image 20260712130715.png]]
	2. Linear Probing

- This is **open addressing**, not chaining. 
- Instead of building a list at the colliding slot, you say: "index 4 is taken, so try index 5. Taken too? Try index 6. Keep going until you find an empty slot." 
- No linked lists at all, every item lives directly in the table array itself, just possibly not at its "ideal" index.

### Hash Table Attacks 

![[Pasted image 20260712130854.png]]

If an attacker finds many keys that all collide into the same bucket:

- With **chaining**: that bucket's linked list grows to length n, and looking anything up in it becomes O(n) — a linear scan.
- With **linear probing**: you get long clusters of occupied slots, and finding an empty one (or the right slot) means scanning through the whole cluster — also O(n).

Either technique degrades from O(1) to O(n) per operation under a deliberate collision attack. 
# Space complexity attacks :

### 1. Compression Bombs:
![[Pasted image 20260712131656.png]]

- The file itself is only about **42 kilobytes**.
- Inside, it's not one layer of compression — it's **nested** zip files inside zip files, many layers deep (42.zip famously uses 5 layers of 16 zip files each, recursively).
- If you actually unzip everything all the way down, the total decompressed size balloons to roughly **4.5 petabytes** (4.5 million gigabytes).

# Time and Space Complexity Attacks
### 1. Billion Laughs 
- attacks using XML entities .
- When custom symbols references other symbols.. &lol9 will be called, and when it goes to lol9 then lol8 and then so on and on. 

![[Pasted image 20260712132642.png]]

Each entity is defined in terms of the previous one, repeated 10 times:

![[Pasted image 20260712133138.png]]
when an XML parser resolves an entity reference, it doesn't just "visit" it and move on — it has to **actually construct the expanded text (or DOM tree) and hold it in memory**, because the parser's whole job is to hand the application the fully-resolved content.

### Real attacks 
- watch the video from the slides

#### Target: Kubernetes 
![[Pasted image 20260712143520.png]]

##### Symbol references means in YAML:

**What "symbol references" means in YAML:**

YAML has a feature called **anchors and aliases**, which let you define a piece of data once and then _reuse_ it elsewhere in the document without retyping it — like a variable.

The syntax looks like this:

yaml

```yaml
a: &a ["web", "web", "web"]
b: [*a, *a, *a]
```

- `&a` — this **defines an anchor** named `a`, attached to the list `["web", "web", "web"]`. Think of `&a` as "save this value under the label `a`."
- `*a` — this is an **alias**, meaning "insert whatever was saved under anchor `a` right here."
- So `b: [*a, *a, *a]` doesn't literally contain three copies of `"web"` written out — it contains **three references** to the same anchor, each of which the YAML parser must expand into the full `["web","web","web"]` list when it processes the document.


![[Pasted image 20260712144329.png]]

- `a` = 9 literal strings.
- `b` = 9 references to `a` → when expanded, 9 × 9 = 81 strings.
- `c` = 9 references to `b` → 9 × 81 = 729 strings.
- ...and this keeps multiplying by 9 at every letter, all the way to `i`.

#### Target: Web Server

![[Pasted image 20260712144736.png]]
If someone submits a form with fields `username=alice&language=en`, the framework automatically parses that into a dictionary-like structure so your code can just do:

```
request.form["username"]   → "alice"
request.query["language"]  → "en"
```

**The key question the slide is asking:** _"Can you guess the data structure used?"_

The answer: it's a **hash table**. Every parameter name (`username`, `language`, etc.) becomes a _key_ in a hash table, so lookups like `request.form["username"]` are O(1)

- They find the specific hash function the web framework's language/runtime uses internally (many languages use similar, sometimes not-so-strong, default hash functions for dictionaries/hash tables).
- They **precompute** a large batch of strings that are all guaranteed to hash to the _same_ bucket — a mass hash collision.
- They craft one POST request with a body containing thousands (or tens of thousands) of these colliding "field names" as parameters — something like `x1=1&x2=1&x3=1...` where all those `x1, x2, x3...` names were deliberately chosen to collide.
- The server tries to parse this into its hash table. But because every key collides into the same bucket, that bucket's linked list grows to be huge — and inserting n items that all collide costs O(n²).
# Side Channels Attacks 

