the inconsistent treatment of the X-HTTP-Method-Override header, header size limits and the parsing of meta characters.

# Private and Shared Cache. 

### The Core Distinction

There are two types of caches based on **who they serve**:

```
Private Cache  →  stores content for ONE specific user only
Shared Cache   →  stores content for MANY users
```

### Private Cache

This is your **browser cache**. When you visit a website:

```
You → Browser Cache → Server
```

Your browser stores the response **just for you**. Nobody else can get your cached copy. Examples:

- Chrome's local cache on your laptop
- Firefox storing images so pages load faster for you

Cache-Control: private   ← tells caches "only store this for this specific user"

### Shared Cache

This sits **between many users and the server**. One cached copy serves everyone:

```
User A ──→                          
User B ──→  [Shared Cache/CDN]  →  Origin Server
User C ──→
```

The first person's request fetches from origin and caches it. Everyone after gets the cached copy. Examples:

- **CDNs** (Cloudflare, Akamai) — globally shared
- **ISP proxy caches** — shared among ISP customers
- **Reverse proxies** (Nginx, Varnish) — shared among all visitors to a site

## Web-Cache Standard 

The web caching standard defines a set of control directives for instructing caches how to store and reuse recyclable responses.
RFC 7234  defines the max-age and s maxage attributes in the Cache-Control response header.
The keyword max-age is applicable to private and shared caches whereas s-maxage only applies to shared web caching systems

### Responses that can be cached. 

![[Pasted image 20260612131640.png]]

Moreover, responses to GET method must contain defined status codes including, e.g., **200 Ok, 204 No Content and 301 Moved Permanently.

404 Not Found          →  cacheable ✓
405 Method Not Allowed →  cacheable ✓**

**POST, DELETE and PUT are also known as unsafe methods. 


![[Pasted image 20260612133831.png]]

## Request Smuggling 

Attack which occurs when the web caching system and the origin server do not strictly conform to the policies specified by RFC 7234.

### Method 1: Sending two Content-Length headers. 

The attacker can send a request with two Content-Length headers to impair a shared cache. Even though the presence of two Content-Length headers is forbidden as per RFC 7234, some HTTP engines in caches and origin servers still parse the request. 

**Due to the duplicate headers, the malformed request is able to confuse the origin server and the cache so that a harmful crafted response can be injected to the web caching system. This malicious response is then reused for recurring requests.**

### Method 2: Sending two host headers. 

Here, the attacker constructs a request with **two Host headers**. These duplicate headers induce a similar misbehavior in the cache and origin server as the request smuggling attack. Likewise, a malicious response is injected to poison the cache.

Each layer picks a different Host:

```
Cache sees:          first Host  →  192.168.1.77:5002
                     "I know this resource, cache key matches"
                     
Origin Server sees:  second Host →  evil.com
                     "I don't recognize this host!"
                     → returns error page
```

So:

```
Cache        →  "this is a valid request for a known resource"
Origin       →  "what is evil.com? I don't serve that!" → 400/404 error
```

![[Pasted image 20260612134851.png]]


### Method 3: Response splitting  attack

#### What the Attacker Actually Sends

The `\r\n` in the request are **not** the literal characters backslash-r-backslash-n. They are **actual invisible line break bytes**:

```
\r  =  byte 0x0D (carriage return)
\n  =  byte 0x0A (line feed)
```

So the raw bytes the server receives look like:

```
GET / HTTP/1.1↵
X-Custom-Header: hello↵
HTTP/1.1 200 OK↵
Content-Length: 13↵
↵
Poisoned Page!
```

Where `↵` represents the actual invisible CRLF bytes.

---

#### Why Doesn't the Server Get Confused?

This is the key — **the server processes the request differently from how it builds the response**.

When the server receives the request:

```
RECEIVING phase:
Server reads line by line
Line 1: "GET / HTTP/1.1"          → this is the request method
Line 2: "X-Custom-Header: hello"  → this is a header
                                     everything after "hello" 
                                     on the same header line
                                     gets treated as the header VALUE
```

The vulnerable server **doesn't validate** what's inside the header value. It just stores it as:

```
X-Custom-Header = "hello\r\nHTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\nPoisoned Page!"
```

It accepted the whole thing as one header value without questioning it.

#### Where It Goes Wrong — The Response Phase

The problem happens when the server **reflects** that value back into the response:

```
REFLECTING phase (vulnerable server):
Server builds response and blindly copies the header value in:

HTTP/1.1 200 OK\r\n
X-Custom-Header: hello\r\n        ← server writes this
HTTP/1.1 200 OK\r\n               ← these were INSIDE the value!
Content-Length: 13\r\n            ← server didn't escape them
\r\n
Poisoned Page!
```

The server just **copy-pasted** the raw value including the hidden line breaks into its response output — without stripping or escaping them.

---

#### What the Cache Sees

The cache receives this raw byte stream and parses it:

```
HTTP/1.1 200 OK              ← start of response 1
X-Custom-Header: hello       ← header of response 1
                             ← blank line = end of response 1 headers
                             ← (no body because Content-Length was 0)

HTTP/1.1 200 OK              ← "oh, a new response starting!"
Content-Length: 13           ← header of response 2
                             ← blank line = end of response 2 headers
Poisoned Page!               ← body of response 2
```

The cache has no idea this was one server response — it just sees **two valid HTTP responses** in the byte stream

## DDos with Random Query String
### Normal URL vs URL with Random Query String

A normal URL looks like:

```
https://thedenstore.com/homepage
```

A URL with a random query string appended looks like:

```
https://thedenstore.com/homepage?x=ab3kf9
https://thedenstore.com/homepage?x=zq7mp2
https://thedenstore.com/homepage?x=yw1cx8
```

The `?x=` part is the **query string** and `ab3kf9` is the **random string**.

---

### Why Does This Bypass the Cache?

Remember how caches work — they store responses based on a **cache key**, which is typically the full URL:

```
Cache stores:
/homepage?x=ab3kf9   →  one cache entry
/homepage?x=zq7mp2   →  different cache entry
/homepage?x=yw1cx8   →  yet another cache entry
```

Even though all three URLs point to the **exact same page**, the cache treats them as **completely different resources** because the URLs are different.

So every unique random string = guaranteed **cache miss**:

```
Request with ?x=ab3kf9  →  cache miss  →  goes to origin server
Request with ?x=zq7mp2  →  cache miss  →  goes to origin server
Request with ?x=yw1cx8  →  cache miss  →  goes to origin server
```

The cache is effectively **bypassed entirely**.

---

### The Attack Flow

```
Attacker generates thousands of random strings:
?x=ab3kf9
?x=zq7mp2
?x=yw1cx8
... thousands more

Sends all of them to every CDN edge server:

Attacker → Edge Server 1 → Origin Server ←─┐
Attacker → Edge Server 2 → Origin Server   │  All hitting
Attacker → Edge Server 3 → Origin Server   │  origin at
Attacker → Edge Server 4 → Origin Server ──┘  once!

Origin server gets overwhelmed
→ Cannot process legitimate requests
→ Effective DoS
```

---

### Why This is Clever

Normally a CDN **protects** the origin server by absorbing traffic:

```
Normal:
1000 users request /homepage
→ Cache serves 999 of them
→ Only 1 request reaches origin
→ Origin is protected
```

But with random query strings:

```
Attack:
1000 requests with unique ?x= values
→ Cache misses every single one
→ All 1000 reach origin server
→ CDN protection is completely neutralized
```

The CDN ironically **amplifies** the attack because it has many edge servers, each forwarding requests to the same origin.
## Semantic Gap 

different interpretation of HTTP messages by two or more distinct message processing entities, which is known as the semantic gap

400 Bad Request, 403 Forbidden and 500 Internal Server Error
## Request that are not suppose to be cached. 

![[Pasted image 20260612153610.png]]


## HTTPMethodOverride (HMO)Attack


### What Are Intermediate Systems?

When your request travels from your browser to a server it doesn't go directly — it passes through multiple devices in between:

```
Your Browser → [Firewall] → [Load Balancer] → [Cache/Proxy] → Origin Server
                    ↑               ↑                ↑
                    └───────────────┴────────────────┘
                         These are INTERMEDIATE SYSTEMS
```

Common intermediate systems:

|System|What it Does|
|---|---|
|Firewall|Blocks suspicious or unauthorized traffic|
|Load Balancer|Distributes requests across multiple servers|
|Cache/Proxy|Stores and serves cached responses|
|CDN Edge Server|Delivers content from nearest location|

---

### Why They Only Support GET and POST

Many older intermediate systems were built when the web was simpler. Back then only GET and POST existed practically. So:

```
GET    →  "give me a resource"         ✓ supported everywhere
POST   →  "here's some data"           ✓ supported everywhere
PUT    →  "replace this resource"      ✗ some intermediaries block this
DELETE →  "remove this resource"       ✗ some intermediaries block this
PATCH  →  "partially update resource"  ✗ some intermediaries block this
```

So a firewall might simply drop any request that isn't GET or POST — it never reaches the server.

---

### The Method Override Solution

To work around this restriction, web frameworks invented special headers:

```
X-HTTP-Method-Override: DELETE
X-HTTP-Method: PUT
X-Method-Override: PATCH
```

The idea:

```
Client sends:
GET /index.html HTTP/1.1
X-HTTP-Method-Override: DELETE

Intermediate system sees:  GET  → "that's fine, let it through" ✓
Origin server sees:        X-HTTP-Method-Override: DELETE
                           → "oh, treat this as DELETE" ✓
```

Everyone is happy — the intermediate system sees a safe GET, the server does the actual DELETE.

![[Pasted image 20260612162129.png]]

**Step 1 — Attacker sends malicious GET request:**

```
GET /index.html HTTP/1.1
Host: example.org
X-HTTP-Method-Override: POST    ← this is the weapon
```

Attacker sends a GET request but secretly tells the server to treat it as POST.

**Step 2 — Cache forwards to origin:**

```
Cache sees:  GET request → "this is cacheable, let me forward it"
Cache also forwards the X-HTTP-Method-Override: POST header along
```

Cache doesn't understand or care about the override header — it just passes everything through.

**Step 3 — Origin server processes as POST:**

```
Origin server reads X-HTTP-Method-Override: POST
→ "I'll treat this as a POST request on /index.html"
→ POST on /index.html doesn't exist!
→ Returns 404 Not Found "POST on /index.html not found"
```

**Step 4 — Cache stores the 404:**

```
Cache receives 404 Not Found
→ "404 is cacheable!" (remember our earlier discussion)
→ Stores the error page for GET /index.html
```

The floppy disk icon in the diagram represents the cache **storing** the response.

**Step 5 — Innocent user makes normal request:**

```
GET /index.html HTTP/1.1
Host: example.org
```

A completely normal, legitimate request from a benign client.

**Step 6 — Cache serves poisoned response:**

```
Cache sees: GET /index.html → "I have this cached!"
→ Serves the stored 404 error page
→ Benign client gets "POST on /index.html not found"
→ Even though they sent a perfectly valid GET request!
```

The recycling icon represents the cache **reusing** the poisoned response.


## HTTPHeaderOversize (HHO) Attack

![[Pasted image 20260612163636.png]]

### **Steps 1 & 2 — Attacker sends oversized header:**

```
GET /index.html HTTP/1.1
Host: example.org
X-Oversized-Header: Bigvalue[...thousands of bytes...]
```

Cache sees a normal GET request → forwards everything including the giant header.

### **Step 3 — Origin hits its size limit:**

```
Origin checks header size → "this exceeds 8000 bytes!"
→ 400 Bad Request "Header size exceeded"
```

### **Step 4 — Cache stores the 400:**

```
Cache receives 400 → stores it for GET /index.html
```
### **Steps 5 & 6 — Innocent user gets poisoned response:**

```
Benign client sends normal GET /index.html
→ Cache serves cached 400 "Header size exceeded"
→ User never reaches origin server
```

## HTTP Meta Character (HMC)

![[Pasted image 20260612164552.png]]

HTTP Meta Character (HMC) attack. To do so, the attacker crafts a request with a meta character, e.g. \n, as shown in Figure 5. The goal of this example attack in is to fool the origin server into believing that it is attacked by a response splitting request. As with the previously presented vulnerabilities, the HMO request traverses the cache without any issues. Once the request reaches the endpoint, it is blocked and an according error page is returned, since the webserverisawareoftheimplicationsregarding suspicious characters such as \n. This error message is then stored and recycled by the corresponding web caching system


