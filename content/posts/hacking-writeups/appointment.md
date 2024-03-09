---
author: "@reinosk"
title: Appointment Writeups
date: 2024-02-01T01:24:34.807Z
description: Appointment is a box that is mostly web-application oriented. More specifically, we will find out how to perform an SQL Injection against an SQL Database enabled web application.
summary: Appointment is a box that is mostly web-application oriented. More specifically, we will find out how to perform an SQL Injection against an SQL Database enabled web application.
series: ["Hacking"]
tags: ["HackTheBox"]
ShowToc: false
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