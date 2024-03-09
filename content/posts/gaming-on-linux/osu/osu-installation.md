---
author: "@reinosk"
title: 怜之助 GUIDE - osu! Installation
date: 2024-02-01T08:22:10.083Z
description: This is my personal configuration for my osu! stuff on Arch Linux. No plans will be made to make a separate osu! wiki page.
summary: This is my personal configuration for my osu! stuff on Arch Linux. No plans will be made to make a separate osu! wiki page.
series: ["Gaming on Linux"]
# cover: 
#   image: https://imgur.com/uJ2GTeX.png
ShowToc: true
# TocOpen: true
---

> *This guide implies you have read [Help:Reading](https://wiki.archlinux.org/title/Help:Reading) and/or know your ways around Linux. In case you're using a different distribution, you can try [hwsmm's guide](https://gist.github.com/hwsmm/ba73a5cd82e17cec14fe8d2cc2a8d32d).*

osu! is a freeware rhythm game where player uses mouse and keyboard input to click on circles to the rhythm in main gameplay mode.

The following install guide has different installation methods for osu!, one with Lutris and a basic one. There are also included some instructions on improving experience with the game, like switching to a custom wine version or switching to PipeWire audio server.

You should pick your preferred installation method and then decide whether you want to do additional steps to improve your experience with the game also outlined here. 

## Installing osu!

Enable [multilib](https://wiki.archlinux.org/title/Multilib) and install [wine](https://archlinux.org/packages/?name=wine) and [winetricks](https://archlinux.org/packages/?name=winetricks)

### Update Deps

```shell
$ sudo pacman -Syy && sudo pacman -Syu
```

### Prepare wineprefix

Create WINEPREFIX for your osu! installation and run winetricks to install required dependencies for osu! to work correctly. 

```shell
$ WINEARCH=win32 WINEPREFIX=~/.wineosu winetricks dotnet40 gdiplus corefonts baekmuk meiryo tahoma vlgothic cjkfonts fontfix
```

cjkfonts allows you to see CJK characters correctly, instead of squares. gdiplus fixes icon display in osu! settings. 

> *You do not need to install gdiplus if you use [wine](https://archlinux.org/packages/?name=wine) version 6.10 or above.*

![prepare_wineprefix](https://imgur.com/3bHKY0V.png#center)

### Installing The Game

> *You can skip next 3 steps if you want to symlink your existing osu! installation. Refer to [ln(1)](https://man.archlinux.org/man/ln.1) for instructions.*

```shell
$ mkdir ~/.wineosu/osu/
```

Download osu! executable. 

```shell
$ wget --output-document ~/.wineosu/osu/osu\!.exe https://m1.ppy.sh/r/osu!install.exe
```

Start osu! and test if it works correctly. 

```shell
$ WINEARCH=win32 WINEPREFIX=~/.wineosu wine ~/.wineosu/osu/osu\!.exe
```

Create startup script for osu! 

in `~/.wineosu/osu/start.sh` create:

```bash {linenos=table}
#!/usr/bin/env bash
#export PATH="$HOME/.wineosu/osuwine/bin:$PATH" #Use custom WINE version to run osu!
export WINEARCH=win32
export WINEPREFIX="$HOME/.wineosu"
#export WINEFSYNC=1

#VSync. For some reason, some people had been getting input latency issues and for some reason, the fix is to set VSync to off.
export vblank_mode=0 #For AMD, Intel and others
export __GL_SYNC_TO_VBLANK=0 #For NVIDIA proprietary and open source >=500

#export STAGING_AUDIO_PERIOD=10000

#start osu!
wine osu\!.exe
```

### Creating freedesktop entry

Fetch osu! logo. 

```shell
$ wget --output-document ~/.wineosu/osu/icon.png https://github.com/ppy/osu-wiki/raw/master/wiki/Brand_identity_guidelines/img/usage-full-colour.png
```

Create and edit a new desktop entry file for osu!. 

in `~/.local/share/applications/osu.desktop` create:

```bash {linenos=table}
[Desktop Entry]
Type=Application
Comment=A freeware rhythm game where player uses mouse and keyboard input to click on circles to the rhythm in main gameplay mode.
Icon=<change to your home folder>/.wineosu/osu/icon.png #XDG spec doesn\\'t support environment variables. Enter home path manually.
Exec=<change to your home folder>/.wineosu/osu/start.sh #XDG spec doesn\\'t support environment variables. Enter home path manually.
Path=/home/<change to your home folder>/.wineosu/osu #XDG spec doesn\\'t support environment variables. Enter home path manually.
GenericName=osu!
Name=osu!
StartupNotify=true
```

Let's start the GAMEEEEEDKAJDLASJFLASDJFJ!!!
![osu_running_successfully](https://i.ibb.co/S7RhBwB/screenshot090.jpg)


## Troubleshooting

### Networking

WTF is this sh*t???!!

```shell
...
0128:fixme:virtual:NtFlushProcessWriteBuffers stub
0128:fixme:crypt:SystemFunction041 (010A8A74, 10, 0): stub [RtlDecryptMemory]
0128:fixme:ras:RasEnumConnectionsW (01109FD8,0728F17C,0728F180),stub!
0128:fixme:ras:RasEnumConnectionsW RAS support is not implemented! Configure program to use LAN connection/winsock instead!
0128:fixme:ras:RasConnectionNotificationW (FFFFFFFF,000002F4,0x00000003),stub!
0128:err:winediag:process_attach Failed to load libgnutls, secure connections will not be available.
0128:err:secur32:SECUR32_initSchannelSP no schannel support, expect problems
0128:err:winediag:ntlm_check_version ntlm_auth was not found. Make sure that ntlm_auth >= 3.0.25 is in your path. Usually, you can find it in the winbind package of your distribution.
0128:err:ntlm:ntlm_LsaApInitializePackage no NTLM support, expect problems
0124:fixme:thread:NtQueryInformationThread ThreadIsIoPending info class not supported yet
0024:fixme:olepicture:OLEPictureImpl_QueryInterface () : asking for unsupported interface {c3fcc19e-a970-11d2-8b5a-00a0c9b7c9c4}
0024:fixme:olepicture:OLEPictureImpl_QueryInterface () : asking for unsupported interface {b196b283-bab4-101a-b69c-00aa00341d07}
0024:fixme:olepicture:OLEPictureImpl_QueryInterface () : asking for unsupported interface {00000003-0000-0000-c000-000000000046}
0024:fixme:olepicture:OLEPictureImpl_QueryInterface () : asking for unsupported interface {00000144-0000-0000-c000-000000000046}
...
```

Don't worry, it's because you haven't configured the network in wine.

Take a look at this reference [Wine Networking](https://wiki.archlinux.org/title/Wine#Networking). After installation, the [lib32-gnutls](https://archlinux.org/packages/?name=lib32-gnutls) package may need to be [installed](https://wiki.archlinux.org/title/Install) for applications making TLS or HTTPS connections to work.

For ICMP (ping), Wine may need the network access as described in the [WineHQ FAQ](https://wiki.winehq.org/FAQ#Failed_to_use_ICMP_.28network_ping.29.2C_this_requires_special_permissions):

```cmd
# setcap cap_net_raw+epi /usr/bin/wine-preloader
```

If issues arise after this (such as an unhandled exception or privileged instruction), remove via: 

```cmd
# setcap -r /usr/bin/wine-preloader
```

### Dependency Requirements

<!-- ```bash {linenos=table,hl_lines=[21,30]} -->
```bash
sudo pacman -Sy pacman -Sy --noconfirm --needed git base-devel p7zip wget zenity wine-staging winetricks giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox
```

```bash
sudo pacman --needed -Sy libxcomposite lib32-libxcomposite gnutls lib32-gnutls wine winetricks
```

### Beatmaps

If your Beatmap couldn't be loaded successfully. Just following this:

```
$ yay -S osu-handler
```

## winetricks.log
```cmd
remove_mono internal
winxp
dotnet40
sourcehansans
fakechinese
fakejapanese
fakekorean
unifont
cjkfonts
gdiplus
fakechinese
fakejapanese
fakekorean
cjkfonts
fakechinese
fakejapanese
fakekorean
cjkfonts
fakechinese
fakejapanese
fakekorean
cjkfonts
andale
arial
comicsans
courier
georgia
impact
times
trebuchet
verdana
webdings
corefonts
baekmuk
meiryo
tahoma
vlgothic
fakechinese
fakejapanese
fakekorean
cjkfonts
fontfix
```
## References

- [Installing osu! on Linux with low-latency [2023]](https://osu.ppy.sh/community/forums/topics/1248084?n=1)
- [KatouMegumi's guide](https://wiki.archlinux.org/title/User:Katoumegumi#osu!_(stable)_on_Arch_Linux)
