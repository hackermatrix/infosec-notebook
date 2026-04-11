## 🛡**Encryption & Decryption**:

### 1. Symmetric (password-based) encryption

```
# Encrypt file with passphrase 
gpg --symmetric file.txt 

# Non-interactive / script mode 
gpg --batch --passphrase "$PASS" --output file.txt.gpg --symmetric file.txt
```

### 2. Symmetric decryption

```
gpg --decrypt file.txt.gpg > file.txt 

# Non-interactive 
gpg --batch --passphrase "$PASS" --output file.txt --decrypt file.txt.gpg
```


## ✍️ Signing & Verifying:

### 1. Sign a file

```
# Detached signature 
gpg --output file.sig --detach-sign file.txt  

# Cleartext signature (good for text files) 
gpg --clearsign file.txt

```

### 2. Verify a signature

```
# Detached signature 
gpg --verify file.sig file.txt  

# Cleartext signature 
gpg file.txt.asc

```

---

## **📄 Import / Export Keys From Keyservers**

```
# Receive a public key from keyserver 
gpg --keyserver keyserver.ubuntu.com --recv-keys ABCDEFGH  

# Send your public key to keyserver 
gpg --keyserver keyserver.ubuntu.com --send-keys ABCDEFGH
```



## **🔑 Key Management**

### Generate a new key pair

```
gpg --full-generate-key
```

### List your keys

```
# Public keys 
gpg --list-keys  

# Private keys 
gpg --list-secret-keys

# list key IDs
gpg --list-public-keys --keyid-format **none|short|0xshort|long|0xlong**

```

### Export keys

```
# Export public key 
gpg --export -a "User Name" > public.key  

# Export private key 
gpg --export-secret-keys -a "User Name" > private.key

```

### Import keys

```
gpg --import public.key gpg --import private.key
```