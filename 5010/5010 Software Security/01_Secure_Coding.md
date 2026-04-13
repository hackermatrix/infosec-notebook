
## 1. How do i ensure secure code ?
1. Start with Secure Design ( also called as **Shift Left** )
	- Follow Principles like : **Least Privilege, Defense in Depth, Fail Securely** .
2. **Follow Secure Coding Practices**
	- Validate all inputs (user, API, files, headers) **( Assume every input to be insecure )**
	- Use allow lists instead of blocklists.
	- Data/ Input Sanitization.
	- Auth and Authorization 
	- Data Encryption
	
3. **Automated Security Testing**
	- **Static Analysis (SAST)**
		- Scans source code
		- Finds issues early

	- **Dynamic Analysis (DAST)**
		- Tests running application

	- **Software Composition Analysis (SCA)**
		- Checks vulnerable dependencies
		
4. **Code Reviews (Human Layer)**
	- Peer review every PR
	- Look specifically for:
	    - Unsafe input usage
	    - Broken auth logic
	    - Hardcoded secrets
	    
5. **Logging & Monitoring**
	- Detect attacks early
	- Log authentication attempts, failures, anomalies
	- Use SIEM tools if possible

--- 
## 2. INPUT SIZE & BUFFER OVERFLOW

### # What is a buffer?
- A **buffer** is just a chunk of memory used to store data.
- Example:
```C
char name[10];  // buffer of size 10
```

### # The Wrong Assumption

- Developers often assume:

> “User input will be small and well-behaved (e.g., a normal line of text).”

- So they do something like:
```C
gets(name);  // dangerous
```

### # Problem!

- If user enters:
	AAAAAAAAAAAAAAAAAAAA

👉 That’s more than 10 bytes → **overflow happens**

---
## 3. INTERPRETATION OF INPUT

### Input is NOT always simple text
- Programs receive:
	- Binary data (files, packets)
	- Text (user input, URLs)
### Problem 1: Encoding Matters
- Text isn’t always simple ASCII.
#### Example:
- ASCII: `A`
- Unicode: can be multi-byte (e.g., emojis, special chars)
👉 Same “character” may take different space in memory

### Problem 2: Different Interpretations
- Input meaning depends on context:

| Input               | Different interpretations |
| ------------------- | ------------------------- |
| `../../etc/passwd`  | File path traversal       |
| `<script>`          | XSS in browser            |
| `%00`               | Null byte injection       |
| `admin@example.com` | Email format              |
|                     |                           |
### Problem 3: Internationalization (Unicode Issues)
- With Unicode:
	- Multiple ways to represent same character
	- Homoglyph attacks (e.g., fake domains) **( Attackers register a domain which looks identical to the original domain and use it to scam people.)**

- **Example**:
	`paypal.com vs раypal.com  (Cyrillic 'a')`




## 4. What is INPUT FUZZING ?

- **Input fuzzing (fuzz testing)** = Sending a program **a huge number of random, unexpected, or malformed inputs** to see how it behaves.
- **Example:**
	Imagine a function:
```c
	void process(char *input);
```

A fuzzer will try inputs like:

- Very long strings (`AAAAAA...`)
- Empty input
- Binary garbage (`\x00\xFF\xAB`)
- Special characters (`<script>`, `%s%s%s`)
- Unexpected formats

---
### Goal

> “Test whether the program correctly handles abnormal inputs.”

We’re looking for:
	- Crashes
	- Memory corruption
	- Unexpected behavior
	- Security vulnerabilities