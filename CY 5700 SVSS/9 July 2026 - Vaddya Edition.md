
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

#### Target: Password Strength Matters 

![[Pasted image 20260713192606.png]]

##### zxcvbn

zxcvbn is Dropbox's password strength estimator, the little meter you see on signup forms saying "weak / okay / strong" as you type your password. It's meant to be smarter than dumb rules like "must contain 3 of {upper, lower, number, symbol}" — instead it actually analyzes the password's structure (common patterns, dictionary words, keyboard walks, etc.) to estimate how guessable it really is.

##### The vulnerability :

A security researcher found that the zxcvbn algorithm has quadratic time complexity, meaning a user could submit an arbitrarily long password to the library and cause a denial of service if done at scale. [HackerOne](https://hackerone.com/reports/542897)

the strength-checking logic isn't scanning your password once because it's checking for overlapping patterns, substrings, repeated segments, dictionary matches at every position, etc., the amount of work grows roughly with the _square_ of the password length.

**The attack, step-by-step:**

1. Find a form using zxcvbn (or any quadratic-complexity string analysis) on a password field.
2. Submit an extremely long string as the "password" (submitting a password field containing, say, 100,000 characters) no need to guess collisions or precompute anything fancy, unlike the hash table attack. Just _**length**_ is the weapon here.
3. The server spends wildly disproportionate CPU time analyzing that one field.
4. Repeat with a few concurrent requests, and you can pin a server's CPU again, a tiny, ordinary-looking request (just a long text field) causing outsized damage.


#### "Denial of Service with a Fistful of Packets"

algorithmic complexity vulnerabilities can be much quieter than traditional denial-of-service attacks, because they arise from intended functionality rather than a bug, the normal indicators of compromise like errors, unusually high traffic volume, or excessive logging often aren't present. That's the scary part: you don't need a botnet or a flood of traffic, a handful of well-chosen packets (or even one) is enough, and it can look like completely normal application behavior right up until the CPU is pegged.

##### an algorithm has good _average-case_ behavior that developers rely on, but a _worst-case_ input (here: just "make the string very long") breaks that assumption completely

# Defense 

![[Pasted image 20260713194625.png]]

# Side Channels Attacks 

![[Pasted image 20260713194702.png]]
## Code Check_Token 


c ```
for (i = 0; i < TOKEN_LEN; ++i) {
    if (user_token[i] != real_token[i]) {
        return BAD_TOKEN;   // exits immediately on first mismatch
    }
}
return GOOD_TOKEN;
```
```


compares the `user_token` against the `real_token` (the secret), one character at a time — and the moment it finds a mismatched character, it **immediately returns** `BAD_TOKEN`. This is exactly what `strcmp` does internally too

### Vulnerability

**Say the real secret is `tannysingh` and the attacker submits `tannyXXXXX` (first 5 correct, then wrong):**

```
i=0:  user_token[0]='t'  vs  real_token[0]='t'  → match, continue
i=1:  user_token[1]='a'  vs  real_token[1]='a'  → match, continue
i=2:  user_token[2]='n'  vs  real_token[2]='n'  → match, continue
i=3:  user_token[3]='n'  vs  real_token[3]='n'  → match, continue
i=4:  user_token[4]='y'  vs  real_token[4]='y'  → match, continue
i=5:  user_token[5]='X'  vs  real_token[5]='s'  → MISMATCH → return BAD_TOKEN immediately
```

So the loop runs **6 times** (i=0 through i=5) before it bails out — one iteration for each correct character, plus one more to discover the wrong one.

An attacker who can measure response time (even down to microseconds, over a network, using enough repeated requests to average out noise) can exploit this character by character. Try every possible first character. The one that takes _slightly longer_ means that first character was correct (because the loop ran one more iteration before failing).Instead of having to brute-force the entire token at once (which for any reasonably long secret is computationally infeasible), the attacker can crack it **one character at a time**, using timing as a side channel.


### FIX 


c ```

int check_token(const char *user_token, const char *real_token) {
    int mismatch = 0;
    for (int i = 0; i < TOKEN_LEN; ++i) {
        mismatch |= (user_token[i] != real_token[i]);  // never breaks early
    }
    return mismatch ? BAD_TOKEN : GOOD_TOKEN;
}

**Say the real secret is `tannysingh` (10 characters), and the attacker submits `tannyXXXXX`:**

c

```c
int mismatch = 0;
```

Start with `mismatch = 0` (meaning "no problems found yet").

Now walk through **every single index, i = 0 to 9, no matter what**:

```
i=0: user_token[0]='t' vs real_token[0]='t'  → equal   → (false) → mismatch |= 0 → mismatch stays 0
i=1: user_token[1]='a' vs real_token[1]='a'  → equal   → (false) → mismatch |= 0 → mismatch stays 0
i=2: user_token[2]='n' vs real_token[2]='n'  → equal   → (false) → mismatch |= 0 → mismatch stays 0
i=3: user_token[3]='n' vs real_token[3]='n'  → equal   → (false) → mismatch |= 0 → mismatch stays 0
i=4: user_token[4]='y' vs real_token[4]='y'  → equal   → (false) → mismatch |= 0 → mismatch stays 0
i=5: user_token[5]='X' vs real_token[5]='s'  → NOT equal → (true=1) → mismatch |= 1 → mismatch becomes 1
i=6: user_token[6]='X' vs real_token[6]='i'  → NOT equal → (true=1) → mismatch |= 1 → mismatch stays 1
i=7: user_token[7]='X' vs real_token[7]='n'  → NOT equal → (true=1) → mismatch |= 1 → mismatch stays 1
i=8: user_token[8]='X' vs real_token[8]='g'  → NOT equal → (true=1) → mismatch |= 1 → mismatch stays 1
i=9: user_token[9]='X' vs real_token[9]='h'  → NOT equal → (true=1) → mismatch |= 1 → mismatch stays 1
```

**Notice: the loop does NOT stop at i=5.** Even though we already know it's wrong by i=5, the code keeps going all the way to i=9 anyway, comparing every remaining character even though the answer is already decided.

After the loop, `mismatch = 1`, so:

c

```c
return mismatch ? BAD_TOKEN : GOOD_TOKEN;   // mismatch is 1 (truthy) → returns BAD_TOKEN
```

**Now compare with a guess where the very first letter is wrong: `Xannysingh`:**

```
i=0: 'X' vs 't' → NOT equal → mismatch becomes 1
i=1: 'a' vs 'a' → equal    → mismatch |= 0 → stays 1
i=2: 'n' vs 'n' → equal    → mismatch |= 0 → stays 1
i=3: 'n' vs 'n' → equal    → mismatch |= 0 → stays 1
i=4: 'y' vs 'y' → equal    → mismatch |= 0 → stays 1
i=5: 's' vs 's' → equal    → mismatch |= 0 → stays 1
i=6: 'i' vs 'i' → equal    → mismatch |= 0 → stays 1
i=7: 'n' vs 'n' → equal    → mismatch |= 0 → stays 1
i=8: 'g' vs 'g' → equal    → mismatch |= 0 → stays 1
i=9: 'h' vs 'h' → equal    → mismatch |= 0 → stays 1
```

Still 10 iterations. Still `mismatch = 1` at the end. Still returns `BAD_TOKEN`.

**The key point:**

Both guesses — `tannyXXXXX` (5 correct) and `Xannysingh` (0 correct) — ran the loop **exactly the same number of times: 10.** There's no early exit anywhere. The attacker's clock sees identical timing regardless of how many characters were actually correct, so there's nothing left to measure — the letter-by-letter timing signal from before is completely gone.

That `|=` (bitwise OR) trick is what makes this work: once `mismatch` becomes 1, later correct matches (`mismatch |= 0`) can't un-set it back to 0 — so you can safely keep comparing every character without needing an `if`/early-return to "lock in" the failure.


## Hertzbleed

https://blog.cloudflare.com/hertzbleed-explained/


### **The core idea of Hertzbleed:**

Modern CPUs don't run at a fixed speed — they use **DVFS (Dynamic Voltage and Frequency Scaling)** to automatically adjust their clock frequency based on power/heat conditions, to stay within the chip's **TDP (Thermal Design Point)** — basically its safe power/heat budget.

**the amount of power a CPU draws depends on the _data_ it's processing** — specifically, how many bits are `1` vs `0` in the values being computed.

That's what image 3 is showing:

- **Hamming weight** = how many `1` bits are in a value. `01111111` has more 1s (weight 7) than `01000000` (weight 1).
- **Hamming distance** = how many bits differ between two values. Comparing A and B differs in just 1 bit; comparing C and D differs in 6 bits.

**Why more 1-bits or more bit-flips matter:** Physically, flipping a transistor from 0→1 (or having more 1-bits active) draws more power than staying at 0. So a computation on data with high Hamming weight/distance draws **more power** than the same computation on data with low Hamming weight/distance — even though it's the exact same instructions.

![[Pasted image 20260713211447.png]]

**Left example: `01111111 + 01000000`**

```
  0 1 1 1 1 1 1 1
+ 0 1 0 0 0 0 0 0
-----------------
  1 0 1 1 1 1 1 1
```

Watch what happens bit by bit, from the right: `1+0=1`, no carry. Next: `1+0=1`, no carry... until you hit the bit where both are `1`. When you add `1+1`, that produces a carry that has to **ripple/propagate** through the next bits. Because the first number (`01111111`) has so many 1s in a row,

**Right example: `01000000 + 01000000`**

```
  0 1 0 0 0 0 0 0
+ 0 1 0 0 0 0 0 0
-----------------
  1 0 0 0 0 0 0 0
```

Here there's only **one** `1+1` collision (at that single bit position), producing exactly one carry, and it doesn't have to ripple through a long chain of other 1-bits — much less internal switching.

#### **Connecting power to frequency (the DVFS link):**

![[Pasted image 20260713212013.png]]

If a computation happens to draw more power (because the secret data it's processing has more 1-bits), the chip's DVFS system reacts by **lowering the clock frequency slightly** to stay within its safe power/thermal budget (image 2: frequency dips from 4.1 → 3.9 GHz). Lower frequency = the computation takes **slightly longer** to finish.

#### **Putting the whole chain together:**

```
Secret data (e.g. a private key)
   ↓
Number of 1-bits in that data varies
   ↓
Power draw varies (more 1-bits = more power)
   ↓
DVFS adjusts CPU frequency to compensate
   ↓
Execution time changes, measurably, from outside the chip
```

**So why is this dangerous?**

An attacker who can measure _how long_ a cryptographic operation takes (e.g., over a network, many times, averaging out noise) can work backward through this chain: timing differences → frequency changes → power differences → **Hamming weight of the secret data being processed.** That's enough of a signal, repeated across many measurements, to eventually recover bits of a private key — even though the attacker never touched the chip and never saw a single byte of memory. It's a pure **remote timing side-channel born from a power-saving feature**, which is why it was such a surprising and hard-to-patch discovery.

## Cache 

### **Quick refresher: what a cache actually is**

CPUs have small, very fast memory (cache) sitting between the processor and slow main RAM. When the CPU needs data, it first checks the cache:

- **Cache hit:** data is already there → very fast access.
- **Cache miss:** data isn't there → CPU has to fetch it from slower RAM → noticeably slower.

That speed difference (hit vs. miss) is small, but it's **measurable** and that's the entire foundation of cache attacks.


## Meltdown & Spectre
- The Example code considered by the professor : 
```c
myarray = {1, 2};
value = read(kernel_address);
index = value & 1;
myarray[index];
```
- The Normal flow is that the pr


## Fault Injection 

## Cold Boot Attacks
- if an attacker has physical access to a system, they can :
	- use a freeze spray to freeze a RAM stick
	- take the RAM stick out of the system
	- Extract Data from RAM Later.
- This Happens because if we  the lower temperature, the data retains for longer time on the hardware.  

## Rowhammer Attacks
- This attack takes the advantage of the fact that the modern hardware is very dense.
- The attack:
	- Hardware Stores bits (0s and 1s).
	- The Bits can change based on what is running on the system.
	- if the bits inside a electronic component is flipped very fast, this creates an electromagnetic field and this can influence the bits inside the neighboring components.
- An attacker can modify inaccessible memory by doing this intelligently.


## Defense 
![[Pasted image 20260713212849.png]]**Sharing** (in this context usually called **masking** or **secret sharing**) — you split a sensitive intermediate value into multiple random _shares_ such that any individual share is statistically independent of the true value, and you only recombine them at the end.
