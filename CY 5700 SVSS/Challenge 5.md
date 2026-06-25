
Debuggers behave differently with privileged processes to prevent unprivileged ones to prevent security attacks. unprivileged users could debug privileged programs, they could easily take control of the whole system

![[Pasted image 20260623050701.png]]
![[Pasted image 20260623051123.png]]
`sun` is an executable program. Two facts about it matter:

1. It's owned by the **group** `prog10`.
2. Its **setgid bit** is set.


-rwsr-xr-x  1 grader grader  16360 May 31 01:38 win

![[Pasted image 20260623051535.png]]

![[Pasted image 20260623170033.png]]
![[Pasted image 20260625115128.png]]


**One thing to keep in mind check the lea and push arguments before the call function** 

# Calculating the address of buf

**`argv[1]`**: The **first user-provided argument**.

![[Pasted image 20260623174134.png]]
 
now if we look at the objdump of read_file 

![[Pasted image 20260625141922.png]]

you see lea after the first push now let';s recall the calling convention when the caller function (main) calls the callee function (read_file) arugments are pushed in the reverse order in the stack 

![[Pasted image 20260625121455.png]]

so the address of the buf will be second lea -0x848 before the second push 

![[Pasted image 20260625121743.png]]


Now, we find the address of the input &buf which is 0x848  that we send , something we can control. 


Then the code part which is vulnerable is this part where if current year is greater than equal to hydrogen it executes success otherwise it executes this part that the program only works after the sun's exhaustion. per the output. 

![[Pasted image 20260625060809.png]]

![[Pasted image 20260625060358.png]]
# Find the address of conf

The distance to the **start** of `conf`. Now we want hydrogen in the conf 

![[Pasted image 20260625061358.png]]

![[Pasted image 20260625123908.png]]
conf is here , which holds hydrogen 

![[Pasted image 20260625142105.png]]

&conf is -0x428

0x848 - 0x428 = 1056

![[Pasted image 20260625142311.png]]

Now we know from char till conf. Now we need to find the distance till that of hydrogen. 

# Calculating hydrogen location from conf 

We know in the source code hydrogen in being compared 

![[Pasted image 20260625144906.png]]
and we can see that there are 6 mov. 

![[Pasted image 20260625144830.png]]

`long long` is **64 bits**, but x86 32-bit registers are only **32 bits wide**. The CPU physically cannot hold a `long long` in one register. So the compiler splits every 64-bit value into two 32-bit halves and uses two registers:

```
eax = low  32 bits (bits  0–31)
edx = high 32 bits (bits 32–63)
```

The low 32 bits are always at the **lower address** on a little-endian system (which x86 is). So. 
0x408 is 1032.

so 1056 + 1032 = 2088 

And then we now we need to fill the next 8 bytes so that makes it 2088+8 = 2096. 


