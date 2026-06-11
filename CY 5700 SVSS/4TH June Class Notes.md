
## Client Server Model

![[Pasted image 20260609160054.png]]

it is abstract it missed details it never happens in practice. 
Web Proxy intermediary between client and server. 
It is never a single proxy there are layers and layers. 

## What is Web Proxy? 
It is an HTTP server understands the HTTP protocol forwards the request, change the request. 
In practise it can be **simple as load balancer**
It could be **web application firewall**.
it could be **anything a general purpose http server.** 

## Content Delivery Network (CDN)
Massively distributed networks of reverse proxies. 
Akamai is the biggest footprint of CDN. 
Forms an internet overlay network

Clients are us, our browsers. 
Customers of CDNS:-  governments, banks ,amazon, netflix. 
**Origin server is where the content originated from.**
**Edge server are plain old proxy.** 

BGP is not designed for performance. all the ISP, route traffic from A to B do not find the shortest path. 
BGP has zero security built in. 

Most CDN's ignore BGP, they have the internet overlay who do their own routing. 
Deploying such platform is super expensive. AWS, Azure has hundreds of data centers whereas Akamai have more data centers all over the world, distribution is important. 
**60% to 70% of internet is behind the CDN.** 

CDN are also recognized as **critical infrastructure in countries like Germany.** 
Akamai does not use partial caching. 

![[Pasted image 20260607154833.png]]
https://builder.aws.com/content/2wChJSmjrexaiedg3RNFA934NDl/application-security-origin-cloaking

## Web Caches 

You can't cache everything. 
Objects have to be publicly available & static objects. It can't be confidential or sensitive data.
Like electricity bill , only one person or family needs to access it will not be cached. 
Static objects, if the content changes everything it can't be cached. eg. stock market. 
https://aws.amazon.com/caching/

netflix film it is accessible to all netflix customers (10-20 Gb) it is static. 

There are experimental technology that does caching for dynamic objects. 
**e.g. where static part is cached on the edge location and the origin is fetched for the dynamic object.** 

Routing , waf you need to look inside traffic, you need to terminate TLS. You have multiple TLS hops. CDN's can see everything. **The whole security reason is nothing bad happens to the data during transit** 

if you are an origin server, how do you signal to cache or not. 
It is done through HTTP response headers like **Cache-Control: no-cache.** 
**The proxy obeys.** 

**Partial caching** is a performance optimization technique where an application caches only specific, frequently requested portions of a page, file, or data response, rather than caching the entire item.
### Cache-Control Headers 

Let us say you have a web application deployed to old school like IBM. You're caching policy changes saying that you can specifically cache anymore.  you need to go to each server to change cache-control. You will need to identify the servers, owners of the servers. Go through an entire change management process. This is a time-consuming process in practise, you have a (Content Delivery Network) CDN, eg. Akamai. Through a centralized portal they will check on Ignore 'Cache-Control Headers' From that point on Akamai servers will ignore this. Then and there you will set up your cache rules which will ensure all the servers follow it. 

- max-age=seconds
- no-store: it should not be cached
- no-cache 
- no-transform 
- public 
- private

The proxy **trusts you to define the headers.** 
 

Below is a response header 

![[Pasted image 20260608151435.png]]

### Caching Rules

You configure the cache to decide _what_ gets cached using rules based on:

- **File extension** — e.g., cache anything ending in `.jpg`, `.css`, `.js`
- **Regexes** — more flexible pattern matching, like "cache any URL matching `/static/.*`"
- **Headers** — e.g., cache responses with `Cache-Control: public` but not `Cache-Control: private`
- **Data** — could refer to response body, content-type, or other metadata

https://falconcloud.ae/about/blog/how-do-i-configure-cache-rules-on-a-cdn/

It is important to set up the caching rules correctly. 

Reason there is amazing refereshing button because northeastern in behind a cdn. 

![[Pasted image 20260608155154.png]]

To byass the cdn the button is there, what does it do. 

![[Pasted image 20260608155251.png]]

Click on more tools > Web developer tools 
![[Pasted image 20260608155429.png]]

Look at the headers. 
![[Pasted image 20260608155621.png]]

The `x-gateway-cache-status: HIT` header indicates that the API gateway or proxy handling your request already had a fresh copy of the resource saved in its memory. The gateway successfully served your response directly from that cache without having to contact the origin server

The `x-gateway-cache-key` is an unofficial HTTP response header used by proxies, Content Delivery Networks (CDNs), or API Gateways to identify the specific **cache key** generated for a given request.
if you look at the value in the picture you understand that the url and everything is included in the cache. 


Suppose you had an arbitary argument it changes the cache. 
![[Pasted image 20260608160046.png]]

This is why now you can see it as MISS, because it had to fetch the request from the origin. 

![[Pasted image 20260608160217.png]]



#### Difference between Cache Headers and Caching Rules 

**Cache-Control` headers are standardized HTTP tags sent directly by web servers to instruct browsers and CDNs how to handle content, while Cache Rules are custom, centralized configurations managed within a CDN or proxy dashboard (like Cloudflare or Akamai) to override or refine those default behaviors.


![[Pasted image 20260608154628.png]]


### Cache-Key 

A **cache key** is the unique identifier the cache uses to look up a stored response. Think of it as the "address" of a cached object.

For example; a cache key like `['node', 5]` might represent the cache entry for the rendered output of _node/5_.

Cache keys are precise. When you want to delete or retrieve a specific cache entry, the cache key ensures you’re interacting with the correct data. The specificity of cache keys means they work well for **individual items**, but they don’t help much when you need to invalidate multiple related items at once.

If _node/5_ appears in a block, a menu, and a view, each of these items has its own distinct cache key.

![[Pasted image 20260607163556.png]]

Read x-gateway-cache-status 

 
## Range Attacks 
 ![[Pasted image 20260607161554.png]]
HTTP defines the range header, Range: bytes=0-10240. If you define the range bytes and send to a server. The server will send the part requested 

The question is if you have a proxy in between what should it do with the header. 
Option 1: 
You can choose to do nothing about it. Take the request you receive & give it to the origin.  The origin will return the requested part. But if you do this the proxy misses out on the opportunity to cache. Because there is no such thing as partial object caching. 

Suppose you have a video file that is 1GB. If user wants only 10K of the gig file. If it is 5 people doing such request it is fine. But what if the video went super viral, you have millions of range request accessing different parts of the request. In such case you may have to cache this thing instead of going to the origin server.  Remember it does not do partial caching it caches the entire 1GB, and just gives the requested range. 

Option 2: 

- CDN **strips the Range header** before forwarding to origin
- Origin receives just `GET /video.mkv` — no Range header — so it returns the **entire 1GB file**
- CDN **caches the full 1GB**
- CDN then slices out bytes 0–10240 and returns just that to the client

What is the attacker re-arranges. 
![[Pasted image 20260609143840.png]]
**The attack:**

1. Attacker sends `GET /video.mkv Range: bytes=0-1` to Edge Server A (Boston)
2. Boston edge has never seen this file → cache miss → strips Range header → asks Netflix for the **entire 1GB**
3. Boston edge caches 1GB, returns 1 byte to attacker
4. Attacker now hits Edge Server B (Chicago) with the same `Range: bytes=0-1`
5. Chicago has its own cache, hasn't seen this file either → cache miss → asks Netflix for **another 1GB**
6. Chicago caches 1GB, returns 1 byte to attacker
7. Attacker repeats this across **hundreds of edge servers**


![[Pasted image 20260609145659.png]]


**The key insight:**

**The amplification factor is what makes it devastating. The CDN's Option 2 behavior (fetch the whole thing) is being weaponized, the attacker is essentially using Akamai's infrastructure _against_ Netflix's origin..** 

Side Note: This counts as a denial of service attack, the key thing to look for it is that it is asymmetric. Asymmetric means the Attacker spends a very little bandwidth request. 
if it is no costing much to the hacker, the hacker might not pursue it. 

Side Note: What does the CDN do then
The CDN today still do option 2, you design the system to handle the benign traffic , For the attack traffic, they monitor they try to detect and block it .

## POST Request 

### Header

![[Pasted image 20260609155242.png]]

### Body 
![[Pasted image 20260609155301.png]]

The `Content-Length: 509` in the headers tells the server "expect 509 bytes of body coming." The server reads the headers first, sees that number, then waits to receive that many bytes as the body.

### How Slowloris exploits this on POST

The attacker sends the headers normally (so the server doesn't time out), then **drip-feeds the body** — maybe 1 byte every 5 seconds. The server sees `Content-Length: 509`, knows more is coming, and keeps the connection open waiting. Multiply by thousands of connections → origin is holding thousands of open connections waiting for bodies that never fully arrive.

## Slowloris Attacks 
![[Pasted image 20260607161922.png]]


### Why is the origin vulnerable when edge streams slowly?

The edge opens a connection to the origin and starts forwarding data as it trickles in. That connection to the origin **stays open and waiting** the entire time.

So the attacker's slow request to the edge → becomes a slow, hanging connection from edge to origin.

Now imagine the attacker opens 10,000 parallel slow connections to the edge. The edge opens 10,000 parallel slow connections to the origin. The origin hits its connection limit → DoS.

The edge didn't absorb the attack — it **passed it through** to the origin. That's the vulnerability. The CDN is supposed to be a shield but in streaming mode it just becomes a pipe that forwards the slowloris behavior downstream.
Suppose you are sending you're origin a huge request a POST request. Edge can do one of the two things.


https://www.netscout.com/what-is-ddos/slow-post-attacks

![[Pasted image 20260607163831.png]]


### CDNs DO protect against classic Slowloris (GET requests)**

Attacker → slow connection → Edge Edge buffers the full request, THEN opens a fast connection to origin. Origin never sees the slow connection. It's shielded.


**But POST breaks that protection**

The edge has two bad choices:

**Stream immediately →** attacker's slow connection gets forwarded as a slow connection to origin. CDN is now just a pipe, not a shield. Origin is exposed to slowloris again.

**Buffer the full POST body first, then forward →** now every legitimate user's POST request has to be fully received and held in the edge's memory before origin gets it. For a site with millions of users uploading large files, this **destroys performance** — hence "obliterated website performance.

## URL 

![[Pasted image 20260607165320.png]]
![[Pasted image 20260607165414.png]]
If you click on i-love-pokemon,jpg link the worst case is you would expect a 404. 

it is a string, can be manipulated by the server. 

example.com/home/index.html

 Clean URL 

example.com/home/index/en/us

We do not expose the name of the argument. 
It is just a different way to write. 

### Example 

Web server is the bank application, web cache here can be standalone proxy or a CDN to cache stuff. Using sea surf or something the attacker makes the victim send the link. 

![[Pasted image 20260609161125.png]]

The proxy checks if it sees the link for the first time. It forwards the link to the origin. 

![[Pasted image 20260609161416.png]]

The server knows that the link does not exist, it may send a 404. If the web application server on which this thing is built on

It does reroute it depending on the framework. The invalid page goes away.

![[Pasted image 20260609162002.png]]



![[Pasted image 20260609162230.png]]

- The `?` signals "everything after this is a query parameter, not a file path"
- So the server runs `account.php` (which exists) and passes `nonexistent.jpg` as an **input parameter** to it
- `account.php` runs fine, does whatever it does with that parameter → **200**

![[Pasted image 20260609163237.png]]

This part is dangerous because the cache does not know this happened. This can cause misunderstanding between the cache and proxy it gives 200 Ok, 

It internally re-routed it, the web server is telling the web-cache I did some rerouting here but you do not remember it by doing CACHE-CONTROL;NO-store. Now this would have worked only if the Cache-control would have stayed as NO **but 99% of the company check the box that says ignore the CACHE-CONTROL error.** 

Because of this. 
any attacker who requests  a static file externsion `GET /account.php/nonexistent.jpg` gets the victim's **cached sensitive bank page** served directly from cache. **No authentication needed, no hitting the origin.**

The `.jpg` suffix tricked the cache into storing something it should never have stored.

![[Pasted image 20260609164130.png]]


E.g. Amazon 

![[Pasted image 20260610153140.png]]

In an attack scenario **We assume that fall back page is a sensitive page.** 

How do we know if the web page will return a sensitive page like account.php. 
## Web Cache Deception 

https://portswigger.net/web-security/web-cache-deception
Reroute is a usability thing cause 404 is ugly. server knows it doesn't exists and it gives a 200 success. 
![[Pasted image 20260607165805.png]]
##  HTTP Processing Discrepancy.

There are many different proxies like Akamai and stuff. So different proxies have different design decisions and different processing rules. 

In HTTP you have your standard headers like x-content-type-options
![[Pasted image 20260610155156.png]]
![[Pasted image 20260610155829.png]]
But there are also custom headers like Kaan's-Favourite-FF! It is meaningful for your application and no one else. 
![[Pasted image 20260607165921.png]]

The browser treats it as just another key-value pair it's carrying along — it has no idea what it means.

On the server side, your application code explicitly reads it:

python

```python
# Flask example
fav = request.headers.get("Kaan's-Favorite-FF!")
# fav = "VIII"
```

If the application doesn't have code to read that header, it's simply **ignored**. Nothing breaks.

![[Pasted image 20260610160053.png]]

Per this specification it says you can't send this ? 
![[Pasted image 20260610160145.png]]

Example of leveraging this ? 
![[Pasted image 20260610160843.png]]

The web server does input sanitization and just removes this. This has got fixed now. 

![[Pasted image 20260610161229.png]]


? - Bad request 

Cache purging. 

in the challenge 0\r\n

Content length - decimal 
Chunked encoding hexadecimal 

\r\n should be counted as content-length 
 
## Web Cache Poisoning 

![[Pasted image 20260607171012.png]]
## Content-Length Encoding 

Parsing the request and headers is trivial they have terminators. 

![[Pasted image 20260610163345.png]]

The body does not have a terminator. You need to indicate to the server where your header ends and that is done by 'Content-Length Encoding.

Content-Length: 16 tells here that after you are done with the header you should read 16 bytes. The next data is from the next request. 

`query=funny+cats` is exactly 16 bytes — so the server reads those 16 bytes and considers the request complete.
## Chunked Encoding 

![[Pasted image 20260610165256.png]]

In chunked encoding the terminator is at the end of each 
![[Pasted image 20260610165912.png]]

![[Pasted image 20260610170816.png]]
![[Pasted image 20260610171045.png]]

![[Pasted image 20260607171023.png]]
https://en.wikipedia.org/wiki/Chunked_transfer_encoding

### Disagreement between the origin server and proxy on transfer encoding and content-length

The disagreement comes from the fact that **proxies and origin servers are built by different people and may handle ambiguous requests differently.**


**The specific ambiguity: what if a request has BOTH headers?**

```
POST /search HTTP/1.1
Host: example.com
Content-Length: 16
Transfer-Encoding: chunked

...body...
```

HTTP spec says if both are present, **chunked wins**. But not every proxy/server follows this correctly.

**Where the disagreement happens:**

![[Pasted image 20260610172651.png]]

![[Pasted image 20260610173119.png]]


**Left side — Proxy uses Content-Length: 32**


The proxy counts exactly 32 bytes from the body. Let's count:

```
0\r\n                        = 3 bytes
\r\n                         = 2 bytes
GET /img/x.jpg HTTP/1.1\r\n  = 24 bytes
X:                           = 2 bytes (+ 1 space = 3?)
```

That adds up to roughly 32 bytes → proxy thinks the **entire thing including the smuggled GET is the body** of the POST. It forwards all 32 bytes to the origin as one request. Nothing smuggled.

---

**Right side — Origin uses Transfer-Encoding: chunked**

Origin sees `0\r\n\r\n` → that means **chunk size 0, body is done**. Request ends there.

Everything after — `GET /img/x.jpg HTTP/1.1\r\nX:` — is treated as a **brand new request** sitting in the persistent connection pipeline


![[Pasted image 20260610173638.png]]

The next user is just a normal request this is going to be forwarded to the proxy and it is going to look like this In this example it could be a simple cache poisoning but it is not known as HTTP Request Smuggling because you smuggled your request and directly hit the origin and it gets triggered later. 
![[Pasted image 20260610174320.png]]

The origin can;t read all of this it looks like the X got appended in the next header. 

## HTTP Request Smuggling

![[Pasted image 20260611101624.png]]
### Example 1: Bypassing Access Control 
![[Pasted image 20260611102002.png]]
![[Pasted image 20260611102817.png]]


---

**What the attacker sends (one request):**

```
POST /public HTTP/1.1
Content-Length: ...
Transfer-Encoding: chunked

0\r\n
\r\n
GET /admin HTTP/1.1\r\n
X:
```

---

**Step 1 — Proxy reads it (uses Content-Length):**

Proxy counts all the bytes including `0\r\n\r\nGET /admin HTTP/1.1\r\nX:` and says "this is all one POST body." Forwards everything to origin as one request. Access control check passes because the outer request is to `/public` which is allowed.

---

**Step 2 — Origin reads it (uses chunked):**

Origin sees `0\r\n\r\n` → body is empty, POST is done.

Now `GET /admin HTTP/1.1\r\nX:` is **sitting in the pipeline** as a pending request.

---

**Step 3 — Next legitimate user sends their request:**

```
GET / HTTP/1.1
Host: example.com
```

Origin **combines** the leftover smuggled part with this new request:

```
GET /admin HTTP/1.1
X: GET / HTTP/1.1
Host: example.com
```

- Origin processes `GET /admin` — the restricted endpoint the attacker wanted
- The legitimate user's `GET /` gets swallowed into the `X:` header  it becomes invisible, just a header value
- The legitimate user gets back the `/admin` response instead of their own page ,completely confused

**The two things that make this work:**

1. **`X:` is a deliberately incomplete header — it has no value yet, so it "absorbs" the next request as its value, neutralizing it**
2. The proxy never saw `GET /admin` — it only saw `POST /public` so **access control was never checked** for the admin request


HTTP 2.0 is a very different protocol not just in terms of semantics but also structure it does not have content length and does not have transfer encoding. 

### Example 2:  Leaking user request. 

![[Pasted image 20260611104838.png]]

The proxy reads the content-length and forwards everything to the origin. 
The attacker includes his own cookie. eg. his reddit session 

Now suppose a poor victim is trying to read the home page of the reddit. The home page get request gets appended here 

![[Pasted image 20260611105447.png]]

For server, it looks like attacker is trying to comment 



