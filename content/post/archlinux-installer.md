---
title: Archlinux-Installer使用教程
date: 2018-03-15T14:00:00+08:00
description: "Archlinux-Installer为ArchLinux快速安装脚本，支持配置备份，支持环境快速恢复"
categories: ["Linux"]
featuredImage: "attachments/archlinux-logo-black-1200dpi.94d8489023b3.png"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### About

使用Linux也已经两年了，开始使用的是Ubuntu，后来各种折腾，换到了Archlinux，使用至今。在使用Archlinux过程中，各种折腾各种配置，各种快捷键，终于把Archlinux折腾成了自己觉得很好看，很好用的样子。但是问题就是，如果哪天我想重装我的Arch，我还得从头一个命令一个命令敲一遍。还得重新改各种配置，重新装各种常用的软件。虽然说从头敲一遍命令可以学到很多东西，但那是对于第一次装的时候。如果以后每次重装都重新敲一遍，岂不是很蠢，很浪费时间。所以呢，我就使用bash配合dialog工具，写了这个伪界面版本的Archlinux安装器。

### Feature

以下是这个安装器的一些特性:

- 伪界面，相对纯纯的命令行，是不是友好那么点
- 支持KDE、Xfce、Gnome桌面系统的安装
- 支持Gnome桌面系统的简单配置
- 支持Gnome桌面系统的中文输入法(搜狗输入法)的安装
- 支持一些软件的配置的备份和恢复(可以添加自己的备份/恢复脚本)
- 支持Bios和UEFI两种启动方式
- 自动检测Windows启动项

<!-- more -->

### I Want Say

Arch Linux主张“以用户为中心”，让用户自己去动手控制自己的系统，让用户自己动手去解决问题。它的安装过程就体现了这一点。我写这个安装器并不是想违背这个观点。我也认为作为开发人员，应该自己动手去解决遇到的问题，解决问题能帮助我们学到更多的东西。我写这个安装器是为了能够更快速地恢复自己的系统环境。也是为了能够帮助刚开始使用Arch的童鞋能够一点点帮助。感兴趣的童鞋可以修改这个安装器，加入自己的软件备份/恢复脚本。

### How To Use

#### 制作Arch启动盘

首先，需要下载`Arch`安装`ios`包，怎么下载我就不多说了。然后找个启动盘制作工具，在`Windows`上，我比较喜欢的一个工具是`Rufus`。如果使用虚拟机的童鞋，就没必要制作启动盘了，直接使用`ios`包就行了。

#### 使用启动盘启动并连网

怎么启动就不多说了。启动之后最重要的事就是连网，只有连上网才能继续后续的操作。直接使用网线连网并且不需要验证的话，一般启动之后就连上网了。如果是需要验证或使用`WIFI`的话就有点麻烦了。不会的童鞋可以参考我的文章([怎么在Linux使用命令行连接WIFI](https://coolcodes.me/2018/03/15/how-to-connect-wifi-in-linux-command/))。怎么看是否连上网了呢？`ping`一下，比如`ping www.baidu.com`，如果`ping`能成功的话，那就是连上了。如果不成功的话，那.....，再检查检查 。

#### 开始安装

前面都是一些准备工作，接下来才是使用安装器。

在命令行中输入:

```bash
bash <(curl https://raw.githubusercontent.com/si9ma/Archlinux-Installer/master/install.sh)
```

#### 选择键盘布局

![keymap-1](/attachments/archlinux-installer/keymap-1.png)

一般使用的都是US布局，所以选择No就行。但是如果你想使用其它布局的话就选择Yes，然后选择合适的布局。如下，

![keymap-2](/attachments/archlinux-installer/keymap-2.png)

#### 硬盘分区

安装Arch之前，需要对硬盘进行分区，在分区之前一定要看好各个磁盘/分区的大小，避免在后续挂载分区的时候选错，然后格错分区。

![partition-1](/attachments/archlinux-installer/partition-1.png)

##### 对于两种启动方式

1. BIOS启动方式

如果你的启动方式是BIOS，那么你应该把你的硬盘转换成MBR的，也就是说接下来的选择分区结构，你应该选择dos。

![partition-bios](/attachments/archlinux-installer/partition-bios.png)

2. UEFI启动方式

如果你的启动方式是UEFI，你必须有一个100M-200M大小的分区用作ESP分区。如果你电脑上之前有装过Windows，并且也是UEFI启动，那么已经存在一个EFI分区了，在后续的分区挂载时候不应该格式化该EFI分区，否则Windows就无法启动了。

![uefi](/attachments/archlinux-installer/uefi.png)

##### 选择需要进行分区的硬盘

如果有多个硬盘，将按照顺序进行分区:

![partition-select](/attachments/archlinux-installer/partition-select.png)

##### 选择硬盘分区结构

如果你的硬盘是还没进行过分区的硬盘，会出现这个页面。如果你是BIOS启动，那么选择dos，如果是UEFI启动，那么选择gpt。

![partition-label](/attachments/archlinux-installer/partition-label.png)

##### 对硬盘分区

使用`New`创建新的分区，分区完成之后，记得`Write`，然后`Quit`完成分区。

![partition-go](/attachments/archlinux-installer/partition-go.png)

#### 分区挂载

选择需要单独挂载的文件目录，如果你的启动方式是UEFI,那么你必须单独挂载 `/boot`。我一般只挂载根目录`/`。你还可以添加`swap`分区。

![fs-mount](/attachments/archlinux-installer/fs-mount.png)

##### 为每个选择的目录选择分区

请注意分区大小，一定不要选错分区，因为选择的分区后续将会被格式化。根据分区大小来选择正确的分区。`/dev/sda1(ext2) devtmpfs/16G-->ext4`的意思是，该分区为`/dev/sda1`,大小为16G，当前文件系统格式为`devtmpfs`，将被格式化为`ext2`。请选择合适的文件系统格式，我一般选择`ext4`。

![root-mount](/attachments/archlinux-installer/root-mount.png)

##### 对于/boot

如果你的启动方式是UEFI，那么/boot必须单独挂载到ESP分区上去，如果ESP分区是来自之前的Windows的安装，那么你不能格式化该分区，如图，你应该选择No

![uefi-confirm](/attachments/archlinux-installer/uefi-confirm.png)

##### 对于swap分区

`swap`分区有两种方式，一种是选择分区，另外一种是使用文件来实现。如果使用文件实现，那么选择`swapfile`。

![swap](/attachments/archlinux-installer/swap.png)

#### 选择源

先选择国家/地区

![mirrors](/attachments/archlinux-installer/mirrors.png)

选择源，一般来说越靠前的源，速度会越快

![mirrors-2](/attachments/archlinux-installer/mirrors-2.png)

#### 开始安装基本系统

等待基本系统安装完成......

![basic](/attachments/archlinux-installer/basic.png)

#### 选择时区

先选择地区，国内的童鞋选择`Asia`

![timezone](/attachments/archlinux-installer/timezone.png)

再选择城市,国内童鞋选择`Shanghai`

![timezone-location](/attachments/archlinux-installer/timezone-location.png)

#### 本地化

先选择字符集，我一般选择`zh_CN.UTF-8`和`en_US.UTF-8`

![locale](/attachments/archlinux-installer/locale.png)

然后是`System Locale`，建议先选择`en_US.UTF-8`，进入桌面系统后再更改桌面系统的`locale`

![sys-locale](/attachments/archlinux-installer/sys-locale.png)

#### 基本配置

主机名

![hostname](/attachments/archlinux-installer/hostname.png)

root密码

![passwd](/attachments/archlinux-installer/passwd.png)

用户名，用户名中请不要有大写字母

![user](/attachments/archlinux-installer/user.png)

用户密码

![passwd-user](/attachments/archlinux-installer/passwd-user.png)

#### 其他安装

安装一些必要软件

![other-install](/attachments/archlinux-installer/other-install.png)

#### 基本系统安装完成 

![basic-complete](/attachments/archlinux-installer/basic-complete.png)

#### 重启后启动Arch

![boot](/attachments/archlinux-installer/boot.png)

#### 登录进行后续安装

使用前面设置的用户进行登录，别使用root用户进行登录，使用root登录将导致后续安装失败

![boot-go](/attachments/archlinux-installer/boot-go.png)

#### 启用AUR

AUR库并不是官方的源，但很多时候很好用。你也可以选择不启用。

![aur](/attachments/archlinux-installer/aur.png)

选择源，国内用户选择archlinuxcn

![aur-mirrors](/attachments/archlinux-installer/aur-mirrors.png)

#### 启用32位库

`Arch`已经不再支持32位的系统了，但依然可以在64位系统里使用32位的库。你也可以不启用

![lib32](/attachments/archlinux-installer/lib32.png)

#### 安装桌面系统

先安装显卡驱动，虚拟机用户可以安装对应的虚拟机驱动，intel用户一般都有intel的集成显卡，所以选择intel的驱动。Linux对`NVIDIA`显卡的驱动支持不是很好，所以如果你想使用`NVIDIA`显卡驱动的话，你自己之后慢慢折腾吧～

![driver](/attachments/archlinux-installer/driver.png)

然后选择桌面系统，这里提供了三个桌面系统

![desktop](/attachments/archlinux-installer/desktop.png)

![desktop-to](/attachments/archlinux-installer/desktop-to.png)

如果你安装了Gnome桌面系统，那么后续将会提供Gnome的配置.

#### Gnome桌面主题配置

这部分可能比较慢，因为一些主题需要到国外网站上下载主题，`local`表示本地，`remote`表示需要下载。

##### GTK主题

![gtk-theme](/attachments/archlinux-installer/gtk-theme.png)

##### 图标主题

![icon](/attachments/archlinux-installer/icon.png)

##### Shell主题

![shell](/attachments/archlinux-installer/shell.png)

#### Gnome插件

![plugin](/attachments/archlinux-installer/plugin.png)

#### Gnome中文输入法配置

选择(1)将整个桌面系统都配置成中文的，并安装搜狗输入法。选择(2)只安装搜狗输入法，但系统环境是英文的，比如标题等。

![chinese](/attachments/archlinux-installer/chinese.png)

#### 软件安装/配置恢复

选择你需要安装的软件或需要恢复的配置，你也可以在`backup.conf`中添加需要的操作，并在`backup_script.sh`中实现备份方法，在`restore_script.sh`中实现安装/恢复操作。

![app](/attachments/archlinux-installer/app.png)

#### 安装完成

![done](/attachments/archlinux-installer/done.png)

#### 关于配置备份

执行`backup.sh`进行配置备份

---
