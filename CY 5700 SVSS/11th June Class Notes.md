Midterm: Until the end of lecture, Challenge 4, piazza. 
don't memorize syntax 
look at design 
look at snippet of the code - if you know the language 
abstract and theory questions. 
no more than 90 minutes 

Why not use encryption mechanism to protect proxies. 
Suppose the web-origin is encrypted. 
Proxy and the origin need to share keys. 
Data is encrypted on the cache 
it gets decrypted when it reaches you. 
even with all of this attacker is just a normal user you can;t really 
By encrypting it you are making content unique for each user and defying the purpose of cache. 

## HTTP Parameter Pollution 

What happens if you send multiple parameters with the exact same name in an HTTP request? 

www.example.com/login?id=kaan&id=bob

Behaviour depends on implementation!

This applies to everything that takes parameters

Real Example: Blogger 

If you standardized parsing you will still need to understand that it is not your own code. You may not have much control since this is not your third party system. 

Make your error messages consistent. 

Side Channel Attack - A More Subtle Example. 

## Three Modern Mechanisms 

With Content Security Policy (CSP) you are making the SOP stricter. 
SOP
**Same Origin Policy is important** 

Cross-Origin Resource Sharing (CORS)
Sub resource Integrity (SRI)

## Confused Deputy 


## CSRF Tokens 


