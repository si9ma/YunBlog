---
title: 在安卓设备上部署安装Linux 
date: 2017-02-26T03:00:02+08:00
description: "第一篇博文，教你如何在安卓设备上安装一个迷你Linux"
categories: ["Linux"]
featuredImage: "attachments/android-apps-on-linux.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

搭建博客已经有10天了，但仍然还没有写任何东西，待火车上甚是无聊，所以就来写写第一篇博文（jidong（“.”））。

### Why
使用Linux已经有一段时间了，虽说不是精通，但用作日常使用已经是不成问题了，不过自己一般都是在电脑上使用Linux。那么问题来了，出门在外就没法使用它了，怎么办？使用安卓终端模拟器？虽说安卓终端模拟器会提供一些类似于Linux命令的命令，但是它只提供一小部分，很多Linux常用命令它都是不提供的。所以为何不在安卓手机上安装一个Linux呢？谷歌了一下，还真找到了在安卓上装Linux的方法。


<!-- more -->


### 道具
- 已经获得root权限的安卓设备（还没root的童鞋请自行google或百度寻找root自己爱机的方法）

- 安卓设备上至少有4G的储存空间（越大越好）

- 最新版的**[BusyBox](https://zh.m.wikipedia.org/zh-cn/BusyBox)**（BusyBox是一个以自由形式发行的应用程序，它在单一的可执行文件中提供了精简的Unix工具集。）

- 最新版安卓终端模拟器（我一般使用Termux）

- 最新版Linux Deploy（记得使用最新版的，因为我使用非最新版安装时，出现了错误）

- 最新版的Hacker’s Keyboard(安卓神器，解决安卓虚拟键盘部分键缺失的问题）

上面提到的最新版BusyBox，Termux，Linux Deploy,Hacker’s Keyboard均可在Google Play商店免费下载，对于无法访问Google的童鞋，可以从国内各大安卓市场下载，或者从**[我的百度云](http://pan.baidu.com/share/link?shareid=430693170&uk=2141079826)**下载，均是我从Google Play商店下载下来的。

### Go

#### 下载安装BusyBox
- 下载BusyBox后，打开BusyBox，如下图

![](/attachments/android-linux/android-linux-1.png)

- 安装BusyBox需要root权限，上图中为安装完成后的状态

#### 安装Termux和Hacker’s Keyboard
- 配置Hacker’s Keyboard

![](/attachments/android-linux/android-linux-2.png)

![](/attachments/android-linux/android-linux-3.png)

![](/attachments/android-linux/android-linux-4.png)

![](/attachments/android-linux/android-linux-5.png)

- 效果

![](/attachments/android-linux/android-linux-6.png)

#### 安装Linux

- 打开Linux Deploy,更换语言为中文

![](/attachments/android-linux/android-linux-7.png)

![](/attachments/android-linux/android-linux-8.png)

- Linux Deploy设置

![](/attachments/android-linux/android-linux-7.png)

![](/attachments/android-linux/android-linux-9.png)

![](/attachments/android-linux/android-linux-10.png)

- 配置Linux Deploy（点击主界面右下角类似有下载的图标进行配置）

![](/attachments/android-linux/android-linux-11.png)

![](/attachments/android-linux/android-linux-12.png)

![](/attachments/android-linux/android-linux-13.png)

- 安装

![](/attachments/android-linux/android-linux-14.png)

![](/attachments/android-linux/android-linux-15.png)

![](/attachments/android-linux/android-linux-16.png)

![](/attachments/android-linux/android-linux-17.png)

![](/attachments/android-linux/android-linux-18.png)

安装中……….

- 启动

![](/attachments/android-linux/android-linux-19.png)

![](/attachments/android-linux/android-linux-20.png)

#### SSH连接Linux
- 打开Termux，通过SSH连接容器，本地地址为127.0.0.1，或者远程连接容器，IP地址在Linux Deploy主页可以看到，通过sudo passwd root更改root用户的密码


![](/attachments/android-linux/android-linux-21.png)

![](/attachments/android-linux/android-linux-22.png)

#### Done
- 终于可以愉快地在手机上玩耍Linux了

### 总结

第一次写博客，感觉挺耗时间的，写下了也挺累的，不过感觉挺好的。。。。。。
