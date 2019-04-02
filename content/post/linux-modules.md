---
title: 编写一个简单的Linux可加载内核模块
date: 2017-04-05T23:00:00+08:00
description: "编写Linux可加载内核模块"
categories: ["Linux"]
featuredImage: "/img/linux-1-800x420.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

什么是Linux可加载内核模块？Linux可加载内核模块（`Loadable Kernel Module，LKM`）是Linux内核向外部提供的一个接口。我们知道Linux内核是一个单内核，它集成了很多的内容。那么当我想向Linux内核中写入点新功能怎么办？需要向Linux内核添加一个新的设备驱动怎么办？修改内核源码，然后重新编译？那不得麻烦死。所以Linux就提供了模块加载机制。那样，我们就可以编写自己的可加载内核模块，然后加载到Linux内核，成为内核的一部分。当我们不需要它的时候，可以把它卸载。这样添加新的设备驱动也变得十分容易了。
`模块是具有独立功能的程序，它可以被单独编译，但不能独立运行。它在运行时被链接到内核作为内核的一部分在内核空间运行`，这与运行在用户空间的进程是不同的。模块通常由一组函数和数据结构组成，用来实现一种文件系统、一个驱动程序或其他内核上层的功能。


<!-- more -->

- 编写内核模块使用的头文件是内核头文件(`KernelHeaders`),用于构建内核模块的头文件在`/lib/modules/${kver}/build`(下。（`${kver`是当前linux内核的版本，一般是`uname -r`的输出)。(`/usr/include`下的头文件是用户空间用户程序的头文件）**[#more about KernelHeaders](https://kernelnewbies.org/KernelHeaders)**

### 编写模块源码
`hello.c`
```1c
#include <linux/module.h>    // included for all kernel modules
#include <linux/kernel.h>    // included for KERN_INFO
#include <linux/init.h>        // included for __init and __exit macros

static int __init hello_init(void)      //模块入口函数
{
    printk(KERN_INFO "Hello world!\n");
    return 0;    // Non-zero return means that the module couldn't be loaded.
}

static void __exit hello_exit(void)       //模块出口函数，无返回值
{
    printk(KERN_INFO "Cleaning up module.\n");
}

module_init(hello_init);
module_exit(hello_exit);
```
内核模块的编写规范自行Google

### 编写Makefile
```makefile
obj-m := hello.o
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
 
all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
 
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
```
Makefile的编写规范自行Google
### 编译并测试
`编译：在工作目录下执行`
```bash
make
```
`加载模块到内核：`
```bash
sudo insmod hello.ko
```
`运行：`
```bash
sudo dmesg
```
![](../../static/img/linux-modules/linux-modules-1.png)

`使用lsmod查看已经加载的模块：`
```bash
lsmod | grep hello
```
![](../../static/img/linux-modules/linux-modules-2.png)
`卸载模块：`
```bash
sudo rmmod hello
sudo dmesg
```
![](../../static/img/linux-modules/linux-modules-3.png)
