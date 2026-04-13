**RESOURCES:**
1. https://github.com/linux-audit/audit-documentation/wiki
2. https://linux.die.net/man/7/audit.rules ---( How to Write auditd.rules )
3. https://github.com/bfuzzy/auditd-attack/tree/master ---( rules examples from MITRE )
4. https://izyknows.medium.com/linux-auditd-for-threat-detection-d06c8b941505 ---(Medium Blog)
## **The Linux Audit System**

- The Linux Audit system provides a way to log events that happen on a Linux system. The recording options offered by the Audit system is extensive : process, network, file, user login/logout events, etc.

- The entire list of types that can be recorded are listed [here](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security_guide/sec-audit_record_types).

- “auditd” is the **audit d**aemon that leverages the Linux audit system to write events to the disk. User-space applications make system calls which the kernel passes through certain filters and then finally through the “exclude” filter.

### What is the difference between autditd and journalctl or syslog
- **auditd** = security camera (watches specific things you tell it to)
- **journalctl** = general diary (records everything the system does) [[04_Unix_Syslog|More Info]]


## How does auditd work ?

![[Pasted image 20260412200948.png]]
### The Flow

**1. Application makes a system call**

- Any app (web server, shell, script) needs to talk to the kernel
- It sends a system call (open file, create process, etc.)

**2. Kernel receives it**

- The call enters the kernel at the **User** entry point
- Goes to **System Call Processing** : the kernel does the actual work

**3. Audit checkpoints inside the kernel**

- There are multiple hook points watching the system call:
    - **User** : who initiated it?
    - **Task** : what process/task is it?
    - **Exit** : what was the result?
    - **Exclude** : should we ignore this event?

**4. Two paths out**

- **Back to Application** : the system call result returns to the app (normal operation, happens regardless)
- **To Audit Daemon** : if the call matches your audit rules, the kernel sends a log entry to `auditd`

## Components of auditd

### 1. auditd (Audit Daemon)
	- The core background process
	- Receives events from the kernel
	- Writes them to `/var/log/audit/audit.log`
	- That's it — it's just the writer
### 2. auditctl
	- Command-line tool to **manage audit rules**
	- Add, delete, or list rules on the fly
	- Example: `auditctl -w /etc/passwd -p rwa -k passwd_watch`
	- Changes are temporary — gone after reboot unless saved

### 3. audit.rules
	- File at `/etc/audit/audit.rules`
	- **Permanent rules** that load at boot
	- Same syntax as auditctl but persists across reboots

### 4. ausearch
	- **Search tool** for audit logs
	- Find specific events quickly
	- Examples:
	    - `ausearch -k passwd_watch` — find events by key
	    - `ausearch -ui 1000` — find events by user ID
	    - `ausearch -ts today` — find today's events

### 5. aureport
	- **Reporting tool** — gives you summaries
	- Examples:
	    - `aureport -au` — authentication report
	    - `aureport -f` — file access report
	    - `aureport -l` — login report
	    - `aureport --summary` — overall summary

### 6. auditspd (audisp)
	- **Dispatcher** — sends audit events to other places
	- Instead of just writing to disk, forward logs to:
	    - A SIEM
	    - A remote server
	    - A custom script
	- Lives at `/etc/audisp/`

### 7. Kernel Audit System
	- The actual engine inside the kernel
	- Intercepts system calls
	- Applies filters (User, Task, Exit, Exclude)
	- Sends matching events to auditd
	- This is where the real work happens


## How do you configure ?

- The two files we particularly care about in the audit system are

	- **/etc/audit/audit.rules**: Tells the audit daemon what to record. This is where most of one’s time should go deciding what events are most important to you
	- **audit.conf**: Governs how the audit daemon runs. Log file location, buffer size, log rotation criteria, etc. I would not mess around too much with this file, but we’ll get to some important parameters of it later