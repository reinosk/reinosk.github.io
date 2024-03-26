---
author: "@reinosk"
title: Setup VM for Hacking Lab
date: 2024-03-26T12:58:03.164Z
description: Setup VM for Hacking Lab
summary: Setup VM for Hacking Lab
series: ["Hacking"]
tags: ["Linux"]
ShowToc: true
TocOpen: true
---

**tl;dr** 
This is a vm installation on archlinux for my hacking lab.

## Upgrading Packages
Update and upgrading packages

```cmd
$ sudo pacman -Syy && sudo pacman -Syu
```

## Install the core packages
Install the virtualbox package. You will also need to choose a package to provide host modules
- for the linux kernel, choose [virtualbox-host-modules-arch](https://archlinux.org/packages/?name=virtualbox-host-modules-arch)
- for any other kernel (including linux-lts), choose [virtualbox-host-dkms](https://archlinux.org/packages/?name=virtualbox-host-dkms)

To compile the VirtualBox modules provided by virtualbox-host-dkms, it will also be necessary to install the appropriate headers package(s) for your installed kernel(s) (e.g. linux-lts-headers for linux-lts). When either VirtualBox or the kernel is updated, the kernel modules will be automatically recompiled thanks to the DKMS pacman hook. 

```cmd
$ sudo pacman -S virtualbox-host-dkms virtualbox
```

Load module manually

```cmd
$ sudo modprobe vboxdrv vboxnetflt
```
Run Virtualbox

![...](https://i.imgur.com/K8uyzHx.png)

## Setup the internet for VM
The following modules are only required in advanced configurations:

`vboxnetadp` and `vboxnetflt` are both needed when you intend to use the bridged or host-only networking feature. More precisely, `vboxnetadp` is needed to create the host interface in the VirtualBox global preferences, and `vboxnetflt` is needed to launch a virtual machine using that network interface.

![...](https://i.imgur.com/JPzsK8k.png)