Demo Lab

When a buffer overflow overwrites the saved return address on the stack, the CPU detects the corruption immediately and raises a segfault before executing any malicious code.

✗ False. The CPU has no awareness that the return address has been tampered with. The corruption is only 'discovered' when the function executes 'ret', which pops the overwritten address into RIP and jumps there. The segfault (if any) occurs at that destination, not at the point of overflow.

In login.c, check_authentication() declares local buffers in this order: password_buffer[TEAM_VAR_SIZE], username_buffer[16], auth_flag. On a typical x86-64 stack frame (higher addresses = older data), which layout is most likely and why does it matter for exploitation?

✗ On x86-64 the stack grows downward. Locals declared first (password_buffer) sit at lower addresses; later ones (username_buffer, then auth_flag) sit at progressively higher addresses. Overflowing password_buffer upward crosses username_buffer and reaches auth_flag. This is why declaration order in C directly affects exploitability.

![[Pasted image 20260413193540.png]]
![[Pasted image 20260413194031.png]]

![[Pasted image 20260413194103.png]]

![[Pasted image 20260413194344.png]]
![[Pasted image 20260413195232.png]]
