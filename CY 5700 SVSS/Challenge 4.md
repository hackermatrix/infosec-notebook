
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