---
author: "@reinosk"
title: DVWA Setup
date: 2024-03-27T13:13:13.591Z
description: Damn Vulnerable Web Application (DVWA) is a PHP/MySQL web application that is damn vulnerable. Its main goal is to be an aid for security professionals to test their skills and tools in a legal environment, help web developers better understand the processes of securing web applications and to aid both students & teachers to learn about web application security in a controlled class room environment.
summary: Welcome to Damn Vulnerable Web Application!
series: ["Hacking"]
tags: ["DVWA"]
ShowToc: true
TocOpen: true
---

**tl;dr** I setup DVMA from repo to my archlinux. Archlinux users may find this documentation helpful.

## Installation
Go to the `/var/www/html` directory, clone the repo into it, and rename.
```cmd
$ cd /var/www/html && sudo git clone https://github.com/digininja/DVWA.git && sudo mv DVWA dvwa
```

then give it access.
```cmd
$ chmod -R 777 dvwa
```

and it will look like this.
![...](https://i.imgur.com/16A5Hqh.png#center)

open `config/` directory, rename `config.inc.php.dist*` to `config.inc.php` and edit the config file.

> _configure it according to your needs._
![...](https://i.imgur.com/3yKe476.png#center)

Now it's time to install `apache`, `php`, `php-apache`, `php-gd`:
```cmd
$ sudo pacman -S apache php php-apache php-gd
```

## Configuring The Apache Server
Edit `php.ini` in `/etc/php` directory
![...](https://i.imgur.com/Tnem8xa.png#center)

Because DVMA uses php, we configure it for php, edit `httpd.conf` in `/etc/httpd/conf/` directory. In `/etc/httpd/conf/httpd.conf`, comment the line:
```conf
#LoadModule mpm_event_module modules/mod_mpm_event.so
```

and uncomment the line: 
```conf
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
```

![...](https://i.imgur.com/dvao23h.png#center)

To enable PHP, add these lines to `/etc/httpd/conf/httpd.conf`:
- Place this at the end of the `LoadModule` list: 
```conf
LoadModule php_module modules/libphp.so
AddHandler php-script .php
```
![...](https://i.imgur.com/hwCTDmn.png#center)

- Place this at the end of the Include list:
```conf
Include conf/extra/php_module.conf
```
![...](https://i.imgur.com/fABKBsc.png#center)

### Advanced Options (recommended to follow)
Because apache calls everything in this directory `/srv/http`, but we installed it in this directory `/var/www/html/`. Therefore we need to change the path.

![...](https://i.imgur.com/CAvIFGD.png#center)
![...](https://i.imgur.com/JDQsXVx.png#center)
![...](https://i.imgur.com/yZEeW8R.png#center)

then [restart](https://wiki.archlinux.org/title/Restart) `httpd.service`. 

```cmd
$ sudo systemctl restart httpd.service
```

## Configuring The Database

I'm not going to write this in the documentation. You can refer to [this video](https://www.youtube.com/watch?v=W2PY3A32LzY&t=274s&pp=ygUPbXlzcWwgYXJjaGxpbnV4) if you want to set up your database the same way I did with MySQL.

![...](https://i.imgur.com/ikhDTxr.png#center)

## Running DVWA

![...](https://i.imgur.com/QfKTm7U.png#center)