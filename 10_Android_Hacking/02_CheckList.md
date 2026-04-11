#### More on : https://book.hacktricks.wiki/en/mobile-pentesting/android-checklist.html

# Android Application Security Testing Checklist

## Information Gathering
- [ ] Obtain the APK file of the application
- [ ] Identify the Android version the application runs on
- [ ] Identify device hardware requirements
- [ ] Identify device software requirements

## Static Analysis
- [ ] Decompile the APK using JADX or dex2jar
- [ ] Review the AndroidManifest.xml file
- [ ] Identify sensitive data in source code
- [ ] Review requested permissions
- [ ] Identify exposed or risky APIs
- [ ] Check input validation mechanisms
- [ ] Check error handling practices
- [ ] Review authentication and authorization logic

## Dynamic Analysis
- [ ] Intercept application traffic using Burp Suite or OWASP ZAP
- [ ] Modify and replay requests
- [ ] Test for SQL Injection
- [ ] Test for Cross-Site Scripting (XSS)
- [ ] Test for Cross-Site Request Forgery (CSRF)
- [ ] Check for insecure local storage
- [ ] Verify secure communication (SSL/TLS implementation)

## Reverse Engineering
- [ ] Reverse engineer APK using Apktool
- [ ] Analyze application resources (XML, assets, libs)
- [ ] Look for hardcoded secrets or API keys
- [ ] Identify sensitive data in assets
- [ ] Check for code obfuscation techniques
- [ ] Assess effectiveness of obfuscation

## Runtime Analysis
- [ ] Hook application runtime using Frida or Xposed
- [ ] Intercept sensitive function calls
- [ ] Test for code injection vulnerabilities
- [ ] Check for buffer overflow conditions
- [ ] Test for privilege escalation paths
- [ ] Detect anti-debugging mechanisms
- [ ] Detect anti-tampering protections
