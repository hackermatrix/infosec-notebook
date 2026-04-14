
1. Set up requirements, making sure gcc and stuff is already installed. 

Calculate your team_var[xx] size
xx = (team_member NUID % 512)
2590422 % 512 = 214


![[Pasted image 20260401093728.png]]

![[Pasted image 20260401093533.png]]

.



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













