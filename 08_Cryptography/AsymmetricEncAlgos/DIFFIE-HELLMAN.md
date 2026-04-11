![[Pasted image 20260223145855.png]]

- It’s a way for **two people to create a shared secret key over the internet** —  even if someone is listening to everything.

Step1 :

Alice and Bob agree on two public numbers:
- Prime number: **p = 23**
- Base number: **g = 5**

Step 2 :
- Alice chooses secret number: **a = 6**
- Bob chooses secret number: **b = 15**
These are NEVER shared.

Step3 :
#### Alice computes:
	 A=g^a mod p
	 A=5^6 mod 23
	 15625 mod 23 = 8

So Alice sends **8** to Bob.


