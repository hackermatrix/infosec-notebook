
## The main task 

Log into warhead, and take a look at the TCP service running on the IP address **192.168.1.77, port 4000**. 

![[Pasted image 20260510160049.png]]

Your task is to nicely ask this service for the solution token you need to submit to the grading system. And it will tell you, simple as that! …but something’s wrong. It looks like there’s interference in your communication channel, corrupting the data you receive

Write a C program to communicate with the server according to our custom secure transport protocol. Specifically, you have to: 1. **Open a TCP connection to the service socket**. 2. Follow the protocol and ask for the solution–more on this later. **You need to encrypt your message payload as described in the protocol. 3. When you receive a response, check its integrity. If it's good, fine. Otherwise, repeat step 2, ask again, repeat step 3, check integrity again, rinse & repeat until you get a message that’s not corrupted. So you finally got a good response, decrypted the message, and got the solution token? Great, but don't submit it for grading yet!** 

The token is a long byte sequence with **non-printable characters** and other gibberish in it. We want something nicer for grading, so you need to cook this raw token first. Specifically: 1. Compute the hash of the token, which will give you shorter (but still binary) data. 2. Encode this hash value in base64, which will represent the same data in printable characters only.


## The Cryptography

Sodium provides an API that can be used both for key derivation using a low-entropy input and password storage.

pacman -Qi libsodium

![[Pasted image 20260510173323.png]]



[Authenticated encryption | Libsodium documentation](https://libsodium.gitbook.io/doc/secret-key_cryptography/secretbox)


## Creating my own key 


[The pwhash* API | Libsodium documentation](https://doc.libsodium.org/doc/password_hashing/default_phf)


## Successful connection & Encryption 

![[Pasted image 20260513135315.png]]

https://libsodium.gitbook.io/doc/secret-key_cryptography/secretbox

## Decryption 

unsigned char decrypted[MESSAGE_LEN]; if (crypto_secretbox_open_easy(decrypted, ciphertext, CIPHERTEXT_LEN, nonce, key) != 0) { /* message forged! */ }

`c` is a pointer to an authentication tag + encrypted message combination, as produced by `crypto_secretbox_easy()`. 
`clen` is the length of this authentication tag + encrypted message combination. 

Put differently, `clen` is the number of bytes written by `crypto_secretbox_easy()`, which is `crypto_secretbox_MACBYTES` + the length of the message.

The nonce `n` and the key `k` have to match those used to encrypt and authenticate the message.

The function returns `-1` if the verification fails, and `0` on success. On success, the decrypted message is stored into `m`.

`m` and `c` can overlap, making in-place decryption possible.

https://libsodium.gitbook.io/doc/quickstart
