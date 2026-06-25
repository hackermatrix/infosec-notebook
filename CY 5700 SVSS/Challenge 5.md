
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

which i think can be the of struct config conf 
![[Pasted image 20260624100429.png]]
 8d 83 79 e3 ff ff       lea    -0x1c87(%ebx),%eax