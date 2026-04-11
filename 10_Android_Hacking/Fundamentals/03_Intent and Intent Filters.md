

## What is an Intent?
An **Intent** is a messaging object in Android used to request an action from another application component.  
It enables communication between components **within the same app** or **across different apps**.

---

## What Intents Are Used For
Intents are commonly used to:
- Start an **Activity**
- Start or interact with a **Service**
- Send a **Broadcast**
- Launch system components (browser, camera, dialer, etc.)

---

## Types of Intents

### Explicit Intent
An explicit intent specifies the **exact component** to start.  
Typically used within the same application.

```java
Intent intent = new Intent(this, ProfileActivity.class);
startActivity(intent);
```

---

### Implicit Intent
An implicit intent does **not specify a component**.  
Android determines which app can handle the request.

```java
Intent intent = new Intent(Intent.ACTION_VIEW);
intent.setData(Uri.parse("https://example.com"));
startActivity(intent);
```

If multiple apps can handle the intent, the user is shown a chooser.

---

## Core Components of an Intent

### Action
Defines **what action** should be performed.

Common actions:
- `ACTION_VIEW`
- `ACTION_SEND`
- `ACTION_DIAL`

```java
intent.setAction(Intent.ACTION_SEND);
```

---

### Data
Specifies the data to operate on, usually in the form of a URI.

```java
intent.setData(Uri.parse("tel:123456789"));
```

---

### Extras
Key-value pairs used to pass additional data.

```java
intent.putExtra("username", "hck");
```

---

### Category
Provides additional information about how the intent should be handled.

Example:
- `CATEGORY_LAUNCHER`

```xml
<intent-filter>
    <action android:name="android.intent.action.MAIN"/>
    <category android:name="android.intent.category.LAUNCHER"/>
</intent-filter>
```

---

## Intent Filters
Intent filters are defined in **AndroidManifest.xml** and declare which intents a component can respond to.

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <data android:scheme="https"/>
</intent-filter>
```

---

## Security Perspective
Intents represent a **significant attack surface** in Android applications.

Common security issues include:
- Exported Activities or Services without proper restrictions
- Implicit intents handling sensitive data
- Missing permission checks
- Intent injection vulnerabilities
- Insecure use of `PendingIntent`

---

## Mental Model
Think of intents as messages:
- **Explicit Intent** → Direct message to a known recipient
- **Implicit Intent** → Broadcast request to anyone who can handle it
