
APIs are mechanisms that enable **two software components to communicate with each other using a set of definitions and protocols**.

**REST API and Websocket APIs are both WEB APIs**

# What is REST API?

REST is a **style of API architecture** used on the web.  
REST APIs use **HTTP methods**.
It works on the **(Request–Response Model)**

REST works like this:
Client → Request → Server  
Client ← Response ← Server

Example:

Mobile App → GET /balance  
Server → returns JSON with balance

After the response, **the connection ends**.

If the app wants new data, it must **send another request**.

Example:

GET /accounts/123  
POST /transactions  
PUT /profile  
DELETE /session

Each endpoint performs an action.

Example:

GET /transactions

returns a list of transactions.

| Method | Meaning |
| ------ | ------- |
| GET    | Read    |
| POST   | Create  |
| PUT    | Update  |
| DELETE | Remove  |

The main feature of [REST API](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-vs-rest.html) is statelessness. Statelessness means that servers do not save client data between requests.
## WebSocket API (Persistent Connection)

WebSockets keep a **continuous open connection**.

Client ↔ Server

Once connected, **both sides can send messages anytime**.
that uses JSON objects to pass data. A WebSocket API supports two-way communication between client apps and the server. The server can send callback messages to connected clients, making it more efficient than REST API.


|Feature|REST API|WebSocket API|
|---|---|---|
|Connection|Opens per request|Persistent connection|
|Communication|Client initiates|Two-way anytime|
|Data format|JSON/XML|Usually JSON|
|Use case|Standard web apps|Real-time systems|

# What is JSON?

JSON = **JavaScript Object Notation**

It is the **data format used by APIs to send information**.

Example API response:

{  
  "account_id": "12345",  
  "balance": 8500,  
  "currency": "USD"  
}

Simple rule:

JSON = **how data is structured in API responses**

# What is XML?

XML is **another data format**, older but still used in financial systems.
XML is a markup-based data format

Example:

<account>  
  <account_id>12345</account_id>  
  <balance>8500</balance>  
</account>

How to Conduct API Security Audit: 

### 1. Scope Definition
First, I would define the scope of the API audit by identifying **which APIs are in scope**, **what data they expose**, and **what systems or business processes depend on them.**
Depending on the scope of the engagement, testing might involve automated scanning tools or controlled testing. Consider if it is controlled testing:
### 2. Information Gathering
Next, I would **review API documentation and architectur**e, understand the API’s code and design, and conducting interviews with the API developers. During the interview with the Developers I would try to understand this: 
**How authentication, authorization, and data handling are implemented**
3. **Threat modeling**: Identify potential threats and vulnerabilities. This can be done using different techniques by reviewing common API attack vectors **OWASP API Top 10**.
### 4. Testing and Evaluation

Based on the scope, I would perform testing or validation of controls, which may include reviewing authentication mechanisms like OAuth or API keys, verifying encryption such as HTTPS, and checking whether endpoints enforce access controls properly.


### 1️⃣ Authentication

Who can call the API?

Check for:

- API keys
    
- OAuth tokens
    
- JWT tokens
-
Example risk:

API endpoint accessible without authentication

### 2️⃣ Authorization

Even if a user is authenticated:

Can they access **only their data**?

Example risk:

GET /accounts/123

If changing `123 → 124` returns another user's data, that is a **major security flaw**.

Broken Object Level Authorization (BOLA): 

### 3️⃣ Data Protection

Check if sensitive data is protected.

Look for:

- HTTPS/TLS encryption
    
- PII in API responses
    
- data masking
    
- logging of sensitive data

### 4️⃣ Abuse Protection

APIs must prevent attacks like:

- brute force
    
- data scraping
    
- DDoS
-

### 5. Reporting and Remediation

Finally, I would document the findings, explain the associated risks, and work with the development team to implement remediation steps. After remediation, I would validate that the controls are effective and recommend ongoing monitoring of API activity.

## How to secure a REST API?


Security Flow:

**Broken Object Level Authorization:**


## What are the benefits of REST APIs?

REST APIs offer four main benefits:

### 1. Integration 

APIs are used to integrate new applications with existing software systems. This increases development speed because each functionality doesn’t have to be written from scratch. You can use APIs to leverage existing code.

2. Ease of Maintenance 

## What are the different types of APIs?

APIs are classified both according to their architecture and scope of use. We have already explored the main types of API architectures so let’s take a look at the scope of use.

### Private APIs

These are internal to an enterprise and only used for connecting systems and data within the business.

### Public APIs 

These are open to the public and may be used by anyone. There may or not be some authorization and cost associated with these types of APIs.

### Partner APIs 

These are only accessible by authorized external developers to aid business-to-business partnerships.

### Composite APIs 

These combine two or more different APIs to address complex system requirements or behaviors.


## What is an API endpoint and why is it important?

API endpoints are the final touchpoints in the API communication system. These include server URLs, services, and other specific digital locations from where information is sent and received between systems. API endpoints are critical to enterprises for two main reasons: 

### 1. Security

API endpoints make the system vulnerable to attack. API monitoring is crucial for preventing misuse.

### 2. Performance

API endpoints, especially high traffic ones, can cause bottlenecks and affect system performance.

https://aws.amazon.com/what-is/api/


How would you know which APIs exist in the environment?”
I would start by reviewing **API documentation and architecture diagrams to identify officially documented APIs**. I would also **review API gateways, service registries, or developer portals where APIs are typically managed.** Additionally, **network logs, API gateway logs, or traffic monitoring tools can help identify APIs that may not be formally documented but are still active in the environment.**

What if the developer disagrees with your finding and says the API works fine?
I would first try to understand the **developer’s implementation and any technical constraints**. Then I would explain the risk in **terms of business impact** rather than purely technical concerns. For example, if **an API exposes financial transaction data without strong authorization checks, it could allow unauthorized access to customer information, which creates regulatory and reputational risks for the organization.**
I would stay put to my point, If the concern remains unresolved, the issue would be documented as an audit finding and escalated through the appropriate governance channels.



What risks exist if APIs return too much data in JSON responses
Excessive Data Exposure


https://www.sentinelone.com/cybersecurity-101/cybersecurity/api-security-audit/
