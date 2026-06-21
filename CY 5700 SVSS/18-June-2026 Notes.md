Per the calling convention before the caller calls the calleee the arguments are pushed in the reverse order in the stack. First argument 2 goes and then argument 1. The hardware is designed like that. 

![[Pasted image 20260621104419.png]]

If you want to reference local data it is ebp - 8. 

Strings have a null byte. 
char buffer[100]
strcpy(bufffer,msg) 
it copies everyting till it is a null byte. 
msg has to be a string and not a null byte. 


if you crash something you get segmentation fault 
0x414141 in ?? ()'
Capital A is 0x414141 

Return address is the key. 

get_nobody is a convention for a user who has acccess to nothing. 

Use python as an array and then print that. 

python;s program does not use string python 3 print is a unicode we want a ram byte printer not an acii printer that is why use 
sys.stdout.buffer.write("asd") 

objdump is present on every linux ststem

for practise make an another function and make it vulnerable. 
look at the clues from the calling conventions 
abuse the fact ebp is the fixed point in stack. 

ebp -values are local data 
+values are arguments 
