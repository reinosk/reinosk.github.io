---
author: "@reinosk"
title: Getting Help
date: 2024-02-01T04:30:40.000Z
description: Familiarizing with unfamiliar tools and their optional parameters is vital. Use man pages and help functions to understand new tools. Learn about a tool before use to discover unexpected features. Man pages offer detailed manuals for better understanding.
summary: Familiarizing with unfamiliar tools and their optional parameters is vital. Use man pages and help functions to understand new tools. Learn about a tool before use to discover unexpected features. Man pages offer detailed manuals for better understanding.
series: ["HTB"]
ShowToc: true
# TocOpen: true
---
### Syntax:

```shell
reinosk@htb[/htb]$ man <tool>
```

Let us have a look at an example:

### Example:
```shell
reinosk@htb[/htb]$ man curl
```

```shell
curl(1)                                                             Curl Manual                                                            curl(1)

NAME
       curl - transfer a URL

SYNOPSIS
       curl [options] [URL...]

DESCRIPTION
       curl  is  a tool to transfer data from or to a server, using one of the supported protocols (DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS,  
       IMAP, IMAPS,  LDAP,  LDAPS,  POP3,  POP3S,  RTMP, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET, and TFTP). The command is designed to work without user interaction.

       curl offers a busload of useful tricks like proxy support, user authentication, FTP upload, HTTP post, SSL connections, cookies, file transfer resume, Metalink,  and more. As we will see below, the number of features will make our head spin!

       curl is powered by libcurl for all transfer-related features.  See libcurl(3) for details.

Manual page curl(1) line 1 (press h for help or q to quit)
```

After looking at some examples, we can also quickly look at the optional parameters without browsing through the complete documentation. We have several ways to do that.

### Syntax:

```shell
reinosk@htb[/htb]$ <tool> -h
```

### Example:

```shell
reinosk@htb[/htb]$ curl -h

Usage: curl [options...] <url>
     --abstract-unix-socket <path> Connect via abstract Unix domain socket
     --anyauth       Pick any authentication method
 -a, --append        Append to target file when uploading
     --basic         Use HTTP Basic Authentication
     --cacert <file> CA certificate to verify peer against
     --capath <dir>  CA directory to verify peer against
 -E, --cert <certificate[:password]> Client certificate file and password
<SNIP>
```

As we can see, the results from each other do not differ in this example. Another tool that can be useful in the beginning is `apropos`. Each manual page has a short description available within it. This tool searches the descriptions for instances of a given keyword.

### Syntax:

```shell
reinosk@htb[/htb]$ apropos <keyword>
```

### Example:

```shell
reinosk@htb[/htb]$ apropos sudo

sudo (8)             - execute a command as another user
sudo.conf (5)        - configuration for sudo front end
sudo_plugin (8)      - Sudo Plugin API
sudo_root (8)        - How to run administrative commands
sudoedit (8)         - execute a command as another user
sudoers (5)          - default sudo security policy plugin
sudoreplay (8)       - replay sudo session logs
visudo (8)           - edit the sudoers file
```

Another useful resource: [https://explainshell.com/](https://explainshell.com/)