# Connecting to the lab environment

ssh -4 -D 9090 -p 10001 hacker22@warhead.khoury.northeastern.edu

# Understanding challenge 

![[Pasted image 20260530103509.png]]

![[Pasted image 20260530104203.png]]

![[Pasted image 20260530104345.png]]
![[Pasted image 20260530104357.png]]
![[Pasted image 20260530120356.png]]


![[Pasted image 20260530120323.png]]

First change of thought it says SQLi, XSS, and CSRF in action.

## Inspect I 
![[Pasted image 20260530120837.png]]
My hacker token is remebered. 
![[Pasted image 20260530120911.png]]
HttpOnly:true

Remembering from classnotes: If you set httponly = true that means cookie cannot be sent through document.cookie() or javascript 


## Purchase an item with an account you create.

### Inspecting input 

![[Pasted image 20260601124105.png]]

![[Pasted image 20260601124900.png]]

![[Pasted image 20260601124925.png]]
![[Pasted image 20260601125002.png]]


![[Pasted image 20260601124941.png]]

### Inspecting I the first page 

![[Pasted image 20260601125142.png]]

All the src images seem fine

### Hints

![[Pasted image 20260601125827.png]]


## SQL injection to login to bob. 

SELECT * FROM users WHERE username = 'bob’ - -’ AND password = 'anything';

https://www.sentinelone.com/cybersecurity-101/cybersecurity/types-of-sql-injection/


![[Pasted image 20260531154710.png]]


https://infosecwriteups.com/from-sql-injection-to-weak-passwords-a-deep-dive-into-a-tamil-nadu-government-security-flaw-1b648d62d457
![[Pasted image 20260531155053.png]]


