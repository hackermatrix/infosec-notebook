
## 🔑 SSH Key Generation & Management

### **Generate SSH Key Pair**

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

### **Generate Key with Custom Comment**

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa_custom
```

### **Specify Passphrase for Key**

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa_secure -N "your_passphrase"
```

### **View Public Key**

```bash
cat ~/.ssh/id_rsa.pub
cat ~/.ssh/id_ed25519.pub
```

### **Copy Public Key to Remote Server**

```bash
ssh-copy-id user@remote_host
```

### **Test SSH Connection**

```bash
ssh -i ~/.ssh/id_rsa user@remote_host
```

### **Change Passphrase of Existing Key**

```bash
ssh-keygen -p -f ~/.ssh/id_rsa
```

### **List Fingerprint of Key**

```bash
ssh-keygen -lf ~/.ssh/id_rsa.pub
ssh-keygen -lf ~/.ssh/id_ed25519.pub
```

### **Convert Key Formats**

```bash
# PEM to OpenSSH
ssh-keygen -p -m PEM -f ~/.ssh/id_rsa
# OpenSSH to PEM
ssh-keygen -p -m PKCS8 -f ~/.ssh/id_rsa
```

### **Remove Passphrase for Key**

```bash
ssh-keygen -p -N "" -f ~/.ssh/id_rsa
```

### **Generate Key for SSH Agent**

```bash
ssh-add ~/.ssh/id_rsa
ssh-add -l  # List keys added to agent
ssh-add -D  # Remove all keys from agent
```