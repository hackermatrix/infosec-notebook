


### Log Management Activities 

- General functions 
	-  Log Parsing, filtering and aggregation.  
- Storage functions 
	- Log rotation 
		- Keep logs size manageable 
	- Log Archival
		- Determined by retention policy 
		- Preservation of logs of particular interest 
	- Log reduction/normalization
	- File integrity
- Analysis 
	- Correlation/Viewing/reporting 
- Disposal 
	- Secure disposal

## GENERAL SECURITY AUDIT AND ALARMS PRINCIPLES FOR OSI ITU X.816
- OSI ITU X.816 is a standard from the ITU-T (International Telecommunication Union – Telecommunication Standardization Sector) that deals with **Security Frameworks for Open Systems : Security Audit and Alarms Framework**.
- **Key Components defined in the framework include:**
	- **Audit Trail** : a chronological record of system activities sufficient to enable reconstruction and examination of the sequence of events.
	- **Audit Authority** : the entity responsible for defining what events are auditable and managing the audit process.
	- **Alarm Reporting** : mechanisms for notifying administrators or security systems when thresholds are breached or anomalies detected.
	- **Event Discrimination** : filtering and selecting which events are significant enough to log or trigger alarms.
	- **Audit Analysis** : tools and methods for reviewing collected audit data to identify security incidents or policy violations.


## Practical management of audit trail data

1. Configuring Log Sources:
	- Capture the necessary information and retain it the appropriate period of time. 
	- It depends on the type of log source.


## AUDIT TRAIL ANALYSIS

#### Why it's challenging ?
- You're drowning in logs. Every service, every server, every login attempt generates entries. You need the right tools, you need to understand what the software actually logs (every vendor does it differently), and you need context  a failed login at 3am from a foreign IP means something very different than one at 9am from the office.
#### **How you prioritize what to look at:**

- Not all log entries are equal. You rank them by asking: What type of event is it? Is it new or recurring? Where did it come from? What IP? What time? How often? A single failed SSH login is nothing. A thousand in one minute from the same IP? That's an attack.

#### **Who's responsible ?**

- Infrastructure admins (network, firewalls, etc.) treat log analysis as their primary job. System-level admins (managing individual servers/apps) often treat it as secondary : they've got other stuff to do.

**Three ways to use audit trails:**

1. **After something bad happens** : "We got breached, let's trace what happened." You dig through logs looking for clues, focused on that specific incident.
2. **Periodic review** : Regularly scanning bulk logs to spot trends, weird behavior, or slow-building problems before they explode.
3. **Real-time analysis** : Logs are watched live, usually by an intrusion detection system (IDS), catching attacks as they happen.


### Approaches to Audit Data Analysis

1. **Basic Alerting**
	- Simplest approach
	- "Tell me when X happens"
	- You define the rules, it watches for them
	- Example: alert on 5 failed logins

2. **Baselining**
	- First, learn what "normal" looks like
	- Then compare new data against that normal
	- Flag anything that deviates
	- **Thresholding** = setting a specific number as the limit (like a speed limit)

3. **Windowing**
	- Look at events within a specific time frame or parameters
	- "Show me everything between 2am and 4am"
	- Zooming into a slice of data instead of one event

4. **Correlation**
	- Seeks relationships between separate events
	- Connects the dots across different logs
	- Port scan + failed login + successful login + file download = attack story
	- Most powerful of the four

5. **Sophistication order:**
	- Alerting → "this happened"
	- Baselining → "this is unusual"
	- Windowing → "look at this timeframe"
	- Correlation → "these events are connected"



