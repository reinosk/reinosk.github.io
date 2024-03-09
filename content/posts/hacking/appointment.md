---
author: "@reinosk"
title: Appointment Writeups
date: 2024-02-01T01:24:34.807Z
description: Appointment is a box that is mostly web-application oriented. More specifically, we will find out how to perform an SQL Injection against an SQL Database enabled web application.
summary: Appointment is a box that is mostly web-application oriented. More specifically, we will find out how to perform an SQL Injection against an SQL Database enabled web application.
series: ["Hacking"]
tags: ["HackTheBox"]
ShowToc: true
# TocOpen: true
---

## Introduction

Appointment is a box that is mostly web-application oriented. More specifically, we will find out how toperform an `SQL Injection` against an `SQL Database` enabled web application. Our target is running a website with search capabilities against a back-end database containing searchable items vulnerable to this type of attack. Not all items in this database should be seen by any user, so different privileges on the website will grant you different search results.

Hypothetically, an administrator of the website will search up users, their emails, billing information,shipping address, and others. In contrast, a simple user or unauthenticated visitor might only have permission to search for the products on sale. These `tables` of information will be separate. However, foran attacker with knowledge on web application vulnerabilities - specifically SQL Injection, in this case - these paration between those tables will mean nothing, as they will be able to exploit the web application to directly query any table found on the SQL Database of the webserver.

![...](https://raw.githubusercontent.com/reinosk/NDiS/master/imgs/appointment-sql-service.jpg#center)

An excellent example of how an SQL Service typically operates is the log-in process utilized for any user.Each time the user wants to log in, the web application sends the log-in page input (username/password combination) to the SQL Service, comparing it with stored database entries for that specific user. Suppose the specified username and password match any entry in the database. In that case, the SQL Service will report it back to the web application, which will, in turn, log the user in, giving them access to the restricted parts of the website. Post-log-in, the web application will set the user a special permission in the form of a cookie or authentication token that associates his online presence with his authenticated presence on the website. This cookie is stored both locally, on the user's browser storage, and the web server.

Afterward, if the user wants to search through the list items listed on the page for something in particular,he will input the object's name in a search bar, which will trigger the same SQL Service to run the SQL query on behalf of the user. Suppose an entry for the searched item exists in the database, typically under a different table. In that case, the associated information is retrieved and sent to the web application to be presented to the user as images, text, links, and other types, such as comments and reviews.

![...](https://raw.githubusercontent.com/reinosk/NDiS/master/imgs/searched%20item-exists-in-the-database.jpg#center)

The reason websites use databases such as MySQL, MariaDB, or other kinds is that the data they collect or serve needs to be stored somewhere. Data could be usernames, passwords, posts, messages, or more sensitive sets such as [PII (Personally Identifiable Information)](https://en.wikipedia.org/wiki/Personal_data), which is protected by international data privacy laws. Any enterprise with a disregard towards protecting its users' PII is welcomed with very hefty fines from international regulators and data privacy agencies.

SQL Injection is a common way of exploiting web pages that use `SQL Statements` that retrieve and storeuser input data. If configured incorrectly, one can use this attack to exploit the well-known `SQL Injection` vulnerability, which is very dangerous. There are many different techniques of protecting from SQL injections, some of them being input validation, parameterized queries, stored procedures, and implementing a WAF (Web Application Firewall) on the perimeter of the server's network. However,instances can be found where none of these fixes are in place, hence why this type of attack is prevalent,according to the [OWASP Top 10](https://owasp.org/www-project-top-ten/) list of web vulnerabilities.

![...](https://raw.githubusercontent.com/reinosk/NDiS/master/imgs/sql-injection.jpg#center)

## Enumeration

First, we perform an nmap scan to find the open and available ports and their services. If no alternative flag is specified in the command syntax, nmap will scan the most common 1000 TCP ports for active services.This will suit us in our case.

Additionally, we will need super-user privileges to run the command below with the `-sC` or `-sV` flags. This is because script scanning ( `-sC` ) and version detection ( `-sV` ) are considered more intrusive methods ofscanning the target. This results in a higher probability of being caught by a perimeter security device on thetarget's network.

> `-sC`: _Performs a script scan using the default set of scripts. It is equivalent to `--script=default`. Some of the scripts in this category are considered intrusive and should not be run against a target network without permission._
> 
> `-sV`: _Enables version detection, which will detect what versions are running on what port._

```cmd
$ sudo nmap -sC -sV 10.129.131.208
```
![...](https://i.ibb.co/vvjJSBf/image.png#center)

The only open port we detect is port 80 TCP, which is running the `Apache httpd` server version `2.4.38`.

Apache HTTP Server is a free and open-source application that runs web pages on either physical or virtual web servers. It is one of the most popular HTTP servers, and it usually runs on standard HTTP ports such as ports 80 TCP, 443 TCP, and alternatively on HTTP ports such as 8080 TCP or 8000 TCP. HTTP stands for Hypertext Transfer Protocol, and it is an application-layer protocol used for transmitting hypermedia documents, such as HTML (Hypertext Markup Language).

The nmap scan provided us with the exact version of the Apache httpd service, which is 2.4.38. Usually, a good idea would be to search up the service version on popular vulnerability databases online to see if any vulnerability exists for the specified version. However, in our case, this version does not contain any known vulnerability that we could potentially exploit.

In order to further enumerate the service running on port 80, we can navigate directly to the IP address of
the target from our browse.

![...](https://i.imgur.com/dMFd9x9.png#center)

By typing the IP address of the target into the URL field of our browser, we are faced with a website containing a log-in form. Log-in forms are used to authenticate users and give them access to restricted parts of the website depending on the privilege level associated with the input username. Since we are not aware of any specific credentials that we could use to log-in, we will check if there are any other directories or pages useful for us in the enumeration process. It is always considered good practice to fully enumerate the target before we target a specific vulnerability we are aware of, such as the SQL Injection vulnerability in this case. We need the whole picture to ensure we are not missing anything and fall into a rabbit hole, which could quickly become frustrating.

Think of web directories as "web folders" where other resources and relevant files are stored and organized, such as other pages, log-in forms, administrative log-in forms, images, and configuration file storage such as CSS, JavaScript, PHP, and more. Some of these resources are linked directly from the landing page of the website. Pages we are all accustomed to, such as `Home`, `About`, `Contact`, `Register`, and `Log-in` pages, are considered separate web directories. When navigating to these pages, the URL address at the top of our browser window will change depending on our current location. For example, if we navigate from the `Home` page to the `Contact` page of a website, the URL would change as follows:

Home page:

```cmd
https://www.example.com/home
```

Contact page:

```cmd
https://www.example.com/login
```

Forgot Password page:
```cmd
https://www.example.com/login/forgot
```
## Foothold