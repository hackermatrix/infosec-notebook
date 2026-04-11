Concepts in Lab 4:

IPtables is always compared with **Netfilter** but netfilter is a firewall framework tables and iptables is a utility for managing. 
1. NAT
2. Modifying packets
3. Act as a router 
**iptables** is a command-line utility for configuring the built-in Linux [kernel](https://phoenixnap.com/glossary/what-is-a-kernel) firewall. It enables administrators to define chained rules that control incoming and outgoing network traffic.

- **Tables**. Tables are files that group similar rules. A table consists of several rule **chains**.
- - **Chains**. A chain is a string of **rules**. When a packet is received, iptables finds the appropriate table and filters it through the rule chain until a match is found.
- **Rules.** A rule is a statement that defines the conditions for matching a packet, which is then sent to a **target**.
- **Targets.** A target is a decision of what to do with a packet. The packet is either accepted, dropped, or rejected.

When the packet enters it will match the firewall rules, if there are no firewall rules. It will match the default rules. 

**Important takeways:**

1. IPtables work on **layer 2 of the tcp/ip stack**
2. IPtables are evaluated from the **top to bottom.**
3. Always allow [SSH access](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys) before applying restrictive rules on remote servers to avoid accidentally locking yourself out.
4. `iptables` rules are not **persistent by default;** using `****iptables-persistent`** and **`netfilter-persistent`**** ensures rules survive reboots.
5. Many common firewall tasks—such as allowing web traffic, database access, or blocking specific IPs—can be handled with targeted `INPUT` and `OUTPUT` rules.
6. NAT and port forwarding require enabling IP forwarding and configuring rules in the `nat` table in addition to standard filter rules.
7. Ubuntu enables IPv6 by default, so configuring only IPv4 rules with `iptables` may leave services exposed unless `ip6tables` or `nftables` is also configured.
### Tables

Linux firewall iptables have four default tables that manage different rule chains:

- **Filter**. The default packet filtering table. It acts as a gatekeeper that decides which packets enter and leave a network.
-Filter table is responsible for filtering incoming and outgoing traffic.

- [Network Address Translation (NAT)](https://phoenixnap.com/glossary/nat-network-address-translation). Contains NAT rules for routing packets to remote networks. It is used for packets that require alterations.
-Nat table is used to redirect connections to other interfaces. 
- **Mangle**. Adjusts the IP header properties of packets.
Mangle table is for modifying and changing various aspects of a packet. 
- **Raw**. Exempts packets from connection tracking.

Some [Linux distributions](https://phoenixnap.com/glossary/what-is-a-linux-distribution) include a **security** table that

- 
![[Pasted image 20260314215207.png]]

The table you see in the image is a default table. 
### **1. Chains (the sections)**

Prerouting chain: After the packet has entered the network interface.
Postrouting chain: After the packet has left the network interface. After the routing decision is being made. 
Input chain: Is used to manage incoming packets and connections. 

**Built-in chains** (default Linux):

- `INPUT` - packets coming TO your machine
- `FORWARD` - packets passing THROUGH your machine (routing)
- `OUTPUT` - packets going FROM your machine

**Custom chains** (Docker created these):

- `DOCKER`, `DOCKER-USER`, `DOCKER-FORWARD`
- `DOCKER-BRIDGE`, `DOCKER-CT`
- `DOCKER-ISOLATION-STAGE-1`, `DOCKER-ISOLATION-STAGE-2`

**Policy** (in parentheses): **default action if no rules match**

- `(policy ACCEPT)` = allow by default
- `(policy DROP)` = block by default, any traffic that does not match the rule to DROP
-REJECTION Policy will not accept the traffic, but it will send an ICMP rejection to the sender. 

![[Pasted image 20260322102043.png]]

In the Screenshot the input, forward and the output will be executed first then the policy drop will be executed. 

Allow incoming and outgoing traffic. 
If you do not mention anything the default rules, will allow everything.
### **2. Targets (the "decision" column)**

**Two types:**

**a) Terminal decisions** (packet stops here):

- `ACCEPT` - allow the packet ✓
- `DROP` - silently discard the packet ✗

**b) Jump to another chain** (keep evaluating):

- `DOCKER-USER`, `DOCKER-CT`, etc. - sends packet to that chain for more rules

## **How to Read a Rule**

Take this example from your DOCKER-CT chain:

```
ACCEPT  all  --  anywhere  anywhere  ctstate RELATED,ESTABLISHED
```

- **Target**: ACCEPT (allow it)
- **Protocol**: all (any protocol)
- **Source**: anywhere (any IP)
- **Destination**: anywhere (any IP)
- **Condition**: ctstate RELATED,ESTABLISHED (only if connection is already established/related)

**Translation**: "Allow packets from anywhere to anywhere IF they're part of an existing connection"

## **The Flow**

Using your FORWARD chain as an example:

```
Chain FORWARD (policy DROP)
target              prot opt source      destination
DOCKER-USER         all  --  anywhere    anywhere
DOCKER-FORWARD      all  --  anywhere    anywhere
```

**What happens to a forwarded packet:**

1. Enters FORWARD chain (policy is DROP by default)
2. First rule: jumps to DOCKER-USER chain → evaluates those rules
3. Returns to FORWARD, hits next rule: jumps to DOCKER-FORWARD → evaluates those rules
4. If no ACCEPT/DROP found, uses policy (DROP)

## **Filter vs NAT Table: Side-by-Side**

| Aspect             | FILTER Table              | NAT Table                       |
| ------------------ | ------------------------- | ------------------------------- |
| **Purpose**        | "Allow or block?"         | "Change addresses/ports?"       |
| **Chains**         | INPUT, FORWARD, OUTPUT    | PREROUTING, POSTROUTING, OUTPUT |
| **Common Targets** | ACCEPT, DROP, chain jumps | DNAT, SNAT, MASQUERADE, RETURN  |
| **When it runs**   | After routing decision    | Before/after routing            |

### Targets

A target is what happens after a packet matches a rule criteria. Common targets include:

- **ACCEPT**. Allows the packet to pass through the firewall.
- **DROP**. Discards the packet **without informing the sender.**
- **REJECT**. Discards the packet and returns an error response to the sender.
- **LOG**. Records packet information into a log file.
- **SNAT**. Stands for Source Network Address Translation. Alters the packet's source address.
- **DNAT**. Stands for Destination Network Address Translation. Changes the packet's destination address.
- **MASQUERADE**. Alters a packet's source address for dynamically assigned IPs.

https://phoenixnap.com/kb/iptables-linux
https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#HOWTOREAD


Playing with IPtables:

Suppose I am adding a rule to allow all incoming and outgoing traffic and then change the default policy to drop. 

sudo iptables -A INPUT -j ACCEPT 

-A is the append
-I is to insert at specific line
-j is the target
-P is the policy append
-p is the port number/protocol
-dport is the destination port
 -i is the interface 
 -o is the output interface eth0
 eg. sudo iptables -A INPUT -i eth0
 sudo iptables -A INPUT -j ACCEPT -i lo
 -D is the delete
 **`-L`**: Lists the rules.
 -n: Numeric output (shows IP addresses like `192.168.1.1` 
 -v: Verbose mode. This shows the **pkts** (packets) and **bytes** columns, letting you see exactly how much traffic has hit each rule
 -V prints the version 


 sudo iptables -D INPUT 3


![[Pasted image 20260322101149.png]]

Difference between sudo iptables -L and sudo iptables -L -n -v , you can -L -n -v will show you source and destination. 
![[Pasted image 20260322103344.png]]

Difference between sudo iptables -L -n -v , and sudo iptables -L -n -v --line-numbers is that --line-numbers will should num at the far left. 
![[Pasted image 20260322105645.png]]

- **`-L`**: Lists the rules.
    
- **`-n`**: Numeric output (shows IP addresses like `192.168.1.1` instead of trying to resolve names like `router.local`, which is much faster).
    
- **`-v`**: Verbose mode. This shows the **pkts** (packets) and **bytes** columns, letting you see exactly how much traffic has hit each rule

This shows you the filter table, to check the nat table use:

sudo iptables -t nat -L -n -v --line-numbers
![[Pasted image 20260323150714.png]]

Allowing the loopback traffic, loopback traffic never leaves the machine.
Here i ran two rules:
sudo iptables -A INPUT -i lo
sudo iptables -A INPUT -j ACCEPT -i lo

![[Pasted image 20260322105028.png]]

![[Pasted image 20260322104920.png]]

You can see the difference in the **target**  in sudo iptables -A INPUT -j ACCEPT -i lo there is no **ACCEPT**

Syntax for Deleting it is 
sudo iptables -D <chain_table> <rule_number>

![[Pasted image 20260322124630.png]]


Now here you have blocked everything else almost  you cant even get int your own system.

Enabling some rules, like icmp, port 22
sudo iptables -A INPUT -j ACCEPT -p tcp --dport 22

- **`INPUT` chain**: This handles packets **arriving** at your server.
- **`--dport 22`**: This tells the firewall: "If a packet arrives and its **final destination** on this machine is Port 22, let it in."
![[Pasted image 20260322155334.png]]

See the column prot here:

Here I am enabling 80, 443 and 53 DNS.
![[Pasted image 20260322160137.png]]
![[Pasted image 20260322160359.png]]
![[Pasted image 20260322160430.png]]
![[Pasted image 20260322160551.png]]

-V prints the version 
-v prints the verbiose
![[Pasted image 20260322195702.png]]

**Understanding polices****
![[Pasted image 20260322201358.png]]
Now here you can see that even in the iptables if I am only allowing ctstate ESTABLISHES, icmptype 8 and loopback. I am not allowing ssh, 443 or 80. my ping is working because my policy says ACCEPT, so default it says that if it nothing matches ACCEPT it. 

How to append policies:**
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP 
sudo iptables -P OUTPUT DROP

Now even after drop policy ping is working because we have icmptype 8 in the 3rd rule. which becomes established. 

Now after dropping wget is not working. 
![[Pasted image 20260322202524.png]]


**Source Network Address Translation**. 
**REWRITE THE SOURCE IP ADDRESS** 
SNAT is a technique that translates source [IP addresses](https://www.geeksforgeeks.org/computer-science-fundamentals/what-is-an-ip-address/) generally when connecting from a private IP address to a public IP address. It maps the source client IP address in a request to a translation defined on a BIG-IP device ( a network load balancer or Layer 4-7 switch). It is the most common form of [NAT](https://www.geeksforgeeks.org/computer-networks/network-address-translation-nat/) that is used when an internal host needs to initiate a session with an external host or public host.

https://www.reddit.com/r/networking/comments/151yw2/what_exactly_is_bigip/

NAT involves both  SNAT and DNAT
![[Pasted image 20260323000545.png]]
![[Pasted image 20260323000559.png]]
https://www.geeksforgeeks.org/computer-networks/difference-between-snat-and-dnat/

## DNAT target

REWRITE THE DESTIONATION IP ADDDRESS

DNAT, as the name suggests, is a technique that **translates the destination [IP address](https://www.geeksforgeeks.org/computer-networks/structure-and-types-of-ip-address/) generally when connecting from a public IP address to a private IP address.** It is generally used to **redirect packets destined for a specific IP address or specific port on an IP address, on one host simply to a different address mostly on a different host.**

| Option      | --to-destination                                                                                                                                                                                                                                                                     |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Example     | iptables -t nat -A PREROUTING -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10                                                                                                                                                                     |
| Explanation | The --to-destination option tells the DNAT mechanism which Destination IP to set in the IP header, and where to send packets that are matched. The above example would send all packets destined for IP address 15.45.23.67 to a range of _LAN_ IP's, namely 192.168.1.1 through 10. |
|             |                                                                                                                                                                                                                                                                                      |
here in the above example you can see we have given range of IP address like 192.168.1.1 to 192.168.1.10 we can also mention the port number. Eg. 

example, an :80 statement to the IP addresses to which we want to DNAT the packets. A rule could then look like --to-destination 192.168.1.1:80 for example, or like --to-destination 192.168.1.1:80-100 if we wanted to specify a port range

![[Pasted image 20260323171015.png]]

### Masquerading in IPTABLES

https://blogs.learningdevops.com/what-is-ip-masquerade-a-simple-explanation-of-this-powerful-nat-feature-445eecca43e8
https://demos.learningdevops.com/nat-masquerade-demo/

![[Pasted image 20260410113829.png]]

## Prerouting & Postrouting 
## The Key Insight: Think About _When_ the Rewrite Needs to Happen

```
Incoming Packet                                    Outgoing Packet
      │                                                  ▲
      ▼                                                  │
 PREROUTING          →        Routing Decision      →  POSTROUTING
(change destination            "where does this         (change source
 BEFORE router                  packet go?")             AFTER router
 decides where                                           has decided)
 to send it)
```

## Why DNAT goes in PREROUTING

DNAT **changes the destination IP**. The routing decision uses the destination IP to figure out _where to send the packet_.

So you **must** rewrite the destination **before** the routing decision — otherwise the router looks at the original destination, sends it the wrong way, and your DNAT rule never gets a chance to redirect it.


## Why SNAT/MASQUERADE goes in POSTROUTING

SNAT **changes the source IP**. The routing decision doesn't care about the source IP at all — it only looks at destination. So source rewriting can safely happen **after** routing.

Also practically — for MASQUERADE, you need to know **which outgoing interface** the packet is leaving from before you can rewrite the source to match that interface's IP.

DNAT PRACTISE: 
So I have two VM;s setup Gateway and Client:
 
![[Pasted image 20260323175550.png]]

SNAT and MASQUERADE both do the same job (rewrite source on the way **out**), just for static vs dynamic IPs. Eg. of Masquerading
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

Example, if you want to block all incoming traffic and allow all outgoing traffic.
Brushing up some basics: 
`-i lan` → incoming interface, the NIC connected to the **internal/private** network (like 192.168.x.x)
`-o wan` → outgoing interface, the NIC connected to the **external/public** network (internet-facing)
For this you should know no the interfaces in your ubuntu vm. 
Example, you do ip a:

Here you can see for enp0s3 it is dynamic and also when you do ip route it is through enp0s3, which shows that enp0s3 is the internet facing interface. and enp0s8 is the internal 
![[Pasted image 20260323145005.png]]


![[Pasted image 20260323145301.png]]

So for my case scenario it will be 
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE -m comment --comment "masquerade lan to wan"
IT WILLL NOT BE THIS 
sudo iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE -m comment --comment "masquerade enp0s8->enp0s3"

REMEMber MASQUERADE rewrites the source IP.


To make the rules persistent: you should right
![[Pasted image 20260323151309.png]]

### Comment match

The comment match is used to add comments inside the iptables ruleset and the kernel. This can make it much easier to understand your ruleset and to ease debugging.

**Table 10-10. Comment match options**

|             |                                                                                                                                   |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Match       | --comment                                                                                                                         |
| Kernel      | 2.6                                                                                                                               |
| Example     | iptables -A INPUT -m comment --comment "A comment"                                                                                |
| Explanation | The --comment option specifies the comment to actually add to the rule in kernel. The comment can be a maximum of 256 characters. |

![[Pasted image 20260323160343.png]]


**HOW TO SAVE IPTABLES:**
![[Pasted image 20260323161027.png]]

How to manually save it:
![[Pasted image 20260323161141.png]]


State Machine is the **connection tracking machine.** 
**Connection tracking** is done to let the **Netfilter framework know the state of a specific connection**
**Firewalls that implement this are generally called stateful firewalls.**
Packets can be related to tracked connections in four different so-called states.  
1. **NEW**
2. **ESTABLISHED**
3. **RELATED** 
4. **INVALID.**

Connection tracking is done by a special framework within the kernel called **conntrack**

**Conntrack**
Specific parts of conntrack that handles the TCP, UDP or ICMP protocols among others.
These modules grab specific, unique, information from the packets, so that they may keep track of each stream of data. 
The information that **conntrack gathers is then used to tell conntrack in which state the stream is currently in**. 
Eg, **UDP streams are, generally, uniquely identified by their destination IP address, source IP address, destination port and source port.**

Defragmenting has been incorporated into conntrack and is carried out automatically


The Two Entry Points for "State": 
#### 1. Traffic coming from the Outside (External)
When a packet hits your network card from the internet, the **PREROUTING** chain is the very first stop.
- **The Action:** The connection tracking engine looks at the packet. If it's a brand new request, it marks it as `NEW`.
- **The Flow:** This happens _before_ the packet is even routed to the `INPUT` or `FORWARD` chains.
 
#### 2. Traffic coming from your Own Computer (Local)

When you open a browser and go to a website, that packet is "locally generated." It doesn't go through PREROUTING because it started _inside_ the house.

- **The Action:** The **OUTPUT** chain is where `conntrack` first sees this packet.
- **The Flow:** It marks your outgoing request as `NEW`.

| **Step** | **Direction**            | **Chain Involved** | **conntrack "Note"**                                       | **State**       |
| -------- | ------------------------ | ------------------ | ---------------------------------------------------------- | --------------- |
| **1**    | Outgoing (You start it)  | **OUTPUT**         | "I see a new request going out."                           | **NEW**         |
| **2**    | Incoming (The Reply)     | **PREROUTING**     | "I recognize this! It's a reply to the request in Step 1." | **ESTABLISHED** |
| **3**    | Outgoing (Your Next Msg) | **OUTPUT**         | "Still part of the same conversation."                     | **ESTABLISHED** |
|          |                          |                    |                                                            |                 |


| State       | Explanation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| NEW         | The NEW state tells us that the packet is the first packet that we see. This means that the first packet that the conntrack module sees, within a specific connection, will be matched. For example, if we see a SYN packet and it is the first packet in a connection that we see, it will match. However, the packet may as well not be a SYN packet and still be considered NEW. This may lead to certain problems in some instances, but it may also be extremely helpful when we need to pick up lost connections from other firewalls, or when a connection has already timed out, but in reality is not closed. |
| ESTABLISHED | The only requirement to get into an ESTABLISHED state is that **one host sends a packet, and that it later on gets a reply from the other host**. The NEW state will upon receipt of the reply packet to or through the **firewall change to the ESTABLISHED state. ICMP reply messages can also be considered as ESTABLISHED,** if we created a packet that in turn generated the reply ICMP message.                                                                                                                                                                                                                 |
| RELATED     | The RELATED state is one of the more tricky states. A connection is considered RELATED when it is related to another already ESTABLISHED connection. What this means, is that for a connection to be considered as RELATED, **we must first have a connection that is considered** **ESTABLISHED**. **The ESTABLISHED connection will then spawn a connection outside of the main connection. The newly spawned connection will then be considered RELATED**,                                                                                                                                                          |
| INVALID     | The **INVALID state means that the packet can't be identified or that it does not have any state**. This may be due to several reasons, **such as the system running out of memory or ICMP error messages that do not respond to any known connections. Generally, it is a good idea to DROP everything in this state.**                                                                                                                                                                                                                                                                                               |
| UNTRACKED   | This is the UNTRACKED state. In brief, if a packet is marked within the raw table with the NOTRACK target, then that packet will show up as UNTRACKED in the state machine. This also means that all RELATED connections will not be seen, so some caution must be taken when dealing with the UNTRACKED connections since the state machine will not be able to see related ICMP messages et cetera.                                                                                                                                                                                                                  |


Think of the **ESTABLISHED** state as the "Main Conversation" and the **RELATED** state as a "Side Hustle" that the main conversation started.

The firewall needs a way to say: "I didn't expect this new person to knock on my door, but since my friend inside the house invited them, I'll let them in."

### The "Assistant" Analogy

Imagine you are at a high-security office building:

- **ESTABLISHED:** You have a meeting with a Manager. You are already in his office talking (The Main Connection).
    
- **RELATED:** During the meeting, the Manager picks up the phone and calls his Assistant to bring in some files. When the Assistant arrives at the security desk, they aren't on the original guest list, but because the **Manager** (who you are already talking to) called them, the security guard lets them in.
    

---

### The Classic Example: FTP (File Transfer Protocol)

FTP is the reason the `RELATED` state was invented. It's "weird" because it uses two different connections:

1. **The Command Channel (Port 21):** You log in and say "I want to download `cat_photo.jpg`." This is **ESTABLISHED**.
    
2. **The Data Channel (Random Port):** The server says "Okay, I'm going to send that photo to you on Port 54321."
    
3. **The Problem:** Your firewall sees a random connection trying to come in on Port 54321. Normally, it would `DROP` this because it's a "NEW" incoming connection you didn't ask for.
    
4. **The Solution:** The `conntrack` module (with a special "helper" module) "listens" to your conversation on Port 21. It hears the server say "I'm sending the file on 54321." It makes a note: _"Expect a packet on 54321; it's **RELATED** to the session on Port 21."_
    
### Why ICMP is also RELATED

If you send a packet to a server and that server is on fire or the path is blocked, a router along the way might send you an **ICMP Error** message (like "Destination Unreachable").

- You didn't start a "conversation" with that random router.
    
- However, that error message only exists **because** of the packet you sent.
    
- The firewall sees the error, checks your "Main Connection," and says: "This error is **RELATED** to that web request you just made. I'll let the error message through so your browser knows to stop waiting."

You use **UNTRACKED** when **Speed > Intelligence**. You are telling the system: "I'll handle the security manually; just move the data as fast as possible."



--state match  matches the above state.

## TCP connections

![[Pasted image 20260322122622.png]]
With this particular implementation, you can allow NEW and ESTABLISHED packets to leave your local network, only allow ESTABLISHED connections back, and that will work perfectly.

## UDP connections
UDP connections are in themselves not stateful connections, but rather stateless. There are several reasons why, mainly because they don't contain any connection establishment or connection closing; most of all they lack sequencing. Receiving two UDP datagrams in a specific order does not say anything about the order in which they were sent. It is, however, still possible to set states on the connections within the kernel

![[Pasted image 20260322123632.png]]

Because there is no "Open" or "Close" signal in UDP, `iptables` creates a temporary memory entry based strictly on **time and direction**.

### 1. The NEW State (The Timer Starts)

When you send a UDP packet (like a DNS request), `iptables` sees it and thinks: _"I'll make a note of this. I'll give this 'conversation' **30 seconds** to live."_

- It records the Source IP/Port and Destination IP/Port.
    
- It marks this entry as `[UNREPLIED]`.
### The ESTABLISHED State (The "Handshake" by Proxy)

Since there is no "ACK" packet, `iptables` waits for **any** packet coming back from that specific Destination IP/Port addressed to your Source IP/Port.

- The moment a return packet arrives, `iptables` says: _"Aha! They replied. This is now a real conversation."_
    
- It removes the `[UNREPLIED]` tag and replaces it with `[ASSURED]`.

sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
![[Pasted image 20260322124253.png]]
![[Pasted image 20260322124354.png]]
