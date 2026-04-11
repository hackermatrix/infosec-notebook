
### **Check OpenSSL Version**

```bash
openssl version
openssl version -a
```

### **Generate Private Key**

```bash
openssl genpkey -algorithm RSA -out private.key -pkeyopt rsa_keygen_bits:2048
openssl ecparam -name prime256v1 -genkey -noout -out ec_private.key  # EC key
```

### **Generate Public Key from Private Key**

```bash
openssl rsa -in private.key -pubout -out public.key
openssl ec -in ec_private.key -pubout -out ec_public.key
```

### **Create Certificate Signing Request (CSR)**
- This is sent to somebody else to get sign from them 

```bash
openssl req -new -key private.key -out request.csr
openssl req -new -key private.key -out request.csr -subj "/C=US/ST=State/L=City/O=Org/OU=Unit/CN=example.com"
```

## Sign CSR with your own CA 
```bash
openssl x509 -req -in request.csr -CA ca.crt  -CAkey ca.key  -CAcreateserial  -out certificate.crt -days 365 -sha256

- -req → input is a CSR
- -in request.csr → CSR file
- -CA ca.crt → CA certificate
- -CAkey ca.key → CA private key
- -CAcreateserial → generates serial file if missing
- -out certificate.crt → signed certificate output
- -days 365 → validity
- -sha256 → signing algorithm
```
### **Generate Self-Signed Certificate**

```bash
openssl req -x509 -days 365 -key private.key -in request.csr -out certificate.crt
```

### **Convert Certificate Formats**

```bash
# PEM → DER
openssl x509 -in cert.pem -outform der -out cert.der
# DER → PEM
openssl x509 -in cert.der -inform der -out cert.pem
# PEM → PKCS12
openssl pkcs12 -export -in cert.pem -inkey private.key -out cert.p12
# PKCS12 → PEM
openssl pkcs12 -in cert.p12 -out cert.pem -nodes
```

### **View Certificate Details**

```bash
openssl x509 -in certificate.crt -text -noout
openssl x509 -in certificate.pem -dates -noout
```

### **Check CSR Details**

```bash
openssl req -in request.csr -text -noout
```

### **Encrypt / Decrypt Files**

```bash
# Encrypt
openssl enc -aes-256-cbc -salt -in file.txt -out file.txt.enc
# Decrypt
openssl enc -aes-256-cbc -d -in file.txt.enc -out file.txt
```

### **Generate Digest / Hash**

```bash
openssl dgst -sha256 file.txt
openssl dgst -md5 file.txt
```

### **Verify Signature**

```bash
openssl dgst -sha256 -verify public.key -signature file.sig file.txt
```

### **Check SSL/TLS Connection**

```bash
openssl s_client -connect example.com:443
openssl s_client -connect example.com:443 -servername example.com  # SNI
```

### **Start OpenSSL Server**

```bash
openssl s_server -cert certificate.crt -key private.key -accept 4433
```

### **Generate Random Data**

```bash
openssl rand -hex 16
openssl rand -base64 32
```



## Generate a ECC signature :
- **Calculate the message hash:**
```bash
    openssl dgst -sha256 -binary message.txt > hash.bin
```
    
- **Sign the hash with the private key:**
```bash
    openssl pkeyutl -sign -inkey private.key -in hash.bin -out signature.bin
```