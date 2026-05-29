# Get_time
## Analyze the code. 

When I run the code I see. 

![[Pasted image 20260523191815.png]]

![[Pasted image 20260523191547.png]]

Using strings function trying to analyze the code. 
strings - print the sequences of printable characters in files

![[Pasted image 20260523191658.png]]

I can see date function here. 

when I type date 
![[Pasted image 20260523191852.png]]

## Creating exploit 
I created a date file 
![[Pasted image 20260523192607.png]]

## List the environment variables

![[Pasted image 20260523192736.png]]

The file is in this path: 
![[Pasted image 20260523192830.png]]

and my program is here. 
![[Pasted image 20260523192903.png]]

## Adding the exploit file path 

I will add the exploit file path 
![[Pasted image 20260523194149.png|617]]

Checking the initial user id 

![[Pasted image 20260523194056.png]]

Id got changed. 

![[Pasted image 20260523194424.png]]

![[Pasted image 20260523194620.png]]

22--oJ1C1hPZOZr_ybC6upKOw-22

# Get_IP

## Analyzing the code 

It does ask for the interference 
![[Pasted image 20260523195207.png]]

If you give the wrong interface it gives error 
![[Pasted image 20260523195550.png]]

![[Pasted image 20260523200247.png]]
![[Pasted image 20260523200313.png]]

system()

## ltrace 

![[Pasted image 20260525141057.png]]

https://man7.org/linux/man-pages/man1/ltrace.1.html
**ltrace** is a program that simply runs the specified _command_ until it exits.  It intercepts and records the dynamic library calls which are called by the executed process and the signals which are received by that process.  It can also intercept and print the
system calls executed by the program.

![[Pasted image 20260525141806.png]]

![[Pasted image 20260525144445.png]]

`/usr/bin/tail` command in Unix/Linux systems ==outputs the final part of a file or piped data to the terminal==

Trying to see system() 
![[Pasted image 20260525145224.png]]
![[Pasted image 20260525145308.png]]
![[Pasted image 20260525145414.png]]


![[Pasted image 20260525150342.png]]


## Blacklisting bypass 

https://forum.hackthebox.com/t/bypassing-other-blacklisted-characters/255983

![[Pasted image 20260525153121.png]]

![[Pasted image 20260525153847.png]]


Let us debug this '('. 
https://oneuptime.com/blog/post/2026-01-24-bash-syntax-error-unexpected-token/view

![[Pasted image 20260525162736.png]]
/usr/bin/ip addr show dev lo $(bash)

https://eitca.org/cybersecurity/eitc-is-lsa-linux-system-administration/bash-scripting/bash-variables-and-quoting/examination-review-bash-variables-and-quoting/what-is-command-substitution-in-bash-and-how-is-it-done/

I did this then 
![[Pasted image 20260525170414.png]]

it is not giving and error which means that I cannot see it i just need to send the file somewhere. 

So i send the file somewhere else. 
![[Pasted image 20260525170543.png]]

![[Pasted image 20260525165556.png]]

It is a second shell

I tried submitting it. 
![[Pasted image 20260525170640.png]]

![[Pasted image 20260525170701.png]]

22-7nsRP_spFss37IfMSatCxQ-22

# Fantasy_pub_generator:

## Analyzing the code. 

![[Pasted image 20260526125741.png]]

## Looking at the hints 
![[Pasted image 20260526125826.png]]
## Strings 
![[Pasted image 20260526125942.png]]
![[Pasted image 20260526125958.png]]
![[Pasted image 20260526130021.png]]

## ltrace 

![[Pasted image 20260526130218.png]]

Ltrace shows that dlopen does open in my directory 

Couple of things here one is getpwuid, dlopen, dlsym, dlerror & dlcose. 

![[Pasted image 20260526132915.png]]

## Bypassing 

So i know it is this libpub.so which is calling it. but i know that it does call it here 
dlopen("/home/hackers/hacker22/libpub.so"..., 2)

So i created a file name as libpub.c  and compiled it but i got this error 
![[Pasted image 20260526140720.png]]

So I knew it needed a function named as generate

![[Pasted image 20260526140555.png]]

![[Pasted image 20260526140956.png]]

Compiled it like this.
![[Pasted image 20260526141127.png]]


https://pubs.opengroup.org/onlinepubs/009695399/functions/getpwuid.html

https://man7.org/linux/man-pages/man3/dlopen.3.html

https://man7.org/linux/man-pages/man3/dlsym.3.html

https://www.geeksforgeeks.org/operating-systems/static-and-dynamic-linking-in-operating-systems/

## Output 

Then ran 

![[Pasted image 20260526135906.png]]

![[Pasted image 20260526140135.png]]

22-8xKHl1CoR1NtRlwAgBSp0A-22

# prog5do

like sudo, but for prog5; run a target command with prog5’s privileges

![[Pasted image 20260526141457.png]]
![[Pasted image 20260526141807.png]]

you can;t even cat it 
![[Pasted image 20260526141859.png]]
![[Pasted image 20260527135952.png]]

This is the biggest clue though as hacker22 i have the rw permissions i could not cat it. 
Then it says user blocked by ACL. 

There is a symlink to it 
https://www.freecodecamp.org/news/symlink-tutorial-in-linux-how-to-create-and-remove-a-symbolic-link/

## ltrace 

I think it does strncmp with my privileges to that of the hacker which is 6. 
![[Pasted image 20260526143946.png]]

![[Pasted image 20260526145201.png]]

![[Pasted image 20260526180723.png]]

![[Pasted image 20260527134244.png]]

Only the root has access to the acls 

![[Pasted image 20260526145220.png]]

read(3, "# allowlist\nbob kaan root grader"..., 1024)

Linux system call (`read`) attempting to read up to \(1024\) bytes from a file descriptor (`3`) into a buffer containing an allowlist of usernames (`bob`, `kaan`, `root`, `grader`)

![[Pasted image 20260526150700.png]]
![[Pasted image 20260526150714.png]]

### Open 

#### ACL.txt 

Open function are in the two parts one is for opening the acl 

![[Pasted image 20260527134443.png]]

In the context of the C and POSIX `open()` system call, passing `0` as the `flags` parameter signifies **read-only access** (equivalent to `O_RDONLY`) with no additional options. (just read the file, don't create it)
[[1](https://stackoverflow.com/questions/42119595/open-system-call-with-parameter-0-as-a-flag), [2](https://www.reddit.com/r/C_Programming/comments/1cnmj6g/posix_and_o_readonly/)]
![[Pasted image 20260527132925.png]]

![[Pasted image 20260527134613.png]]

#### error.txt


![[Pasted image 20260527135131.png]]

![[Pasted image 20260527135452.png]]

![[Pasted image 20260527135555.png]]

### strtok

The **`strtok`** function in C **splits a string into smaller pieces called tokens** based on specified delimiter characters. It belongs to the `<string.h>`

### `memset
a standard C/C++ function used to fill a specified block of memory with a particular byte value==

I could not see the paths so I did this 

ltrace -s 1000 prog5do echo
![[Pasted image 20260526151755.png]]

This is the allowlist of graders 
![[Pasted image 20260526151818.png]]

### Figuring out the environment variables 
![[Pasted image 20260526154732.png]]

Tried chanding the environment variable 

![[Pasted image 20260526160647.png]]

![[Pasted image 20260526160735.png]]

### Exploit flow 

#### Step 1: Delete the file 
![[Pasted image 20260527142304.png]]

#### Step 2: Create symlink

```bash 

ln -s /usr/local/share/acls/22-PzWs2RGx3wRiLImVqtQNUQ-22/acl.txt ~/prog5do-error.txt

```

####  Step 3: Run prog5do with a command

```
prog5do "hacker22 x"
```


Inside prog5do's execution:

1. Reads the ACL file: `acl.txt` contains `# allowlist`, `bob kaan root grader`
2. Tokenizes and searches: `strcmp("hacker22", "bob")`, `strcmp("hacker22", "kaan")`, ... all fail
3. Access denied — writes error log
4. Opens `~/prog5do-error.txt` with `open(..., O_CREAT|O_WRONLY, 0644)`
5. **The kernel follows the symlink** → actually opens `/usr/local/share/acls/.../acl.txt`
6. Writes the message: `hacker22 x: Permission denied. User blocked by ACL.`
7. Closes the file

#### **Step 4: Verify it worked**

bash

```bash
cat /usr/local/share/acls/22-PzWs2RGx3wRiLImVqtQNUQ-22/acl.txt
```

Output shows:

```
hacker22 x: Permission denied. User blocked by ACL.
```

Your name is there as the first whitespace-delimited token!

#### Step 5: Run prog5do with the real command**

bash

```bash
prog5do win
```

Now when prog5do reads acl.txt:

1. Tokenizes: `strtok(..., " \n")` → first token is `hacker22`
2. Searches: `strcmp("hacker22", "hacker22")` → **match!**
3. Access granted — executes `/usr/local/bin/win` with group prog5 privileges
4. Prints token

![[Pasted image 20260527142952.png]]

22-N4VttUWMDpOdxcZ_toY_cQ-22
# moon 

## Understanding the code 

![[Pasted image 20260527143933.png]]

## ltrace

![[Pasted image 20260527144101.png]]
![[Pasted image 20260527144118.png]]
![[Pasted image 20260527144143.png]]


## understanding moon file 

![[Pasted image 20260527144427.png]]
I can cat the moon.ini file 

![[Pasted image 20260527144551.png]]


![[Pasted image 20260529160228.png]]

![[Pasted image 20260529160357.png]
the db-path is gibberish 
![[Pasted image 20260527144611.png]]

## Tring the manipulating the file 

![[Pasted image 20260527151032.png]]

![[Pasted image 20260527151047.png]]

![[Pasted image 20260527151142.png]]

It does strncmp here so maybe i need to do keep the same database. 

When i change the db-type from binary to string i get this 
![[Pasted image 20260527160049.png]]

When i change to timestamp 

![[Pasted image 20260527160126.png]]


I tried adding data-type of one more thing and it gave me this error. When I did ltrace i  saw this 

![[Pasted image 20260527161617.png]]

![[Pasted image 20260527161748.png]]

![[Pasted image 20260527163514.png]]

### System gets called when there is error in db-type 

### There is string compare with db-type 

![[Pasted image 20260527163935.png]]

IN THE .ini file doesn;t matter namiing and path with the sym link , the %s in the ltrace can be exploited.

Even when i type the three names , i get only two %s, %s

![[Pasted image 20260529161741.png]]

![[Pasted image 20260529161231.png]]

### Analyzing the sprintf and system 


snprintf("/usr/bin/grep db-type "/home/hackers/hacker22/moon.ini" | /usr/bin/grep -v "^#"", 512, "/usr/bin/grep %s "%s" | /usr/bin/grep -v "^#"", "db-type", "/home/hackers/hacker22/moon.ini") = 79

The full line you provided looks like arguments for a string formatting function (like `snprintf` in C).

- **`/usr/bin/grep db-type`**: Searches for the text "db-type" inside a file.
- **`"/home/hackers/hacker22/moon.ini"`**: The specific configuration file being searched.
- **`|` (Pipe)**: Sends the output of the first search into the next search tool.
- **`/usr/bin/grep -v "^#"`**: Filters out lines that start with a hashtag.
    - `-v` means "invert match" (exclude these lines).
    - `^#` means "starts with #".
    - **Purpose**: This removes commented-out lines so you only see active configuration settings.

- **`"/usr/bin/grep %s "%s"`**: The base template string. The `%s` markers are placeholders for text variables.
- **`512`**: The maximum buffer size allocated in memory to prevent security bugs like buffer overflows.
- **The variables**: The code injects `db-type` and the file path into those `%s` placeholders to safely build the final command line.

### Important thing to note in sprint 
- The 1st `%s` gets replaced by **`db-type`**
- The 2nd `%s` gets replaced by **`/home/hackers/hacker22/moon.ini

what if i slink the /home/hackers/hacker22/moon.ini with a bash shell 

