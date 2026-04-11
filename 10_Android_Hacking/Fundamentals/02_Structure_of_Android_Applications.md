
Understanding the **internal structure of an Android app (APK)** is fundamental for reverse engineering and vulnerability discovery.

---

## 1. APK Container

### What is an APK?

- **APK (Android Package)** is a ZIP-based archive
- Contains **all code, resources, and metadata** required to run an Android app

You can rename it:

```bash
app.apk → app.zip
```

### Why Bug Bounty Hunters Care

- APK = **your primary target**
- Everything you test starts by unpacking the APK
- Sensitive data often lives inside the APK

### Common Recon Actions

```bash
unzip app.apk
apktool d app.apk
```

---

## 2. DEX Files (Dalvik Executable)

### What are DEX files?

- `classes.dex` contains the **compiled Java/Kotlin bytecode**
- Newer apps may have:
    - `classes2.dex`
    - `classes3.dex`

### Key Characteristics
- Runs on **ART (Android Runtime)**
- Optimized for low-memory environments

### Bug Bounty Relevance

- This is where:
    - Business logic lives
    - Authentication logic exists
    - Client-side checks are implemented

### Common Issues Found

- Hardcoded API keys
- Insecure crypto usage
- Feature flags
- Debug checks
- Root/emulator detection
    

### Analysis Tools

```bash
jadx app.apk
jadx-gui app.apk
```

> If logic exists in the app, it can usually be bypassed.

---

## 3. Resources

### What are Resources?

- Non-code files used by the app
- Stored inside the `res/` directory

### Common Resource Types

- `res/layout/` → UI layouts (XML)
- `res/values/` → strings, colors, configs
- `res/drawable/` → images
- `res/raw/` → raw files (sometimes certificates or configs)
    

### Bug Bounty Goldmine 🔥

- `strings.xml` often contains:
    - API endpoints
    - Secrets
    - Feature toggles
        
### Example

```xml
<string name="api_base_url">https://api.example.com</string>
```

### Things to Look For

- Hidden endpoints
- Debug URLs
- Third-party service keys
    

---

## 4. AndroidManifest.xml

### What is the Manifest?

- **Blueprint of the app**
- Declares:
    - App components
    - Permissions
    - Exported components
    - Entry points
        
### Why It’s Critical for Bug Bounty

- First file you should read after decompiling
- Reveals **attack surface instantly**
    

### Key Things to Check

- Exported activities/services/receivers
- Dangerous permissions
- Deep links (`intent-filter`)
- Backup enabled
    

### Example

```xml
<activity
    android:name=".MainActivity"
    android:exported="true" />
```

> `exported="true"` = externally accessible = attack vector

### High-Risk Misconfigurations

- Exported components without permission checks
- `android:debuggable="true"`
- `android:allowBackup="true"`

---

## Quick Mental Model

```
APK
├── AndroidManifest.xml  ← Attack surface map
├── classes.dex          ← Logic & bypasses
├── res/                 ← Secrets & endpoints
├── assets/              ← Web content (Hybrid apps)
└── META-INF/            ← Signing info
```

---

## Bug Bounty Workflow Tip

When you get an APK:

1. Decompile it
2. Open **AndroidManifest.xml first**
3. Scan `strings.xml`
4. Reverse logic in `classes.dex`
    

> This order saves time and finds bugs faster.

---
