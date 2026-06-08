
System Security 

Web Application Attacks 2.0 (a.k.a Why the internet is Doomed)

## Client Server Model
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

 
 # Range Attacks 
 ![[Pasted image 20260607161554.png]]
HTTP defines the range header, Range: bytes=0-10240 

Does denial of service, it is asymmetry. Attacker spends very little request. 

if it is no costing much to the hacker, the hacker might not pursue it. 
If you design the system to handle the benin traffic , they monitor they try to detect it. 


# Slowloris Sttacks 
![[Pasted image 20260607161922.png]]

https://www.netscout.com/what-is-ddos/slow-post-attacks

![[Pasted image 20260607163831.png]]
# URL 

![[Pasted image 20260607165320.png]]
![[Pasted image 20260607165414.png]]
it is a string, can be manipulated by the server. 

example.com/home/index.html

## Clean URL 

example.com/home/index/en/us

We do not expose the name of the argument. 
It is just a different way to write. 


example.com/index/img/pic.jpg
example.com/index.html?part1=img?part2=pic.jpg 

this is how it is iteratied. 

bank.com/account.php

bank.com/account.php/i-love-pokemon.jpg 

you may get a 404. 

# Web Cache Deception 

https://portswigger.net/web-security/web-cache-deception
Reroute is a usability thing cause 404 is ugly. server knows it doesn't exists and it gives a 200 success. 
![[Pasted image 20260607165805.png]]

bank.com/accont.php/nonexistent.jpg   -400 

bank.com/account.php?parameter=nonexistent.jpg     -  200

This can cause misunderstanding between the cache and proxy it gives 200 Ok, CACHE-CONTROL;NO-store. 

99% of the comapny check the box that says ignore the CACHE-CONTROL error. 

**We assume that fall back page is a sensitive page.** 

# HTTP Processing Discrepancy.

![[Pasted image 20260607165921.png]]

? - Bad request 

Cache purging. 

in the challenge 0\r\n

Content length - decimal 
Chunked encoding hexadecimal 

\r\n should be counted as content-length 
 

Draw the picture  on a pen and paper 
what does the process see 
what does the origin see 
what does it result it 
does the final result look like a valid request. 

![[Pasted image 20260607170847.png]]

# Web Cache Poisoning 

![[Pasted image 20260607171012.png]]
![[Pasted image 20260607171023.png]]
https://en.wikipedia.org/wiki/Chunked_transfer_encoding

# HTTP Request Smuggling
