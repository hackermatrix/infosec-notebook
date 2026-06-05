
System Security 

Web Application Attacks 2.0 (a.k.a Why the internet is Doomed)


## Client Server Model
it is abstract it missed details it never happens in practice. 
Web Proxy intermediary between client and server. 
It is never a single proxy there are layers and layers. 

## What is Proxy? 
It is an HTTP server understands the HTTP protocol forwards the request, change the request. 
In practise it can be simple as load balancer
It could be web application firewall.
it could be anything a general purpose http server. 

Akamai does not use partial caching .
## Content Delivery Network (CDN)
Massively distributed networks of reverse proxies. 
Akamai is the biggest footprint of CDN. 
Forms an internet overlay network


Clients are us, our browsers. 
Customers of CDNS, govenrments, banks ,amazon, netflix. 
Origin server is where the content originated from.
Edge server are plain old proxy. 


BGP is not designed for performace. all the ISP, route traffic from A to B do not find the shortest path. 
BGP has zero security built in. 

Most CDN's ignore BGP, they have the internet overlay who do their own routing. 
Deploying such platform is super expensive. AWS, Azure has hunders of data centers whereas Akamai have more data centers all over the world, distribution is important. 

60% to 70% of internet is behind the CDN. 

CDN are also recognized as critical infrastructure in countries like Germany. 


## Web Caches 

You can;t cache everything. 
Objects have to be publicly available objects. It can be confidential or sensitive data.
Like electricity bill , only one person or family needs to access it will not be cached. 
Static objects, if the content changes everything it can be cached. eg. stock market. 

netflix film it is accessible to all netflix customers (10-20 Gb) it is static. 

There are experimental technology that does caching for dynamic objects. 
e.g. where static part is cached on the edge location and the origin is fetched for the dynamic object. 

Routing , waf you need to look inside traffic, you need to terminate TLS. You have multiple TLS hops. CDN's can see everything. The whole security reason is nothing bad happens to the data during transit 


if you are an origin server, how do you signal to cache or not. 
It is done through HTTP response headers like Cache-Control: no-cache. 
The proxy obeys. 

### Cache-Control Headers 

- max-age=seconds
- no-store 
- no-cache 
- no-transform 
- public 

Let us say you have a web application deployed to old school like IBM. You're cahcing policy changes you need to go to each server to change cache-control. 

Identify the servers, the cache-owners. 


Read x-gateway-cache-status 

 ## Range Attacks 
HTTP defines the range header, Range: bytes=0-10240 

Does denial of service, it is asymmetry. Attakcker spends very little request. 

if it is no costing much to the hacker,the hacker might not persue it. 


If you design the system to handle the bening traffic , they monitor they try to detect it. 


## Slowloris Sttacks 




## URL 

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

## Web Cache Deception 

Reroute is a usability thing cause 404 is ugly. server knows it doesnt exists and it gives a 200 success. 

bank.com/accont.php/nonexistent.jpg   -400 

bank.com/account.php?parameter=nonexistent.jpg     -  200

This can cause misunderstanding between the cache and proxy it gives 200 Ok, CACHE-CONTROL;NO-store. 

99% of the comapny check the box that says ignore the CACHE-CONTROL error. 

We assume that fall back page is a sensitive page. 


Cached and Confused, USENIX Security 2020 
tested 340 sites, 37 impacted. 
CDN default configurations don;t help. 


## HTTP Processing Discrepancy.

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
