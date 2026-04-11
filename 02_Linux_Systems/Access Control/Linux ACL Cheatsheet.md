
## 1. Getfacl

1.  Viewing ACL

```bash
getfacl <file_name>
```



## 2. Setfacl

1. To add permission for user
```bash
setfacl -m "u:user:permissions" /path/to/file
```


2. To add permissions for a group

```bash
setfacl -m "g:group:permissions" /path/to/file
```


3. To allow all files or directories to inherit ACL entries from the directory it is within

```bash
setfacl -dm "entry" /path/to/dir
```


4. To remove a specific entry **(entry eg. u:alice, g:accounts)**
```bash
setfacl -x "entry" /path/to/file
```


5. To remove all entries
```bash
setfacl -b path/to/file
```

