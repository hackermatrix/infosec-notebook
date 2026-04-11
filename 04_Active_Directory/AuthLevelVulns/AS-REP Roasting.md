##### Resources
- https://jumpcloud.com/it-index/what-is-as-rep-roasting

- AS-REP Roasting is a **credential-dumping** attack targeting [Active Directory](https://jumpcloud.com/blog/active-directory-faq) by exploiting accounts with “Do not require Kerberos pre-authentication” enabled.

- Happens when the Kerberos Pre-authentication is OFF . Meaning the user does not need to send the NTLM hash of the timestamp to prove its identity. So the attacker can simply send the username to the KDC and get the TGT and the session key. Then the attacker can crack the TGT to get the user's password.

**Exploitation:**