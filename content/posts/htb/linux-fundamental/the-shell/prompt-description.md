---
author: "@reinosk"
title: Prompt Description
date: 2024-02-01T04:00:24.042Z
description: The bash prompt is easy to understand and, by default, includes information such as the user, hostname, and current working directory.
summary: The bash prompt is easy to understand and, by default, includes information such as the user, hostname, and current working directory.
series: ["HTB"]
ShowToc: false
# TocOpen: true
---

It is a string of characters displayed on the terminal screen that indicates that the system is ready for our input. It typically includes information such as the current user, the computer’s hostname, and the current working directory. The prompt is usually displayed on a new line, and the cursor is positioned after the prompt, ready for the user to start typing a command.

```shell
<username>@<hostname><current working directory>$
```

The home directory for a user is marked with a tilde `<~>` and is the default folder when we log in.

```shell
<username>@<hostname>[~]$
```

The dollar sign, in this case, stands for a user. As soon as we log in as `root`, the character changes to a hash `<#>` and looks like this:

```shell
root@htb[/htb]#
```

For example, when we upload and run a shell on the target system, we may not see the username, hostname, and current working directory. This may be due to the PS1 variable in the environment not being set correctly. In this case, we would see the following prompts:

### Unprivileged - User Shell Prompt

```shell
$
```

### Privileged - Root Shell Prompt

```shell
#
```

In addition to providing basic information like the current user and working directory, we can customize to display other information in the prompt, such as the IP address, date, time, the exit status of the last command, and more. This is especially useful for us during our penetration tests because we can use various tools and possibilities like `script` or the `.bash_history` to filter and print all the commands we used and sort them by date and time. For example, the prompt could be set to display the full path of the current working directory instead of just the current directory name, which can also include the target’s IP address if we work organized.


The prompt can be customized using special characters and variables in the shell’s configuration file (`.bashrc` for the Bash shell). For example, we can use: the `\u` character to represent the current username, `\h` for the hostname, and `\w` for the current working directory.

|Special Character|Description|
|---|---|
|`\d`|Date (Mon Feb 6)|
|`\D{%Y-%m-%d}`|Date (YYYY-MM-DD)|
|`\H`|Full hostname|
|`\j`|Number of jobs managed by the shell|
|`\n`|Newline|
|`\r`|Carriage return|
|`\s`| 	Name of the shell|
|`\t`|Current time 24-hour (HH:MM:SS)|
|`\T`|Current time 12-hour (HH:MM:SS)|
|`\@`|Current time|
|`\u`|Current username|
|`\w`|Full path of the current working directory|

Customizing your terminal's prompt offers a practical means to enhance both personalization and efficiency in your terminal usage. It serves as a valuable aid in diagnosing issues and addressing them promptly by offering insights into the system's current status.

Beyond just modifying the prompt, users can tailor their terminal environment further by adjusting color schemes, fonts, and various settings, thereby enhancing visual appeal and usability.

Similar to the customization options available in graphical user interfaces like Windows, users can personalize their experience in the terminal environment. This includes identifying their logged-in user and current directory, and adapting the bash prompt to suit individual preferences. While the specifics of bash prompt customization are not covered in this module, resources such as [bash-prompt-generator](https://bash-prompt-generator.org/) and [powerline](https://github.com/powerline/powerline) can be explored to facilitate this customization process.