![[Pasted image 20260518134713.png]]
https://medium.com/@rakesh.therani/clickhouse-swarm-clusters-with-antalya-a-complete-guide-b3d624fb5a51

![[Pasted image 20260518140019.png]]

To be honest i read through everything there is nothing as cipher drift compute swarm 

## Bit error rates may exceed nominal operating ranges. 
![[Pasted image 20260518140730.png]]


When i run the same key and the same solution again I get this 
![[Pasted image 20260518143052.png]]

So I tried googling this 

when libsodium authentication and encryption is taking long: 

METHODS I AM THINKING! 

- **Switch to XChaCha20-Poly1305:** For general secret-key encryption, use the `crypto_secretbox_xchacha20poly1305` API for optimal hardware-accelerated speeds on most modern processors.
- https://docs.rs/crypto_secretbox/latest/crypto_secretbox/
- https://medium.com/apptastic-coder/have-you-heard-chacha20-poly1305-580586e47347
- 
- **Optimize Memory Allocation:** Avoid frequent `malloc()` or `calloc()` calls by reusing fixed memory buffers to hold your ciphertexts. [[1](https://stackoverflow.com/questions/22450518/encryption-using-libsodium), [2](https://libsodium.gitbook.io/doc/password_hashing/default_phf), [3](https://libsodium.gitbook.io/doc/public-key_cryptography/authenticated_encryption)]


Another one
https://libsodium.gitbook.io/doc/secret-key_cryptography/aead  - do not go with this. 
Very large messages should be split in multiple chunks instead of being encrypted as a single ciphertext:

- This keeps memory usage in control,
    
- A corrupted chunk can be immediately detected before the whole ciphertext is received,

I tired printing size of the payload

## Hints from professor
Noise can be random

it is based on the number of tries you send. 

with the bad message try to recover the good message. 

Needs to pass the MAC check 