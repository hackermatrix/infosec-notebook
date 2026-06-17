

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
