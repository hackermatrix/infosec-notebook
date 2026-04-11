# Types of Android Applications 

Understanding the **type of Android application** you’re testing is critical in bug bounty, because the **attack surface, tooling, and vulnerabilities** differ a lot.

---

## 1. Pure Native Applications

### What they are

- Built **entirely using native Android technologies**
- Written mainly in:
    - **Java**
    - **Kotlin**
- Use Android SDK and system APIs directly
    
### Architecture

- No embedded browser for core logic
- Business logic runs **inside the APK**
- Uses:
    
    - Activities
    - Services
    - Broadcast Receivers
    - Content Providers

### Key Point

> You mostly attack the **APK itself**.

---

## 2. Hybrid Applications

### What they are

- Mix of **native code + web technologies**
- UI often built using:
    - HTML
    - CSS
    - JavaScript
- Rendered using **WebView**
    

### Popular Frameworks
- React Native
- Flutter (Dart)
- Ionic
- Cordova / PhoneGap
### Architecture

- Native shell
- WebView loads:
    - Local HTML/JS files **or**
    - Remote web content
- JavaScript can communicate with native code via **JavaScript bridges**
    


### Typical Bugs

- XSS → Native code execution
- Arbitrary file access
- Sensitive data exposure via JS bridges
    

### Key Point

> You test **both Android + Web vulnerabilities**.

---

## 3. Web Wrapper Applications

### What they are

- Basically a **browser packaged as an APK**
- The app just loads a website inside a WebView
    

### Architecture

- Minimal native code
- Almost all logic runs on:
    - A **remote web server**
- App acts like a container for a website
    

### Common Examples

- News apps
- Simple startup MVP apps
- PWA-to-APK conversions


### Typical Bugs

- Account takeover via web bugs
- Token leakage via intents
- Open redirects leading to phishing
    

### Key Point

> Treat it like **web pentesting + light Android checks**.

---

## Quick Comparison Table

|Type|Code Location|Main Focus|Bug Bounty Angle|
|---|---|---|---|
|Pure Native|APK|Android internals|Reverse engineering & runtime hooking|
|Hybrid|APK + Web|Android + WebView|JS bridge & WebView abuse|
|Web Wrapper|Web server|Website|Web vulnerabilities|

---

# Steps to follow 
## 1. Target Selection

- Apps that use a large number of web views or simply wrap a web app
-  Apps that expose a lot of different functionality when talking to servers
- Games with leaderboards
## 2. Get the Source Code 

## 3. Setup a Burp Proxy