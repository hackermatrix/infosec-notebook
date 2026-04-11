	Was performing nmap on this:



![[Pasted image 20260404145827.png]]

I got this error: 

![[Pasted image 20260404145853.png]]

Ping requests are getting blocked. 
We would use this then

| `-Pn` | No Ping           | Assume host is up (bypasses ICMP blocks).                |
| :---- | :---------------- | :------------------------------------------------------- |

![[Pasted image 20260404150825.png]]

Nmap by default tries to do reverse DNS lookups (IP → hostname) for targets. Since there's no DNS server available, it fails. Lab VM has **no DNS server configured**.

- `1 up` → host IS alive ✓
- `1 undergoing XMAS Scan` → currently being scanned ✓
- `0 hosts completed` → scan not **finished** yet

![[Pasted image 20260404152016.png]]

With -Pn: Step 1: SKIPPED → just assume alive Step 2: Scan ports → all 999 = no response = open|filtered

Now to understand the exact response let us you use vv for verbosity. 
![[Pasted image 20260404153056.png]]

Perform a TCP SYN scan on the first 5000 ports of the target -- how many ports are shown to be open?
![[Pasted image 20260404153438.png]]
