---
title: Archlinux下的中文输入法问题
date: 2017-04-21T23:00:00+08:00
description: "ArchLinux下搜狗输入法问题解决"
categories: ["Linux"]
featuredImage: "attachments/archlinux-logo-black-1200dpi.94d8489023b3.png"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

桌面系统：Gnome 3.22
输入法框架: fcitx

今天打开电脑突然发现，无法使用`Ctrl-空格`切换中文输入法了。通过一番Google，找到了解决方法。

### $
终端中输入以下命令即可解决：
```sh
gsettings set \
  	org.gnome.settings-daemon.plugins.xsettings overrides \
"{'Gtk/IMModule':<'fcitx'>}"
```

<!-- more -->


终于可以愉快滴输入中文了。
