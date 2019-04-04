---
title: Linux启动第一个进程之Init & Systemd
date: 2019-04-04T10:23:00+08:00
description: "Linux启动过程中的第一个进程,Init or Systemd"
categories: ["Linux"]
featuredImage: "/img/SYSTEMD-e1434229775958.gif"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

当初大学操作系统课程中，老师说Linux操作系统启动过程中的第一个进程是Init，Init进程id是1，后续的进程均是该进程的子进程。那现在还是这样吗？其实，至今大多数Linux发行版的Init进程已经被替换为Systemd。当然，Systemd进程的pid依然是1，后续的所有进程依然是Systemd的子进程。那是不是从Init到Systemd只是换了个名字呢？是不是只是重复造了个轮子呢？不是这样的，Systemd相较于Init，解决了Init的弊端，也新增了很多新的特性。

## Init VS Systemd

{{< sizeimg src="../../static/img/init_vs_systemd_1.png" size="80" >}}
{{< sizeimg src="../../static/img/init_vs_systemd_2.png" size="80" >}}

## Systemd支持情况

{{< sizeimg src="../../static/img/systemd_support.png" size="80" >}}

## Example

```bash
pstree -p -g
```

{{< sizeimg src="../../static/img/systemd_1.png" size="80" >}}
{{< sizeimg src="../../static/img/systemd_2.png" size="80" >}}

从上面两张图可以看出，systemd进程id和进程组id都是1，其他进程都是systemd的子进程。同时可以看到vscode(code进程)有很多子进程。第二张图显示了gnome桌面系统的情况，父进程是gdm(GNOME Display Manager)，Gnome下的UI应用均是gdm的子进程。

## 所有进程都是systemd的子进程吗

```bash
ps axo pid,pgid,ppid,sid,command | sort -d -k2
```

{{< sizeimg src="../../static/img/kthreadd.png" size="50" >}}

从上图可以看出，进程kthreadd(2)并不是systemd的子进程，kthreadd的ppid是0，表示kthreadd和systemd一样是一个顶层进程。同时可以看到，有不少进程都是kthreadd的子进程。kthreadd为kernel thread daemon,负责所有内核线程的调度和管理。

---

- [The Story Behind ‘init’ and ‘systemd’: Why ‘init’ Needed to be Replaced with ‘systemd’ in Linux](https://www.tecmint.com/systemd-replaces-init-in-linux/)
- [what is the \[kthreadd\] process?](http://www.linuxvox.com/post/what-is-the-kthreadd-process/)