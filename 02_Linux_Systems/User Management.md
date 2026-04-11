## **1. Add a User**

```
# Add a new user interactively (creates home directory, prompts for password) 
sudo adduser username  # Example sudo adduser hrishi
```

✅ Notes:

- Creates `/home/username`
- Prompts to set password and optional info (Full Name, Phone, etc.)
---

## **2. Add a User Without Prompt**

```
# Add user without interactive prompts, set password in one command 
sudo adduser --gecos "" --disabled-password username 
sudo passwd username   # Then set password manually
```

---

## **3. Delete a User**

```
# Remove user but keep home directory 
sudo deluser username 

# Remove user and home directory 
sudo deluser --remove-home username
```

---

## **4. Change User Password**

```
sudo passwd username
```

---

## **5. Add User to a Group**

```
# Add existing user to a group 
sudo usermod -aG groupname username  
# Example: add hrishi to sudo group sudo usermod -aG sudo hrishi
```

---

## **6. Remove User from a Group**

```
sudo gpasswd -d username groupname
```

---

## **7. List Users**

```
# Show all users from /etc/passwd 
cut -d: -f1 /etc/passwd  

# List users and their groups 
getent passwd
```

---

## **8. List Groups**

```
# Show all groups 
cut -d: -f1 /etc/group  

# Show groups for a user 
groups username
```

---

## **9. Lock / Unlock a User Account**

```
# Lock account (disable login) 
sudo usermod -L username  

# Unlock account 
sudo usermod -U username
```