Setup the Internal Network interface of the Linux VM to any valid static IP address in the 10.0.100.0/24 CIDR (Classless Inter-Domain Routing) range.
## Part 1 

┌─────────────────────────────────────────┐
│ Windows PowerShell                      │
│                                         │
│ ssh -p 2222 tanc@localhost              │
└──────────────┬──────────────────────────┘
               │ Port forwarding (2222→22)
               ↓
┌──────────────────────────────────────────┐
│ Gateway VM (Ubuntu-Tan)                  │
│ - Adapter 1: NAT (has port forwarding)   │
│ - Adapter 2: Internal Network (intnet)   │
│                                          │
│ ssh tan@10.0.100.10                      │
└──────────────┬───────────────────────────┘
               │ Internal network only
               ↓
┌──────────────────────────────────────────┐
│ Client VM (Linux-Client)                 │
│ - Adapter 1: Internal Network (intnet)   │
│ - NO port forwarding (by design!)        │
└──────────────────────────────────────────┘\

# Gateway 

A **gateway** is a node that enables devices from one network to communicate with devices on another network. To setup the Linux VM as a gateway, you would **need two network interfaces on the Linux VM:** one **that is connected to the Internet and another that is connected to the local network.**

# Netplan
Netplan is a **utility for easily configuring networking on a linux system.** You simply create a **YAML description of the required network interfaces and what each should be configured to do**. From this description Netplan will generate all the necessary configuration for your chosen renderer tool.


You have two client and gateway 
### Step 1. Setting up **client**.
Make sure in the client the IP address is not as same as the gateway but it should be in the same CIDR range as the gateway

#### Task 1: Do ip a and check the interface the client has and then fix the netplan file accordingly 
I can see enp0s3 here and i will add this interface in the netplan
![[Pasted image 20260410150503.png]]

#### Task 2: Setting up netplan:
Netplan yaml file is in the 
**cd /etc/netplan directory** 
Couple of things to do edit the file using sudo otherwise you cant edit it. 
Make sure of the indentations in the yaml file
I can see enp0s3 & I have added the required address
![[Pasted image 20260410150556.png]]

Set the required permisssions to the yaml file mostly 600 otherwise it will give you error
![[Pasted image 20260316154344.png]]

### Step 2. Setting up the **gateway:**

In the gateway you need to have two connections : 
- Adapter 1: NAT (has port forwarding)   │
│ - Adapter 2: Internal Network (intnet)   

#### Task 1: ip a

I see two interfaces here. When I first do `ip a` on the gateway, I will see`enp0s8` has **no IP address** at all::. 
![[Pasted image 20260410155722.png]]

#### Task 2: 
So will edit my netplan file mentioning enp0s3 and enp0s8
Note: How do i know it is the enp0s3 that i need to add in my netplan check "**Dynamic"** which is at inet 
This is the netplan file
Renderer can be NetworManager (legacy Network) or NetworkD

![[Pasted image 20260316160856.png]]

#### Task 3 Recheck with ip a 

![[Pasted image 20260316161038.png]]

I can see 10.0.100.1 in the interface enp0s8.

#### Task 4 Ping from the client to the gateway
Now from the client I can ping the gateway. I **can** ping between devices on the **same subnet** of 10.0.100.0 before any iptables rules, because that's just direct Layer 2 communication, no routing needed.

Same subnet, no routing required. 

![[Pasted image 20260316161310.png]]

Make sure you restart the system:

#### Task 5: **Enable IP forwarding on the gateway:** 

![[Pasted image 20260316173742.png]]

### Why IP Forwarding is Needed

Without IP forwarding, the gateway Linux kernel behaves like this:

```
Client → sends packet destined for 8.8.8.8
         ↓
Gateway receives it on enp0s8
         ↓
Kernel says "this packet isn't for me... 
I'll just DROP it" ❌
```

With IP forwarding ON:

```
Client → sends packet destined for 8.8.8.8
         ↓
Gateway receives it on enp0s8
         ↓
Kernel says "this isn't for me, but 
ip_forward=1 so let me FORWARD it" 
         ↓
Passes it to enp0s3 → internet ✅
```

Ping won;t workL

![[Pasted image 20260410162727.png]]
## **Part 2:**

### Step 1: On the **Gateway**  install bind9

### Step 2: Change this file /etc/bind/named.conf.options

Make sure you do sudo nano 
![[Pasted image 20260316162254.png]]
make the following changes to this

![[Pasted image 20260316162452.png]]

### Step 3:  then do restart: 

sudo systemctl restart bind9

![[Pasted image 20260316164057.png]]

### Step 4: Make changes in the client netplan 
For part 2 make sure in the client change the Netplan file add nameserver, add **nameservers** and **addresses

![[Pasted image 20260316163753.png]]

When you add this to netplan:

yaml

```yaml
nameservers:
  addresses:
    - 10.0.100.1
```

Netplan tells **systemd-resolved** to use `10.0.100.1` as DNS

From my client you can do dig northeastern.edu
![[Pasted image 20260316163535.png]]


##  Part 3


![[Pasted image 20260316172817.png]]

My iptables NAT table is empty
Make sure the forwarding is enabled.
![[Pasted image 20260316173749.png]]

### Allow internal network to NAT network (Part 3a)

Run:
sudo iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT
`-A` means **Append a rule**.
`FORWARD` is the **chain**.
So this part means:
Add this rule to the FORWARD chain
#### What is the FORWARD chain?

Linux processes packets in different stages:

| Chain   | Purpose                                 |
| ------- | --------------------------------------- |
| INPUT   | Traffic going **to the machine**        |
| OUTPUT  | Traffic **leaving the machine**         |
| FORWARD | Traffic **passing through the machine** |

In your lab:

Windows VM → Linux Gateway → Internet

The packets are **passing through**, not destined for the Linux machine.

So they go through the **FORWARD chain**.

---

# 3️⃣ `-i enp0s8`

`-i` = **incoming interface**

This means:

If the packet enters through interface enp0s8

From your setup:

enp0s8 = internal network  
10.0.100.0/24

So the packet is coming from the **Windows VM network**.

---

# 4️⃣ `-o enp0s3`

`-o` = **outgoing interface**

Meaning:

Packet leaves through enp0s3

From your system:

enp0s3 = NAT internet interface  
10.0.2.x

So the packet path is:

Windows VM → enp0s8 → Linux gateway → enp0s3 → Internet

---

# 5️⃣ `-j ACCEPT`

`-j` means **jump to target**.

The target tells iptables **what to do with the packet**.

Common targets:

|Target|Meaning|
|---|---|
|ACCEPT|allow packet|
|DROP|silently discard|
|REJECT|block and send error|
|LOG|log packet|

So:

-j ACCEPT

means:

Allow this packet to pass

![[Pasted image 20260316175100.png]]

####  Route only Related & Established connections from NAT to  the  interna network  (Part 3b)

sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT
# `-m state`

This is **very important**.

`-m` = **match module**

Here you're using the **state module**, which lets iptables understand **connection states**.

Without this, the firewall only sees **individual packets**.

With this, it understands **connections**.

Example:

Client → Server : request  
Server → Client : response

The firewall tracks that relationship.

# 7. `--state RELATED,ESTABLISHED`

This tells the firewall:

> Allow packets that belong to **existing connections**.

Two types here:

## ESTABLISHED

Packets that belong to a **connection that already started**.

Example:

1️⃣ Internal machine sends request:

10.0.100.5 → google.com

2️⃣ Google replies:

google.com → 10.0.100.5

The reply is **ESTABLISHED traffic**.

Your firewall rule allows that reply to pass.

---

#### RELATED

Packets that are **related to an existing connection**.

Example:

FTP connection:

Client opens control connection  
Server opens a data connection

The second connection is **RELATED**.

Other examples:

- ICMP errors
    
- FTP data channel
    

---

# 8. `-j ACCEPT`

`-j` = **jump**

Meaning:

> What should the firewall do if the rule matches?

Options include:

|Action|Meaning|
|---|---|
|ACCEPT|Allow packet|
|DROP|Silently discard|
|REJECT|Block and notify sender|

Here:

-j ACCEPT

means

> allow the packet through.


#### Step 5 — Enable NAT masquerading (Part 3c)

Run:

sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

![[Pasted image 20260316182236.png]]

Trying to ping from the internal network:

![[Pasted image 20260316192422.png]]
![[Pasted image 20260316192458.png]]

Make sure you change the netplan and add the routes to default and to via.

![[Pasted image 20260316192814.png]]

Note: MASQUERADE always goes on the interface that **faces the internet/outside network**  the one whose IP you want to "pretend" the traffic is coming from.
#####  Why isn't MASQUERADE done on the client?

Because the client has **no idea** about other networks — it just sends packets to the gateway and trusts it to handle everything:

## Part 4:

**Route traffic from the internal network to NAT ONLY when the destination port is SSH (10020/tcp), DNS (53/udp), HTTPS (443/tcp). Drop all the other packets.**

Save the tables

**sudo netfilter-persistent save**

![[Pasted image 20260316194438.png]]

#### 4a.  Allow traffic from the internal network to nat only when the destination is SSH (port 10020)/tcp

Requirement **4a**.

sudo iptables -A FORWARD -i enp0s8 -o enp0s3 -p tcp --dport 10020 -j ACCEPT
#### 4a. Allow traffic from the internal network to nat only when the destination is DNS (port 53 UDP)

sudo iptables -A FORWARD -i enp0s8 -o enp0s3 -p udp --dport 53 -j ACCEPT

This allows your Windows VM to **resolve domain names**.

---

#### 4a.  Allow traffic from the internal network to nat only when the destination is 443/tcp

sudo iptables -A FORWARD -i enp0s8 -o enp0s3 -p tcp --dport 443 -j ACCEPT

##### This allows secure web traffic.
---
#### 4b Route only RELATED and ESTABLISHED connections from NAT to the internal network.


sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT

Without this, replies from servers will be blocked.

Note: 
---

#### 4a.  Drop rule 

This enforces the firewall.

sudo iptables -A FORWARD -j DROP![[Pasted image 20260317113140.png]]

Deleted an extra rule 

## 4c. Perform IP masquerading for all traffic leaving the NAT network (Hint: POSTROUTING chain in NAT)

sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

4.1 
![[Pasted image 20260317114110.png]]

4.2 
![[Pasted image 20260317120040.png]]
![[Pasted image 20260317115822.png]]


Testing before moving to Part 5:
![[Pasted image 20260317120228.png]]
Professor's server was not working and curl is not installed. 



## Part 5

I need to log every time a packet is dropped.

https://stackoverflow.com/questions/21771684/iptables-log-and-drop-in-one-rule

![[Pasted image 20260318152854.png]]

![[Pasted image 20260318152824.png]]

Rules order drop is added before log:
![[Pasted image 20260318153246.png]]


![[Pasted image 20260318182259.png]]


## Part 6.

5.1 :4a* *



6.1

tcp listening on gateway
![[Pasted image 20260318202230.png]]

SSH not for client
![[Pasted image 20260318202142.png]]

6.2
![[Pasted image 20260318202548.png]]

6.3
![[Pasted image 20260318211155.png]]





![[Pasted image 20260318211743.png]]
![[Pasted image 20260318211802.png]]
![[Pasted image 20260318211816.png]]
![[Pasted image 20260318211833.png]]
![[Pasted image 20260318211855.png]]

6.3 Latest
![[Pasted image 20260318221412.png]]

![[Pasted image 20260318222209.png]]
6.4:

![[Pasted image 20260318212009.png]]