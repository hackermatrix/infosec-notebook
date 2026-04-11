
## 🔐 Setting Password Policies in Linux with libpam-pwquality

### **1. Install libpam-pwquality**

```bash
# Debian/Ubuntu
sudo apt install libpam-pwquality

# RHEL/CentOS/Fedora
sudo yum install libpwquality
```

### **2. Configure PAM to Use libpam-pwquality**

Edit the PAM password file:

```bash
sudo nano /etc/pam.d/common-password  # Debian/Ubuntu
sudo nano /etc/pam.d/system-auth     # RHEL/CentOS/Fedora
```

Add or modify the line for `pam_pwquality.so`:

```text
password requisite pam_pwquality.so retry=3 minlen=12 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 enforce_for_root
```

- `minlen=12` → Minimum password length
- `dcredit=-1` → At least 1 digit
- `ucredit=-1` → At least 1 uppercase letter
- `lcredit=-1` → At least 1 lowercase letter
- `ocredit=-1` → At least 1 special character
- `retry=3` → Maximum retries before failure
- `enforce_for_root` → Apply policy to root user as well

### **3. Configure pwquality Settings (Optional)**

Edit `/etc/security/pwquality.conf`:

```text
minlen = 12
minclass = 4   # Number of character classes required (upper, lower, digit, special)
maxrepeat = 3  # Max repeated characters
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
```

### **4. Password Aging**

Set maximum and minimum password age, warning period, and inactivity.

```bash
sudo chage -M 90 username   # Max age 90 days
sudo chage -m 7 username    # Min age 7 days
sudo chage -W 14 username   # Warn 14 days before expiry
sudo chage -I 30 username   # Inactive account lock after 30 days
sudo chage -l username      # List password aging info
```

### **5. Force Password Change on First Login**

```bash
sudo chage -d 0 username
```

### **6. Locking and Unlocking Accounts**

```bash
sudo passwd -l username  # Lock account
sudo passwd -u username  # Unlock account
```

### **7. Enforce Password History (Prevent Reuse)**

Edit `/etc/security/pwquality.conf` or PAM:

```text
remember = 5  # Prevent last 5 passwords from being reused
```

### **8. Account Lockout on Failed Attempts**

Use `pam_tally2` with PAM:

```text
# Add to /etc/pam.d/common-auth or system-auth
auth required pam_tally2.so deny=5 unlock_time=900 onerr=fail audit
```

- `deny=5` → Lock after 5 failed attempts
    
- `unlock_time=900` → Unlock after 15 minutes
    

### **9. Verify Password Policies**

```bash
# Test password complexity
passwd username
# Check PAM configuration
sudo pam-auth-update --enable pwquality
```

### **References**

- [libpam-pwquality Documentation](https://linux.die.net/man/8/pam_pwquality)
    
- `man chage`
    
- `man pam.d`