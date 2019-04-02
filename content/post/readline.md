---
title: Linux中的Readline
date: 2018-02-02T11:44:00+08:00
description: "Linux中的Readline学习"
categories: ["Linux"]
featuredImage: "/img/linux-1-800x420.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### 什么是Readline

今天在弄`MATLAB`命令行的过程中，了解到了有这么个东西的存在。那什么是`Readline`呢？

准确的说应该是`GNU Readline`。在Linux的世界中，命令行界面是无处不在。很多应用程序都提供了自己的交互式命令行界面，也就是说需要用户敲入命令/数据，然后应用程序给出结果。我们需要手动敲入命令，输入即编辑。说到编辑，最简单的方式就是手动输入，如果有错误，就用退格键删除，重新输入。那么问题来了，我想自动补全怎么整？我想快速输入以前输入过的命令怎么整？我想搜索输入历史怎么整？...。`GNU Readline`就是干这个的。

`GNU Readline`是一个库,其通过命令行界面（如Bash）为交互式程序提供行编辑和历史功能。其实`GNU Readline`就相当于一个变相的、迷你的编辑器。

<!-- more -->

### Readline使用

`GNU Readline`有两种编辑模式，即Emacs和vi编辑模式。默认的应该是Emacs编辑模式,但在vi的插入模式下Emacs的一些快捷键也是可以使用的,比如`Ctrl+H`删除一个字符。

`GNU Readline`的配置文件为`/etc/inputrc`(系统)和`~/.inputrc`(用户)。通过修改配置来更改`GNU Readline`的行为，比如编辑模式等。通过统一的配置文件，可以控制所有使用了 `GNU Readline`库的命令行应用的编辑方式。比如，作为一个`VIM`党，我想在所有的命令行中使用`VIM`。我只需要配置`GNU Readline`的编辑模式为vi，我就可以在所有使用了`GNU Readline`库的命令行应用中使用`VIM`来输入命令。使用了`GNU Readline`库的应用有比如`Bash`、`Mysql`的命令行界面等。

`GNU Readline`的配置可以参考  [Archlinux Wiki](https://wiki.archlinux.org/index.php/readline)

### rlwrap

如前面所说，有了`GNU Readline`库，就可以在使用了`GNU Readline`库的命令行应用中使用`VIM`。那么，问题来了。 面对没有使用`GNU Readline`库的命令行应用,我们应该怎么整？答案就是使用`rlwrap`。

`rlwrap`即`Readline wrapper`。它可以让任何一个命令行应用支持`GNU Readline`。其大致原理为，封装命令行应用的输入和输出，然后控制用户的输入使用`GNU Readline`，然后再把用户输入的命令传给应用程序。相当于为命令行应用提供了一个可以使用`GNU Readline`库的前台。

安装(Archlinux):

```bash
sudo pacman -S rlwrap
```

使用例子(MATLAB):

```bash
rlwrap -a -c -m' \ ' -H ~/.matlab/R2017b/history.m matlab -nodesktop -nosplash -nodisplay
```

- `-a`:交互式命令行应用需要该参数
- `-c`:这个不太懂~
- `-m'\'`:支持多行输入，使用`\`表示换行
- `-H ~/.matlab/R2017b/history.m`:将历史命令保存到文件中，并从文件中读取历史记录

通过上面的命令就可以在`MATLAB`命令行中使用`GNU Readline`了。
