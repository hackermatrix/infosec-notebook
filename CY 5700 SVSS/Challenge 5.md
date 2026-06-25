
Debuggers behave differently with privileged processes to prevent unprivileged ones to prevent security attacks. unprivileged users could debug privileged programs, they could easily take control of the whole system

![[Pasted image 20260623050701.png]]
![[Pasted image 20260623051123.png]]
`sun` is an executable program. Two facts about it matter:

1. It's owned by the **group** `prog10`.
2. Its **setgid bit** is set.



-rwsr-xr-x  1 grader grader  16360 May 31 01:38 win

![[Pasted image 20260623051535.png]]

![[Pasted image 20260623170033.png]]

read_file(buf, argv[1]);
**`argv[1]`**: The **first user-provided argument**.

![[Pasted image 20260623174134.png]]
 f file descriptor 4 bytes, 
 buf +cur puts the content of the file into this 

![[Pasted image 20260625054531.png]]
-0x848(%ebp),%eax

Then the code part which is vulnerable is this part where if current year is greater than equal to hydrogen it executes success otherwise it executes this part that the program only works after the sun's exhaustion. per the output. 

![[Pasted image 20260625060809.png]]

![[Pasted image 20260625060358.png]]

![[Pasted image 20260625060254.png]]

0x428

0x848 - 0x428 = 1056

The distance to the **start** of `conf`. Now we want hydrogen in the conf 

![[Pasted image 20260625061358.png]]

