---
author: "@reinosk"
title: PW Crack 5 Write-up
date: 2024-03-22T17:23:32.998Z
description: Can you crack the password to get the flag?
summary: Can you crack the password to get the flag?
series: ["Hacking"]
# cover: 
#     image: https://i.imgur.com/a2evoxS.png
tags: ["picoCTF"]
ShowToc: true
TocOpen: true
---

## Hints
> _Can you crack the password to get the flag? Download the password checker [here](https://artifacts.picoctf.net/c/31/level5.py) and you'll need the encrypted [flag](https://artifacts.picoctf.net/c/31/level5.flag.txt.enc) and the [hash](https://artifacts.picoctf.net/c/31/level5.hash.bin) in the same directory too. Here's a [dictionary](https://artifacts.picoctf.net/c/31/dictionary.txt) with all possible passwords based on the password conventions we've seen so far._

## Approach

![...](https://i.imgur.com/LYTMHWw.png)

we must create a new code from this reference.
![...](https://i.imgur.com/rYqpDef.png)

- line 12 read `directory.txt` file
- line 14-17 validating password in `directory.txt` file.

```py { linenos=table,hl_lines=[12,14,15,16,17] }
import hashlib

correct_pw_hash = open('level5.hash.bin', 'rb').read()

def hash_pw(pw_str):
    pw_bytes = bytearray()
    pw_bytes.extend(pw_str.encode())
    m = hashlib.md5()
    m.update(pw_bytes)
    return m.digest()

post_pw_list = open('dictionary.txt', 'r').read().splitlines()

for pw in post_pw_list:
    if hash_pw(pw) == correct_pw_hash:
        print('This is your password: ' + pw)
        break
```

run this code:

```cmd
$ python3 crack.py
```

## Summary

This code is a password cracker that uses a dictionary attack to find a password. It imports the `hashlib` module to generate MD5 hashes of passwords. The correct password hash is read from a binary file `level5.hash.bin` and stored in the `correct_pw_hash` variable. The `hash_pw` function takes a string password, converts it to bytearray, hashes it using MD5, and returns the digest. A list of potential passwords is read from a text file `dictionary.txt` and stored in the `post_pw_list` variable. The code loops through each password in the `post_pw_list` list, hashes it using the `hash_pw` function, and compares it to the correct password hash. If a hashed password matches the correct password hash, the code prints the password and breaks the loop, effectively finding the correct password by brute-forcing it with a list of potential passwords.