

Regularly use to Express their string pattern matching specifications had an Evil side?: **Regex**

https://secupress.me/blog/evil-regex-the-redos-case/
https://owasp.org/www-community/attacks/Regular_expression_Denial_of_Service_-_ReDoS


![[Pasted image 20260719144249.png]]

![[Pasted image 20260719145452.png]]

# Question 1 


Q1) Find a one-hit server resource exhaustion vulnerability **on the sign up page. That is, you need to send a single request that makes the server work unexpectedly hard, waste resources, and eventually throw a timeout.** **You’ll get your solution token with the timeout error.** This means **DDos
*
## Evil Regex*

https://owasp.org/www-community/attacks/Regular_expression_Denial_of_Service_-_ReDoS

https://stackoverflow.com/questions/12841970/how-can-i-recognize-an-evil-regex

**Evil Regex contains**:

- Grouping with repetition
- Inside the repeated group:
    - Repetition
    - Alternation with overlapping

**Examples of Evil Regex**:

- `(a+)+$`
- `([a-zA-Z]+)*$`
- `(a|aa)+$`
- `(a|a?)+$`



![[Pasted image 20260719151339.png]]

It said sign up page 

![[Pasted image 20260719154347.png]]
