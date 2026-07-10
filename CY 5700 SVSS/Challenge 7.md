
# Understanding the challenge 

![[Pasted image 20260710135721.png]]


Defeat Non-Executable stack 

Ret 2 lib - RECOMMENDED
Rop 

Defeat Stack Canary 

Brute - force 
guessing 

![[Pasted image 20260710140057.png]]
# How the code functions

https://linux.die.net/man/1/nc

![[Pasted image 20260710142437.png]]
![[Pasted image 20260710142747.png]]



![[Pasted image 20260710142256.png]]
![[Pasted image 20260710142839.png]]

## Code


![[Pasted image 20260710140550.png]]

![[Pasted image 20260710140611.png]]
![[Pasted image 20260710140842.png]]
![[Pasted image 20260710140914.png]]
![[Pasted image 20260710140935.png]]

# Finding the vulnerability

![[Pasted image 20260710150634.png]]

![[Pasted image 20260710150711.png]]
 So i know buf_size 512 is allocated. 

This is called once per connection (remember, `main()` forks a new child for every `accept()`, and each child calls `process(accept_sock)` on its own copy of this socket). `buf` is a 512-byte array sitting on this function's stack frame.

len = read(sock, buf, CHUNK_SIZE);

`read()` does _not_ null-terminate anything, and it doesn't care what's in the bytes — it just copies raw bytes off the socket into `buf`. So if you send `"hi"`, `len` is 2, and only the first 2 bytes of `buf` are meaningfully set — the rest of `buf` still has leftover stack garbage from whatever used that memory before.  This function's own `read()` is capped safely at `CHUNK_SIZE`, so there's no overflow here directly

read(sock, buf, CHUNK_SIZE);
     ^      ^      ^
     |      |      |
     |      |      +-- "read AT MOST this many bytes"
     |      +--------- "put the bytes HERE" (destination address)
     +---------------- "read FROM this file descriptor"

if (len == -1) {
        die_perror("Cannot read from socket");
    } else if (len == 0) {
        puts("Received nothing, moving along");
    } else { /* Small reads are okay. */


# On brief reading I don;t really find any vulnerability in judge 

![[Pasted image 20260710155059.png]]


