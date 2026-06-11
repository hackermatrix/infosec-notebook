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

