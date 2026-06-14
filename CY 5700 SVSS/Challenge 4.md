
# Understanding the challenge 

![[Pasted image 20260611142632.png]]
![[Pasted image 20260611142659.png]]

# Strategy 

![[Pasted image 20260611142813.png]]


The three attacks mentioned in the paper are: 

1. **HTTPMethodOverride (HMO)Attack**
2. **HTTPHeaderOversize (HHO) Attack**
3. **HTTPMetaCharacter (HMC)Attack**

![[Pasted image 20260611143051.png]]

# Hints 

1. 
![[Pasted image 20260611144139.png]]

Manipulate **Content-Length & Transfer-Encoding**



2. ![[Pasted image 20260611144511.png]]

The **aforementioned two headers** they're warning about are the real HTTP protocol headers:

```
Content-Length: <value>
Transfer-Encoding: chunked
```

These are **core HTTP/1.1 headers** that control how the body of a request is framed/sized. Every device in the network that speaks HTTP understands and acts on these.

### Why Messing With Them Is Dangerous in Transit

When your request travels across the internet, it doesn't go directly to the challenge server. It hops through many devices:

```
Your Browser → ISP Router → Northeastern Network → CDN/Proxy → The Den™ Server
```

**Every single one of these intermediate devices** parses HTTP headers — routers, load balancers, firewalls, proxies. They all look at `Content-Length` and `Transfer-Encoding` because those headers tell them:

> _"How long is this request body? When does this message end?"_

If you **manipulate** those real headers (which is exactly what CPDoS/HTTP desync attacks do), intermediate devices might:

- **Drop your request** entirely thinking it's malformed
- **Misframe the request** and confuse it with the next one
- **Return their own error** before it even reaches the challenge server

for **initial exploration**:

```
X-Hack-Mode: 0    ← or just don't include it at all
```


### The Core Rule

```
Real Headers          →  For the internet/middleboxes to understand
X- Custom Headers     →  For The Den™ to understand (in Hack Mode)
```

They need to **coexist** in your request. Each audience reads what it knows.


### Point 1 — Keep a Real `Content-Length` for the Journey

When your request has a body, the middleboxes (ISP, routers, proxies) need to know how big it is so they can **forward the whole thing** correctly. So:

```
Content-Length: 42        ← real, correct, full body size
                            → middleboxes use this to forward your request intact

X-Content-Length: 10      ← your "fake" smuggling value
                            → The Den™ uses this, ignores the real one
```

### Point 2 — Don't Insert a Real `Transfer-Encoding` Header

Under normal circumstances your tools use `Content-Length` for framing anyway, so this shouldn't be an issue. But the warning is:

> Don't manually add `Transfer-Encoding: chunked` as a real header

Because if you do:

- Middleboxes will see it and try to parse your body as chunked
- This will likely **mangle your request** before it even reaches The Den™



![[Pasted image 20260611155730.png]]


![[Pasted image 20260611155911.png]]

## Playing with the headers 

![[Pasted image 20260613123411.png]]
![[Pasted image 20260613123426.png]]

If i remove everything it does drop the request. 

![[Pasted image 20260613123535.png]]


## Exploring the Den™

The Come in.. is getting cached. 

![[Pasted image 20260611161321.png]]

![[Pasted image 20260611161456.png]]

![[Pasted image 20260611161553.png]]

![[Pasted image 20260611162056.png]]


## Tried two header request smuggling 

![[Pasted image 20260612140450.png]]

It doesn;t work. 


#
## Need to try query strings 


## Different content length 


## Trying X HTTP-Method-Override it blocks it

![[Pasted image 20260612174018.png]]
![[Pasted image 20260613121317.png]]

I gave the method in the main body itself what if I try it in the later part. 

![[Pasted image 20260614123715.png]]

POST /login HTTP/1.1
Host: 192.168.1.77:5002
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.9
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Cache-Control: max-age=0
Content-Length: 
X-Hack-Mode: 1
X-Content-Length: 1109
X-Transfer-Encoding: chunked
Origin: http://192.168.1.77:5002
Connection: keep-alive
Referer: http://192.168.1.77:5002/
Cookie: hacker_token=22-s_yiTw1IDkQdzlq2xQkglg-22
Upgrade-Insecure-Requests: 1
Priority: u=0, i

11
name=tan&code=tan
0

GET /login HTTP/1.1
X:
Host: 192.168.1.77:5002
X-HTTP-Method-Override: DELETE 
X-Hack-Mode: 1
X-Content-Length: 0
Cookie: hacker_token=22-s_yiTw1IDkQdzlq2xQkglg-22
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.9
Accept-Encoding: gzip, deflate

![[Pasted image 20260614123426.png]]

Now I am considering that x-content-length will be read by the origin

![[Pasted image 20260614124211.png]]

It says access denied though 

![[Pasted image 20260614124237.png]]

If i send again i get this 

![[Pasted image 20260614124521.png]]

![[Pasted image 20260614124509.png]]

![[Pasted image 20260614125246.png]]

## Trying X- HTTPMetaCharacter (HMC)Attack

![[Pasted image 20260612174320.png]]

It does not block it 
![[Pasted image 20260612174420.png]]

![[Pasted image 20260612174404.png]]

### Trying with the hex values & string

![[Pasted image 20260613130100.png]]

![[Pasted image 20260613130657.png]]

When i did this cache got close, that means it reached the origin server, but the origin ignores it that is why i am not getting an error. 

![[Pasted image 20260613130739.png]]

%0d%0a as text    →  origin ignores it  →  200 OK
0x0D 0x0A as real bytes  →  origin rejects  →  400 error  →  gets cached!

let us try sending it 
![[Pasted image 20260613132059.png]]

this got hit 
![[Pasted image 20260613132146.png]]

The proxy is **ignoring query strings** when building cache keys. So `/?x=anything` always matches the cached `/` entry.


![[Pasted image 20260612180831.png]]


![[Pasted image 20260612180934.png]]

## HTTPHeaderOversize (HHO) Attack

![[Pasted image 20260613152734.png]]

![[Pasted image 20260613152752.png]]


![[Pasted image 20260613135429.png]]
![[Pasted image 20260613135441.png]]

![[Pasted image 20260613152841.png]]

Metachar → similar potential but harder to execute (need real bytes, not text)

![[Pasted image 20260613140410.png]]

I am not adding anything at X-Content-Length: 

![[Pasted image 20260613153316.png]]
![[Pasted image 20260613153332.png]]

![[Pasted image 20260613153359.png]]

![[Pasted image 20260613153425.png]]

![[Pasted image 20260613153529.png]]

#### Origin is looking at the chunk i.e, the transfer encoding. 

![[Pasted image 20260613153835.png]]
![[Pasted image 20260613153850.png]]

Look at the error message carefully:

```
"Origin error: Invalid chunked body."
```

This is different from before! Previously it said:

```
"Proxy error: Invalid chunked body. Not forwarding."  ← proxy rejected it
```

Now it says:

```
"Origin error: Invalid chunked body."  ← origin rejected it!
```

