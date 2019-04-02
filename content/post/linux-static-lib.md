---
title: linux构建静态库并测试
date: 2017-04-17T23:00:00+08:00
description: "编写Linux静态库"
categories: ["Linux"]
featuredImage: "/img/linux-1-800x420.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

linux中静态库(.a)和动态库(.so).静态库文件是归档文件(archives).由`ar`生成.
构建静态库大致步骤如下：

1. 编写库函数源代码,使用gcc编译为`.o`目标文件.

2. 使用`ar`命令将目标文件归档为`.a`文件.

3. 为库编写头文件.

4. 编写代码测试.

<!-- more -->

### 编写源码并编译为目标文件
`mylib.c:`
```1c
#include<stdio.h>

int mylib(void)
{
	printf("SUCCESSFUL!\n");

	return 0;
}

```
编译为目标文件：
```bash
gcc -c mylib.c -o mylib.o
```
### 构建为归档文件
使用`ar`命令将`mylib.o`归档为归档文件:
```bash
ar -cqv libmylib.a mylib.o
```
- `ar`的参数`c`为创建(create)新的归档文件,`q`为添加(quick append)新的文件到归档文件中,`v`显示处理过程。使用`man ar`或`ar -h`查看更多关于`ar`的使用。
- 可用`ar -t libmylib.a`查看`libmylib.a`归档文件中包含的文件.

- 静态库文件必须命名为`lib***.a`,因为使用`gcc *.c -l***`链接静态库编译的时候，编译器会到特定目录搜索`lib***.a`文件或`lib***.so`文件.

### 为库编写头文件
告诉用户如何使用`mylib.a`静态库.

`mylib.h:`
```1c
#ifndef __MY_LIB_H__
#define __MY_LIB_H__

int mylib(void);

#endif

```
### 编写测试文件测试
`test.c:`
```1c
#include <mylib.h>   //包含头文件mylib.h

int main(void)
{
	mylib();

	return 0;
}

```
编译：
```bash
gcc -L. -I. test.c -lmylib -o test
```
- `-L <dir>`参数指示编译器从特定目录搜索库文件,L后跟目录，中间可有空格也可以没有空格,这里`.`指当前目录。
- `-lmylib`指示编译器链接`libmylib.a`或`libmylib.so`库文件.这里是`libmylib.a`.
- `-I <dir>`参数指示编译器从特定目录搜索头文件,I后跟目录，中间可有空格也可以没有空格,这里`.`指当前目录。

测试`./test`：
```bash
SUCCESSFUL!
```
### 写个Makefile实现自动化
`Makefile:`
```makefile
test:libmylib.a test.c
	gcc -L. -I. test.c -lmylib -o test

libmylib.a:mylib.o
	ar -cqv libmylib.a mylib.o

mylib.o:mylib.c
	gcc -c mylib.c -o mylib.o

clean:
	rm *.o *.a test
```
