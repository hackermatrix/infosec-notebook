**Reference Lab:** ShadowBait

### What Are Windows Artifacts Anyway?

Think of Windows artifacts as **digital footprints or diary entries** left behind by your interactions with the system. They're pieces of evidence embedded in the Windows operating system tiny clues that reveal:

- What programs you ran
- Which files you opened
- When you logged in and out
- What devices you connected
etc etc ......

### Common Windows Artifacts You Should Know

Let's meet some of the most important and frequently encountered artifacts:

#### 1. Prefetch Files

- **Location:** **`C:\Windows\Prefetch`**
- **What it tells you:** When and how often a program was executed. Windows creates `.pf` files to speed up program loading. These files include timestamps and program details — a great way to track app usage.

#### 2. Jump Lists

- **Location:** **`%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\`**
- **What it tells you:** Recent files and tasks associated with programs, helping reconstruct file opening and program usage history.

#### 3. LNK (Shortcut) Files

- **Location:** Anywhere, often Desktop or Recent folders
- **What it tells you:** They point to files or folders a user interacted with, including access timestamps and file paths.

#### 4. ShellBags

- **Location:** Windows Registry under `HKCU\Software\Microsoft\Windows\Shell\Bags`
- **What it tells you:** Folder viewing history — which folders were opened and how they were viewed, surviving even folder deletion.

#### 5. Windows Event Logs

- **Location:** `C:\Windows\System32\winevt\Logs`
- **What it tells you:** System, security, and application events with detailed timestamps and user info. Great for timeline construction.

#### 6. UserAssist Keys

- **Location:** Registry at `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist`
- **What it tells you:** Programs launched by the user, including counts and last run times.