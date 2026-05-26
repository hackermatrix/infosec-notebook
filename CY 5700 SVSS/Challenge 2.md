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

## ltrace 

I think it does strncmp with my privileges to that of the hacker which is 6. 
![[Pasted image 20260526143946.png]]

![[Pasted image 20260526145201.png]]

![[Pasted image 20260526180723.png]]

Only the root has access to the acls 

![[Pasted image 20260526145220.png]]

read(3, "# allowlist\nbob kaan root grader"..., 1024)

Linux system call (`read`) attempting to read up to \(1024\) bytes from a file descriptor (`3`) into a buffer containing an allowlist of usernames (`bob`, `kaan`, `root`, `grader`)

![[Pasted image 20260526150700.png]]
![[Pasted image 20260526150714.png]]

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
