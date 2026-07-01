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



