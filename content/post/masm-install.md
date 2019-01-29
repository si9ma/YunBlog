---
title: 在linux上通过wine使用MASM汇编器
date: 2017-03-13T22:00:00+08:00
description: "在Linux上安装MASM"
categories: ["Linux"]
featuredImage: "attachments/linux-1-800x420.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### What MASM

```bash
The Microsoft Macho Assembler (MASM) is an x86 assembler(汇编器) that uses the Intel syntax for MS-DOS and Microsoft Windows. Beginning with MASM 8.0 there are two versions of the assembler - one for 16-bit and 32-bit assembly sources, and another (ML64) for 64-bit sources only.
```

### Why

这学期学校开了汇编语言与接口技术课程。教材中使用的汇编器是微软的MASM，但MASM只支持win平台，不支持mac和linux平台。虽然linux平台也有很多汇编器，比如NSMA（使用intel语法）、GAS（使用AT&T语法）。但考虑到NASM和GAS的语法跟MASM的语法还是有差异，和老师讲课内容有出入，而且又不想使用Windows。所以打算在linux通过wine安装使用MASM。也希望自己多动手，多学点东西。

### 安装Wine

- Archlinux上通过pacman安装
```bash
sudo pacman -Sy wine
```

- Ubuntu 上的**[安装方法](https://wiki.winehq.org/Ubuntu)**

其他发行版可以百度or谷歌搜索安装方法



<!-- more -->




### 初始化Wine

Wine有个东西叫做wineprefix，wineprefix默认是`～/.wine`,如果你只在终端里使用`wine program`,那么wine将在用户home目录创建一个`.wine`文件夹，然后在`.wine`文件夹中初始化wine环境， 该环境的配置保存在`～/.wine/*.reg`文件中，C:\的文件树保存在`~/.wine/drive_c`文件夹下。
当然，你也可以自定义wineprefix，使用下列命令初始化你自己的wine环境：
```bash
WINEARCH=win32 WINEPREFIX=~/你自定义的文件夹名 winecfg
```
比如，我的是：
```bash
WINEARCH=win32 WINEPREFIX=~/.wine_ml11 winecfg
```

这样我的wine环境就初始化到了`~/.wine_ml11`文件夹下，Windows文件系统储存在`～/.wine_ml11/drive_c`文件夹下
### 下载解压MASM32

使用`wget`下载 masm32v11r.zip：
```bash
wget  http://www.masm32.com/download/masm32v11r.zip
```

解压：
```bash
unzip masm32v11r.zip
```

### 安装MASM

使用命令安装：
```bash
WINEPREFIX=~/wine的初始化目录 wine install.exe
```
比如我的：
```bash
WINEPREFIX=~/.wine_ml11 wine install.exe
```

- 安装过程(一路ok）：

 ![](/attachments/masm-install/masm-install-1.png)

 ![](/attachments/masm-install/masm-install-2.png)
 
 ![](/attachments/masm-install/masm-install-3.png)

 ![](/attachments/masm-install/masm-install-4.png)
 
 ![](/attachments/masm-install/masm-install-5.png)

 ![](/attachments/masm-install/masm-install-6.png)
 
 ![](/attachments/masm-install/masm-install-7.png)
 
 ![](/attachments/masm-install/masm-install-8.png)
 
 ![](/attachments/masm-install/masm-install-9.png)

 ![](/attachments/masm-install/masm-install-10.png)

 ![](/attachments/masm-install/masm-install-11.png)

- 创建桌面快捷方式，yes创建，no不创建。

 ![](/attachments/masm-install/masm-install-12.png)
 
 - 安装成功


### 设置环境变量

设置环境变量：
```bash
WINEPREFIX=~/你的wine目录 wine regedit
```
比如我的：
```bash
WINPREFIX=~/.wine_ml11 wine regedit
```
在弹出的窗口中定位到`HKEY_LOCAL_MACHINE->System->CurrentControlSet->Control->Session Manager->Environment`

 ![](/attachments/masm-install/masm-install-13.png)
 
 
在PATH的值后面加上`;C:\masm32\bin`

新建String Value,新增INCLUDE变量，填写值`C:\masm32\include`以及新增LIB变量，填写值`C:\masm32\lib`

退出wine，使环境变量更改生效

- 到此安装配置成功

### 编写运行第一个Hello World程序

- 在home目录编写Hello.asm:
```x86asm
DATA SEGMENT
     MSG DB "Hello World!","$"
DATA ENDS

CODE SEGMENT
     ASSUME CS:CODE, DS:DATA
	 START:
	     MOV AX, DATA
		 MOV DS, AX

         MOV AH, 09H
		 LEA DX, MSG     ;Print String
		 INT 21H

	STOP:
	     MOV AX, 4C00H
		 INT 21H
CODE ENDS
     END START
```

- 设置WINEPREFIX变量
如果你使用默认的`~/.wine`,可忽略此步骤。
临时设置：
```bash
export WINEPREFIX=~/.wine_ml11(改为你的目录）
```
  永久设置：
把`export WINEPREFIX=~/.wine_ml11（改为你的目录）`写入.bashrc文件或者.zshrc文件中

- 编译Hello.asm
```bash
wine ml /c Hello.asm
```
 ![](/attachments/masm-install/masm-install-14.png)
编译后会生成Hello.obj文件

- 链接Hello.obj
```bash
wine link Hello.obj
```
  ![](/attachments/masm-install/masm-install-15.png)
链接报错，`fatal error LNK1123: failure during conversion to COFF: file invalid or corrupt`，使用link16进行链接可解决

  ![](/attachments/masm-install/masm-install-16.png)
链接成功。

- 运行Hello.exe
```bash
wine Hello.exe
```
  ![](/attachments/masm-install/masm-install-17.png)
提示需要安装dosbox
安装dosbox：
```bash
sudo pacman -S dosbox
```
  命令运行dosbox：
![](/attachments/masm-install/masm-install-18.png)
挂载当前目录为C：
![](/attachments/masm-install/masm-install-19.png)

- 切换到`C：`并运行Hello.exe
![](/attachments/masm-install/masm-install-20.png)
搞定！

### 补充
上课的时候发现老师讲的编译命令是MASM,一脸懵，一查才发现MASM是旧版本的编译命令，貌似从6.x版本后，编译命令就从MASM改为ML了。而且发现教材用的masm版本是6.15的。
  需要的童鞋，可以从**[这里](http://www2.hawaii.edu/~pager/312/masm%20615.ZIP)**下载MASM6.15压缩版（其中提供了MASM.EXE和LINK.EXE等程序，感觉有可能是从5.x版本中提取出来的）(你也可以从网上找5.x版本的）的，解压之后将其复制到你的wine的drive_c下，然后改一下wine中的环境变量，然后就可以通过`wine MASM` `wine LINK`使用了。
  
- 发现少了个调试程序，名字叫做debug.exe，是dos系统下的一个16-bit调试程序，可以从**[我云盘](https://pan.baidu.com/s/1jHAlmL4)**上下载，然后放到你经常写（编译，链接，调试）汇编程序的文件夹，并使用dosbox来运行debug.exe程序（因为是dos程序，所以需要dosbox来运行)

- 还可以设置doxbox运行时自动挂载目录，在`～/.dosbox`下的配置文件下找到`[autoexec]`，然后加入以下内容：
```dos
MOUNT C .
C:
```
保存退出

现在就可以运行`dosbox`，然后在弹出的窗口中使用DEBUG了。

### 总结
MASM下载安装下来，也就几M，而且运行起来挺流畅。配合bash脚本使用就更方便了。

---
【参考】：[https://reberhardt.com/blog/programming/2016/01/30/masm-on-mac-or-linux.html](https://reberhardt.com/blog/programming/2016/01/30/masm-on-mac-or-linux.html)
