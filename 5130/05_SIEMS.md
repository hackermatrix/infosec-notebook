
## What is it?

- A tool that collects logs from EVERYTHING in your network
- Combines two older concepts:
    - **SIM** (Security Information Management) : log storage & reporting
    - **SEM** (Security Event Management) : real-time monitoring & alerts
- SIEM = both combined into one platform

## What does it collect from?
- Firewalls
- Servers
- Routers/switches
- Antivirus software
- Applications
- Databases
- Operating systems
- Cloud services
- Basically anything that produces logs


## Core Functions

**1. Log Collection & Aggregation**
- Pulls logs from all sources into one place
- Normalizes them into a common format
- No more jumping between 50 different servers to read logs

**2. Correlation**
- Connects events across different sources
- Failed login on server + firewall port scan + new account created = possible breach
- This is the real power of a SIEM

**3. Alerting**
- Real-time notifications when something suspicious happens
- Based on rules you define or built-in detection logic
- Example: "alert if admin account logs in from a foreign country"

**4. Dashboards & Visualization**
- Pretty graphs showing what's happening across your network
- Top attacked hosts, most common alerts, trends over time

**5. Retention & Storage**
- Stores logs long-term for compliance
- Regulations like HIPAA, PCI-DSS, GDPR require you to keep logs for months/years

**6. Forensics & Investigation**
- When something bad happens, you search through historical logs
- "Show me everything this IP did in the last 30 days"

**7. Compliance Reporting**
- Auto-generates reports for auditors
- Proves you're monitoring and responding to security events

## How it works (simplified flow)

1. Sources send logs → SIEM
2. SIEM normalizes & stores them
3. Correlation engine looks for patterns
4. Rules match → alert fires
5. Analyst investigates the alert
6. Response & remediation


# Agent vs Agentless Log Collection

## Agent-Based

**What is it?**

- A small piece of software installed on each machine
- Sits there, watches logs, and sends them to your SIEM/log server

**How it works:**

1. Install agent on the machine
2. Agent reads local logs
3. Agent forwards them to central server
4. Runs 24/7 in the background

**Pros:**

- More detailed data collection
- Works even if network is down (caches logs locally)
- Can collect custom application logs
- Better filtering at the source
- More secure — encrypted transmission

**Cons:**

- Must install on EVERY machine
- Uses CPU/memory on each host
- Needs updates and maintenance
- Doesn't work on devices that can't run software (like some network gear)

**Examples:**

- Splunk Universal Forwarder
- Elastic Beats
- Microsoft Defender agent
- OSSEC agent

---

## Agentless

**What is it?**

- No software installed on the target machine
- Central server pulls logs remotely using existing protocols

**How it works:**

1. Central server connects to target machine
2. Reads logs via syslog, WMI, SNMP, SSH, APIs
3. No installation needed on the target

**Pros:**

- No software to install or maintain
- No performance impact on target machines
- Works on devices that can't run agents (routers, switches, printers)
- Faster to deploy

**Cons:**

- Less detailed data
- Depends on network connectivity
- If network is down, logs may be lost
- Limited to what the device exposes via protocols

**Examples:**

- Syslog forwarding from routers
- SNMP polling
- WMI for Windows machines
- API-based cloud log collection