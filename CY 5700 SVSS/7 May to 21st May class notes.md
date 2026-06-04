
# 7 May 2026 

## Couple of cyber attacks to read about: 
A Cybersecurity breach at Equifax 
Lapsus cyberattacks
Scatterd Spider
Log4j
Solarwinds - SEC charge them 
XZ utlis backsdoor 
Meltdown & Spectre - You can't patch a processor. 
SLAP 
FLOP 
INCEPTION 
Barracude urges customers - firmware support to patch firmware
Japan is running out of beer
Akamai wrestles with AWS S3 **web cache poisoning bug.** 
**Windows - atlernative to NTP.**  replay attack - recheck 
MOVEit
CSRF flaw in csurf NPM package aimed at protecting against the same flaws. 
Ivanti - VPN 
Why do AI company logos look like butthole - classic 
2024 Crodwstrike Incident - software egineering problem 

internwtional requirements 
tuv 
bsi 

operational side of problem in the patching is the problem.

## Slide -02 

Retro Hacking Culture Blackhat hacking

jake davis ted talk 
Mirai Botnet
Klikparty 2007


## Security Lifecycle:

 1. Architecture: Security issues at **Architecture**, **some security decisions should be made here even before right single line of code.**
 2. Implementation: eg. when writing the code for software.  
       e.g buffer overflow, memory corruption, Input validation, output sanitization
 3. Operation: Security considerations when using the system. not going to talk about. -> strong credentials, secure configurations, vulnerability maangement. 

## what is an attack:
Depends on the security policy. Any malicious act against a system that violates your security policy.

## Security policy: 
what are you trying to protect, what assets, what are the security goals, what do you want to protect against, threats. what is the risk? 

## Super important : Security Goals
1. Confidentiality:  the property that **information is not made available to unauthorized entities.** 
2. Integrity: the **property that information is not altered or destroyed in an unauthorized manner.** 
3. Availability: **property of information being available on demand by authorized entity.**
4. Authentication:  **the act of confirming the identity of an entity interacting with a system.**
5. Authorization: **confirming privileges**. 
 e.g have the zoom link to professor's lecture i.e authorization as you the privilege of the link
6. Non-repudiation: **the ability to associate actions or changes to a unique entity** 


## 03- Cryptography for Dummies 

Practice of secure communication in the presence of an adversary. 

Cryptographic primitives: 
Core algorithms to build

Only encrypting the data is not enough it serves only **confidentiality.** 

There should be collision between plaintext and ciphertext. 
With Analayzing ciphertext one should not be able to decipher the plaintext. 
No collision between the plaintext and ciphertext. 
No correlation between the ciphertext and key. 


## Security by obscurity

We do not do that e.g. ciphertext is always public. 
then you securiy be leaked and reverse-engineeed. 

## Mode of Operation 

block cipher mode of operation. 
an alogrithm that describes how to repeatedly 

## Message Authentication Code 

**MAC is for authentication and integrity**. But it is weak because suppose you share your key with multiple folk you can authenticate that it is from your shared key but you dont know from whom it is. 


## Cryptohraphic Hash Functions 

A function to map data of arbitrary length to a short, fixed length bit hash. 
also called a digest. 

**Integrity**
**Authentication**

MAC gives you better authentication/integrity than hash. ubutnu attacker example. 


# 14 May 2026 

## Changing the ciphertext example 

Fresh out of college working on a payroll processor. 

JSON PAYLOAD looks like this and sends to the backend of the company. 
src_account: 946720344
dst_account: 94
amount: 1000 


20 means space. 
39 asii to 9 

now to get the difference in cryto  you do xor 
20 = 0010 0000
39 = 0011 1001
    +  0001 1001 = X

APPLY this to the cipher text 


This attack violates integrity as we are changing ciphertext, encryption protects confidentiality and not integrity. 
You need to assume the encryption is through stream cipher. 

Intergrity of block cipher can also be changed but it is different. 
that is why mac is needed along with encryption 
second we need to assume that structure of message is known. 
e.g even though you cant see src_account, dst_account atleast knowing the fixed structure helps. 


### Important topic for exam what provides if encryption provides confidentiality, integrity, authentication & non-repudiation 


What about metadata? 

How to break Crypto:

If the key space is small, brute force try all keys!
Find a bias in the algorithm. 
- correlation between plaintext, ciphertext, key.
Usually it is the protocol that is broken. eg. SSL  that is why TLS is used today. 


Randomness is important, 
A lot depends on good random bits. 
Generatinh a nonce/IV - random bit providers. 
picking cipher parameters - eg. like diffie helman not our domain. 

**Need to read Lava Lamps from Cloudflare**. 

Use full disk encryption - xts aes symmetric. 


## 04 - Security Architecture 

1. It is about **components** 
2. Relation about components 
3. Labelling/ what does components do.

When facing security questions, allows developers to answer "yes", or "no" with confidence 

## Design Principles (8) for Security: 

- 1. **Economy of mechanism**; If you want to connect two thing KISS keep it as simple and stupid as **possible.** 

**Higher the complexity, more possibilities for errors. Complex mechanisms are difficult to test.**

Tony Hoare - One way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult. 

Kernighan's Law - Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it.
-
Black Box Testing 
White Box Testing

2.  **Fail-safe defaults**: 
**Default privilege : None** 
**Default state: Lack of access**

Allow by Default:- Wrong method. 

Deny by Default: Roll back to secure state. 
This depends on the context 

3. Complete mediation 

**Check every access to every object** **Every time.** for authorization and authentication.  


- 4. *Open Design 
-It should be possible to **make design available for all parties without compromising security - Security through Obscurity. 

Make security depend on the secrecy of a small token.

- 5. Seperation of privilege
Do not grant access based on a single condition.
-Process-oriented too; e.g., commits to your git repo.
https://techcommunity.microsoft.com/blog/azuresqlblog/security-separation-of-privilege/2393637

- 6. Least privilege 
-Hold the minimum possible privileges to complete the task.
If augmented privileges are needed, relinquish them when no longer needed.
Minimizes **damage if something goes wrong**.

- 7. Least Common mechanism.
-![[Pasted image 20260520143528.png]]


- 8. Pscyhological acceptability. 
- If security controls, software, or policies are too cumbersome, unintuitive, or frustrating to navigate, **humans will inevitably try to bypass them to get their work done.**
- ==security mechanisms should not make a resource more difficult to access than if the security controls were not present==.
- 
- 9. Seperation of data and control. 
 Control: Processing Information. e.g Javascript is pure control. 
When designing the system make sure your system can differentiate between data and control. 
An HTML page is supposed to be _data_ ,content you read. But HTML allows `<script>` tags, meaning executable code lives right alongside the content. This is exactly why XSS works.

- 10. Defense in depth. 


## Linux Security

### What is Kernel 
Linux kernel is the software that runs in **supervisor mode** and **handles all those responsibilities listed (process management, memory management, filesystem, drivers, security enforcement).**

###  What is User Space 
Userspace - operates in user mode.– System binaries, daemons, applications.

## Difference between user space and kernel space. 
https://blogs.oracle.com/linux/userspace-vs-kernelspace-understanding-the-divide
https://en.wikipedia.org/wiki/Protection_ring
https://medium.com/codex/understanding-operating-system-part-3-7df85242cce5

Anything under /dev and /proc are not files. (Kernel)

### Why is the Linux in the file system

1. For the programs to interface with other things 
2. Ensures uniform access control. 

###  What are linux processes

![[Pasted image 20260603224256.png]]

Linux Process: Processes are the programs currently running on your machine. The Linux kernel manages them, and each process is assigned a unique number called the **process ID (PID**. `ps` command. This provides a quick snapshot of the processes associated with your current terminal session.

here you can see different process id. 

![[Pasted image 20260519174915.png]]
![[Pasted image 20260519175038.png]]
![[Pasted image 20260519175056.png]]

![[Pasted image 20260519180650.png]]
https://www.geeksforgeeks.org/linux-unix/real-effective-and-saved-userid-in-linux/

#### Real User Id (ruid): 
It is simply the **user id** that started the process 

#### Effective User Id (euid): 

It is also same as the real user id but changes when a non-privileged user accesses files meant for privileged user like root. 

Example: You are seeing permissions of usr/bin/passwd 

when a non-privileged user runs it the effective user id will be that of the root i.,e the user id will be of the one the actually user that runs it.  

Lets understand this better with an example. I ran passwd in one terminal. 
![[Pasted image 20260520121401.png]]

In the other terminal I ran ps -a | grep password 
![[Pasted image 20260520121440.png]]
You can see the euid is 0 and the ruid is 1003 here. 

the highlighted red is giving a warning that please be aware if you launch this thing the euid is 0. 

e.g. /usr/bin/sudo : 
this program mentions which user can have sudo like ability.  it will compare if your uid is in the list. 

setgid : will be in all the challenges.

The stat where uid is different than euid is the most privilege. 
#### Saved User Id:

When a process is running with elevated privileges but then suppose it needs to run a process that does not require those elevated privileges. This can be done by saved user id where it switches to a non-privileged account. 

While performing under privileged work the effective user is changed.


## 21 May 2026 

### Linux Security Model 

#### Processes 


![[Pasted image 20260522091835.png]]

Kernel knows the userid, who run the process. The file system is designed to expose as much as possible even things that are not files like sockets, names,

#### Goals
Linux is a multi-user OS.  As multiple users use the same machine you need to isolate the users. Different users should not interfere with each other That is the focus. 

##### Least Privilege: 
smallest amount of privilege, **if they need more give them that for short time and drop it later.** 

If an entity needs to do A give them privileges to do A and not B,C and D. 

eg. Network service must bind to low port. ([check privileges assigned with Ports](https://www.w3.org/Daemon/User/Installation/PrivilegedPorts.html)) 
1. launch with privileges.
2. Use privileges to set up network service. 
3. Drop privileges. 
DROP AND RESTORE THE PRIVILEGES - JUGGLING PRIVILEGES, CONTIONUS CYCLE- have to be in **runtime** 

In the ssh example when someone tries to connect the ssh daemon should set up the environment for you and set up your login, once you set up your login it should be dropped and the cycle continuous.

There might be a time where you will have to drop the privileges forever. 


### Discretionary Access Control, DAC. 

it is an idea an abstraction and different system can implement it not specific to Linux. 

**Control access to objects based on the identity of the subjects or groups they belong to.** 
**owners of objects define policy.** 

In Linux:

subjects are users, objects are file, or that looks like file. 
if you own the file, you get to decide who gets the access. 

### Mandatory access control. 

DAC contrasts MAC
In MAC you have one system admin, one entity at the top who makes all the access control. 

### Role based access control. 
eg. Canvas. 

Every role defines the privileges. 

### File permissions


![[Pasted image 20260522094539.png]]
![[Pasted image 20260522094556.png]]

![[Pasted image 20260522095553.png]]

The first kaan is the owner kaan and the second is the group kaan. 
The uid and group is different. 
It differes per the distro.


#### Directory write bit:
If you see a write you can write files to the directory and delete files inside the directory. There may be a file that does not give you a write access but if the parent directory gives you a write permission you can still delete the file. 

#### File write bit:
Write bit is all about modifying the contents but not completely deleting it. 

File creation and file destruction are directory operations not file. 

![[Pasted image 20260522101007.png]]
![[Pasted image 20260522101026.png|617]]

#### Directory Read Bit: 
if you have a read for directory you can do ls and get contents of the directory. 
if no r ls will give permission denied 

Remember r is about listing the contents. 

#### Directory Execute Bit

execute is accessing the contents of the directory. suppose you want to open etc/a/b/b/c.txt 
to open you need to have read bit set on the file but you also need execute on every parent directory. 

Execute says you can access the contents of the directory. If you drop the r they can no longer do the ls but if they know the name they can directly access it without the ls. 

Note: in the challenge you mean see something like this. 

Example: 

![[Pasted image 20260522102049.png]]

![[Pasted image 20260522102219.png]]

![[Pasted image 20260522102233.png]]

t - sticky bit: files only deletable by owner. - not really talk about 

### Set user id:
![[Pasted image 20260522102945.png]]
![[Pasted image 20260522103015.png]]

![[Pasted image 20260522103221.png]]

![[Pasted image 20260522103248.png]]

This process is run by tara's user id. 

Privilege is employed by ownership. You can only access objects that you own. 

When kaan launches is it does not start with his id but with owner's id (the euid will be 0 , but uid will be kaan's.) Now here euid is not equal to uid. 

![[Pasted image 20260522103940.png]]
![[Pasted image 20260522103953.png]]
This is a privilege elevation mechanism. 

**sudu allows you to be anybody not necesary root.** 

An implication layer check is present at the configuration file  who can do this.
Once you launch this the program launches with the euid root opens the configuration file and see if your uid matches. this is done by the programmers and not operating system.

if you see source code of sudo : 
1. it simply starts 
2. Checks your real user id 
3. Opens the configuration file 
4. Checks if the configuration file has your user id. 
5. If no it exists the program 
6. if yes it creates a child `sudo` calls `fork()` and runs you program with root euid. 
**Child process** — an exact copy that then calls `execve()` to replace itself with whatever command you asked to run, but now with root's effective UID (euid 0)

**To set SUID (User):**  
`chmod u+s filename`

### Setgid programs. 
![[Pasted image 20260522110130.png]]
### Privilege Modification

System admin can say that I am going to make the sshd accessible through the root and also set the setuid bit on it, give execute write to anybody. Anybody can execute the sshd when the process starts the euid will be 0 it can 

Setting the privileges is the deployment administrative tasks. The juggling of the privileges should happen when the process is running in the code. 
This should be in the code - C. 
syscall- need to ask the operating system to change the userid.
setuid family of system calls.
-setuid, setreuid, setresuid
also a libc shortcut: seteduid : 
![[Pasted image 20260522113211.png]]
int seteuid(uid_t uid);
-read the manpages 

setEuid(new):
if (new == UID) OR (new == SUID)

- **You can't gain privileges starting from nothing.**

**There are rules to change these ids in Linux.** 
![[Pasted image 20260522120904.png]]
![[Pasted image 20260522121429.png]]

- **UID (real)** = who you actually are. Kaan ran the program, so UID is always kaan. This never changes (unless you're root). It's your identity.
- **EUID (effective)** = who the kernel _thinks_ you are for permission checks. Because the binary is owned by bob and has the setuid bit, the EUID starts as **bob**. This is the whole point of setuid, temporarily act as the file owner.
- **SUID (saved)** = a backup of the elevated EUID, so you can restore it later if needed. Saves "bob" for that purpose.

![[Pasted image 20260522121842.png]]

Now EUID=kaan, so the kernel treats the process as kaan. Privilege dropped.
Notice SUID still equals bob — so the process _could_ escalate back to bob if it wanted to.

![[Pasted image 20260522122718.png]]

![[Pasted image 20260522122830.png]]
![[Pasted image 20260522122857.png]]
![[Pasted image 20260522123147.png]]


###  Capabilities 

DAC & Capabilites run in parallel. They interact. One more thing about privileges is capability:  is the actions. E.g binding to the lower point. 

**Before capabilities we had to give suid = 0**. **Capabilities is not about users it is about processes.**  

![[Pasted image 20260522144729.png]]
![[Pasted image 20260522144759.png]]
Check man 7 capabilties.
![[Pasted image 20260522145752.png]]

Capabilities that influence the DAC model. 
![[Pasted image 20260522145819.png]]

eg, CAP_KILL
CAP_NET_ADMIN
CAP_SYS_PTRACE 

Intreact with DAC!

CAP_CHOWN
make arbitary changes to file UIDs and GIDS 
CAP_DAC_OVERRIDE

If you have capability you can make arbitary changes to the euid. 
A process under normal condition does not start with any capabilty.
With capabilies it is all or nothing for fine grained access you need DAC. 
For effectively implementing least privilege you need both DAC and capabilities. 
### File Capabilities
![[Pasted image 20260522150620.png]]
E.g. root is going to say I am going to mark sudo with certain file capabilities. Any body launching sudo starts the process holding this capability. 

### Capability Control 

Boils down to juggling members of capability sets. 
capget and capset do capability management during runtime. there are not written in libc you need to write it down. 

every process has five set of capabilities. 
![[Pasted image 20260522163314.png]]
### Capability Sets 
https://man7.org/linux/man-pages/man7/capabilities.7.html

Every process has 5 sets of capabilities. 
1. Effective: 
Actual active capability. Euid

2. Permitted: 
Latent capabilities. is similar to suid.

3. Bounding: 
You start a root process then you launch a child. You don't want to hold all the capabilities. Hard upper bound on allowed capabilties. 

4. Inheritable: 
What capabilties your children inherit. 

5. Ambient: 
What inheritable should have done. 

You need something to start the capabilties. Bootstrat your program with privileges and give it something to run. 

### Launch with privileges. 

![[Pasted image 20260522174658.png]]
![[Pasted image 20260522174830.png]]
Not allow anyone to launch sshd. 

2. Set the suid bit:
Make the sshd all set by root, give the suid bit so almost everyone can do ssh. 

3. Configure the file capabilties: NET_ADMIN
4. Use standard helpers like sudo:
5. Use custom helpers or launchers. 

![[Pasted image 20260522180143.png]]
Developers need to give you code that looks like this. 

#### Example 1 
![[Pasted image 20260522180502.png]]
![[Pasted image 20260522180606.png]]

This is dropping privileges but not dropping capabilities. I think they are going to launch the setuid,  then it will not have affect on the program it will not drop any capabilities running with full capabilities.  But when it restores to root (EUID ← SUID), it gets back **all** of root's powers. 

Decide to use setuid as the system admin.
![[Pasted image 20260522181937.png]]

if this the code you get you need to use capabilities you cannot use setuid. 

Do not pick up program which says this program is not capability aware. 

## Alternatives
![[Pasted image 20260522182433.png]]

AppArmor is a kernal extension. something that Ubuntu applies. 

ACL :- EG. GOOGLE DOCS WHICH IS NOT IN DAC. 

Sudo configuration file is an example of access control. 
## Shell Interpretation Attacks & Other CLI Classics

### Shell 

![[Pasted image 20260603164104.png]]
Bash is a default and most common shell in Linux and macOS. Zsh is default on macOS

### Shell command injection 

![[Pasted image 20260524183316.png]]
https://www.shellscript.sh/escape.html

### Attack

![[Pasted image 20260524111836.png]]
![[Pasted image 20260524180520.png]]

To get those extra privileges you may use setuid. 
###  system()
https://www.geeksforgeeks.org/cpp/system-call-in-c/
System() function comes in libc by default
The **function takes one argument it is a string & it literally launches the shell.**
![[Pasted image 20260524184426.png]]

When you call `system("ls -la")`, it doesn't just run `ls -la` directly. It does this:

1. **Forks** a child process (creates a copy of your running program)
2. **Launches `/bin/sh -c`** in that child — meaning it spawns an actual shell
3. **Passes your string** to that shell for interpretation
4. The **shell parses** the string, expands wildcards, handles pipes, semicolons, redirects — all of it
5. Parent process **waits** for the child to finish


So if your code does something like:

c

```c
char cmd[256];
sprintf(cmd, "ls %s", user_input);
system(cmd);
```

And the user provides: `; rm -rf /` as input, the shell sees:

```
/bin/sh -c "ls ; rm -rf /"
```

The shell interprets the semicolon as a command separator and happily runs both commands. That's command injection.

`popen()` has the same problem — it also invokes `/bin/sh -c` underneath — but additionally gives you a pipe to read/write the command's output.

The core issue: **you think you're running a command, but you're actually running a shell that interprets a command.

If you do code review check these bad functions. 
Every single process has an environment variable. 

### Demo1 

There is this program which counts the number of files in the directory. 
The yellow indicates a gid program. 
![[Pasted image 20260524190831.png]]

![[Pasted image 20260524191054.png]]
![[Pasted image 20260524191129.png]]

For this program you will need directory reversal code and it will be long. 

This is the code written, most of it is boiler plate
![[Pasted image 20260524191417.png]]
![[Pasted image 20260524191441.png]]

The above four lines of code does the directory traversal. 
strcpy(cmd, CMD_P1);          // cmd = "ls "
strncat(cmd, argv[1], len);   // cmd = "ls /some/path"
strcat(cmd, CMD_P2);          // cmd = "ls /some/path | wc -l"
system(cmd);                  // hands that string to /bin/sh -c

In the code you can see it takes an argument. 

So we do this 
![[Pasted image 20260524192023.png]]

Here **semi colon; is a special syntax character.** 

![[Pasted image 20260524192328.png]]

What are we gaining from this we could have open a normal shell as well but if the ./dircount programme has a suid bit and that opens a shell we will have a shell with higher privileges. 

#### Why are we writing ;echo a 

The program always appends `" | wc -l"` at the end (that's `CMD_P2`). You can't avoid it, it's hardcoded. 
![[Pasted image 20260524194357.png]]
So whatever you inject, that pipe will be sitting at the tail.

**Scenario 1: just `;sh`**

The final string becomes:

```
ls ;sh | wc -l
```

The shell sees a pipe between `sh` and `wc -l`. A pipe means "take the output of the left command and feed it into the right command." So every time you type a command inside that shell, its output goes into `wc -l` instead of your screen. **You're typing blind the shell is running,** **but you can't see anything it outputs.** Useless.

**Scenario 2: `;sh;echo a`**

The final string becomes:

```
ls ;sh;echo a  | wc -l
```

Now the shell sees three separate commands split by semicolons:

1. `ls` → runs, you see the directory listing
2. `sh` → runs, you get a **clean interactive shell** with output on your screen
3. `echo a | wc -l` → this only runs **after you exit `sh`** — it's just sitting in line waiting

The `echo a` acts as a **sacrificial command** that absorbs the `| wc -l`, keeping it away from `sh`. That's its entire purpose.

`echo a | wc -l` → this only runs **after you exit `sh`** — it's just sitting in line waiting

![[Pasted image 20260603041346.png]]
#### How would you analyze a code.

Now if you see system() you know it is dangerous.  You system() here is system(cmd) 

The external user has any influence on the command. If is hardcoded it doesnt have to be a problem. Here you see argument goes to the command. So it is automatically vulnerable.  

### Environment Variables 

![[Pasted image 20260603041546.png]]
![[Pasted image 20260603041604.png]]

 Environment variables is like a **dictionary (key=value pairs) that every process carries with it. When you run `printenv` or `env`, you see your shell's current environment  things like `USER=kaan`, `HOME=/home/kaan`, `SHELL=/bin/bash`, etc.

####  Environment variable Rules

**1. Every process has its own copy** When a process is created, it gets a _copy_ of its parent's environment — not a reference to it. So changes one process makes don't affect anyone else's copy.

**2. Processes can modify their own environment** Using `setenv()` in C, or `export VAR=value` in bash but this only affects _that process's_ copy.

**3. The inheritance chain (this is the important part)**

```
Shell (USER=kaan)
    │
    ├── fork() → child inherits a COPY
    │               └── child changes HOME=/tmp
    │                       └── grandchild inherits HOME=/tmp  ✓
    │
    └── Shell still has HOME=/home/kaan  ✓  (unaffected)
```

Children inherit from their parent at the moment of `fork()`. Changes flow **downward only**, never upward or sideways.

####  Why This Matters in Security (relevant for you!)

- **Privilege escalation risk**: SUID binaries inherit the calling user's environment. A malicious `PATH` or `LD_PRELOAD` in the environment can hijack what a privileged binary loads/executes , this is exactly why secure SUID programs sanitize their environment on startup.
- **`LD_PRELOAD` attacks**: If you can inject a library path via the environment, you can intercept function calls in privileged processes.
- **`PATH` hijacking**: If a SUID binary calls `system("ls")` without an absolute path, a crafted `PATH` in the environment points it to your malicious `ls`
- 
#### Cd 

Home environment variable is what cd looks for. You change the value it will take you to different directory. 

#### Path

The **`PATH` environment variable** contains a list of search directories that the operating system uses to locate executable programs and commands.

If you type a command inside shell and hit enter without relative or absolute path. The shell knows where to look and search the first directory in the path if it can;t find it there it will  move to the second directory. 

By changing the environment variables you can change the content of these variables you can change the behaviour of the program that relies on these variables.

#### Internal field separator. 
 

IFS : Internal field separator. it tells the shell _"where does one token end and the next begin?"_

![[Pasted image 20260603044758.png]]


https://notes.kodekloud.com/docs/Advanced-Bash-Scripting/Special-Shell-Variables/ifs/page

IFS is by default set to **blank space.** 
#### What is Tokenization?

When the shell sees a command, it splits the string into **tokens** (individual meaningful chunks) using IFS as the delimiter.

bash

```bash
/usr/bin/cat myfile
```

The shell splits this on the space:

```
Token 1: /usr/bin/cat   ← the program to run
Token 2: myfile         ← argument passed to it
```

### Demo 2 

![[Pasted image 20260603045934.png]]
![[Pasted image 20260603050006.png]]

Preserve sees why your program crashed. Before terminating anything it takes the backup of your file, preserves the file. It sends an email 
Preserve is set to a set binary 

./preserve asd
    │
    ├── fork()
    │     ├── CHILD  → drop_privileges() → execl nano (opens "asd" in nano)
    │     └── PARENT → waitpid() → watches for crash → system(sendmail)

Analyzing the code the child drops the privileges, the child exists the editor command. Child picks up the hard coded nano 
![[Pasted image 20260603050651.png]]

You spot the system() command 
![[Pasted image 20260603051351.png]]

This is a multi-stage attack.  You are going to change the way the shell is going to make sense of the 

Change the internal field separator from blank space to /  then launch preserve. So when you launch preserve the command is going to be interpreted by the ifs. 

The command is going to be ![[Pasted image 20260603052614.png]]
home [space] kaan 
So it looks like home is the name of the command that is going to be executed and the rest are arguments to the command. 

But then it is going to complain that there is no such thing as home. 

So you eventually want to have an executable called home. But usr/bin is not writable 
So we would change the path 

home has not provided an absolute or relative path so it will trigger a path search. Trick into running our home executable. 

#### Before the attack observing preserve. (analysing the flow of the code )

![[Pasted image 20260603053835.png]]

![[Pasted image 20260603054011.png]]
![[Pasted image 20260603054057.png]]

![[Pasted image 20260603053915.png]]

 #### Now crashing it , we are looking for PID 
 ![[Pasted image 20260603054228.png]]
![[Pasted image 20260603054228.png]]
![[Pasted image 20260603054245.png]]

#### We found the program id. 

![[Pasted image 20260603054400.png]]

#### Kill command for the pid


![[Pasted image 20260603054430.png]]

![[Pasted image 20260603054516.png]]

SIMULATE A CRASH of the editor
                    ↓
          nano IS the child process
                    ↓
        killing nano = "crash detected"
                    ↓
   parent's WIFSIGNALED(stat_var) becomes TRUE
                    ↓
        **parent runs system(CMD_MAIL)** ← this is the vulnerable line!


#### Modifying the environment 

![[Pasted image 20260603055339.png]]

this is the short cut saying that modify the environment only for the purpose of the program 

![[Pasted image 20260603055526.png]]

####  Breaking Down `IFS=/ PATH=/tmp:$PATH ./preserve`

#####  Piece by Piece

#### `IFS=/`

Changes the field separator from **space** to **forward slash**

```
Normal IFS=" "  →  "/usr/bin/nano" is ONE token
IFS="/"         →  "/usr/bin/nano" splits into: "" "usr" "bin" "nano"
```

So when `preserve` internally calls:

c

```c
execl("/usr/bin/nano", ...)   // this is hardcoded, safe
```

That's fine. But when the crash handler calls:

c

```c
system(CMD_MAIL);
// CMD_MAIL = "/home/kaan/work/cs3740/class/demos/shellattack/sendmail"
```

With `IFS=/`, that path **tokenizes** into fragments — the shell can no longer resolve it as a path properly.

---

#### `PATH=/tmp:$PATH`

Prepends `/tmp` to the PATH, so **`/tmp` is searched first** for any command.

```
Before: PATH=/usr/local/bin:/usr/bin:/bin
After:  PATH=/tmp:/usr/local/bin:/usr/bin:/bin
                ↑
        attacker's directory checked FIRST
```

So if the attacker placed a malicious file called `sendmail` or `home` in `/tmp`, the shell finds it before the real one.

---

#### `./preserve`

Runs the SUID binary — **which runs as root**.


####  Final execution 

![[Pasted image 20260603060122.png]]

#### Creating symbolic link 
##### The Syntax

bash

```bash
ln -s `which sh` home
#      ↑           ↑
#   TARGET       SYMLINK NAME
#  (real thing)  (shortcut created)
```

```
ln -s  (what already exists)  (new shortcut to create)
```


![[Pasted image 20260603060230.png]]
![[Pasted image 20260603060309.png]]
![[Pasted image 20260603061115.png]]

We are inside a nested shell now . 
![[Pasted image 20260603061450.png]]

If we launch another shell, the IFS relaunches to the normal value.  Don't play with IFS for challenge.



![[Pasted image 20260603125629.png]]

#### What Happens When Root Executes `/bin/ls` with `IFS=/`

Normal Execution (IFS = space)

```
system("/bin/ls")
```
 
shell sees ONE token: /bin/ls
runs the real ls binary → safe ✓

With IFS="/"

system("/bin/ls")
 shell splits on "/" → tokens: ""  "bin"  "ls"
                               ↑
                 first token is empty, ignored
 second token "bin" becomes the COMMAND

So the shell now tries to execute **`bin`** as a command, and looks it up in `PATH`!

Why "Root Executes" is the Scary Part

Normal user runs malicious "bin"  →  damage limited to that user
ROOT runs malicious "bin"         →  full system compromise
                                      can do anything:
                                      - add root users
                                      - install backdoors
                                      - read /etc/shadow
                                      - destroy the system


## Shellshock 

![[Pasted image 20260603130401.png]]

 Bash allows storing functions in environment variables
env VAR='() { echo hello; }' bash
       ↑
this is a function definition

Shellshock bug: bash KEPT EXECUTING whatever came AFTER the function
env VAR='() { echo hello; }; rm -rf /' bash
                           ↑
THIS part should be ignored
but bash executed it anyway!

https://www.youtube.com/watch?v=aKShnpOXqn0


## File Descriptors 

you can read, write when the file is open 
what if it is a privileged file when fork happens the child inherits open child it was not suppose to do. 
![[Pasted image 20260603132231.png]]
https://medium.com/@tharinduimalka915/linux-file-descriptors-ec945fd36893

![[Pasted image 20260603133135.png]]
This is also known as the **capability leak.** 
### Child can still access the file via the descriptor!

#### FLOW 

Permission Check Happens at `open()`, NOT at `read()`

Root process calls **open("/etc/shadow")**
         ↓
Kernel checks: **"is caller root?" → YES ✓**
         ↓
Returns file descriptor **(just an integer, e.g. fd=5)**
         ↓
**fork() → child inherits fd=5**
         ↓
**Child calls read(fd=5, ...)**
         ↓
Kernel checks: ???

**The kernel does NOT re-check permissions on read/write.** The file descriptor is already open — it's just a number pointing to an open file. The gate was only checked once, at `open()`.

#### Why This is a Problem

SUID root program          Unprivileged child
─────────────────          ──────────────────
open("/etc/shadow")   →    gets fd=5 inherited
[runs as root, succeeds]   
fork()                →          child drops to user kaan
drop_privileges()          but still HAS fd=5!
                           read(fd=5) → reads /etc/shadow ✓
                           [no permission check on read!]


### setuid root program opens a file only readable by root. 

#### Flow 

SUID binary runs as root
    → opens sensitive file (root-only)
    → fork()
    → child drops privileges to normal user
    → but fd is ALREADY open → child can still read it

Dropping privileges closes the SUID elevation, but it **does not close open file descriptors**.

#### The Fix

Before forking into an unprivileged child, explicitly close any sensitive file descriptors:

fd = open("/etc/shadow", O_RDONLY);  // root opens it
// ... do root work ...
close(fd);          // close BEFORE fork
fork();             // now child has nothing sensitive

Or use the `O_CLOEXEC` flag when opening, which auto-closes the fd on `exec()`.

![[Pasted image 20260603134616.png]]
This ensures that the kernel **automatically closes the file descriptor** when the current process executes a new program via any `exec` function family call. 

## Shared Libraries. 

![[Pasted image 20260603135219.png]]
https://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html

![[Pasted image 20260603141035.png]]

### Library Path Resolution, How Linux Finds Libraries

When you run a program, the **dynamic linker** needs to find all required `.so` files. It searches in this order:

#### 1. Default System Paths

/lib
/usr/lib
/lib64

Trusted, root-owned, always checked. Safe ✓

#### 2. `LD_LIBRARY_PATH` (Environment Variable)

bash

```bash
export LD_LIBRARY_PATH=/tmp/mylibs
./myprogram
# linker checks /tmp/mylibs FIRST before system paths
```

User-controlled → **ignored for SUID**   (Check below)

#### 3. Configuration Files

```
/etc/ld.so.conf
/etc/ld.so.conf.d/*.conf
```

Root-owned files that tell the linker about additional trusted directories. Safe ✓

#### 4. Cache

```
/etc/ld.so.cache
```

`ldconfig` reads the config files above and builds this **binary cache** for fast lookups — so the linker doesn't have to scan directories every time a program starts.

```
/etc/ld.so.conf  →  ldconfig  →  /etc/ld.so.cache
(config)            (command)     (fast lookup index)
```

### Can't Preload malicious library
####  What LD_PRELOAD Does Normally

 Normal (non-SUID) program

```
LD_PRELOAD=/tmp/evil.so ./normalprogram
```

evil.so gets loaded FIRST

can override any function like open(), read(), system()

works perfectly on normal binaries ✓

####  What Happens With SUID Binaries

bash

```
LD_PRELOAD=/tmp/evil.so ./preserve```

#                              ↑
                         SUID binary
```

The dynamic linker (`ld.so`) sees: _"wait, this binary has the SUID bit set"_ and **silently ignores** `LD_PRELOAD` entirely.

LD_PRELOAD set? → is binary SUID? → YES → ignore LD_PRELOAD
                                         → ignore LD_LIBRARY_PATH
                                         → only load from trusted paths
                                           (/lib, /usr/lib, /etc/ld.so.conf)


## Debugging 

![[Pasted image 20260603141710.png]]

## Demo 3 

The setup is like this. This sets an internal tool. Every user transaction or purchase records in the database. Employees should grab non-sensitive data from the database. 


![[Pasted image 20260603145551.png]]

![[Pasted image 20260603150624.png]]
![[Pasted image 20260603150648.png]]

![[Pasted image 20260603150719.png]]

The invoice file should exist. 

![[Pasted image 20260603151203.png]]

The database is a binary database format. 

Goal is to use the invoice program to corrupt the database.  What the professor is trying to do her is to get the output as transactions.db 

![[Pasted image 20260603151433.png]]

![[Pasted image 20260603151521.png]]

**transactions.db:**

```
-rw-rw----  root  superpriv
 ↑↑↑↑↑↑↑↑
 rw-  = owner (root) can read/write
 rw-  = group (superpriv) can read/write
 ---  = others = NO ACCESS
```

**invoice binary:**

```
-rwxr-sr-x  kaan  superpriv
      ↑
      s = SGID bit (Set Group ID)
          runs with GROUP = superpriv
```
### The Key — SGID not SUID!

```
SUID = runs with owner's privileges  (root)
SGID = runs with GROUP's privileges  (superpriv)
```

So `invoice` runs as **group `superpriv`** which means it CAN read `transactions.db`.


### Looking at the source code 
![[Pasted image 20260603152916.png]]
if (access(argv[2], W_OK)) {
`access()` is **defined by POSIX** to explicitly use the **real UID/GID**, not the effective UID/GID. This is its entire purpose for existing as a separate function.

access(path, W_OK)    → "does REAL user have write permission?"
                                              ↑
                                    permission check, not ownership

open(path, O_WRONLY)  → "does EFFECTIVE gid have write permission?"
                                              ↑
                                    same check, different identity

This is a race condition here. 

The sequence of conditions 

1. Create a normal file. 
2. Wait until the thing executes 
3. Go and delete the empty invoice file 
4. Replace it with a symbolic link. 
5. With open syscall 

As the CPU switches contexts between threads you want to get lucky. 

![[Pasted image 20260603155007.png]]

![[Pasted image 20260603155153.png]]
![[Pasted image 20260603155220.png]]

access(argv[2], W_OK)   // CHECK  ← real uid kaan
    ↓
    ↓  ← TIME GAP HERE (attacker's window!)
    ↓
open(argv[2], O_WRONLY) // USE    ← effective gid superpriv

This gap between CHECK and USE is the **TOCTOU vulnerability** (Time Of Check Time Of Use).

#### Why Delete? — The Symlink Swap Logic

The attacker needs `out.txt` to mean **different things** at check time vs use time:

```
At access() time:
    out.txt = real file owned by kaan
    access() asks: can kaan write out.txt? → YES ✓ passes check

At open() time:
    out.txt = symlink → transactions.db
    open() asks: can superpriv write? → YES ✓ opens transactions.db!
```

**You can't just replace a file with a symlink — you have to DELETE it first** because:

```
out.txt already EXISTS as a real file
    ↓
ln -s transactions.db out.txt
    ↓
ERROR: out.txt already exists!
ln won't overwrite an existing file
```

So delete → recreate as symlink is the only way to swap them


#### The Full Race Condition

![[Pasted image 20260603155535.png]]

LEFT SCRIPT (victim)     RIGHT SCRIPT (attacker)
────────────────────     ──────────────────────
                         touch out.txt  ← real file exists
access(out.txt, W_OK)    
  kaan owns it → PASS ✓  
                         rm -f out.txt  ← DELETE it!
                         ln -s transactions.db out.txt
                                        ← now out.txt = symlink!
open(out.txt, O_WRONLY)  
  follows symlink →
  opens transactions.db!
  superpriv can write → 
🔥 transactions.db gets  
   overwritten!          rm -f out.txt  ← reset, try again

####  Why "Corrupted" Specifically

```
transactions.db was a structured binary database
    ↓
invoice program wrote plain invoice text into it
    ↓
database now contains garbage data
    ↓
any program trying to read transactions.db
finds invalid structure → "Database is corrupted"
```

### Solution 

#### The TOCTOU Problem Was This Gap

access(argv[2], W_OK)    // CHECK  → uses real uid
        ↓
    [GAP - attacker swaps out.txt → symlink]
        ↓
open(argv[2], O_WRONLY)  // USE    → uses effective gid

#### How fd Solves It — Open FIRST, Check AFTER

c

```c
// Step 1: open using REAL uid (drop effective privileges temporarily)
fd = open(argv[2], O_WRONLY);   // if kaan can't write → fails here

// Step 2: NOW check what fd actually points to
fstat(fd, &st);                 // checks the ALREADY OPEN file
                                // not the filename anymore!
```

####  Why This Eliminates the Race

```
With access() + open():
    checking FILENAME → gap → opening FILENAME
    attacker swaps what filename points to in the gap ✓

With fd approach:
    open file → get fd (integer handle to actual file)
    now check fd itself
        ↓
    filename is IRRELEVANT now
    attacker can swap out.txt → symlink all they want
    fd already points to the real file that was opened
    symlink swap has NO EFFECT ✗
```

## Disk Encryption

![[Pasted image 20260603172607.png]]

## Resource Limits

![[Pasted image 20260603222109.png]]
https://medium.com/@weidagang/linux-beyond-the-basics-cgroups-f157d93bd755

 cgroups are a kernel feature that allows you to partition and limit the system resources (CPU, memory, disk I/O, network, etc.) that a group of processes can use.

## TL;DR


## Sandboxes 

![[Pasted image 20260603221056.png]]

### ### What is a Sandbox?

```
Sandbox = prison for untrusted processes

Normal process:    can do ANYTHING the OS allows
Sandboxed 
process: restricted to only what YOU permit
```

### seccomp (Secure Computing Mode)

Every program communicates with kernel via SYSTEM CALLS:
    open(), read(), write(), fork(), exec()...
    
seccomp lets you say:
"this process is ONLY allowed to use these syscalls
 any other syscall → process is KILLED immediately"

### Two Modes

seccomp strict mode:
    only allows: read(), write(), exit(), sigreturn()
    ANY other syscall → SIGKILL
    extremely restrictive
    rarely used directly

seccomp-bpf:
    uses Berkeley Packet Filter rules
    custom filter per syscall
    much more flexible

seccomp-bpf 
Docker uses seccomp: default profile blocks ~44 dangerous syscalls like: ptrace(), mount(), reboot()


### chroot — Filesystem Jail

chroot = change root directory

Normal process sees:
    / 
    ├── etc/
    ├── home/
    ├── bin/
    ├── var/
    └── tmp/

After chroot("/jail"):
    process thinks THIS is /:
    /jail/
    ├── etc/      ← fake etc
    ├── bin/      ← limited binaries
    └── tmp/
    
    cannot see ANYTHING outside /jail
    /etc/shadow?  → doesn't exist from inside
    /home/kaan?   → doesn't exist from inside

#### Concrete Example

bash

```bash
# Create a jail
mkdir /jail
cp /bin/bash /jail/bin/
cp /bin/ls /jail/bin/

# Put process in jail
chroot /jail /bin/bash

# Now inside jail:
ls /           # only sees /jail contents
cat /etc/shadow # /etc doesn't exist!
cd /home/kaan   # /home doesn't exist!
```

#### chroot Security Warning

chroot is NOT perfect isolation!

Root can escape chroot:
    chroot() again from inside
    use mknod to create device files
    use relative paths to escape

So chroot is:
    good for containing non-root processes ✓
    NOT sufficient for containing root ✗
    often combined with dropping privileges first
