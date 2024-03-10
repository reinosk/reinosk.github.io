---
author: "@reinosk"
title: PW Crack 3 Write-up
date: 2024-03-10T13:31:25.611Z
description: Can you crack the password to get the flag?
summary: Can you crack the password to get the flag?
series: ["Hacking"]
cover: 
    image: https://i.imgur.com/CNVmqIv.png
tags: ["picoCTF"]
ShowToc: true
TocOpen: true
---

## Hints
> _Can you crack the password to get the flag? Download the password checker [here](https://artifacts.picoctf.net/c/16/level3.py) and you'll need the encrypted [flag](https://artifacts.picoctf.net/c/16/level3.flag.txt.enc) and the [hash](https://artifacts.picoctf.net/c/16/level3.hash.bin) in the same directory too. There are 7 potential passwords with 1 being correct. You can find these by examining the password checker script._

## Approach

![...](https://i.ibb.co/YpckCS2/image.png#center)

We can try to crack the password using the list of possible passwords. `hashlib` is library to hash the passwords and compare them to the hash file. We will create a new crack code to compare hashes.

```py
import hashlib

correct_pw_hash = open('level3.hash.bin', 'rb').read()

def hash_pw(pw_str):
    pw_bytes = bytearray()
    pw_bytes.extend(pw_str.encode())
    m = hashlib.md5()
    m.update(pw_bytes)
    return m.digest()

pos_pw_list = ["6997", "3ac8", "f0ac", "4b17", "ec27", "4e66", "865e"]

for pw in pos_pw_list:
    if hash_pw(pw) == correct_pw_hash:
        print("The password is: " + pw)
```
![...](https://i.imgur.com/h9AZGxh.png#center)

running command:

```shell
$ python3 crack.py

The password is: 865e
```

![...](https://i.ibb.co/vqQy2Jb/image.png#center)