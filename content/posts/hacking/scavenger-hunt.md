---
author: "@reinosk"
title: Scavanger Hunt Write-up
date: 2024-03-10T10:17:59.171Z
description: There is some interesting information hidden around this site http://mercury.picoctf.net:44070/. Can you find it?
summary: There is some interesting information hidden around this site http://mercury.picoctf.net:44070/. Can you find it?
series: ["Hacking"]
tags: ["picoCTF"]
ShowToc: true
# TocOpen: true
---

| Hints                                                                       | Targets                           |
| --------------------------------------------------------------------------- | --------------------------------- |
| _You should have enough hints to find the files, don't run a brute forcer._ | http://mercury.picoctf.net:44070/ |

## Approach
The target looks like this:
![...](https://i.imgur.com/MZypyay.png#center)

And some of info we got was from [here](http://mercury.picoctf.net:44070/):
```html { linenos=table }
<link rel="stylesheet" type="text/css" href="mycss.css" />
<script type="application/javascript" src="myjs.js"></script>

<!-- Here's the first part of the flag: picoCTF{t -->
```
We think that there must be something inside `mycss.css` file and `myjs.js` file. Why don't we try to open both?

Inside the `mycss.css` we've found [part 2](http://mercury.picoctf.net:44070/mycss.css) of the flag. But we didn't find the hardcoded part of the flag code in the `myjs.js` file.

But if we recall, the CTF game is full puzzles, and there should be a clue in the `myjs.js` file.

Take a look at the bottom comment in the `myjs.js` file, and we know that the sentence `/* How can I keep Google from indexing my website? */` is a search keyword lmao.

```js { linenos=table }
function openTab(tabName, elmnt, color) {
  var i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablink");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].style.backgroundColor = "";
  }
  document.getElementById(tabName).style.display = "block";
  if (elmnt.style != null) {
    elmnt.style.backgroundColor = color;
  }
}

window.onload = function () {
  openTab("tabintro", this, "#222");
};

/* How can I keep Google from indexing my website? */
```

Reffering to indexing, namely `robots.txt`, perhaps we should see if there is anything in there.

![...](https://i.imgur.com/A6d2mXP.png#center)

> _Thanks GOD, part 3 of the flag has been found. however, the closing bracket isn't written there. Meaning there's still the next part to be found._

Next step, we must find the next part with the keyword is `an apache server`. I was wondering if that meant `.htaccess`?

![...](https://i.imgur.com/bynFIHx.png#center)

Okay, right. And the last one is Store, and I know it will refer to the `.DS_Store` path.

![...](https://i.imgur.com/BcQ5hCL.png#center)

## Summary
### robots.txt
`Robots.txt` is a text file used by webmasters to instruct search engine crawlers (such as Googlebot) about which parts of a website should be indexed (given to search engines) and which should not be indexed. In the context of hacking, robots.txt can often provide useful insights to attackers. While information about what should not be indexed may not always be confidential, sometimes the information included in robots.txt can provide clues about the structure of sites, subdomains, or directories that may be attractive targets for attackers. Attackers often use this information to identify areas that may be vulnerable or important in an attack.

### .htaccess
The `.htaccess` file is a configuration file used on Apache-based web servers. It allows users to control the server configuration for a specific directory directly through a text file. In a hacking context, attackers often look for unencrypted or vulnerable .htaccess files to take control of the server or change the server configuration unauthorisedly. Poorly configured or vulnerable .htaccess files can be leveraged by attackers to perform attacks such as redirect phishing, file access exploits, or even uploading malicious scripts.

### .DS_Store
A `.DS_Store` file is a metadata file created by the macOS operating system to store display preferences and folder settings. While essentially harmless, in a hacking context, .DS_Store files can provide valuable information to attackers, especially if they are in a file sharing environment. .DS_Store files often store information about the files and folders within them, including the directory structure and filenames, which can give attackers insight into how the system is organised and structured. Attackers can utilise this information to plan attacks, locate sensitive files, or identify areas that may be targeted in further penetration attempts.