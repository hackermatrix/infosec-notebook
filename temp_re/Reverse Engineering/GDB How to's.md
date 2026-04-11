
## 1. **Start gdb:**

```
gdb <executable_name/path
```

## 2. **Set to intel style:** 

```
set disassembly-flavor intel
```

## 3. **Disassemble a function:**

```
disassemble <function name>
```

## 4. **Setting a Breakpoint:**

```
break *<function_name>
```

## 5. **Running the program:**

```
run
```

## 6. **Get registers info:**

```
info registers 
```


## 7.  Get Current function's Stack Frame :

```
info frame
```


## 8. Examine Memory :

```
x/<count><size><format> <address>

example : x/gx address, x/wx address
```

# Size codes

| Code  | Meaning                                      | Bytes |
| ----- | -------------------------------------------- | ----- |
| **b** | byte                                         | 1     |
| **h** | halfword                                     | 2     |
| **w** | word                                         | 4     |
| **g** | giant word                                   | 8     |
| i     | assembly instruction(a bit diff than others) |       |

# Format codes

| Code  | Meaning          |
| ----- | ---------------- |
| **x** | hex              |
| **d** | signed decimal   |
| **u** | unsigned decimal |
| **t** | binary           |
| **c** | printable char   |
| **s** | string           |