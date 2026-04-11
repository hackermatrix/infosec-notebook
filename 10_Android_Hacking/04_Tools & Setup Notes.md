
This section covers the **essential tools**, **environment setup**, and **decompilation workflow** used in Android bug bounty hunting.

---

## 1. Android Studio

### What it is

- Official IDE for Android development
    
- Includes:
    
    - Android SDK
        
    - AVD Manager
        
    - Emulator
        

### Why Bug Bounty Hunters Use It

- Creating and managing **Android Emulators**
    
- Access to:
    
    - Logcat
        
    - Device file system
        
    - Network debugging
        

### Key Features to Use

- AVD Manager
    
- Logcat (runtime logs & crashes)
    
- Device Explorer
    

---

## 2. Android Emulator

### What it is

- Virtual Android device running on your system
    

### Bug Bounty Advantages

- Easy root access (debug builds)
    
- Snapshot support
    
- Safe testing environment
    

### Emulator Setup (Recommended)

1. Open Android Studio
    
2. Go to **AVD Manager**
    
3. Create a new virtual device
    
4. Choose:
    
    - Pixel device
        
    - x86_64 system image
        
5. Use a **Google APIs image (not Play Store)**
    



---

## 4. apktool

### What it is

- Tool to **decode and rebuild APKs**
    

### Why It’s Important

- Extracts:
    
    - AndroidManifest.xml
        
    - Resources (XML, layouts)
        
- Smali code access
    

### Common Usage

```bash
apktool d app.apk
```

---

## 5. dex2jar

### What it is

- Converts `.dex` files into `.jar`
    

### Purpose

- Enables Java decompilers to read Android bytecode
    

### Usage

```bash
dex2jar classes.dex
```

---

## 6. JD-GUI

### What it is

- Java Decompiler GUI
    

### Why It’s Useful

- Clean Java-like source view
    
- Easy navigation across classes
    

### Pro Tip

> `dex2jar + JD-GUI` make a **great reverse engineering pair**.

---

## 7. Frida

##### Resource: https://medium.com/@agmmnn/ssl-pinning-bypass-for-android-emulators-using-frida-702c6bf84e38

### Why Bug Bounty Hunters Love It

- Hook functions at runtime
    
- Bypass:
    - Root detection
    - SSL pinning
    - Client-side checks

### How To:
- Once the frida server is running on the device, use the following command on the host:
- ```bash
  frida -U -n "Indeed Job Search" --codeshare akabe1/frida-multiple-unpinning
  ```

---

## 8. Decompilation Workflow

### Recommended Approach

#### Step 1: Decode APK

```bash
apktool d app.apk -o app_decoded
```

#### Step 2: Convert DEX to JAR

```bash
dex2jar classes.dex
```

#### Step 3: Analyze in JD-GUI

- Open `.jar` file
    
- Browse Java source
    

---

## 9. Pro Decompilation Tips

- Decompile the **whole APK** into a directory
    
- Use an **external editor** (VS Code / IntelliJ)
    
- Grep for:
    
    - `token`
    - `secret`
    - `password`
        

> Treat the APK like a leaked source code repository.

---
## 9. Logcat 
## What is Logcat?
- Use `adb logcat` to view system and application logs
**Logcat** is Android’s **logging system** that shows:

- App logs
    
- Errors & crashes
    
- Debug messages
    
- Stack traces
    
- System events
    

Think of it as:

> **`tail -f /var/log/app.log` but for Android**

---

## Why Logcat matters in Bug Bounty 🔥

Logcat often leaks **way more than developers realize**.

You’ll commonly find:

- API endpoints
    
- Tokens / session IDs
    
- User IDs
    
- Debug messages
    
- Stack traces with class & method names
    
- Feature flags
    
- Crypto errors
    

Many bugs start with:

> “Oh… they logged _that_ 😬”

---
## Final Bug Bounty Advice

Static + Dynamic analysis together = 🔥

- Static → Find logic
    
- Dynamic → Bypass logic
    

---
