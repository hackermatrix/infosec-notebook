


### Finding what is Imported and the location of the library :
![[Pasted image 20260710160503.png]]

- It also has the base, but it varies at every execution (ASLR)

### Finding the Offset of System :
![[Pasted image 20260710160624.png]]

- the offset is : 0x528b0

 1d3808 /bin/sh


## How much is the variation is the base address  of libc ? :

![[Pasted image 20260710160733.png]]

- looking closely, we find that : 
	0xf7 | d1f | 000
	\[ fixed region ]\[ randomized part ]\[ page offset ]
- so,,,, we have 4096 possible addresses



### FInding the location of return address
![[Pasted image 20260710165238.png]]

![[Pasted image 20260710165101.png]]

- the title buffer is 268 bytes away from the ebp.
- SO, we have 256 byes title + 4 bytes canary and 8 bytes of something (maybe added by the compiler)
- So maybe we need to find the value of ebp to reach the return address.
- So, we now know that our return address is at 272 