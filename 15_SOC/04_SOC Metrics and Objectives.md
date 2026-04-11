
### # Core Metrics

| Metric                | Formula                                  | Measures                     |
| --------------------- | ---------------------------------------- | ---------------------------- |
| Alerts Count          | `AC = Total Count of Alerts Received`    | Overall load of SOC analysts |
| False Positive Rate   | `FPR = False Positives / Total Alerts`   | Level of noise in the alerts |
| Alert Escalation Rate | `AER = Escalated Alerts / Total Alerts`  | Experience of L1 analysts    |
| Threat Detection Rate | `TDR = Detected Threats / Total Threats` | Reliability of the SOC team  |

### # Triage Metrics
| Metric                          | Common SLA | Description                                                               |
| ------------------------------- | ---------- | ------------------------------------------------------------------------- |
| SOC Team Availability           | 24/7       | Working schedule of the SOC team, often Monday-Friday (8/5) or 24/7 mode. |
| Mean Time to Detect (MTTD)      | 5 minutes  | Average time between the attack and its detection by SOC tools            |
| Mean Time to Acknowledge (MTTA) | 10 minutes | Average time for L1 analysts to start triage of the new alert             |
| Mean Time to Respond (MTTR)     | 60 minutes | Average time taken by SOC to actually stop the breach from spreading      |

 **Service Level Agreement (SLA)** - a document signed between the internal SOC team and its company management, or by the managed SOC provider (MSSP) and its customers.

![[Pasted image 20260403150613.png]]

**Note:** MTTR also includes MTTA. So its (MTTR + Internal Process) .  