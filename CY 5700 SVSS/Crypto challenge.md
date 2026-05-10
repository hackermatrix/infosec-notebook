
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

Sodium's standard encryption function performs authenticated encryption, which is a combination of encryption and MAC.

[Authenticated encryption | Libsodium documentation](https://libsodium.gitbook.io/doc/secret-key_cryptography/secretbox)




