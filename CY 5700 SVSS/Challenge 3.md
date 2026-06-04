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

### Inspecting I the second  page 

![[Pasted image 20260601130407.png]]

###  Comment section input 

![[Pasted image 20260601133721.png]]


![[Pasted image 20260601133706.png]]
 
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

### Trying SQL injection on Messages. 

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

## Constructing the sql injection 

UNION SELECT card_id INTEGER PRIMARY KEY, user_id INTEGER, card_name TEXT, card_no TEXT, FROM cards--

The CREATE TABLE statement is the **schema definition**, not the column names to put in your SELECT

### CSRF Token manipulation 

I tried removing the CSRF token thing it gives this. 

![[Pasted image 20260601145835.png]]

The CSRF token that i see here in the response is different 

1efe2104df01ab7f43b1ebc24c58089e81046eecf147e45799505bfe254da520

![[Pasted image 20260601150405.png]]

## Messages part 


![[Pasted image 20260604142602.png]]

UNION SELECT 1,2,3 FROM sqlite_master--


## SQL injection to login to bob. 

SELECT * FROM users WHERE username = 'bob’ - -’ AND password = 'anything';

https://www.sentinelone.com/cybersecurity-101/cybersecurity/types-of-sql-injection/


![[Pasted image 20260531154710.png]]


https://infosecwriteups.com/from-sql-injection-to-weak-passwords-a-deep-dive-into-a-tamil-nadu-government-security-flaw-1b648d62d457
![[Pasted image 20260531155053.png]]



## SQL injection in login 


![[Pasted image 20260602113103.png]]


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