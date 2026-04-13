
When a buffer overflow overwrites the saved return address on the stack, the CPU detects the corruption immediately and raises a segfault before executing any malicious code.

✗ False. The CPU has no awareness that the return address has been tampered with. The corruption is only 'discovered' when the function executes 'ret', which pops the overwritten address into RIP and jumps there. The segfault (if any) occurs at that destination, not at the point of overflow.

