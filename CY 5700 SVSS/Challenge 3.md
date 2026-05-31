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


## SQL injection to login to bob. 

SELECT * FROM users WHERE username = 'bob’ - -’ AND password = 'anything';

https://www.sentinelone.com/cybersecurity-101/cybersecurity/types-of-sql-injection/


![[Pasted image 20260531154710.png]]


https://infosecwriteups.com/from-sql-injection-to-weak-passwords-a-deep-dive-into-a-tamil-nadu-government-security-flaw-1b648d62d457
![[Pasted image 20260531155053.png]]
