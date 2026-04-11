Understanding Kerberos is essential for modern AD exploitation.

**Resources** : 
- https://gost.isi.edu/publications/kerberos-neuman-tso.html
- https://www.youtube.com/watch?v=5N242XcKAsM


## Kerberos Terminologies:

#### 1. Realm:
 - A **logical domain** or group of system , over which Kerberos has authority to authenticate.
 - There can be multiple realms and they can be interconnected. 
#### 2. Principal:
- It is a unique identity, which can be users, service or an application under the realm.

#### 3. KDC( Key Distribution Center ):
- It’s the **trusted authority** in a Kerberos realm that:
	- Verifies identities
	- Issues **tickets**
	- Lets users access services **without sending passwords over the network**

> If Kerberos is a nightclub, the **KDC is the bouncer + wristband desk**.

- The KDC has **two logical parts** (usually the same server):
	### 1️⃣ AS — Authentication Server ( Authenticates the user )
	- You log in
	- AS verifies **you**
	- ==Gives you a **TGT (Ticket Granting Ticket)** (IMPORTANT POINT)==
	
	### 2️⃣ TGS — Ticket Granting Server (Used when accessing a service)
	- You want to access a service (SMB, HTTP, MSSQL, etc.)
	- You present your **TGT**
	- ==TGS gives you a **service ticket **   (IMPORTANT POINT)==


## The Auth Flow :

### Step 1:
![[Pasted image 20260129120233.png]]

- **What is sent to the AS ?**
```
 Username/ID
 Service Name/ID
 User IP Address
 Requested Lifetime of the TGT
```
- This also includes an encrypted timestamp proving the client knows the user’s password.

### Step 2: 
![[Pasted image 20260129120315.png]]
- The Authentication Server has a list of Usernames mapped with a Secret key:
![[Pasted image 20260129121042.png]]
- The AS uses the Username from the Step1 and get the Secret Key for it .
- The AS sends the following back to the user:
![[Pasted image 20260129122821.png]]
- The ==TGS Session Key==  is a randomly generated symmetric key
- Once these details are created, both of the messages are encrypted .
- The first message is encrypted with ==user's secret key==.
- The second message is encrypted with ==TGS's secret key==.

- Once all of this is done, both of the messages are sent back to user . 


### Step 3:
![[Pasted image 20260129120357.png]]
- Once the user has both the messages:
	- Users needs to decrypt the first message with their secret key.
		![[Pasted image 20260129123207.png]]
	- Once the user decrypts the first message , he now has two things :
		- 1. TGS ID (or ID of the TGS server )
		- 2. TGS Session Key 
- Now the user sends two more messages to the TGS along with the TGT
	 ![[Pasted image 20260129123749.png]]
- Important thing here is that one of the msg i.e the User Authenticator msg is encrypted with the ==TGS session key== , which was received earlier.
### Step 4:
![[Pasted image 20260129120423.png]]
- The TGS has a list of ServiceIDs mapped with a ServiceSecret key:
	![[Pasted image 20260129124314.png]]
- Now, the TGS does the following :
	- 1. Uses TGS secret key that it already has, to decrypt the TGT.
	- 2. Gets TGS session key from the TGT and decrypts the user Authenticator Message. 
	- Now, since it now has all the messages decrypted, it starts to validate the data inside:
		- Is Usernames in TGT and Auth msg matching?
		- Are the timestamps in the threshold range (2mins usually)?
		- is TGT expired?
- After that, the TGS creates two messages:
	1. ![[Pasted image 20260129130051.png]]
	2. ![[Pasted image 20260129130110.png]]
- The first msg is encrypted with the ==TGS session key== and the second msg(Service Ticket) with ==Service Secret Key== that we got from the mappings stored in the TGS.
- Both of the msg contains a random symmetric key i.e ==Service Session Key==.

### Step 5:
![[Pasted image 20260129120453.png]]

- After Receiving the messages from the TGS , User does the following :
	- 1. Decrypts the first msg with the ==TGS Session Key== that they already received from AS.
	- 2. User takes the Service Session key from the decrypted msg , creates a user authenticator msg and encrypts it with the ==Service Session Key==.
		![[Pasted image 20260129131403.png]]
- Now, the user Authenticator msg and the Service Ticket are sent to the service .

### Step 6:
![[Pasted image 20260129120531.png]]

- Finally once the service receives these messages, it does the following :
	- 1. Decrypts the ==Service Ticket== with its secret key.
	- 2. Gets ==Service Session Key== and decrypts the User Authenticator Message.
- Once both of the msgs are decrypted validations are done :
	- User IDs from both should match.
	- Compares the Timestamps(2mins tolerance)
	- Check expiry of the Service Ticket
- After the checks are done, the service checks its cache (Service Cache) to be sure that the received Authenticator msg is not in the cache already(to avoid replay attacks) .
- If not in the cache, it adds it .
- Now , the service create a ==Service Authenticator Message== which is then encrypted with the ==Service Session Key==.
- ![[Pasted image 20260129132554.png]]
- This is then sent Back to the user
---

## 🧠 Mental Model
**Password** → **TGT** → **Service Ticket** → **Access**


## 🛡️ Major Attacks
- **AS-REP Roasting**: Exploiting users with "Do not require Kerberos pre-authentication" set.
- **Kerberoasting**: Requesting TGS tickets for SPNs and cracking them offline.
- **Golden Ticket**: Forged TGT using the `krbtgt` hash.
- **Silver Ticket**: Forged TGS for a specific service.

---
**Deep Dives:**
- [[AS-REP Roasting|AS-REP Roasting Detailed]]
- [[Kerberoasting|Kerberoasting Detailed]]
- [[04_Active_Directory/AD_Foundations|AD Foundations]]



## One More Visualization
![[Pasted image 20260226134656.png]]