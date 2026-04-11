
### 1. ECB (Electronic Code Block)

![[Pasted image 20260223144752.png]]

### 2. CIPHER BLOCK CHAINING (CBC) MODE
![[Pasted image 20260223144833.png]]
- IV is XORed with plain text block and then encrypted.

### 3. CFB (Cipher Feedback)
![[Pasted image 20260223144914.png]]
- The Encrypted IV is XORed with the plain text block and the result is used as IV for the next block.


### 4. OFB (Output Feedback)
![[Pasted image 20260223144933.png]]

- The Encrypted IV is directly used as the IV for the next block.