
1. Set up requirements, making sure gcc and stuff is already installed. 

Calculate your team_var[xx] size
xx = (team_member NUID % 512)
2590422 % 512 = 214

![[Pasted image 20260401085251.png]]

```c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TEAM_VAR_SIZE 214   // your xx value: 2590422 % 512 = 214

int check_authentication(char *username, char *password) {
    int auth_flag = 0;
    char team_var[TEAM_VAR_SIZE];
    char username_buffer[16];
    char password_buffer[16];

    strcpy(username_buffer, username);
    strcpy(password_buffer, password);

    if (strcmp(username_buffer, "This doesn't matter") == 0 &&
        strcmp(password_buffer, "neither does this") == 0) {
            auth_flag = 1;
    }
    return auth_flag;
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <username> <password>\n", argv[0]);
        exit(0);
    }

    if (TEAM_VAR_SIZE == 0) {
        printf("\nPlease set the Team Var before moving forward with the lab.\n");
    }

    if (check_authentication(argv[1], argv[2]) == 1) {
        printf("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n");
        printf("      Access Granted.\n");
        printf("\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n");
    } else {
        printf("\nAccess Denied.\n");
    }
    return 0;
}

Trying to understand the code. 

**`check_authentication()` function:**

- Declares `auth_flag = 0` (0 = denied, 1 = granted)
- Three buffers are on the stack in this order:
    - `team_var[214]` — padding buffer (your unique size)
    - `username_buffer[16]` — only 16 bytes!
    - `password_buffer[16]` — only 16 bytes

The `strcmp` check uses hardcoded credentials that you don't know — so you **can't** log in legitimately.

**`main()` function:**

- Takes username and password as command-line arguments (`argv[1]`, `argv[2]`)
- Checks `TEAM_VAR_SIZE != 0` (makes sure you've set it)
- Calls `check_authentication()` and prints Access Granted or Denied

```

![[Pasted image 20260401093728.png]]

![[Pasted image 20260401093533.png]]


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













