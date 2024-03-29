---
author: "@reinosk"
title: Appointment
date: 2024-02-01T01:24:34.807Z
description: Appointment is a box that is mostly web-application oriented. More specifically, we will find out how to perform an SQL Injection against an SQL Database enabled web application.
summary: Appointment is a box that is mostly web-application oriented. More specifically, we will find out how to perform an SQL Injection against an SQL Database enabled web application.
series: ["Hacking"]
tags: ["HackTheBox"]
ShowToc: true
TocOpen: true
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
the target from our browser.

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

However, suppose buttons and links to the desired directories are not provided. In that case, because the directories we are looking for either contain sensitive material or simply resources for the website to load images and videos, we can provide the names of those directories or web pages in the same browser URL field to see if it will load anything. Your browser by itself will not block access to these directories simply because there is no link or button on the webpage for them. Website administrators will need to make sure directories containing sensitive information are properly secured so that users can not just simply manually navigate to them.

When navigating through web directories, the HTTP client, which is your browser, communicates with the HTTP server (in this case Apache 2.4.38) using the HTTP protocol by sending an HTTP Request (a GET or POST message) which the server will then process and return with an HTTP Response.

HTTP Responses contain [status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status), which detail the interaction status between the client's request and how the server handled it.

Let us take a look at the complete process for searching up and accessing a hidden directory. By specifying the IP address of the target that runs an HTTP server in the browser URL field followed by a forward-slash ( `/` ) and the name of the directory or file we are looking for, the following events will take place:
- The user-agent (the browser / the HTTP client) will send a GET request to the HTTP Server with the URL of the resource we requested.
- The HTTP server will look up the resource in the specified location (the given URL).
- If the resource or directory exists, we will receive the HTTP Server response containing the data we requested (be it a webpage, an image, an audio file, a script, etc.) and response code `200 OK`, because the resource was found and the request was fulfilled with success.
- If the resource or directory cannot be found at the specified address, and there is no redirection implemented for it by the server administrator, the HTTP Server response will contain the typical `404 Page` with the response code `404 Not Found` attached.

These two cases above are what we will be focusing on when attempting to enumerate hidden directories or resources. However, instead of manually navigating through the URL search bar to find this hidden data, we will be using a tool that will automate the search for us. This is where tools such as Gobuster, Dirbuster, Dirb, and others come into play.

### Checking out the web directories

Gobuster is a web directory brute-forcing tool used to search for hidden directories and files by sending HTTP requests to the target server with potential directory or file names, identifying unauthorized entry points in web applications. On the other hand, Seclists serves as a comprehensive collection of common passwords, keywords, and patterns utilized in security attacks, aiding in password cracking attempts, password strength testing, or other network attacks by providing a wide array of password possibilities. Together, these tools complement each other in penetration testing, facilitating the discovery of security vulnerabilities, sensitive information, or unauthorized access to systems and data.

```cmd
$ gobuster dir --url http://10.129.254.3/ --wordlist Discovery/Web-Content/directory-list-lowercase-2.3-small.txt
```

![...](https://i.ibb.co/d4sQCR1/image.png#center)

After checking out the web directories, we have found no helpful information. The results present in our output represent default directories for most websites, and most of the time, they do not contain files that could be exploitable or useful for an attacker in any way. However, it is still worth checking them because sometimes, they could contain non-standard files placed there by mistake.

## Foothold

Since Gobuster did not find anything useful, we need to check for any default credentials or bypass the log-in page somehow. To check for default credentials, we could type the most common combinations in the username and password fields, such as:

```cmd
admin:admin
guest:guest
user:user
root:root
administrator:password
```

Here is an example of how authentication works using PHP & SQL:

```php { linenos=table }
<?php
mysql_connect("localhost", "db_username", "db_password"); # Connection to the SQL Database.
mysql_select_db("users"); # Database table where user information is stored.

$username = $_POST["username"]; # User-specified username.
$password = $_POST["password"]; #User-specified password.

$sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
# Query for user/pass retrieval from the DB.

$result = mysql_query($sql);
# Performs query stored in $sql and stores it in $result.

$count = mysql_num_rows($result);
# Sets the $count variable to the number of rows stored in $result.

if ($count == 1) {
    # Checks if there's at least 1 result, and if yes:
    $_SESSION["username"] = $username; # Creates a session with the specified $username.
    $_SESSION["password"] = $password; # Creates a session with the specified $password.
    header("location:home.php"); # Redirect to homepage.
} else {
    # If there's no singular result of a user/pass combination:
    header("location:login.php");
    # No redirection, as the login failed in the case the $count variable is not equal to 1, HTTP Response code 200 OK.
}
?>
```

Notice how after the `#` symbol, everything turns into a comment? This is how the PHP language works. Keep that in mind for later.

This code above is vulnerable to SQL Injection attacks, where you can modify the query (the $sql variable) through the log-in form on the web page to make the query do something that is not supposed to do - bypass the log-in altogether!

Note that we can specify the username and password through the log-in form on the web page. However, it will be directly embedded in the $sql variable that performs the SQL query without input validation. Notice that no regular expressions or functions forbid us from inserting special characters such as a single quote or hashtag. This is a dangerous practice because those special characters can be used for modifying the queries. The pair of single quotes are used to specify the exact data that needs to be retrieved from the SQL Database, while the hashtag symbol is used to make comments. Therefore, we could manipulate the query command by inputting the following:

```cmd
Username: admin'#
```

We will close the query with that single quote, allowing the script to search for the admin username. By adding the hashtag, we will comment out the rest of the query, which will make searching for a matching password for the specified username obsolete. If we look further down in the PHP code above, we will see that the code will only approve the log-in once there is precisely one result of our username and password combination. However, since we have skipped the password search part of our query, the script will now only search if any entry exists with the username admin . In this case, we got lucky. There is indeed an account called admin , which will validate our SQL Injection and return the 1 value for the $count variable, which will be put through the if statement , allowing us to log-in without knowing the password. If there was no admin account, we could try any other accounts until we found one that existed. (administrator, root, john_doe, etc.) Any valid, existing username would make our SQL Injection work.

In this case, because the password-search part of the query has been skipped, we can throw anything we want at the password field, and it will not matter

```cmd
Password: anythingyouwant
```

To be more precise, here is how the query part of the PHP code gets affected by our input. It should be like this:

```sql
SELECT * FROM users WHERE username='admin' AND password='a'
```

to be:
```sql
SELECT * FROM users WHERE username='admin'#' AND password='a'
```
![...](https://i.imgur.com/tiQXygn.png)